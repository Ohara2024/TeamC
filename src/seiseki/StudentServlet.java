package seiseki;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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

        if ("create_done".equals(action)) {
            // 学生作成用のパラメータを取得
            String entranceYear = request.getParameter("entrance_year");
            String studentNumber = request.getParameter("student_number");
            String schoolId = request.getParameter("school_id");
            String studentName = request.getParameter("student_name");
            String classId = request.getParameter("class_id");
            boolean isEnrolled = "true".equals(request.getParameter("is_enrolled"));

            if (entranceYear == null || studentNumber == null || schoolId == null || studentName == null || classId == null) {
                response.sendRedirect("student_create.jsp?error=1");
                return;
            }

            if (saveStudent(entranceYear, studentNumber, schoolId, studentName, classId, isEnrolled)) {
                response.sendRedirect("student_create_done.jsp");
            } else {
                response.sendRedirect("student_create.jsp?error=1");
            }
        } else if ("update".equals(action)) {
            // 学生更新用のパラメータを取得
            String studentId = request.getParameter("student_id");
            String entranceYear = request.getParameter("entrance_year");
            String studentNumber = request.getParameter("student_number");
            String schoolId = request.getParameter("school_id");
            String studentName = request.getParameter("student_name");
            String classId = request.getParameter("class_id");
            boolean isEnrolled = "true".equals(request.getParameter("is_enrolled"));

            if (studentId == null || entranceYear == null || studentNumber == null || schoolId == null || studentName == null || classId == null) {
                response.sendRedirect("student_update.jsp?studentId=" + studentId + "&error=1");
                return;
            }

            if (updateStudent(studentId, entranceYear, studentNumber, schoolId, studentName, classId, isEnrolled)) {
                response.sendRedirect("student_update_done.jsp");
            } else {
                response.sendRedirect("student_update.jsp?studentId=" + studentId + "&error=1");
            }
        }
    }

    private boolean saveStudent(String entranceYear, String studentNumber, String schoolId, String studentName, String classId, boolean isEnrolled) {
        String sql = "INSERT INTO 学生 (入学年度, 学生番号, 学校ID, 氏名, クラスID, 在学中) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, Integer.parseInt(entranceYear));
            pstmt.setString(2, studentNumber);
            pstmt.setInt(3, Integer.parseInt(schoolId));
            pstmt.setString(4, studentName);
            pstmt.setInt(5, Integer.parseInt(classId));
            pstmt.setBoolean(6, isEnrolled);
            pstmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private boolean updateStudent(String studentId, String entranceYear, String studentNumber, String schoolId, String studentName, String classId, boolean isEnrolled) {
        String sql = "UPDATE 学生 SET 入学年度 = ?, 学生番号 = ?, 学校ID = ?, 氏名 = ?, クラスID = ?, 在学中 = ? WHERE 学生ID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, Integer.parseInt(entranceYear));
            pstmt.setString(2, studentNumber);
            pstmt.setInt(3, Integer.parseInt(schoolId));
            pstmt.setString(4, studentName);
            pstmt.setInt(5, Integer.parseInt(classId));
            pstmt.setBoolean(6, isEnrolled);
            pstmt.setInt(7, Integer.parseInt(studentId));
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public void init() throws ServletException {
        try (Connection conn = DBConnection.getConnection()) {
            // 学生テーブルを作成
            String sqlStudent = "CREATE TABLE IF NOT EXISTS 学生 (" +
                    "学生ID INT AUTO_INCREMENT PRIMARY KEY, " +
                    "入学年度 INT NOT NULL, " +
                    "学生番号 VARCHAR(20) NOT NULL, " +
                    "学校ID INT NOT NULL, " +
                    "氏名 VARCHAR(100) NOT NULL, " +
                    "クラスID INT NOT NULL, " +
                    "在学中 BOOLEAN NOT NULL)";
            PreparedStatement pstmtStudent = conn.prepareStatement(sqlStudent);
            pstmtStudent.executeUpdate();

            // 学校テーブルを作成
            String sqlSchool = "CREATE TABLE IF NOT EXISTS 学校 (" +
                    "学校ID INT AUTO_INCREMENT PRIMARY KEY, " +
                    "学校名 VARCHAR(100) NOT NULL)";
            PreparedStatement pstmtSchool = conn.prepareStatement(sqlSchool);
            pstmtSchool.executeUpdate();

            // クラステーブルを作成
            String sqlClass = "CREATE TABLE IF NOT EXISTS クラス (" +
                    "クラスID INT AUTO_INCREMENT PRIMARY KEY, " +
                    "クラス名 VARCHAR(50) NOT NULL)";
            PreparedStatement pstmtClass = conn.prepareStatement(sqlClass);
            pstmtClass.executeUpdate();

            // 学校テーブルにサンプルデータを挿入
            String checkSchool = "SELECT COUNT(*) FROM 学校";
            PreparedStatement pstmtCheckSchool = conn.prepareStatement(checkSchool);
            ResultSet rsSchool = pstmtCheckSchool.executeQuery();
            if (rsSchool.next() && rsSchool.getInt(1) == 0) {
                String insertSchool = "INSERT INTO 学校 (学校名) VALUES ('大原 大原校'), ('大原 佐藤校'), ('大原 三島校')";
                PreparedStatement pstmtInsertSchool = conn.prepareStatement(insertSchool);
                pstmtInsertSchool.executeUpdate();
            }

            // クラステーブルにサンプルデータを挿入
            String checkClass = "SELECT COUNT(*) FROM クラス";
            PreparedStatement pstmtCheckClass = conn.prepareStatement(checkClass);
            ResultSet rsClass = pstmtCheckClass.executeQuery();
            if (rsClass.next() && rsClass.getInt(1) == 0) {
                String insertClass = "INSERT INTO クラス (クラス名) VALUES ('201'), ('202')";
                PreparedStatement pstmtInsertClass = conn.prepareStatement(insertClass);
                pstmtInsertClass.executeUpdate();
            }

        } catch (SQLException e) {
            throw new ServletException("データベース初期化エラー", e);
        }
    }
}