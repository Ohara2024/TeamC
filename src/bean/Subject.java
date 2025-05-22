package bean;

public class Subject {
    private String schoolCd;  // SCHOOL_CD
    private String cd;        // CD
    private String name;      // NAME

    // デフォルトコンストラクタ
    public Subject() {}

    // 全フィールド指定コンストラクタ
    public Subject(String schoolCd, String cd, String name) {
        this.schoolCd = schoolCd;
        this.cd = cd;
        this.name = name;
    }

    // ゲッターとセッター
    public String getSchoolCd() {
        return schoolCd;
    }

    public void setSchoolCd(String schoolCd) {
        this.schoolCd = schoolCd;
    }

    public String getCd() {
        return cd;
    }

    public void setCd(String cd) {
        this.cd = cd;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}