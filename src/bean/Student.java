package bean;

public class Student {
    private String no;        // NO
    private String name;      // NAME
    private int entYear;      // ENT_YEAR
    private String classNum;  // CLASS_NUM
    private boolean attend;   // IS_ATTEND
    private String schoolCd;  // SCHOOL_CD

    // デフォルトコンストラクタ
    public Student() {}

    // 全フィールド指定コンストラクタ
    public Student(String no, String name, int entYear, String classNum, boolean attend, String schoolCd) {
        this.no = no;
        this.name = name;
        this.entYear = entYear;
        this.classNum = classNum;
        this.attend = attend;
        this.schoolCd = schoolCd;
    }

    // ゲッターとセッター
    public String getNo() {
        return no;
    }

    public void setNo(String no) {
        this.no = no;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getEntYear() {
        return entYear;
    }

    public void setEntYear(int entYear) {
        this.entYear = entYear;
    }

    public String getClassNum() {
        return classNum;
    }

    public void setClassNum(String classNum) {
        this.classNum = classNum;
    }

    public boolean isAttend() {
        return attend;
    }

    public void setAttend(boolean attend) {
        this.attend = attend;
    }

    public String getSchoolCd() {
        return schoolCd;
    }

    public void setSchoolCd(String schoolCd) {
        this.schoolCd = schoolCd;
    }
}