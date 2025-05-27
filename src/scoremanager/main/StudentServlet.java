package scoremanager.main;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 学生情報の登録および更新を処理するサーブレット。
 * student_create.jsp および student_update.jsp からのリクエストを受け取り、
 * データベースに学生情報を保存または更新します。
 */
@WebServlet("/StudentServlet")
public class StudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // リクエストとレスポンスの文字エンコーディングを設定
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        // アクションを取得
        String action = request.getParameter("action");
        System.out.println("Action: " + action);

        if ("create_done".equals(action)) {
            // 学生登録処理
            String entranceYear = request.getParameter("entrance_year");
            String studentNumber = request.getParameter("student_number");
            String studentName = request.getParameter("student_name");
            String classNum = request.getParameter("class_num");
            String schoolCd = request.getParameter("school_cd");

            // デバッグログ
            System.out.println("Parameters: entrance_year=" + entranceYear +
                    ", student_number=" + studentNumber +
                    ", student_name=" + studentName +
                    ", class_num=" + classNum +
                    ", school_cd=" + schoolCd);

            // 入力値のバリデーション
            if (entranceYear == null || studentNumber == null || studentName == null ||
                classNum == null || schoolCd == null ||
                entranceYear.isEmpty() || studentNumber.isEmpty() || studentName.isEmpty() ||
                classNum.isEmpty() || schoolCd.isEmpty()) {
                System.out.println("Missing or empty parameters, redirecting to student_create.jsp?error=invalid");
                response.sendRedirect("student_create.jsp?error=invalid");
                return;
            }

            try {
                boolean success = saveStudent(entranceYear, studentNumber, studentName, classNum, schoolCd);
                if (success) {
                    System.out.println("Student saved successfully, redirecting to student_create_done.jsp");
                    response.sendRedirect("student_create_done.jsp");
                } else {
                    System.out.println("Failed to save student, redirecting to student_create.jsp?error=database");
                    response.sendRedirect("student_create.jsp?error=database");
                }
            } catch (SQLException e) {
                // 一意制約違反（学生番号重複）の場合
                String errorType = e.getSQLState().equals("23505") ? "duplicate" : "database";
                System.out.println("SQLException: " + e.getMessage() +
                        ", SQLState: " + e.getSQLState() +
                        ", redirecting to student_create.jsp?error=" + errorType);
                response.sendRedirect("student_create.jsp?error=" + errorType);
            }
        } else if ("update".equals(action)) {
            // 学生更新処理
            String studentNumber = request.getParameter("student_number");
            String entranceYear = request.getParameter("ent_year");
            String studentName = request.getParameter("name");
            String classNum = request.getParameter("class_num");
            String schoolCd = request.getParameter("school_cd");

            // デバッグログ
            System.out.println("Update Parameters: student_number=" + studentNumber +
                    ", ent_year=" + entranceYear +
                    ", name=" + studentName +
                    ", class_num=" + classNum +
                    ", school_cd=" + schoolCd);

            // 入力値のバリデーション
            if (studentNumber == null || entranceYear == null || studentName == null ||
                classNum == null || schoolCd == null ||
                studentNumber.isEmpty() || entranceYear.isEmpty() || studentName.isEmpty() ||
                classNum.isEmpty() || schoolCd.isEmpty()) {
                System.out.println("Missing or empty parameters, redirecting to student_update.jsp?error=invalid");
                response.sendRedirect("student_update.jsp?studentNo=" + studentNumber + "&error=invalid");
                return;
            }

            try {
                boolean success = updateStudent(studentNumber, entranceYear, studentName, classNum, schoolCd);
                if (success) {
                    System.out.println("Student updated successfully, redirecting to student_update_done.jsp");
                    response.sendRedirect("student_update_done.jsp");
                } else {
                    System.out.println("Failed to update student, redirecting to student_update.jsp?error=database");
                    response.sendRedirect("student_update.jsp?studentNo=" + studentNumber + "&error=database");
                }
            } catch (SQLException e) {
                System.out.println("SQLException: " + e.getMessage() +
                        ", SQLState: " + e.getSQLState() +
                        ", redirecting to student_update.jsp?error=database");
                response.sendRedirect("student_update.jsp?studentNo=" + studentNumber + "&error=database");
            }
        } else {
            // 不明なアクション
            System.out.println("Unknown action, redirecting to student_create.jsp?error=invalid");
            response.sendRedirect("student_create.jsp?error=invalid");
        }
    }

    /**
     * 学生情報をデータベースに登録する。
     *
     * @param entranceYear 入学年度
     * @param studentNumber 学生番号
     * @param studentName 学生氏名
     * @param classNum クラス番号
     * @param schoolCd 学校コード
     * @return 登録が成功した場合はtrue、失敗した場合はfalse
     * @throws SQLException データベースエラーが発生した場合
     */
    private boolean saveStudent(String entranceYear, String studentNumber, String studentName,
                               String classNum, String schoolCd) throws SQLException {
        String sql = "INSERT INTO STUDENT (NO, NAME, ENT_YEAR, CLASS_NUM, IS_ATTEND, SCHOOL_CD) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, studentNumber);
            pstmt.setString(2, studentName);
            pstmt.setInt(3, Integer.parseInt(entranceYear));
            pstmt.setString(4, classNum);
            pstmt.setBoolean(5, true); // IS_ATTENDはデフォルトでTRUE
            pstmt.setString(6, schoolCd);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("SQL Error in saveStudent: " + e.getMessage() + ", SQLState: " + e.getSQLState());
            throw e;
        }
    }

    /**
     * 学生情報をデータベースで更新する。
     *
     * @param studentNumber 学生番号
     * @param entranceYear 入学年度
     * @param studentName 学生氏名
     * @param classNum クラス番号
     * @param schoolCd 学校コード
     * @return 更新が成功した場合はtrue、失敗した場合はfalse
     * @throws SQLException データベースエラーが発生した場合
     */
    private boolean updateStudent(String studentNumber, String entranceYear, String studentName,
                                 String classNum, String schoolCd) throws SQLException {
        String sql = "UPDATE STUDENT SET NAME = ?, CLASS_NUM = ?, SCHOOL_CD = ? WHERE NO = ? AND ENT_YEAR = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, studentName);
            pstmt.setString(2, classNum);
            pstmt.setString(3, schoolCd);
            pstmt.setString(4, studentNumber);
            pstmt.setInt(5, Integer.parseInt(entranceYear));
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("SQL Error in updateStudent: " + e.getMessage() + ", SQLState: " + e.getSQLState());
            throw e;
        }
    }
}