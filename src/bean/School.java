package bean;

public class School {
    private String cd;
    private String name; // name フィールドを追加

    public String getCd() {
        return cd;
    }

    public void setCd(String cd) {
        this.cd = cd;
    }

    public String getName() { // getName メソッドを追加
        return name;
    }

    public void setName(String name) { // setName メソッドを追加
        this.name = name;
    }

    @Override
    public String toString() {
        return "School{cd='" + cd + "', name='" + name + "'}"; // toString に name を追加
    }
}