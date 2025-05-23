package seiseki;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 学生登録フォームを表示するアクション。
 */
@WebServlet("/StudentCreateAction")
public class StudentCreateAction extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        // クラス一覧を取得
        List<String> classNumbers = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT CLASS_NUM FROM CLASS_NUM ORDER BY CLASS_NUM")) {
            while (rs.next()) {
                classNumbers.add(rs.getString("CLASS_NUM"));
            }
        } catch (SQLException e) {
            request.setAttribute("error", "データベースエラー: " + e.getMessage());
        }

        request.setAttribute("classNumbers", classNumbers);
        request.getRequestDispatcher("student_create.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}