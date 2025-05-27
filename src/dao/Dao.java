package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Logger;

public class Dao {
    private static final Logger LOGGER = Logger.getLogger(Dao.class.getName());
    private static final String URL = "jdbc:h2:tcp://localhost/~/exam;IFEXISTS=TRUE;DB_CLOSE_ON_EXIT=TRUE;AUTO_RECONNECT=TRUE";
    private static final String USER = "sa";
    private static final String PASSWORD = "";

    protected Connection getConnection() throws SQLException {
        try {
            Class.forName("org.h2.Driver");
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            LOGGER.info("🔗 Dao: H2 データベースに接続成功");
            return conn;
        } catch (SQLException e) {
            LOGGER.severe("❌ データベースエラー: SQLState=" + e.getSQLState() + ", ErrorCode=" + e.getErrorCode() + ", Message=" + e.getMessage());
            throw new SQLException("Database connection failed: " + e.getMessage(), e);
        } catch (ClassNotFoundException e) {
            LOGGER.severe("❌ H2 ドライバが見つかりません: " + e.getMessage());
            throw new SQLException("H2 Driver not found: " + e.getMessage(), e);
        }
    }
}