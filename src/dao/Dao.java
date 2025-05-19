package dao;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.logging.Logger;

import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

/**
 * データベース接続を管理する基盤DAOクラス
 */
public class Dao {
    // データソース: クラスフィールド
    private static volatile DataSource ds;
    private static final Object lock = new Object();
    private static final Logger LOGGER = Logger.getLogger(Dao.class.getName());

    /**
     * データベースへのコネクションを返す
     *
     * @return データベースへのコネクション
     * @throws SQLException データベース接続エラー
     * @throws NamingException JNDIルックアップエラー
     */
    public Connection getConnection() throws SQLException, NamingException {
        if (ds == null) {
            synchronized (lock) {
                if (ds == null) {
                    try {
                        InitialContext ic = new InitialContext();
                        ds = (DataSource) ic.lookup("java:/comp/env/jdbc/yajima");
                        LOGGER.info("データソースが正常に初期化されました。");
                    } catch (NamingException e) {
                        LOGGER.severe("データソースのルックアップに失敗しました: " + e.getMessage());
                        throw e;
                    }
                }
            }
        }
        try {
            Connection conn = ds.getConnection();
            LOGGER.fine("データベース接続を取得しました。");
            return conn;
        } catch (SQLException e) {
            LOGGER.severe("データベース接続の取得に失敗しました: " + e.getMessage());
            throw e;
        }
    }
}