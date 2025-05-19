package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

import javax.naming.NamingException;

import bean.Student;

/**
 * 学生情報を管理するDAOクラス
 */
public class StudentDao extends Dao {
    private static final Logger LOGGER = Logger.getLogger(StudentDao.class.getName());

    /**
     * 学生を全件取得
     * @return 学生リスト
     * @throws SQLException データベース操作エラー
     * @throws NamingException JNDIルックアップエラー
     */
    public List<Student> findAll() throws SQLException, NamingException {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT NO, NAME, ENT_YEAR, CLASS_NUM, IS_ATTEND, SCHOOL_CD FROM STUDENT";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Student student = new Student();
                String no = rs.getString("NO");
                String name = rs.getString("NAME");
                int entYear = rs.getInt("ENT_YEAR");
                String classNum = rs.getString("CLASS_NUM");
                boolean attend = rs.getBoolean("IS_ATTEND");
                String schoolCd = rs.getString("SCHOOL_CD");
                if (no != null && name != null && classNum != null && schoolCd != null && entYear > 0) {
                    student.setNo(no);
                    student.setName(name);
                    student.setEntYear(entYear);
                    student.setClassNum(classNum);
                    student.setAttend(attend);
                    student.setSchoolCd(schoolCd);
                    students.add(student);
                } else {
                    LOGGER.warning("無効な学生データが検出されました: NO, NAME, CLASS_NUM, SCHOOL_CDがnullまたはENT_YEARが0以下です。");
                }
            }
            LOGGER.info("学生を" + students.size() + "件取得しました。");
        } catch (SQLException e) {
            LOGGER.severe("データベース操作に失敗しました: " + e.getMessage());
            throw e;
        } catch (NamingException e) {
            LOGGER.severe("JNDIルックアップに失敗しました: " + e.getMessage());
            throw e;
        }
        return students;
    }

    /**
     * 学生を追加
     * @param student 学生オブジェクト
     * @throws SQLException データベース操作エラー
     * @throws NamingException JNDIルックアップエラー
     * @throws IllegalArgumentException 入力値が無効な場合
     */
    public void insert(Student student) throws SQLException, NamingException {
        if (student.getNo() == null || student.getName() == null || student.getClassNum() == null ||
            student.getSchoolCd() == null || student.getEntYear() <= 0) {
            throw new IllegalArgumentException("学生番号、名前、クラス番号、学校コードは必須で、入学年は1以上である必要があります。");
        }

        String sql = "INSERT INTO STUDENT (NO, NAME, ENT_YEAR, CLASS_NUM, IS_ATTEND, SCHOOL_CD) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, student.getNo());
            pstmt.setString(2, student.getName());
            pstmt.setInt(3, student.getEntYear());
            pstmt.setString(4, student.getClassNum());
            pstmt.setBoolean(5, student.isAttend());
            pstmt.setString(6, student.getSchoolCd());
            pstmt.executeUpdate();
            LOGGER.info("学生番号 " + student.getNo() + " の学生を追加しました。");
        } catch (SQLException e) {
            LOGGER.severe("学生の追加に失敗しました: " + e.getMessage());
            throw e;
        }
    }

    /**
     * 学生を更新
     * @param student 学生オブジェクト
     * @throws SQLException データベース操作エラー
     * @throws NamingException JNDIルックアップエラー
     * @throws IllegalArgumentException 入力値が無効な場合
     */
    public void update(Student student) throws SQLException, NamingException {
        if (student.getNo() == null || student.getName() == null || student.getClassNum() == null ||
            student.getSchoolCd() == null || student.getEntYear() <= 0) {
            throw new IllegalArgumentException("学生番号、名前、クラス番号、学校コードは必須で、入学年は1以上である必要があります。");
        }

        String sql = "UPDATE STUDENT SET NAME = ?, ENT_YEAR = ?, CLASS_NUM = ?, IS_ATTEND = ?, SCHOOL_CD = ? WHERE NO = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, student.getName());
            pstmt.setInt(2, student.getEntYear());
            pstmt.setString(3, student.getClassNum());
            pstmt.setBoolean(4, student.isAttend());
            pstmt.setString(5, student.getSchoolCd());
            pstmt.setString(6, student.getNo());
            int updatedRows = pstmt.executeUpdate();
            if (updatedRows > 0) {
                LOGGER.info("学生番号 " + student.getNo() + " の学生を更新しました。");
            } else {
                LOGGER.warning("学生番号 " + student.getNo() + " の更新対象が見つかりませんでした。");
            }
        } catch (SQLException e) {
            LOGGER.severe("学生の更新に失敗しました: " + e.getMessage());
            throw e;
        }
    }

    /**
     * 学生を削除
     * @param no 学生番号
     * @throws SQLException データベース操作エラー
     * @throws NamingException JNDIルックアップエラー
     */
    public void delete(String no) throws SQLException, NamingException {
        if (no == null) {
            throw new IllegalArgumentException("学生番号は必須です。");
        }

        String sql = "DELETE FROM STUDENT WHERE NO = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, no);
            int deletedRows = pstmt.executeUpdate();
            if (deletedRows > 0) {
                LOGGER.info("学生番号 " + no + " の学生を削除しました。");
            } else {
                LOGGER.warning("学生番号 " + no + " の削除対象が見つかりませんでした。");
            }
        } catch (SQLException e) {
            LOGGER.severe("学生の削除に失敗しました: " + e.getMessage());
            throw e;
        }
    }
}