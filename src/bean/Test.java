package bean;

public class Test {
    private String studentNo;  // STUDENT_NO
    private String subjectCd;  // SUBJECT_CD
    private String schoolCd;   // SCHOOL_CD
    private int no;            // NO
    private int point;         // POINT
    private String classNum;   // CLASS_NUM

    // デフォルトコンストラクタ
    public Test() {}

    // 全フィールド指定コンストラクタ
    public Test(String studentNo, String subjectCd, String schoolCd, int no, int point, String classNum) {
        this.studentNo = studentNo;
        this.subjectCd = subjectCd;
        this.schoolCd = schoolCd;
        this.no = no;
        this.point = point;
        this.classNum = classNum;
    }

    // ゲッターとセッター
    public String getStudentNo() {
        return studentNo;
    }

    public void setStudentNo(String studentNo) {
        this.studentNo = studentNo;
    }

    public String getSubjectCd() {
        return subjectCd;
    }

    public void setSubjectCd(String subjectCd) {
        this.subjectCd = subjectCd;
    }

    public String getSchoolCd() {
        return schoolCd;
    }

    public void setSchoolCd(String schoolCd) {
        this.schoolCd = schoolCd;
    }

    public int getNo() {
        return no;
    }

    public void setNo(int no) {
        this.no = no;
    }

    public int getPoint() {
        return point;
    }

    public void setPoint(int point) {
        this.point = point;
    }

    public String getClassNum() {
        return classNum;
    }

    public void setClassNum(String classNum) {
        this.classNum = classNum;
    }
}