package kouka1;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.naming.InitialContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

@WebServlet(urlPatterns = "/kouka1/insert")
public class InsertServlet extends HttpServlet {
    // POSTメソッド（学生情報の挿入）
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PrintWriter out = response.getWriter();

        try {
            // データソースの取得
            InitialContext ic = new InitialContext();
            DataSource ds = (DataSource) ic.lookup("java:/comp/env/jdbc/kouka");
            Connection con = ds.getConnection();

            // フォームから送信されたデータを取得
            String studentName = request.getParameter("name");
            String courseId = request.getParameter("course");

            // 次の学生番号を取得するSQL（最大のSTUDENT_ID + 1）
            PreparedStatement maxIdStmt = con.prepareStatement("SELECT MAX(STUDENT_ID) FROM student");
            ResultSet rs = maxIdStmt.executeQuery();
            int nextStudentId = 1;  // 初回登録時に1からスタート

            if (rs.next()) {
                nextStudentId = rs.getInt(1) + 1;  // 最大ID + 1
            }
            rs.close();
            maxIdStmt.close();

            // SQL文の準備
            PreparedStatement st = con.prepareStatement(
                    "INSERT INTO student (STUDENT_ID, STUDENT_NAME, COURSE_ID) VALUES (?, ?, ?)");
            st.setInt(1, nextStudentId);  // 次の学生番号をセット
            st.setString(2, studentName);  // 学生名
            st.setString(3, courseId);     // コースID

            // SQL実行
            int line = st.executeUpdate();

            // リダイレクトして結果を表示
            if (line > 0) {
                response.sendRedirect(request.getContextPath() + "/kouka1/StudentAddResult.jsp?success=true");
            } else {
                response.sendRedirect(request.getContextPath() + "/kouka1/StudentAddResult.jsp?success=false");
            }

            // リソースの解放
            st.close();
            con.close();

        } catch (Exception e) {
            // エラー発生時の処理
            e.printStackTrace(out);
            response.sendRedirect(request.getContextPath() + "/kouka1/StudentAddResult.jsp?success=false");
        }
    }
}
