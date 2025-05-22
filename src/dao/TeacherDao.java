package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Logger;

import javax.naming.NamingException;

import bean.Teacher;

/**
 * 教師情報を管理するDAOクラス
 */
public class TeacherDao extends Dao {
    private static final Logger LOGGER = Logger.getLogger(TeacherDao.class.getName());

    /**
     * 教師のログイン認証
     * @param id 教師ID
     * @param password パスワード
     * @return 認証された教師オブジェクト、認証失敗時はnull
     * @throws SQLException データベース操作エラー
     * @throws NamingException JNDIルックアップエラー
     * @throws IllegalArgumentException 入力値が無効な場合
     */
    public Teacher authenticate(String id, String password) throws SQLException, NamingException {
        if (id == null || password == null) {
            throw new IllegalArgumentException("教師IDとパスワードは必須です。");
        }

        // TODO: セキュリティ向上のため、パスワードは平文ではなくハッシュ化（例：BCrypt）して保存・比較することを推奨。
        String sql = "SELECT ID, NAME, SCHOOL_CD FROM TEACHER WHERE ID = ? AND PASSWORD = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, id);
            pstmt.setString(2, password);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Teacher teacher = new Teacher();
                    String teacherId = rs.getString("ID");
                    String name = rs.getString("NAME");
                    String schoolCd = rs.getString("SCHOOL_CD");
                    if (teacherId != null && name != null && schoolCd != null) {
                        teacher.setId(teacherId);
                        teacher.setName(name);
                        teacher.setSchoolCd(schoolCd);
                        LOGGER.info("教師ID " + id + " の認証に成功しました。");
                        return teacher;
                    } else {
                        LOGGER.warning("無効な教師データが検出されました: ID, NAME, SCHOOL_CDがnullです。");
                    }
                }
            }
            LOGGER.info("教師ID " + id + " の認証に失敗しました。");
        } catch (SQLException e) {
            LOGGER.severe("データベース操作に失敗しました: " + e.getMessage());
            throw e;
        } catch (NamingException e) {
            LOGGER.severe("JNDIルックアップに失敗しました: " + e.getMessage());
            throw e;
        }
        return null;
    }
}