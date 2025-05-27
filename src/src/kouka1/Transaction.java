package kouka1;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.naming.InitialContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;
import kouka1.model.Course;
import kouka1.model.Student;

@WebServlet("/kouka1/transaction")
public class Transaction extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // DB接続
            InitialContext ic = new InitialContext();
            DataSource ds = (DataSource) ic.lookup("java:/comp/env/jdbc/kouka");
            Connection con = ds.getConnection();

            // 学生IDを取得
            int studentId = Integer.parseInt(request.getParameter("id"));
            Student student = null;

            // 学生情報を取得
            PreparedStatement st = con.prepareStatement(
                    "SELECT STUDENT_ID, STUDENT_NAME, COURSE_ID FROM STUDENT WHERE STUDENT_ID=?");
            st.setInt(1, studentId);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                student = new Student(
                        rs.getInt("STUDENT_ID"),
                        rs.getString("STUDENT_NAME"),
                        rs.getInt("COURSE_ID")
                );
            }

            // コース一覧取得
            List<Course> courses = new ArrayList<>();
            PreparedStatement st2 = con.prepareStatement("SELECT COURSE_ID, COURSE_NAME FROM COURSE");
            ResultSet rs2 = st2.executeQuery();
            while (rs2.next()) {
                courses.add(new Course(rs2.getInt("COURSE_ID"), rs2.getString("COURSE_NAME")));
            }

            // リソースを解放
            rs.close();
            rs2.close();
            st.close();
            st2.close();
            con.close();

            // JSP にデータを渡す
            request.setAttribute("student", student);
            request.setAttribute("courses", courses);
            request.getRequestDispatcher("/student_update.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // DB接続
            InitialContext ic = new InitialContext();
            DataSource ds = (DataSource) ic.lookup("java:/comp/env/jdbc/kouka");
            Connection con = ds.getConnection();

            // フォームからデータを取得
            int studentId = Integer.parseInt(request.getParameter("STUDENT_ID"));
            String studentName = request.getParameter("STUDENT_NAME");
            int courseId = Integer.parseInt(request.getParameter("COURSE_ID"));

            // 学生情報を更新
            PreparedStatement st = con.prepareStatement(
                    "UPDATE STUDENT SET STUDENT_NAME=?, COURSE_ID=? WHERE STUDENT_ID=?");
            st.setString(1, studentName);
            st.setInt(2, courseId);
            st.setInt(3, studentId);
            st.executeUpdate();

            // リソースを解放
            st.close();
            con.close();

            // 更新後に一覧ページへリダイレクト
            response.sendRedirect("student_list.jsp");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
