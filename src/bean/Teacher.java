package bean;

import java.io.Serializable;

public class Teacher extends User implements Serializable {
	/**
	 * 教員ID:String
	 */
	private String id;

	/**
	 * パスワード:String
	 */
	private String password;

	/**
	 * 教員名:String
	 */
	private String name;

	/**
	 * 所属校:School
	 */
	private School school;

	private String schoolcd;
	private String classnum;

	public String getSchoolcd() {
	    return schoolcd;
	}

	public void setSchoolcd(String schoolcd) {
	    this.schoolcd = schoolcd;
	}

	public String getClassnum() {
	    return classnum;
	}

	public void setClassnum(String classnum) {
	    this.classnum = classnum;
	}

	/**
	 * ゲッター、セッター
	 */
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public School getSchool() {
		return school;
	}

	public void setSchool(School school) {
		this.school = school;
	}
}
