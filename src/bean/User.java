package bean;

public class User {
    private String username;  // ユーザー名（TEACHERのIDに対応）
    private String name;      // 表示名（TEACHERのNAMEに対応）
    private String schoolCd;  // 学校コード（TEACHERのSCHOOL_CDに対応）

    // デフォルトコンストラクタ
    public User() {}

    // 全フィールド指定コンストラクタ
    public User(String username, String name, String schoolCd) {
        this.username = username;
        this.name = name;
        this.schoolCd = schoolCd;
    }

    // ゲッターとセッター
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
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
}