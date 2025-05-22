package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

import javax.naming.NamingException;

import bean.ClassNum;

/**
 * クラス番号情報を管理するDAOクラス
 */
public class ClassNumDao extends Dao {
    private static final Logger LOGGER = Logger.getLogger(ClassNumDao.class.getName());

    /**
     * クラス番号を全件取得
     * @return クラス番号リスト
     * @throws Exception
     */
    public List<ClassNum> findAll() throws Exception {
        List<ClassNum> classNums = new ArrayList<>();
        String sql = "SELECT SCHOOL_CD, CLASS_NUM FROM CLASS_NUM";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                ClassNum classNum = new ClassNum();
                String schoolCd = rs.getString("SCHOOL_CD");
                String classNumValue = rs.getString("CLASS_NUM");
                if (schoolCd != null && classNumValue != null) {
                    classNum.setSchoolCd(schoolCd);
                    classNum.setClassNum(classNumValue);
                    classNums.add(classNum);
                } else {
                    LOGGER.warning("無効なデータが検出されました: SCHOOL_CDまたはCLASS_NUMがnullです。");
                }
            }
            LOGGER.info("クラス番号を" + classNums.size() + "件取得しました。");
        } catch (SQLException e) {
            LOGGER.severe("データベース操作に失敗しました: " + e.getMessage());
            throw e;
        } catch (NamingException e) {
            LOGGER.severe("JNDIルックアップに失敗しました: " + e.getMessage());
            throw e;
        }
        return classNums;
    }
}