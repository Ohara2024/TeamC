<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="menu.jsp" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>学生追加結果</title>
    <style>
        .success { color: green; font-weight: bold; }
        .error { color: red; font-weight: bold; }
    </style>
</head>
<body>
    <h1>学生追加結果</h1>

    <%
        String success = request.getParameter("success");
        if ("true".equals(success)) {
    %>
        <p class="success">学生の追加が完了しました。</p>
    <%
        } else {
    %>
        <p class="error">学生の追加に失敗しました。</p>
    <%
        }
    %>

    <a href="<%= request.getContextPath() %>/kouka1/StudentAdd.jsp">学生追加フォームへ戻る</a>
</body>
</html>
