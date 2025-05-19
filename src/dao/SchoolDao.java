package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

import javax.naming.NamingException;

import bean.School;

/**
 * 学校情報を管理するDAOクラス
 */
public class SchoolDao extends Dao {
    private static final Logger LOGGER = Logger.getLogger(SchoolDao.class.getName());

    /**
     * 学校を全件取得
     * @return 学校リスト
     * @throws SQLException データベース操作エラー
     * @throws NamingException JNDIルックアップエラー
     */
    public List<School> findAll() throws SQLException, NamingException {
        List<School> schools = new ArrayList<>();
        String sql = "SELECT CD, NAME FROM SCHOOL";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                School school = new School();
                String cd = rs.getString("CD");
                String name = rs.getString("NAME");
                if (cd != null && name != null) {
                    school.setCd(cd);
                    school.setName(name);
                    schools.add(school);
                } else {
                    LOGGER.warning("無効なデータが検出されました: CDまたはNAMEがnullです。");
                }
            }
            LOGGER.info("学校を" + schools.size() + "件取得しました。");
        } catch (SQLException e) {
            LOGGER.severe("データベース操作に失敗しました: " + e.getMessage());
            throw e;
        } catch (NamingException e) {
            LOGGER.severe("JNDIルックアップに失敗しました: " + e.getMessage());
            throw e;
        }
        return schools;
    }
}