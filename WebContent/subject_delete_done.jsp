<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>科目削除完了</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; }
        .content {
            margin-left: 220px;
            padding: 20px;
            margin-top: 50px;
        }
        h1 {
            color: #000;
            margin-top: 40px;
            font-size: 26px;
            background-color: #f0f0f0;
            padding: 10px;
        }
        .message-box { margin-bottom: 15px; }
        .message-box p {
            font-size: 16px;
            color: #2c3e50;
            text-align: center;
            background-color: #e6ffeb;
            padding: 10px;
            border-radius: 5px;
        }
        .error { color: red; }
        .link {
            margin-top: 20px;
        }
        .link a {
            color: #007bff;
            text-decoration: underline;
        }
        .link a:hover { color: #0056b3; }
        footer {
            position: fixed;
            bottom: 0;
            width: calc(100% - 220px);
            background: #f0f0f0;
            padding: 5px 20px;
            text-align: right;
        }
    </style>
</head>
<body>
    <%@ include file="sidebar.jsp" %>
    <%@ include file="header.jsp" %>

    <div class="content">
        <h1>科目情報削除完了</h1>

        <div class="message-box">
            <%
                String error = (String) request.getAttribute("error");
                if (error != null && !error.isEmpty()) {
            %>
                <p class="error">エラー: <%= error %></p>
            <%
                } else {
            %>
                <p>削除が完了しました。</p>
            <%
                }
            %>
        </div>

        <div class="link">
            <a href="${pageContext.request.contextPath}/SubjectList.action">科目一覧へ</a>
        </div>
    </div>

    <%@ include file="footer.jsp" %>
</body>
</html>