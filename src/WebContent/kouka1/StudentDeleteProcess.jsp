<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ include file="menu.jsp" %>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>削除結果 - 学生管理システム</title>
    <style>
        body { font-family: Arial, sans-serif; }
        .content { padding: 20px; }
        .message { margin-top: 20px; font-weight: bold; }
    </style>
</head>
<body>

<div class="content">
    <h2>削除結果</h2>

    <%
        String url = "jdbc:h2:tcp://localhost/~/kouka";
        String user = "sa";
        String password = "";
        String studentIdToDelete = request.getParameter("student_id");

        if (studentIdToDelete != null && !studentIdToDelete.isEmpty()) {
            try (Connection conn = DriverManager.getConnection(url, user, password);
                 PreparedStatement pstmt = conn.prepareStatement("DELETE FROM STUDENT WHERE STUDENT_ID = ?")) {

                pstmt.setInt(1, Integer.parseInt(studentIdToDelete));
                int result = pstmt.executeUpdate();

                if (result > 0) {
    %>
                    <div class="message">
                        <p>削除が完了しました。</p>

                        <a href="index.jsp">Topページへ</a>
                    </div>
    <%
                } else {
    %>
                    <div class="message">
                        <p style="color:red;">削除に失敗しました。</p>
|
                        <a href="index.jsp">Topページへ</a>
                    </div>
    <%
                }
            } catch (SQLException | NumberFormatException e) {
                out.println("<p style='color:red;'>エラーが発生しました: " + e.getMessage() + "</p>");
            }
        } else {
    %>
        <div class="message">
            <p style="color:red;">無効な入力です。</p>
            <a href="index.jsp">Topページへ</a>
        </div>
    <%
        }
    %>

</div>

</body>
</html>
