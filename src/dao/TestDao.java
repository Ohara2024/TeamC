package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.NamingException;

import bean.Test;

/**
 * 得点情報を管理するDAOクラス
 */
public class TestDao extends Dao {
    /**
     * 得点を全件取得
     * @return 得点リスト
     * @throws SQLException データベース操作エラー
     * @throws NamingException JNDIルックアップエラー
     */
    public List<Test> findAll() throws SQLException, NamingException {
        List<Test> tests = new ArrayList<>();
        String sql = "SELECT STUDENT_NO, SUBJECT_CD, SCHOOL_CD, NO, POINT, CLASS_NUM FROM TEST";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Test test = new Test();
                test.setStudentNo(rs.getString("STUDENT_NO"));
                test.setSubjectCd(rs.getString("SUBJECT_CD"));
                test.setSchoolCd(rs.getString("SCHOOL_CD"));
                test.setNo(rs.getInt("NO"));
                test.setPoint(rs.getInt("POINT"));
                test.setClassNum(rs.getString("CLASS_NUM"));
                tests.add(test);
            }
        }
        return tests;
    }

    /**
     * 得点を追加
     * @param test 得点オブジェクト
     * @throws SQLException データベース操作エラー
     * @throws NamingException JNDIルックアップエラー
     */
    public void insert(Test test) throws SQLException, NamingException {
        String sql = "INSERT INTO TEST (STUDENT_NO, SUBJECT_CD, SCHOOL_CD, NO, POINT, CLASS_NUM) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, test.getStudentNo());
            pstmt.setString(2, test.getSubjectCd());
            pstmt.setString(3, test.getSchoolCd());
            pstmt.setInt(4, test.getNo());
            pstmt.setInt(5, test.getPoint());
            pstmt.setString(6, test.getClassNum());
            pstmt.executeUpdate();
        }
    }

    /**
     * 得点を更新
     * @param test 得点オブジェクト
     * @throws SQLException データベース操作エラー
     * @throws NamingException JNDIルックアップエラー
     */
    public void update(Test test) throws SQLException, NamingException {
        String sql = "UPDATE TEST SET POINT = ?, CLASS_NUM = ? WHERE STUDENT_NO = ? AND SUBJECT_CD = ? AND SCHOOL_CD = ? AND NO = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, test.getPoint());
            pstmt.setString(2, test.getClassNum());
            pstmt.setString(3, test.getStudentNo());
            pstmt.setString(4, test.getSubjectCd());
            pstmt.setString(5, test.getSchoolCd());
            pstmt.setInt(6, test.getNo());
            pstmt.executeUpdate();
        }
    }

    /**
     * 得点を削除
     * @param studentNo 学生番号
     * @param subjectCd 科目コード
     * @param schoolCd 学校コード
     * @param no 試験番号
     * @throws SQLException データベース操作エラー
     * @throws NamingException JNDIルックアップエラー
     */
    public void delete(String studentNo, String subjectCd, String schoolCd, int no) throws SQLException, NamingException {
        String sql = "DELETE FROM TEST WHERE STUDENT_NO = ? AND SUBJECT_CD = ? AND SCHOOL_CD = ? AND NO = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, studentNo);
            pstmt.setString(2, subjectCd);
            pstmt.setString(3, schoolCd);
            pstmt.setInt(4, no);
            pstmt.executeUpdate();
        }
    }
}