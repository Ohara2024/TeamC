package bean;

import java.util.List;

public class TestListSubject {
    private String subjectCd;  // 科目コード
    private String subjectName; // 科目名
    private List<Test> tests;  // 関連するテストリスト

    // デフォルトコンストラクタ
    public TestListSubject() {}

    // 全フィールド指定コンストラクタ
    public TestListSubject(String subjectCd, String subjectName, List<Test> tests) {
        this.subjectCd = subjectCd;
        this.subjectName = subjectName;
        this.tests = tests;
    }

    // ゲッターとセッター
    public String getSubjectCd() {
        return subjectCd;
    }

    public void setSubjectCd(String subjectCd) {
        this.subjectCd = subjectCd;
    }

    public String getSubjectName() {
        return subjectName;
    }

    public void setSubjectName(String subjectName) {
        this.subjectName = subjectName;
    }

    public List<Test> getTests() {
        return tests;
    }

    public void setTests(List<Test> tests) {
        this.tests = tests;
    }
}