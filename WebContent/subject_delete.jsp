<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>得点管理システム</title>
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
        .form-group { margin-bottom: 15px; }
        label { display: block; font-weight: bold; margin-bottom: 5px; }
        input[type="text"], select {
            width: 300px;
            padding: 5px;
            border: 1px solid #ccc;
        }
        .submit-button { margin-top: 20px; }
        .submit-button input[type="submit"] {
            padding: 8px 15px;
            background-color: #ff0000;
            color: #fff;
            border: none;
            cursor: pointer;
            border-radius: 5px;
        }
        .submit-button input[type="submit"]:hover {
            background-color: #cc0000;
        }
        .link {
            margin-top: 20px;
        }
        .link a {
            color: #007bff;
            text-decoration: underline;
        }
        .link a:hover { color: #0056b3; }
        .cancel-link { margin-left: 10px; }
        .error { color: red; }
        footer {
            position: fixed;
            bottom: 0;
            width: calc(100% - 220px);
            background: #f0f0f0;
            padding: 5px 20px;
            text-align: right;
        }
    </style>
    <script>
        function confirmDelete(subjectcd, subjectName) {
            return confirm("科目コード: " + subjectcd + "\n科目名: " + subjectName + "\nこの科目を削除しますか？");
        }
    </script>
</head>
<body>
    <%@ include file="sidebar.jsp" %>
    <%@ include file="header.jsp" %>

    <div class="content">
        <h1>科目情報削除</h1>

        <%
            String subjectcd = (String) request.getAttribute("subjectcd");
            String subjectName = (String) request.getAttribute("subjectName");
            String schoolCd = (String) request.getAttribute("schoolCd");
            String error = (String) request.getAttribute("error");

            // デバッグ（開発中のみ）
            System.out.println("subject_delete.jsp: subjectcd=" + subjectcd);
            System.out.println("subject_delete.jsp: subjectname=" + subjectName);
            System.out.println("subject_delete.jsp: schoolcd=" + schoolCd);
            System.out.println("subject_delete.jsp: error=" + error);

            if (subjectcd == null || subjectName == null || schoolCd == null) {
        %>
            <p class="error">エラー: 科目情報が正しく指定されていません。</p>
            <div class="link">
                <a href="${pageContext.request.contextPath}/SubjectList.action">戻る</a>
            </div>
        <%
            } else {
        %>
            <% if (error != null && !error.isEmpty()) { %>
                <p class="error">エラー: <%= error %></p>
            <% } %>

            <p>
                科目コード: <%= subjectcd %><br>
                科目名: <%= subjectName %><br>
                この科目を削除します。よろしいですか？
            </p>

            <form action="${pageContext.request.contextPath}/SubjectDelete.action" method="post" class="submit-button" onsubmit="return confirmDelete('<%= subjectcd %>', '<%= subjectName %>')">
                <input type="hidden" name="subjectcd" value="<%= subjectcd %>">
                <input type="hidden" name="schoolCd" value="<%= schoolCd %>">
                <input type="submit" value="削除">
                <div class="link cancel-link">
                    <a href="${pageContext.request.contextPath}/SubjectList.action">戻る</a>
                </div>
            </form>
        <%
            }
        %>
    </div>

    <%@ include file="footer.jsp" %>
</body>
</html>
