<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List, bean.Subject" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>科目管理</title>
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
        <a href="subject_create.jsp">新規登録</a>
    </div>

    <%
        List<Subject> subjects = (List<Subject>) request.getAttribute("subjects");
        String error = (String) request.getAttribute("error");

        // デバッグ出力（本番では削除してください）
        System.out.println("subject_list.jsp: subjects=" + (subjects != null ? subjects.size() : "null"));
        System.out.println("subject_list.jsp: error=" + error);
    %>

    <!-- エラーメッセージ表示 -->
    <% if (error != null && !error.isEmpty()) { %>
        <p class="error">エラー: <%= error %></p>
    <% } %>

    <!-- 科目一覧表示 -->
    <% if (subjects != null && !subjects.isEmpty()) { %>
        <table>
            <tr>
                <th>科目コード</th>
                <th>科目名</th>
                <th></th> <!-- アクション列のヘッダー -->
            </tr>
            <% for (Subject subject : subjects) { %>
                <tr>
                    <td><%= subject.getCd() %></td>
                    <td><%= subject.getName() %></td>
                    <td>
 <%
    String cdEnc = java.net.URLEncoder.encode(subject.getCd(), "UTF-8");
    String nameEnc = java.net.URLEncoder.encode(subject.getName(), "UTF-8");
    String schoolCdEnc = java.net.URLEncoder.encode(subject.getSchool().getCd(), "UTF-8");
%>
<a href="<%= request.getContextPath() %>/SubjectUpdate.action?subjectcd=<%= cdEnc %>&subjectName=<%= nameEnc %>&schoolCd=<%= schoolCdEnc %>">変更</a>

  <a href="<%= request.getContextPath() %>/SubjectDelete.action?subjectcd=<%= subject.getCd() %>&subjectName=<%= subject.getName() %>&schoolCd=<%= subject.getSchool().getCd() %>">削除</a>
</td>

                </tr>
            <% } %>
        </table>
    <% } else { %>
        <p style="color: #000000;">科目情報が存在しませんでした</p>
    <% } %>
</div>

<%@ include file="footer.jsp" %>
</body>
</html>