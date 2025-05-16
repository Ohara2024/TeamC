<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List, bean.Subject" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>科目管理</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; }
        .content { margin-left: 220px; padding: 20px; }
        h1 { color: #000; margin-top: 0; font-size: 26px; background-color: #f0f0f0; padding: 10px; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { padding: 8px; text-align: left; border-width: 1px 0px; border-color: #CCCCCC; border-style: solid; padding: 0.5em; }
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
            text-decoration: underline;
        }
        .top-actions {
            margin-bottom: 10px;
            display: flex;
            justify-content: flex-end;
        }
        .error { color: red; }
    </style>
</head>
<body>
<%@ include file="sidebar.jsp" %>
<%@ include file="header.jsp" %>

<div class="content">
    <br><br><br><br>
    <h1>科目管理</h1>

    <!-- 新規登録リンク -->
    <div class="top-actions">
        <a href="SubjectList.action?action=create" class="action-btn">新規登録</a>
    </div>

    <%
        List<Subject> subjects = (List<Subject>) request.getAttribute("subjects");
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
        <p class="error">エラー: <%= error %></p>
    <%
        }
        if (subjects == null || subjects.isEmpty()) {
    %>
        <p style="color: #000000;">科目情報が存在しませんでした</p>
    <% } else { %>
        <!-- 科目一覧テーブル -->
        <table>
            <tr>
                <th>科目コード</th>
                <th>科目名</th>
                <th></th>
            </tr>
            <% for (Subject subject : subjects) { %>
                <tr>
                    <td><%= subject.getCd() %></td>
                    <td><%= subject.getName() %></td>
                    <td>
                        <a href="SubjectList.action?action=edit&cd=<%= subject.getCd() %>&schoolCd=<%= subject.getSchool().getCd() %>" class="action-btn">変更</a>
                        <a href="SubjectList.action?action=delete&cd=<%= subject.getCd() %>&schoolCd=<%= subject.getSchool().getCd() %>" class="action-btn">削除</a>
                    </td>
                </tr>
            <% } %>
        </table>
    <% } %>
</div>

<%@ include file="footer.jsp" %>
</body>
</html>