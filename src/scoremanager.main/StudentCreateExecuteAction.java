package scoremanager.main;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Teacher; // Teacher クラスのインポート

/**
 * 学生登録を実行するアクション。
 */
@WebServlet("/StudentCreateExecuteAction")
public class StudentCreateExecuteAction extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String DB_URL = "jdbc:h2:tcp://localhost/~/exam;IFEXISTS=TRUE;DB_CLOSE_ON_EXIT=TRUE;AUTO_RECONNECT=TRUE";
    private static final String DB_USER = "sa";
    private static final String DB_PASSWORD = "";
    private static final int MAX_RECONNECT_ATTEMPTS = 3;
    private static final Logger LOGGER = Logger.getLogger(StudentCreateExecuteAction.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String entranceYear = request.getParameter("entrance_year");
        String studentNumber = request.getParameter("student_number");
        String studentName = request.getParameter("student_name");
        String classNum = request.getParameter("class_num");

        // ログに入力データを記録
        LOGGER.info("Received parameters: entranceYear=" + entranceYear + ", studentNumber=" + studentNumber +
                    ", studentName=" + studentName + ", classNum=" + classNum);

        // 入力検証
        if (entranceYear == null || studentNumber == null || studentName == null || classNum == null ||
            entranceYear.trim().isEmpty() || studentNumber.trim().isEmpty() || studentName.trim().isEmpty() ||
            classNum.trim().isEmpty()) {
            LOGGER.warning("Invalid input: Some fields are empty or null");
            response.sendRedirect("StudentCreateAction?error=invalid&message=" + java.net.URLEncoder.encode("すべての項目を入力してください", "UTF-8"));
            return;
        }

        // entranceYearの整数チェック
        int entYear;
        try {
            entYear = Integer.parseInt(entranceYear.trim());
            if (entYear < 1900 || entYear > 2100) {
                LOGGER.warning("Invalid entranceYear: " + entranceYear);
                response.sendRedirect("StudentCreateAction?error=invalid&message=" + java.net.URLEncoder.encode("入学年度は1900～2100の範囲で入力してください", "UTF-8"));
                return;
            }
        } catch (NumberFormatException e) {
            LOGGER.warning("NumberFormatException for entranceYear: " + entranceYear);
            response.sendRedirect("StudentCreateAction?error=invalid&message=" + java.net.URLEncoder.encode("入学年度は数値で入力してください", "UTF-8"));
            return;
        }

        // 文字列長の検証
        if (studentNumber.length() > 10) {
            LOGGER.warning("studentNumber too long: " + studentNumber);
            response.sendRedirect("StudentCreateAction?error=invalid&message=" + java.net.URLEncoder.encode("学生番号は10文字以内で入力してください", "UTF-8"));
            return;
        }
        if (studentName.length() > 50) {
            LOGGER.warning("studentName too long: " + studentName);
            response.sendRedirect("StudentCreateAction?error=invalid&message=" + java.net.URLEncoder.encode("氏名は50文字以内で入力してください", "UTF-8"));
            return;
        }
        if (classNum.length() > 10) {
            LOGGER.warning("classNum too long: " + classNum);
            response.sendRedirect("StudentCreateAction?error=invalid&message=" + java.net.URLEncoder.encode("クラス番号は10文字以内で入力してください", "UTF-8"));
            return;
        }

        // セッションからTeacherオブジェクトを取得
        HttpSession session = request.getSession();
        Teacher teacher = (Teacher) session.getAttribute("teacher");
        String schoolCd = (teacher != null && teacher.getSchool() != null) ? teacher.getSchool().getCd() : null;

        if (teacher == null || schoolCd == null) {
            LOGGER.warning("Teacher or SCHOOL_CD not found in session: teacher=" + teacher + ", schoolCd=" + schoolCd);
            response.sendRedirect("StudentCreateAction?error=session&message=" + java.net.URLEncoder.encode("ログイン情報が見つかりません。再度ログインしてください", "UTF-8"));
            return;
        }

        try {
            boolean success = saveStudent(entYear, studentNumber.trim(), studentName.trim(), classNum.trim(), schoolCd);
            if (success) {
                LOGGER.info("Student registered successfully: " + studentNumber);
                response.sendRedirect("student_create_done.jsp");
            } else {
                LOGGER.warning("No rows affected during student registration");
                response.sendRedirect("StudentCreateAction?error=database&message=" + java.net.URLEncoder.encode("登録に失敗しました。データベースエラーが発生しました", "UTF-8"));
            }
        } catch (SQLException e) {
            LOGGER.severe("SQLException: SQLState=" + e.getSQLState() + ", ErrorCode=" + e.getErrorCode() + ", Message=" + e.getMessage());
            e.printStackTrace();
            String errorType;
            String errorMessage;
            if (e.getSQLState() != null && e.getSQLState().equals("23505")) {
                errorType = "duplicate";
                errorMessage = "学生番号 " + studentNumber + " は既に登録されています";
            } else if (e.getSQLState() != null && e.getSQLState().equals("23503")) {
                errorType = "constraint";
                errorMessage = "指定されたクラス番号が存在しません";
            } else if (e.getErrorCode() == 90020) {
                errorType = "connection";
                errorMessage = "データベース接続エラー: 接続がロックされています";
            } else {
                errorType = "database";
                errorMessage = "データベースエラー: " + e.getMessage();
            }
            response.sendRedirect("StudentCreateAction?error=" + errorType + "&message=" + java.net.URLEncoder.encode(errorMessage, "UTF-8"));
        } catch (Exception e) {
            LOGGER.severe("Unexpected error: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("StudentCreateAction?error=unexpected&message=" + java.net.URLEncoder.encode("予期しないエラー: " + e.getMessage(), "UTF-8"));
        }
    }

    private boolean saveStudent(int entranceYear, String studentNumber, String studentName,
                               String classNum, String schoolCd) throws SQLException {
        String sql = "INSERT INTO STUDENT (NO, NAME, ENT_YEAR, CLASS_NUM, IS_ATTEND, SCHOOL_CD) VALUES (?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        int reconnectAttempts = 0;

        while (reconnectAttempts < MAX_RECONNECT_ATTEMPTS) {
            try {
                Class.forName("org.h2.Driver");
                conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                conn.setAutoCommit(false); // トランザクション開始

                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    pstmt.setString(1, studentNumber);
                    pstmt.setString(2, studentName);
                    pstmt.setInt(3, entranceYear);
                    pstmt.setString(4, classNum);
                    pstmt.setBoolean(5, true);
                    pstmt.setString(6, schoolCd); // SCHOOL_CDを設定
                    int rowsAffected = pstmt.executeUpdate();
                    conn.commit(); // トランザクションコミット
                    LOGGER.info("Inserted student: " + studentNumber + ", rows affected: " + rowsAffected);
                    return rowsAffected > 0;
                } catch (SQLException e) {
                    LOGGER.warning("SQLException in saveStudent: " + e.getMessage());
                    if (conn != null) {
                        try {
                            conn.rollback(); // エラー時にロールバック
                        } catch (SQLException re) {
                            LOGGER.severe("Rollback failed: " + re.getMessage());
                            re.printStackTrace();
                        }
                    }
                    throw e;
                }
            } catch (ClassNotFoundException e) {
                LOGGER.severe("ClassNotFoundException: " + e.getMessage());
                e.printStackTrace();
                throw new SQLException("H2ドライバが見つかりません: " + e.getMessage());
            } catch (SQLException e) {
                LOGGER.severe("SQLException in saveStudent: SQLState=" + e.getSQLState() + ", ErrorCode=" + e.getErrorCode());
                e.printStackTrace();
                if (e.getErrorCode() == 90020) {
                    reconnectAttempts++;
                    if (reconnectAttempts < MAX_RECONNECT_ATTEMPTS) {
                        try {
                            Thread.sleep(1000);
                        } catch (InterruptedException ignored) {}
                        continue;
                    }
                }
                throw e;
            } finally {
                if (conn != null) {
                    try {
                        conn.close();
                        LOGGER.info("Database connection closed");
                    } catch (SQLException e) {
                        LOGGER.severe("Failed to close connection: " + e.getMessage());
                        e.printStackTrace();
                    }
                }
            }
        }
        LOGGER.severe("Failed to connect to database after " + MAX_RECONNECT_ATTEMPTS + " attempts");
        throw new SQLException("データベース接続に失敗しました。最大試行回数を超えました。");
    }
}