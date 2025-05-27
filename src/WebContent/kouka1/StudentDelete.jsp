<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ include file="menu.jsp" %>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>学生削除 - 学生管理システム</title>
    <style>
        body { font-family: Arial, sans-serif; }
        .content { padding: 20px; }
        label { font-weight: bold; margin-right: 10px; }
        .form-group {
            display: flex;
            align-items: center;
            gap: 10px; /* ボックスとボタンの間の余白 */
        }
        select {
            width: 150px; /* 選択ボックスを小さくする */
            padding: 5px;
            font-size: 10px;
        }
        input[type="submit"] {
            padding: 5px 10px;
            font-size: 16px;
        }
    </style>
</head>
<body>

<div class="content">
    <h2>学生削除画面</h2>
    <form action="StudentDeleteProcess.jsp" method="POST">
        <div class="form-group">
            <label for="student_id">学生名:</label>
            <select name="student_id" id="student_id" required>
                <%
                    String url = "jdbc:h2:tcp://localhost/~/kouka";
                    String user = "sa";
                    String password = "";

                    try (Connection conn = DriverManager.getConnection(url, user, password);
                         Statement stmt = conn.createStatement();
                         ResultSet rs = stmt.executeQuery("SELECT STUDENT_ID, STUDENT_NAME FROM STUDENT")) {

                        while (rs.next()) {
                            int studentId = rs.getInt("STUDENT_ID");
                            String studentName = rs.getString("STUDENT_NAME");
                %>
                <option value="<%= studentId %>"><%= studentName %></option>
                <%
                        }
                    } catch (SQLException e) {
                        out.println("<p style='color:red;'>データベース接続エラー: " + e.getMessage() + "</p>");
                    }
                %>
            </select>
            <input type="submit" value="削除">
        </div>
    </form>
</div>

</body>
</html>
