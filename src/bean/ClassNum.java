package bean;

public class ClassNum {
    private String schoolCd;  // SCHOOL_CD
    private String classNum;  // CLASS_NUM

    // デフォルトコンストラクタ
    public ClassNum() {}

    // 全フィールド指定コンストラクタ
    public ClassNum(String schoolCd, String classNum) {
        this.schoolCd = schoolCd;
        this.classNum = classNum;
    }

    // ゲッターとセッター
    public String getSchoolCd() {
        return schoolCd;
    }

    public void setSchoolCd(String schoolCd) {
        this.schoolCd = schoolCd;
    }

    public String getClassNum() {
        return classNum;
    }

    public void setClassNum(String classNum) {
        this.classNum = classNum;
    }
}