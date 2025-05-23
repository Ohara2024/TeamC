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

/**
 * 学生更新フォームを表示するアクション。
 */
@WebServlet("/StudentUpdateAction")
public class StudentUpdateAction extends HttpServlet {
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

        String studentNo = request.getParameter("studentNo");
        System.out.println("[StudentUpdateAction] Received studentNo: " + studentNo);
        if (studentNo == null || studentNo.isEmpty()) {
            System.out.println("[StudentUpdateAction] Error: studentNo is null or empty");
            request.setAttribute("error", "学生番号が指定されていません。");
            request.getRequestDispatcher("student_update.jsp").forward(request, response);
            return;
        }

        StudentListAction.Student student = null;
        List<ClassNum> classNumbers = new ArrayList<>();
        String error = null;
        Connection conn = null;
        int reconnectAttempts = 0;

        while (reconnectAttempts < MAX_RECONNECT_ATTEMPTS) {
            try {
                Class.forName("org.h2.Driver");
                conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                conn.setAutoCommit(true);

                // 学生情報取得
                try (PreparedStatement pstmt = conn.prepareStatement("SELECT ENT_YEAR, NO, NAME, CLASS_NUM, SCHOOL_CD FROM STUDENT WHERE NO = ?")) {
                    pstmt.setString(1, studentNo);
                    System.out.println("[StudentUpdateAction] Executing query for NO: " + studentNo);
                    ResultSet rs = pstmt.executeQuery();
                    if (rs.next()) {
                        System.out.println("[StudentUpdateAction] Found student with NO: " + studentNo);
                        student = new StudentListAction.Student();
                        student.setEntYear(rs.getString("ENT_YEAR"));
                        student.setNo(rs.getString("NO"));
                        student.setName(rs.getString("NAME"));
                        student.setClassNum(rs.getString("CLASS_NUM"));
                        student.setSchoolCd(rs.getString("SCHOOL_CD"));
                        System.out.println("[StudentUpdateAction] Set schoolCd: " + rs.getString("SCHOOL_CD"));
                    } else {
                        System.out.println("[StudentUpdateAction] No student found for NO: " + studentNo);
                        error = "指定された学生が見つかりません。";
                    }
                }

                // クラス一覧を取得
                try (PreparedStatement pstmt = conn.prepareStatement("SELECT SCHOOL_CD, CLASS_NUM FROM CLASS_NUM ORDER BY CLASS_NUM");
                     ResultSet rs = pstmt.executeQuery()) {
                    while (rs.next()) {
                        ClassNum classNum = new ClassNum();
                        classNum.setSchoolCd(rs.getString("SCHOOL_CD"));
                        classNum.setClassNum(rs.getString("CLASS_NUM"));
                        classNumbers.add(classNum);
                    }
                    System.out.println("[StudentUpdateAction] Loaded " + classNumbers.size() + " class numbers");
                }
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
            } catch (Exception e) {
                e.printStackTrace();
                error = "予期しないエラー: " + e.getMessage();
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

        request.setAttribute("student", student);
        request.setAttribute("classNumbers", classNumbers);
        if (error != null) {
            request.setAttribute("error", error);
        }
        System.out.println("[StudentUpdateAction] Forwarding to student_update.jsp");
        request.getRequestDispatcher("student_update.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    // クラスデータを保持する内部クラス
    public static class ClassNum {
        private String schoolCd;
        private String classNum;

        public String getSchoolCd() { return schoolCd; }
        public void setSchoolCd(String schoolCd) { this.schoolCd = schoolCd; }
        public String getClassNum() { return classNum; }
        public void setClassNum(String classNum) { this.classNum = classNum; }
    }
}