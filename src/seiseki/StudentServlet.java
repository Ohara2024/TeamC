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

@WebServlet("/StudentServlet")
public class StudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        String action = request.getParameter("action");

        System.out.println("Action: " + action);

        if ("create_done".equals(action)) {
            String entranceYear = request.getParameter("entrance_year");
            String studentNumber = request.getParameter("student_number");
            String studentName = request.getParameter("student_name");
            String classNum = request.getParameter("class_num");
            String schoolCd = request.getParameter("school_cd");

            System.out.println("Parameters: entrance_year=" + entranceYear + ", student_number=" + studentNumber +
                    ", student_name=" + studentName + ", class_num=" + classNum + ", school_cd=" + schoolCd);

            if (entranceYear == null || studentNumber == null || studentName == null || classNum == null || schoolCd == null) {
                System.out.println("Missing parameters, redirecting to student_create.jsp?error=invalid");
                response.sendRedirect("student_create.jsp?error=invalid");
                return;
            }

            try {
                if (saveStudent(entranceYear, studentNumber, studentName, classNum, schoolCd)) {
                    System.out.println("Student saved successfully, redirecting to student_create_done.jsp");
                    response.sendRedirect("student_create_done.jsp");
                } else {
                    System.out.println("Failed to save student, redirecting to student_create.jsp?error=database");
                    response.sendRedirect("student_create.jsp?error=database");
                }
            } catch (SQLException e) {
                String errorType = e.getSQLState().equals("23505") ? "duplicate" : "database";
                System.out.println("SQLException: " + e.getMessage() + ", SQLState: " + e.getSQLState() + ", redirecting to student_create.jsp?error=" + errorType);
                response.sendRedirect("student_create.jsp?error=" + errorType);
            }
        } else if ("update".equals(action)) {
            String studentNumber = request.getParameter("student_number");
            String entranceYear = request.getParameter("ent_year");
            String studentName = request.getParameter("name");
            String classNum = request.getParameter("class_num");
            String schoolCd = request.getParameter("school_cd");

            System.out.println("Update Parameters: student_number=" + studentNumber + ", ent_year=" + entranceYear +
                    ", name=" + studentName + ", class_num=" + classNum + ", school_cd=" + schoolCd);

            if (studentNumber == null || entranceYear == null || studentName == null || classNum == null || schoolCd == null) {
                System.out.println("Missing parameters, redirecting to student_update.jsp?error=invalid");
                response.sendRedirect("student_update.jsp?studentNo=" + studentNumber + "&error=invalid");
                return;
            }

            try {
                if (updateStudent(studentNumber, entranceYear, studentName, classNum, schoolCd)) {
                    System.out.println("Student updated successfully, redirecting to student_update_done.jsp");
                    response.sendRedirect("student_update_done.jsp");
                } else {
                    System.out.println("Failed to update student, redirecting to student_update.jsp?error=database");
                    response.sendRedirect("student_update.jsp?studentNo=" + studentNumber + "&error=database");
                }
            } catch (SQLException e) {
                System.out.println("SQLException: " + e.getMessage() + ", SQLState: " + e.getSQLState() + ", redirecting to student_update.jsp?error=database");
                response.sendRedirect("student_update.jsp?studentNo=" + studentNumber + "&error=database");
            }
        }
    }

    private boolean saveStudent(String entranceYear, String studentNumber, String studentName, String classNum, String schoolCd) throws SQLException {
        String sql = "INSERT INTO STUDENT (NO, NAME, ENT_YEAR, CLASS_NUM, IS_ATTEND, SCHOOL_CD) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, studentNumber);
            pstmt.setString(2, studentName);
            pstmt.setInt(3, Integer.parseInt(entranceYear));
            pstmt.setString(4, classNum);
            pstmt.setBoolean(5, true); // IS_ATTENDはデフォルトでTRUE
            pstmt.setString(6, schoolCd);
            pstmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            System.err.println("SQL Error: " + e.getMessage() + ", SQLState: " + e.getSQLState());
            throw e; // エラーを上位に伝播
        }
    }

    private boolean updateStudent(String studentNumber, String entranceYear, String studentName, String classNum, String schoolCd) throws SQLException {
        String sql = "UPDATE STUDENT SET NAME = ?, CLASS_NUM = ? WHERE NO = ? AND ENT_YEAR = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, studentName);
            pstmt.setString(2, classNum);
            pstmt.setString(3, studentNumber);
            pstmt.setInt(4, Integer.parseInt(entranceYear));
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("SQL Error: " + e.getMessage() + ", SQLState: " + e.getSQLState());
            throw e;
        }
    }
}