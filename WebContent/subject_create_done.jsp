<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>登録完了 - 科目管理システム</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }
        .content {
            margin-left: 220px;
            padding: 20px;
            margin-top: 50px;
        }
        h2 {
            color: #000;
            font-size: 26px;
            background-color: #f0f0f0;
            padding: 10px;
        }
        a {
            color: #007bff;
            text-decoration: underline;
        }
        a:hover {
            color: #0056b3;
        }
        .message {
        font-size: 18px;
        margin-top: 20px;
        color: #2c3e50;
        background-color: #e6ffeb; /* 背景色 */
        text-align: center; /* テキスト中央 */
        padding: 10px; /* 余白 */
        width:  calc(100% - 220px); /* 幅指定 */
        margin: 20px auto; /* 中央配置 */
        border-radius: 8px; /* 角丸もおしゃれに */
        }
    .back-link {
        margin-top: 20px;
        display: block;
    }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>
    <div class="content">
        <h2>登録完了</h2>
        <p class="message">科目が正常に登録されました。</p>
        <a href="${pageContext.request.contextPath}/SubjectList.action">科目一覧へ</a>
    </div>
    <%@ include file="footer.jsp" %>
</body>
</html>
