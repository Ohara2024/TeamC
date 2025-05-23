package seiseki;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 学生一覧を表示するアクション。
 */
@WebServlet("/StudentListAction")
public class StudentListAction extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String entYearParam = request.getParameter("entYear");
        String classNumParam = request.getParameter("classNum");
        String isAttendParam = request.getParameter("isAttend");

        List<Student> students = new ArrayList<>();
        int resultCount = 0;

        try (Connection conn = DBConnection.getConnection()) {
            StringBuilder query = new StringBuilder("SELECT * FROM STUDENT WHERE 1=1");
            if (entYearParam != null && !entYearParam.isEmpty()) {
                query.append(" AND ENT_YEAR = ?");
            }
            if (classNumParam != null && !classNumParam.isEmpty()) {
                query.append(" AND CLASS_NUM = ?");
            }
            if (isAttendParam != null) {
                query.append(" AND IS_ATTEND = TRUE");
            }

            try (PreparedStatement pstmt = conn.prepareStatement(
                    query.toString(),
                    ResultSet.TYPE_SCROLL_INSENSITIVE,
                    ResultSet.CONCUR_READ_ONLY)) {
                int idx = 1;
                if (entYearParam != null && !entYearParam.isEmpty()) {
                    pstmt.setString(idx++, entYearParam);
                }
                if (classNumParam != null && !classNumParam.isEmpty()) {
                    pstmt.setString(idx++, classNumParam);
                }

                ResultSet rs = pstmt.executeQuery();
                while (rs.next()) {
                    Student student = new Student();
                    student.setEntYear(rs.getString("ENT_YEAR"));
                    student.setNo(rs.getString("NO"));
                    student.setName(rs.getString("NAME"));
                    student.setClassNum(rs.getString("CLASS_NUM"));
                    student.setAttend(rs.getBoolean("IS_ATTEND"));
                    student.setSchoolCd(rs.getString("SCHOOL_CD"));
                    students.add(student);
                    resultCount++;
                }
            }
        } catch (SQLException e) {
            request.setAttribute("error", "データベースエラー: " + e.getMessage());
        }

        // クラス一覧を取得
        List<String> classNumbers = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement("SELECT DISTINCT CLASS_NUM FROM CLASS_NUM ORDER BY CLASS_NUM");
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                classNumbers.add(rs.getString("CLASS_NUM"));
            }
        } catch (SQLException e) {
            request.setAttribute("error", "データベースエラー: " + e.getMessage());
        }

        request.setAttribute("students", students);
        request.setAttribute("resultCount", resultCount);
        request.setAttribute("classNumbers", classNumbers);
        request.setAttribute("entYear", entYearParam);
        request.setAttribute("classNum", classNumParam);
        request.setAttribute("isAttend", isAttendParam);
        request.getRequestDispatcher("student_list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    // 学生データを保持する内部クラス
    public static class Student {
        private String entYear;
        private String no;
        private String name;
        private String classNum;
        private boolean isAttend;
        private String schoolCd;

        public String getEntYear() { return entYear; }
        public void setEntYear(String entYear) { this.entYear = entYear; }
        public String getNo() { return no; }
        public void setNo(String no) { this.no = no; }
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        public String getClassNum() { return classNum; }
        public void setClassNum(String classNum) { this.classNum = classNum; }
        public boolean isAttend() { return isAttend; }
        public void setAttend(boolean isAttend) { this.isAttend = isAttend; }
        public String getSchoolCd() { return schoolCd; }
        public void setSchoolCd(String schoolCd) { this.schoolCd = schoolCd; }
    }
}