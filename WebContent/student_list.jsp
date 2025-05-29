<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List, bean.Student" %>
<%@ page import="java.util.*, scoremanager.main.StudentListAction.Student" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>得点管理システム - 学生一覧</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; }
        .content { margin-left: 220px; padding: 20px; }
        h1 { color: #000; margin-top: 0; font-size: 26px; background-color: #f0f0f0; padding: 10px; }
        .filter-box { display: flex; gap: 20px; align-items: flex-start; margin-bottom: 20px; padding: 10px; border: 1px solid #ccc; border-radius: 8px; }
        .form-group { margin-top: 0; padding: 0; border-radius: 4px; flex: 1; }
        label { display: inline-block; width: 120px; font-weight: bold; vertical-align: top; }
        input[type="text"], select { width: 100%; max-width: 200px; padding: 5px; border: 1px solid #ccc; border-radius: 3px; font-size: 14px; display: block; margin-top: 5px; }
        input[type="submit"] { background-color: #4C4C4C; color: white; padding: 8px 20px; border: none; border-radius: 3px; cursor: pointer; font-size: 14px; margin-top: 28px; }
        input[type="submit"]:hover { background-color: #323232; }
        a { color: #007bff; text-decoration: underline; font-size: 14px; }
        a:hover { color: #0056b3; text-decoration: underline; }
        .error { color: red; font-size: 14px; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { padding: 0.5em; text-align: left; border-width: 1px 0px; border-color: #CCCCCC; border-style: solid; font-size: 14px; }
        th { background-color: #ffffff; font-weight: bold; }
        .top-actions { margin-bottom: 10px; display: flex; justify-content: flex-end; }
        .checkbox-label { display: flex; align-items: center; gap: 8px; }
        input[type="checkbox"] { margin: 0; }
        .filter-message { font-size: 14px; color: #333; margin-bottom: 10px; }
    </style>
</head>
<body>
<%@ include file="sidebar.jsp" %>
<%@ include file="header.jsp" %>

<div class="content">
    <br><br><br><br>
    <h1>学生管理</h1>

    <!-- 新規登録リンク -->
    <div class="top-actions">
        <a href="StudentCreateAction" class="action-btn">新規登録</a>
    </div>

    <!-- セッションからschoolCdを取得 -->
    <% String schoolCd = (String) session.getAttribute("schoolCd"); %>

    <!-- 絞り込みフォーム -->
    <form action="StudentListAction" method="get" id="filterForm">
        <div class="filter-box">
            <div class="form-group">
                <label for="entYear">入学年度</label>
                <select name="entYear" id="entYear">
                    <option value="">--------</option>
                    <%
                    int currentYear = java.time.Year.now().getValue();
                    String selectedYear = (String) request.getAttribute("entYear");
                    if (selectedYear == null) selectedYear = "";
                    for (int year = currentYear; year >= 2000; year--) {
                        String selected = String.valueOf(year).equals(selectedYear) ? "selected" : "";
                        out.println("<option value='" + year + "' " + selected + ">" + year + "</option>");
                    }
                    %>
                </select>
            </div>
            <div class="form-group">
                <label for="classNum">クラス</label>
                <select name="classNum" id="classNum">
                    <option value="">--------</option>
                    <%
                    String selectedClass = (String) request.getAttribute("classNum");
<<<<<<< HEAD
                    String schoolCd = (String) session.getAttribute("schoolCd");
                    if (selectedClass == null) selectedClass = schoolCd != null ? schoolCd : "";
                    String[][] classOptions = {
                        {"101", "101"},
                        {"131", "131"},
                        {"201", "201"},
                        {"oom", "大宮"},
                        {"tky", "東京"}
=======
                    // 初回ロード時にschoolCdをデフォルトとして設定
                    if (selectedClass == null || selectedClass.isEmpty()) {
                        selectedClass = schoolCd != null ? schoolCd : "";
                    }
                    String[][] classOptions = {
                        {"101", "101"},
                        {"131", "131"},
                        {"201", "201"},
                        {"tky", "東京"},
                        {"oom", "大宮"}
>>>>>>> branch 'TeamCマージ' of https://github.com/Ohara2024/TeamC
                    };
                    for (String[] option : classOptions) {
                        String value = option[0];
                        String label = option[1];
                        String selected = value.equals(selectedClass) ? "selected" : "";
                        out.println("<option value='" + value + "' " + selected + ">" + label + "</option>");
                    }
                    %>
                </select>
            </div>
            <div class="form-group">
                <label for="isAttend" class="checkbox-label">
                    在学中
                    <input type="checkbox" name="isAttend" id="isAttend" value="1" <%= "1".equals(request.getAttribute("isAttend")) ? "checked" : "" %>>
                </label>
            </div>
            <div class="form-group">
                <input type="submit" value="絞り込み" id="filterSubmit">
            </div>
        </div>
    </form>

    <%
    String error = (String) request.getAttribute("error");
    List<Student> students = (List<Student>) request.getAttribute("students");
    Integer resultCount = (Integer) request.getAttribute("resultCount");
    if (resultCount == null) resultCount = 0;

    // フィルターメッセージの設定
    String filterMessage = "";
    if (selectedClass != null && !selectedClass.isEmpty()) {
        if ("tky".equals(selectedClass)) {
            filterMessage = "東京の学生を表示中";
        } else if ("oom".equals(selectedClass)) {
            filterMessage = "大宮の学生を表示中";
        }
    }
    %>

    <% if (error != null) { %>
        <p class="error"><%= error %></p>
    <% } %>

    <% if (!filterMessage.isEmpty()) { %>
        <p class="filter-message"><%= filterMessage %></p>
    <% } %>

    <% if (resultCount == 0) { %>
        <p>学生情報が存在しませんでした</p>
    <% } else { %>
        <p>検索結果：<%= resultCount %> 件</p>
        <table>
            <thead>
                <tr>
                    <th>入学年度</th>
                    <th>学生番号</th>
                    <th>氏名</th>
                    <th>クラス</th>
                    <th>在学中</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
                <% for (Student student : students) { %>
                    <tr>
                        <td><%= student.getEntYear() %></td>
                        <td><%= student.getNo() %></td>
                        <td><%= student.getName() %></td>
                        <td><%= student.getClassNum() %></td>
                        <td><%= student.isAttend() ? "○" : "×" %></td>
                        <td><a href="StudentUpdateAction?studentNo=<%= student.getNo() %>">変更</a></td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    <% } %>
</div>

<%@ include file="footer.jsp" %>

<script>
    window.onload = function() {
        var schoolCd = '<%= schoolCd != null ? schoolCd : "" %>';
        var classNumSelect = document.getElementById('classNum');
        var form = document.getElementById('filterForm');
        var isInitialLoad = <%= request.getAttribute("classNum") == null &&
                              request.getAttribute("entYear") == null &&
                              request.getAttribute("isAttend") == null %>;

        console.log("schoolCd: " + schoolCd);
        console.log("classNumSelect.value: " + classNumSelect.value);
        console.log("isInitialLoad: " + isInitialLoad);

        // 初回ロードかつschoolCdが有効な場合、classNumをschoolCdに設定してフォームを送信
        if (isInitialLoad && schoolCd && (classNumSelect.value === "" || classNumSelect.value === schoolCd)) {
            classNumSelect.value = schoolCd;
            console.log("自動絞り込み実行: classNum = " + schoolCd);
            form.submit();
        }
    };
</script>

</body>
</html>