package bean;

public class School {
    private String cd;    // CD
    private String name;  // NAME

    // デフォルトコンストラクタ
    public School() {}

    // 全フィールド指定コンストラクタ
    public School(String cd, String name) {
        this.cd = cd;
        this.name = name;
    }

    // ゲッターとセッター
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