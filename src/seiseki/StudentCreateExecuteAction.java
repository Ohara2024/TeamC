package seiseki;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 学生登録を実行するアクション。
 */
@WebServlet("/StudentCreateExecuteAction")
public class StudentCreateExecuteAction extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String DB_URL = "jdbc:h2:tcp://localhost/~/exam;IFEXISTS=TRUE;DB_CLOSE_ON_EXIT=TRUE";
    private static final String DB_USER = "sa";
    private static final String DB_PASSWORD = "";
    private static final int MAX_RECONNECT_ATTEMPTS = 3;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String entranceYear = request.getParameter("entrance_year");
        String studentNumber = request.getParameter("student_number");
        String studentName = request.getParameter("student_name");
        String classNum = request.getParameter("class_num");
        String schoolCd = request.getParameter("school_cd");

        if (entranceYear == null || studentNumber == null || studentName == null ||
            classNum == null || schoolCd == null ||
            entranceYear.isEmpty() || studentNumber.isEmpty() || studentName.isEmpty() ||
            classNum.isEmpty() || schoolCd.isEmpty()) {
            response.sendRedirect("StudentCreateAction?error=invalid");
            return;
        }

        try {
            boolean success = saveStudent(entranceYear, studentNumber, studentName, classNum, schoolCd);
            if (success) {
                response.sendRedirect("student_create_done.jsp");
            } else {
                response.sendRedirect("StudentCreateAction?error=database");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            String errorType = e.getSQLState().equals("23505") ? "duplicate" : "database";
            response.sendRedirect("StudentCreateAction?error=" + errorType);
        }
    }

    private boolean saveStudent(String entranceYear, String studentNumber, String studentName,
                               String classNum, String schoolCd) throws SQLException {
        String sql = "INSERT INTO STUDENT (NO, NAME, ENT_YEAR, CLASS_NUM, IS_ATTEND, SCHOOL_CD) VALUES (?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        int reconnectAttempts = 0;

        while (reconnectAttempts < MAX_RECONNECT_ATTEMPTS) {
            try {
                Class.forName("org.h2.Driver");
                conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                conn.setAutoCommit(true);

                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    pstmt.setString(1, studentNumber);
                    pstmt.setString(2, studentName);
                    pstmt.setInt(3, Integer.parseInt(entranceYear));
                    pstmt.setString(4, classNum);
                    pstmt.setBoolean(5, true);
                    pstmt.setString(6, schoolCd);
                    int rowsAffected = pstmt.executeUpdate();
                    return rowsAffected > 0;
                }
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
                throw new SQLException("H2ドライバが見つかりません: " + e.getMessage());
            } catch (SQLException e) {
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
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
        return false;
    }
}