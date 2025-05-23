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
 * 学生情報の更新を実行するアクション。
 */
@WebServlet("/StudentUpdateExecuteAction")
public class StudentUpdateExecuteAction extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String studentNumber = request.getParameter("student_number");
        String entranceYear = request.getParameter("ent_year");
        String studentName = request.getParameter("name");
        String classNum = request.getParameter("class_num");
        String schoolCd = request.getParameter("school_cd");

        if (studentNumber == null || entranceYear == null || studentName == null ||
            classNum == null || schoolCd == null ||
            studentNumber.isEmpty() || entranceYear.isEmpty() || studentName.isEmpty() ||
            classNum.isEmpty() || schoolCd.isEmpty()) {
            response.sendRedirect("StudentUpdateAction?studentNo=" + studentNumber + "&error=invalid");
            return;
        }

        try {
            boolean success = updateStudent(studentNumber, entranceYear, studentName, classNum, schoolCd);
            if (success) {
                response.sendRedirect("student_update_done.jsp");
            } else {
                response.sendRedirect("StudentUpdateAction?studentNo=" + studentNumber + "&error=database");
            }
        } catch (SQLException e) {
            response.sendRedirect("StudentUpdateAction?studentNo=" + studentNumber + "&error=database");
        }
    }

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
        }
    }
}