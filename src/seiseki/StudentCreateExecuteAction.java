
package seiseki;

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
 * 学生登録を実行するアクション。
 */
@WebServlet("/StudentCreateExecuteAction")
public class StudentCreateExecuteAction extends HttpServlet {
    private static final long serialVersionUID = 1L;

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
            String errorType = e.getSQLState().equals("23505") ? "duplicate" : "database";
            response.sendRedirect("StudentCreateAction?error=" + errorType);
        }
    }

    private boolean saveStudent(String entranceYear, String studentNumber, String studentName,
                               String classNum, String schoolCd) throws SQLException {
        String sql = "INSERT INTO STUDENT (NO, NAME, ENT_YEAR, CLASS_NUM, IS_ATTEND, SCHOOL_CD) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, studentNumber);
            pstmt.setString(2, studentName);
            pstmt.setInt(3, Integer.parseInt(entranceYear));
            pstmt.setString(4, classNum);
            pstmt.setBoolean(5, true);
            pstmt.setString(6, schoolCd);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        }
    }
}