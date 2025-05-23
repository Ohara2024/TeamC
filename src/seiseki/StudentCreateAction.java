package seiseki;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
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
    private static final String DB_URL = "jdbc:h2:tcp://localhost/~/exam;IFEXISTS=TRUE;DB_CLOSE_ON_EXIT=TRUE";
    private static final String DB_USER = "sa";
    private static final String DB_PASSWORD = "";
    private static final int MAX_RECONNECT_ATTEMPTS = 3;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        // クラス一覧を取得
        List<String> classNumbers = new ArrayList<>();
        Connection conn = null;
        int reconnectAttempts = 0;
        String error = null;

        while (reconnectAttempts < MAX_RECONNECT_ATTEMPTS) {
            try {
                Class.forName("org.h2.Driver");
                conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                conn.setAutoCommit(true);

                try (Statement stmt = conn.createStatement();
                     ResultSet rs = stmt.executeQuery("SELECT CLASS_NUM FROM CLASS_NUM ORDER BY CLASS_NUM")) {
                    while (rs.next()) {
                        classNumbers.add(rs.getString("CLASS_NUM"));
                    }
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
        request.setAttribute("classNumbers", classNumbers);
        request.getRequestDispatcher("student_create.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}