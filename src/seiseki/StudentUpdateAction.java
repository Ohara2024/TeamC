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
 * 学生更新フォームを表示するアクション。
 */
@WebServlet("/StudentUpdateAction")
public class StudentUpdateAction extends HttpServlet {
    private static final long serialVersionUID = 1L;

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
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement("SELECT ENT_YEAR, NO, NAME, CLASS_NUM, SCHOOL_CD FROM STUDENT WHERE NO = ?")) {
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
                request.setAttribute("error", "指定された学生が見つかりません。");
            }
        } catch (SQLException e) {
            System.err.println("[StudentUpdateAction] SQLException: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "データベースエラー: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("[StudentUpdateAction] Unexpected error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "予期しないエラー: " + e.getMessage());
        }

        // クラス一覧を取得
        List<ClassNum> classNumbers = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement("SELECT SCHOOL_CD, CLASS_NUM FROM CLASS_NUM ORDER BY CLASS_NUM");
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                ClassNum classNum = new ClassNum();
                classNum.setSchoolCd(rs.getString("SCHOOL_CD"));
                classNum.setClassNum(rs.getString("CLASS_NUM"));
                classNumbers.add(classNum);
            }
            System.out.println("[StudentUpdateAction] Loaded " + classNumbers.size() + " class numbers");
        } catch (SQLException e) {
            System.err.println("[StudentUpdateAction] SQLException in class numbers: " + e.getMessage());
            request.setAttribute("error", "データベースエラー: " + e.getMessage());
        }

        request.setAttribute("student", student);
        request.setAttribute("classNumbers", classNumbers);
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