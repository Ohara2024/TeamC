package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.NamingException;

import bean.Subject;

/**
 * 科目情報を管理するDAOクラス
 */
public class SubjectDao extends Dao {
    /**
     * 科目を全件取得
     * @return 科目リスト
     * @throws SQLException データベース操作エラー
     * @throws NamingException JNDIルックアップエラー
     */
    public List<Subject> findAll() throws SQLException, NamingException {
        List<Subject> subjects = new ArrayList<>();
        String sql = "SELECT SCHOOL_CD, CD, NAME FROM SUBJECT";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Subject subject = new Subject();
                subject.setSchoolCd(rs.getString("SCHOOL_CD"));
                subject.setCd(rs.getString("CD"));
                subject.setName(rs.getString("NAME"));
                subjects.add(subject);
            }
        }
        return subjects;
    }

    /**
     * 科目を追加
     * @param subject 科目オブジェクト
     * @throws SQLException データベース操作エラー
     * @throws NamingException JNDIルックアップエラー
     */
    public void insert(Subject subject) throws SQLException, NamingException {
        String sql = "INSERT INTO SUBJECT (SCHOOL_CD, CD, NAME) VALUES (?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, subject.getSchoolCd());
            pstmt.setString(2, subject.getCd());
            pstmt.setString(3, subject.getName());
            pstmt.executeUpdate();
        }
    }

    /**
     * 科目を更新
     * @param subject 科目オブジェクト
     * @throws SQLException データベース操作エラー
     * @throws NamingException JNDIルックアップエラー
     */
    public void update(Subject subject) throws SQLException, NamingException {
        String sql = "UPDATE SUBJECT SET NAME = ? WHERE SCHOOL_CD = ? AND CD = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, subject.getName());
            pstmt.setString(2, subject.getSchoolCd());
            pstmt.setString(3, subject.getCd());
            pstmt.executeUpdate();
        }
    }

    /**
     * 科目を削除
     * @param schoolCd 学校コード
     * @param cd 科目コード
     * @throws SQLException データベース操作エラー
     * @throws NamingException JNDIルックアップエラー
     */
    public void delete(String schoolCd, String cd) throws SQLException, NamingException {
        String sql = "DELETE FROM.Subject WHERE SCHOOL_CD = ? AND CD = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, schoolCd);
            pstmt.setString(2, cd);
            pstmt.executeUpdate();
        }
    }
}