<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>得点管理システム</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; }
        .content { margin-left: 220px; padding: 20px; }
        h1 { color: #000000; margin-top: 0; font-size: 30px; background-color: #f0f0f0; padding: 10px; }
        a { color: #007bff; text-decoration: none; }
        a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <%@ include file="sidebar.jsp" %>
    <%@ include file="header.jsp" %>

    <div class="content">
        <br><br><br><br>
        <h1>学生情報登録</h1>
        <p style="text-align: center; background-color: #AAC491; height: 60px;"><br>登録が完了しました</p>
        <a href="StudentCreateAction">戻る</a>
        <a href="StudentListAction">学生一覧</a>
        <br><br><br><br><br><br><br><br><br><br><br><br><br>
    </div>

    <%@ include file="footer.jsp" %>
</body>
</html>
