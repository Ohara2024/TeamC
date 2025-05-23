package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import bean.ClassNum;
import bean.School;

public class ClassNumDao extends Dao {

    public ClassNum getClassByCode(String classCode) throws Exception {
        ClassNum classNum = null;
        Connection connection = getConnection();
        PreparedStatement statement = null;
        ResultSet rSet = null;

        try {
            statement = connection.prepareStatement(
                "SELECT class_num, school_cd FROM classnum WHERE class_num = ?"
            );
            statement.setString(1, classCode);
            rSet = statement.executeQuery();

            if (rSet.next()) {
                classNum = new ClassNum();
                classNum.setNum(rSet.getString("class_num"));

                School school = new School();
                school.setCd(rSet.getString("school_cd"));
                classNum.setSchool(school);
            }
        } finally {
            if (rSet != null) rSet.close();
            if (statement != null) statement.close();
            if (connection != null) connection.close();
        }
        return classNum;
    }

    public String getSchoolCodeByClassCode(String classCode) throws Exception {
        // 既存のschoolCd取得メソッドがあれば使う
        ClassNum classNum = getClassByCode(classCode);
        return (classNum != null && classNum.getSchool() != null) ? classNum.getSchool().getCd() : null;
    }
}
