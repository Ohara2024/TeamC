package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import bean.Teacher;

public class TeacherDao extends Dao {

	/**
	 * getメソッド 教員IDを指定して教員インスタンスを1件取得する
	 *
	 * @param id:String 教員ID
	 * @return 教員クラスのインスタンス 存在しない場合はnull
	 * @throws Exception
	 */
	public Teacher get(String id) throws Exception {
		Teacher teacher = new Teacher();
		Connection connection = getConnection();
		PreparedStatement statement = null;

		try {
			statement = connection.prepareStatement("SELECT * FROM teacher WHERE id = ?");
			statement.setString(1, id);
			ResultSet rSet = statement.executeQuery();

			SchoolDao schoolDao = new SchoolDao();

			if (rSet.next()) {
				teacher.setId(rSet.getString("id"));
				teacher.setPassword(rSet.getString("password"));
				teacher.setName(rSet.getString("name"));
				teacher.setSchool(schoolDao.get(rSet.getString("school_cd")));
			} else {
				teacher = null;
			}
		} catch (Exception e) {
			throw e;
		} finally {
			if (statement != null) {
				try {
					statement.close();
				} catch (SQLException sqle) {
					throw sqle;
				}
			}
			if (connection != null) {
				try {
					connection.close();
				} catch (SQLException sqle) {
					throw sqle;
				}
			}
		}
		return teacher;
	}

	/**
	 * loginメソッド 教員IDとパスワードで認証する
	 *
	 * @param id:String 教員ID
	 * @param password:String パスワード
	 * @return 認証成功:教員クラスのインスタンス, 認証失敗:null
	 * @throws Exception
	 */
	public Teacher login(String id, String password) throws Exception {
	    Teacher teacher = null;

	    Connection con = getConnection();

	    try {
	        // 1. 先生情報を取得
	        String sql1 = "SELECT * FROM teacher WHERE id = ? AND password = ?";
	        PreparedStatement st1 = con.prepareStatement(sql1);
	        st1.setString(1, id);
	        st1.setString(2, password);
	        ResultSet rs1 = st1.executeQuery();

	        if (rs1.next()) {
	            teacher = new Teacher();
	            teacher.setId(rs1.getString("id"));
	            teacher.setName(rs1.getString("name"));
	            teacher.setPassword(rs1.getString("password"));
	            String schoolCd = rs1.getString("school_cd");
	            teacher.setSchoolcd(schoolCd);  // 先生の学校コードをセット

	            rs1.close();
	            st1.close();

	            // 2. クラス情報を取得（同じ school_cd の classnum を取得）
	            String sql2 = "SELECT classnum FROM class_num WHERE schoolcd = ?";
	            PreparedStatement st2 = con.prepareStatement(sql2);
	            st2.setString(1, schoolCd);
	            ResultSet rs2 = st2.executeQuery();

	            if (rs2.next()) {
	                teacher.setClassnum(rs2.getString("classnum"));  // 最初の1件だけ取得
	            }

	            rs2.close();
	            st2.close();
	        } else {
	            // ログイン失敗
	            rs1.close();
	            st1.close();
	        }

	    } finally {
	        con.close();
	    }

	    return teacher;



	}
}
