<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ include file="menu.jsp" %>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>学生一覧 - 学生管理システム</title>
<style>

    body { font-family: Arial, sans-serif; }

    table { width: 100%; border-collapse: collapse; }

    table, th, td { border: 1px solid black; }

    th, td { padding: 8px; text-align: left; }

    th { background-color: #f2f2f2; }

    .content { padding: 20px; }

    .link { display: inline-block; margin-top: 20px; }
</style>
</head>
<body>
<div class="content">
<h2>学生一覧</h2>
<table>
<tr>
<th>学生番号</th>
<th>学生名</th>
<th>コース名</th>
</tr>
<%

                String url = "jdbc:h2:tcp://localhost/~/kouka"; // ポート8080は不要

                String user = "sa";

                String password = "";

                Connection conn = null;

                Statement stmt = null;

                ResultSet rs = null;

                try {

                    Class.forName("org.h2.Driver"); // JDBCドライバのロード

                    conn = DriverManager.getConnection(url, user, password);

                    stmt = conn.createStatement();

                    String query = "SELECT * FROM STUDENT JOIN COURSE ON STUDENT.COURSE_ID = COURSE.COURSE_ID";

                    rs = stmt.executeQuery(query);

                    while (rs.next()) {

                        int studentId = rs.getInt("STUDENT_ID");

                        String name = rs.getString("STUDENT_NAME");

                        String course = rs.getString("COURSE_NAME");

            %>
<tr>
<td><%= studentId %></td>
<td><%= name %></td>
<td><%= course %></td>
</tr>
<%

                    }

                } catch (ClassNotFoundException e) {

                    out.println("<p style='color:red;'>JDBCドライバが見つかりません: " + e.getMessage() + "</p>");

                    e.printStackTrace();

                } catch (SQLException e) {

                    out.println("<p style='color:red;'>データベース接続エラー: " + e.getMessage() + "</p>");

                    e.printStackTrace();

                } finally {

                    try {

                        if (rs != null) rs.close();

                        if (stmt != null) stmt.close();

                        if (conn != null) conn.close();

                    } catch (SQLException e) {

                        e.printStackTrace();

                    }

                }

            %>
</table>
<div class="link">
<a href="index.jsp">Topページへ</a>
</div>
</div>
</body>
</html>

