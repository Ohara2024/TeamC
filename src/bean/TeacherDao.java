package bean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import bean.Teacher;

public class TeacherDao extends Dao {

    public Teacher login(String id, String password) {
        Teacher teacher = null;

        try {
            Connection conn = getConnection();

            String sql = "SELECT * FROM teacher WHERE id = ? AND password = ?";
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, id);
            ps.setString(2, password);

            System.out.println("🔍 SQL実行: id=" + id + ", password=" + password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                System.out.println("✅ ログイン成功");

                teacher = new Teacher();
                teacher.setId(rs.getString("id"));
                teacher.setPassword(rs.getString("password"));
                teacher.setName(rs.getString("name"));
                teacher.setSchoolCd(rs.getString("school_cd")); // ← ここも忘れずに！
            } else {
                System.out.println("❌ ログイン失敗: 該当データなし");
            }

            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return teacher;
    }
}
