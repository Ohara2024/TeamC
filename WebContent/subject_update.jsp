<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>科目情報の変更</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; }
        .content { margin-left: 220px; padding: 20px; }
        h1 { color: #000; margin-top: 0; font-size: 26px; background-color: #f0f0f0; padding: 10px; }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
            border-left: 1px solid #CCCCCC; /* テーブルの左端に縦線 */
            border-right: 1px solid #CCCCCC; /* テーブルの右端に縦線 */
        }
        th, td {
            padding: 8px;
            text-align: left;
            border-top: 1px solid #CCCCCC;
            border-bottom: 1px solid #CCCCCC;
            border-left: none; /* すべての縦線をデフォルトで消す */
            border-right: none; /* すべての縦線をデフォルトで消す */
        }
        th { background-color: #ffffff; }
        .action-btn {
            color: #007bff;
            text-decoration: underline;
            background: none;
            padding: 0;
            margin-right: 10px;
        }
        .action-btn:hover {
            color: #0056b3;
        }
        .top-actions {
            margin-bottom: 10px;
            display: flex;
            justify-content: flex-end;
        }
        .error { color: red; }

        /* フォーム関連の調整 */
        .form-group {
            margin-bottom: 30px; /* 科目名と更新ボタンの間の隙間を広く */
        }
        .submit-button {
            margin-bottom: 20px; /* 更新ボタンと戻るリンクの間の隙間を広く */
        }
        .submit-button input[type="submit"] {
            padding: 8px 20px;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 3px;
            cursor: pointer;
        }
        .submit-button input[type="submit"]:hover {
            background-color: #0056b3;
        }
        .cancel-link {
            text-align: left; /* 中央から左寄せに変更 */
        }
        .cancel-link a {
            color: #007bff;
            text-decoration: none;
        }
        .cancel-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<%@ include file="sidebar.jsp" %>
<%@ include file="header.jsp" %>

<!-- メインコンテンツ -->
<div class="content">
    <h1>科目情報の変更</h1>

    <% String error = (String) request.getAttribute("error"); %>
    <% if (error != null && !error.isEmpty()) { %>
        <p class="error"><%= error %></p>
    <% } %>

    <form action="SubjectUpdate.action" method="post">
        <p>科目ID: <%= request.getAttribute("subjectcd") %></p>
        <input type="hidden" name="subjectcd" value="<%= request.getAttribute("subjectcd") %>">

        <div class="form-group">
            <label>科目名:</label>
            <input type="text" name="subjectName" value="<%= request.getAttribute("subjectName") %>">
        </div>

        <input type="hidden" name="schoolCd" value="<%= request.getAttribute("schoolCd") %>">

        <div class="submit-button">
            <input type="submit" value="更新">
        </div>
    </form>

    <div class="link cancel-link">
        <a href="${pageContext.request.contextPath}/SubjectList.action">戻る</a>
    </div>
</div>

<!-- フッター -->
<%@ include file="footer.jsp" %>

</body>
</html>