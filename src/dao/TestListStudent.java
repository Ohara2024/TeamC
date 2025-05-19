package dao;

import java.util.List;

public class TestListStudent {
    private String studentNo;  // 学生番号
    private String name;       // 学生名
    private List<Test> tests;  // 関連するテストリスト

    // デフォルトコンストラクタ
    public TestListStudent() {}

    // 全フィールド指定コンストラクタ
    public TestListStudent(String studentNo, String name, List<Test> tests) {
        this.studentNo = studentNo;
        this.name = name;
        this.tests = tests;
    }

    // ゲッターとセッター
    public String getStudentNo() {
        return studentNo;
    }

    public void setStudentNo(String studentNo) {
        this.studentNo = studentNo;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public List<Test> getTests() {
        return tests;
    }

    public void setTests(List<Test> tests) {
        this.tests = tests;
    }
}