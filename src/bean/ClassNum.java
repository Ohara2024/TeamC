package bean;

import java.io.Serializable;

public class ClassNum implements Serializable {

    private String teacherId;
    private String schoolcd;
    private String classnum;

    // ゲッター・セッター

    public String getTeacherId() {
        return teacherId;
    }

    public void setTeacherId(String teacherId) {
        this.teacherId = teacherId;
    }

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
}
