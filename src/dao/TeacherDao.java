package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import bean.School;
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

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                teacher = new Teacher();

                teacher.setId(rs.getString("id"));

                teacher.setPassword(rs.getString("password"));

                teacher.setName(rs.getString("name"));

                School school = new School();

                school.setCd(rs.getString("school_cd"));

                teacher.setSchool(school);

            }

            conn.close();

        } catch (Exception e) {

            e.printStackTrace();

        }

        return teacher;

    }

}

