<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>科目一覧 - 科目管理システム</title>
<style>

        body {

            font-family: 'Arial', 'Helvetica Neue', sans-serif;

            background-color: #f0f4f8;

            color: #1a1a1a;

            font-weight: 400;

        }

        .content {

            max-width: 1000px;

            margin: 40px auto;

            padding: 20px;

            background-color: #ffffff;

            border-radius: 10px;

            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);

        }

        h2 {

            color: #2c3e50;

            font-weight: 600;

            margin-bottom: 20px;

            text-align: center;

        }

        table {

            width: 100%;

            border-collapse: collapse;

            background-color: #fff;

            border-radius: 8px;

            overflow: hidden;

        }

        th, td {

            padding: 12px 15px;

            text-align: left;

            border-bottom: 1px solid #e0e0e0;

        }

        th {

            background-color: #3498db;

            color: #fff;

            font-weight: 500;

            text-transform: uppercase;

            letter-spacing: 0.5px;

        }

        tr:nth-child(even) {

            background-color: #f9f9f9;

        }

        tr:hover {

            background-color: #ecf0f1;

            transition: background-color 0.3s ease;

        }

        .link {

            margin-top: 20px;

            text-align: center;

        }

        .link a {

            display: inline-block;

            padding: 10px 20px;

            background-color: #e74c3c;

            color: #fff;

            text-decoration: none;

            border-radius: 25px;

            font-weight: 500;

            transition: background-color 0.3s ease, transform 0.2s ease;

        }

        .link a:hover {

            background-color: #c0392b;

            transform: translateY(-2px);

        }

        p[style*="color:red"] {

            background-color: #ffe6e6;

            padding: 10px;

            border-radius: 5px;

            border-left: 4px solid #e74c3c;

        }
</style>
</head>
<body>
<div class="content">
<h2>科目一覧</h2>
<table>
<tr>
<th>科目ID</th>
<th>科目名</th>
</tr>
<%

                String url = "jdbc:h2:tcp://localhost/~/seiseki";

                String user = "sa";

                String password = "";

                Connection conn = null;

                Statement stmt = null;

                ResultSet rs = null;

                try {

                    // JDBCドライバのロード

                    Class.forName("org.h2.Driver");

                    // データベース接続

                    conn = DriverManager.getConnection(url, user, password);

                    stmt = conn.createStatement();

                    // 科目データを取得

                    String query = "SELECT CD, NAME FROM SUBJECT;";

                    rs = stmt.executeQuery(query);

                    // 結果を表示

                    while (rs.next()) {

                        String subjectId = rs.getString("CD");

                        String subjectName = rs.getString("NAME");

            %>
<tr>
<td><%= subjectId %></td>
<td><%= subjectName %></td>
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
