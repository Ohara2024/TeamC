package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import bean.School;
import bean.Subject;

public class SubjectDao {
    private static final String DB_URL = "jdbc:h2:tcp://localhost/~/exam";
    private static final String DB_USER = "sa";
    private static final String DB_PASSWORD = "";

    private Connection getConnection() throws SQLException {
        try {
            Class.forName("org.h2.Driver");
            return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("JDBCドライバが見つかりません: " + e.getMessage(), e);
        }
    }

    public List<Subject> findAll() throws SQLException {
        List<Subject> subjects = new ArrayList<>();
        String sql = "SELECT cd, name, school_cd FROM subject";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Subject subject = new Subject();
                subject.setCd(rs.getString("cd"));
                subject.setName(rs.getString("name"));

                School school = new School();
                school.setCd(rs.getString("school_cd"));
                subject.setSchool(school);

                subjects.add(subject);
            }
        }
        return subjects;
    }

    // 科目を主キーで取得（統一された名前）
    public Subject getSubjectById(String cd, String schoolCd) throws SQLException {
        String sql = "SELECT cd, name, school_cd FROM subject WHERE cd = ? AND school_cd = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, cd);
            stmt.setString(2, schoolCd);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Subject subject = new Subject();
                    subject.setCd(rs.getString("cd"));
                    subject.setName(rs.getString("name"));

                    School school = new School();
                    school.setCd(rs.getString("school_cd"));
                    subject.setSchool(school);

                    return subject;
                }
            }
        }
        return null;
    }

    // 削除処理（メソッド名も統一）
    public boolean delete(String subjectcd, String schoolCd) throws Exception {
        String sql = "DELETE FROM subject WHERE cd = ? AND school_cd = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, subjectcd);
            ps.setString(2, schoolCd);
            int result = ps.executeUpdate();
            return result > 0;
        }
    }




    // 任意: 登録
    public boolean insert(Subject subject) throws SQLException {
        String sql = "INSERT INTO subject (cd, name, school_cd) VALUES (?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, subject.getCd());
            stmt.setString(2, subject.getName());
            stmt.setString(3, subject.getSchool().getCd());

            int rowsInserted = stmt.executeUpdate();
            return rowsInserted > 0;
        }
    }

    // 任意: 更新
    public boolean update(Subject subject) throws SQLException {
        String sql = "UPDATE subject SET name = ? WHERE cd = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, subject.getName());
            stmt.setString(2, subject.getCd());

            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;
        }
    }

}
