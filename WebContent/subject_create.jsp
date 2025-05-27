<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>科目情報登録 - 科目管理システム</title>
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
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: inline-block;
            width: 100px;
            font-weight: bold;
        }
        input[type="text"] {
            padding: 5px;
            width: 200px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        input[type="submit"] {
            padding: 8px 20px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background-color: #0056b3;
        }
        .error {
            color: red;
            margin-bottom: 10px;
        }
        .link a {
            color: #007bff;
            text-decoration: underline;
            margin-right: 10px;
        }
        .link a:hover {
            color: #0056b3;
        }
        .note {
            font-size: 12px;
            color: #555;
        }
    </style>
</head>
<body>
    <%@ include file="sidebar.jsp" %>
    <%@ include file="header.jsp" %>

    <div class="content">
        <h2>科目情報登録</h2>

        <%-- エラーメッセージの表示 --%>
        <% String error = (String) request.getAttribute("error"); %>
        <% if (error != null && !error.isEmpty()) { %>
            <p class="error">エラー: <%= error %></p>
        <% } %>

        <%-- 科目登録フォーム --%>
        <form action="${pageContext.request.contextPath}/SubjectCreate.action" method="post">
            <div class="form-group">
                <label for="subjectCd">科目コード</label>
                <input type="text" id="subjectCd" name="subjectcd" required maxlength="3"
                       value="<%= request.getAttribute("subjectCd") != null ? request.getAttribute("subjectCd") : "" %>">
                <p class="note">英数字3文字</p>
            </div>
            <div class="form-group">
                <label for="subjectName">科目名</label>
                <input type="text" id="subjectName" name="subjectName" required maxlength="50"
                       value="<%= request.getAttribute("subjectName") != null ? request.getAttribute("subjectName") : "" %>">
                <p class="note">50文字以内</p>
            </div>
            <div class="form-group">
                <input type="submit" value="登録">
            </div>
        </form>

        <%-- 戻るリンク --%>
        <div class="link">
            <a href="${pageContext.request.contextPath}/SubjectList.action">科目一覧へ</a>
        </div>
    </div>

    <%@ include file="footer.jsp" %>
</body>
</html>