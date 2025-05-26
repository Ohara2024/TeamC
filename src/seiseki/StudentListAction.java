package seiseki;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
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
import javax.servlet.http.HttpSession;

import bean.Teacher;

/**
 * 学生一覧を表示するアクション。
 */
@WebServlet("/StudentListAction")
public class StudentListAction extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String DB_URL = "jdbc:h2:tcp://localhost/~/exam;IFEXISTS=TRUE;DB_CLOSE_ON_EXIT=TRUE";
    private static final String DB_USER = "sa";
    private static final String DB_PASSWORD = "";
    private static final int MAX_RECONNECT_ATTEMPTS = 3;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        HttpSession session = request.getSession();
        Teacher teacher = (Teacher) session.getAttribute("teacher");
        String schoolCd = (teacher != null) ? teacher.getSchoolCd() : null;

        String entYearParam = request.getParameter("entYear");
        String classNumParam = request.getParameter("classNum");
        String isAttendParam = request.getParameter("isAttend");

        List<Student> students = new ArrayList<>();
        int resultCount = 0;
        String error = null;

        Connection conn = null;
        int reconnectAttempts = 0;

        while (reconnectAttempts < MAX_RECONNECT_ATTEMPTS) {
            try {
                Class.forName("org.h2.Driver");
                conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                conn.setAutoCommit(true);

                // 学生一覧を取得（SCHOOL_CDでフィルタリング）
                StringBuilder query = new StringBuilder("SELECT * FROM STUDENT WHERE SCHOOL_CD = ?");
                List<String> params = new ArrayList<>();
                params.add(schoolCd);

                if (entYearParam != null && !entYearParam.isEmpty()) {
                    query.append(" AND ENT_YEAR = ?");
                    params.add(entYearParam);
                }
                if (classNumParam != null && !classNumParam.isEmpty()) {
                    query.append(" AND CLASS_NUM = ?");
                    params.add(classNumParam);
                }
                if (isAttendParam != null) {
                    query.append(" AND IS_ATTEND = TRUE");
                }

                try (PreparedStatement pstmt = conn.prepareStatement(
                        query.toString(),
                        ResultSet.TYPE_SCROLL_INSENSITIVE,
                        ResultSet.CONCUR_READ_ONLY)) {
                    for (int i = 0; i < params.size(); i++) {
                        pstmt.setString(i + 1, params.get(i));
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

                // クラス一覧を取得（SCHOOL_CDでフィルタリング）
                List<String> classNumbers = new ArrayList<>();
                try (PreparedStatement pstmt = conn.prepareStatement(
                        "SELECT DISTINCT CLASS_NUM FROM CLASS_NUM WHERE SCHOOL_CD = ? ORDER BY CLASS_NUM")) {
                    pstmt.setString(1, schoolCd);
                    ResultSet rs = pstmt.executeQuery();
                    while (rs.next()) {
                        classNumbers.add(rs.getString("CLASS_NUM"));
                    }
                }

                request.setAttribute("students", students);
                request.setAttribute("resultCount", resultCount);
                request.setAttribute("classNumbers", classNumbers);
                request.setAttribute("entYear", entYearParam);
                request.setAttribute("classNum", classNumParam);
                request.setAttribute("isAttend", isAttendParam);
                break;
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
                error = "H2ドライバが見つかりません: " + e.getMessage();
                break;
            } catch (SQLException e) {
                e.printStackTrace();
                error = "データベースエラー: " + e.getMessage();
                if (e.getErrorCode() == 90020) {
                    reconnectAttempts++;
                    if (reconnectAttempts < MAX_RECONNECT_ATTEMPTS) {
                        try {
                            Thread.sleep(1000);
                        } catch (InterruptedException ignored) {}
                        continue;
                    }
                }
                break;
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

        if (error != null) {
            request.setAttribute("error", error);
        }
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