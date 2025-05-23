<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>得点管理システム</title>
    <style>
    body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 0;
    }
    .content {
        margin-left: 220px;
        padding: 20px;
    }
    h1 {
        background-color: #f0f0f0;
        padding: 10px;
        color: #000;
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

<%@ include file="sidebar.jsp" %>
<%@ include file="header.jsp" %>

<div class="content">
    <br><br><br><br>
    <h1>科目更新完了</h1>
    <p class="message">科目情報の更新が完了しました。</p>
    <div class="link">
            <a href="${pageContext.request.contextPath}/SubjectList.action">科目一覧へ</a>
        </div>
</div>

<%@ include file="footer.jsp" %>
</body>
</html>
