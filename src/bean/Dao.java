package bean;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Dao {

    private static final String URL = "jdbc:h2:tcp://localhost/~/seiseki";

    private static final String USER = "sa"; // デフォルトユーザー名

    private static final String PASSWORD = ""; // デフォルトパスワード

    protected Connection getConnection() throws Exception {

        try {

            // H2 ドライバをロード（Java 6 以降は省略可能）

            Class.forName("org.h2.Driver");

            // データベースに接続

            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);

            System.out.println("🔗 Dao: H2 データベースに接続成功");

            return conn;

        } catch (SQLException e) {

            System.out.println("❌ データベースエラー: " + e.getMessage());

            throw new SQLException("Database connection failed", e);

        } catch (ClassNotFoundException e) {

            System.out.println("❌ H2 ドライバが見つかりません: " + e.getMessage());

            throw new Exception("H2 Driver not found", e);

        }

    }

}
