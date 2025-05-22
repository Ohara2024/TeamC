package bean;

public class Teacher {
    private String id;           // ID
    private String password;     // PASSWORD
    private String name;         // NAME
    private String schoolCd;     // SCHOOL_CD
    private boolean authenticated = false;  // 認証フラグ（追加）

    // デフォルトコンストラクタ
    public Teacher() {}

    // 全フィールド指定コンストラクタ（認証フラグは除く）
    public Teacher(String id, String password, String name, String schoolCd) {
        this.id = id;
        this.password = password;
        this.name = name;
        this.schoolCd = schoolCd;
    }

    // ゲッターとセッター

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

    public String getSchoolCd() {
        return schoolCd;
    }

    public void setSchoolCd(String schoolCd) {
        this.schoolCd = schoolCd;
    }

    // 認証フラグのgetterとsetter

    public boolean isAuthenticated() {
        return authenticated;
    }

    public void setAuthenticated(boolean authenticated) {
        this.authenticated = authenticated;
    }
}
