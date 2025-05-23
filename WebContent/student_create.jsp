<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>学生情報登録 - 得点管理システム</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; }
        .content { margin-left: 220px; padding: 20px; }
        h1 { color: #000; font-size: 26px; background-color: #f0f0f0; padding: 10px; }
        .form-group { margin-bottom: 15px; }
        label { display: inline-block; width: 120px; font-weight: bold; }
        input[type="text"], select {
            width: 200px; padding: 5px; border: 1px solid #ccc; border-radius: 3px; font-size: 14px;
        }
        input[type="submit"] {
            background-color: #007bff; color: white; padding: 8px 20px; border: none;
            border-radius: 3px; cursor: pointer; font-size: 14px;
        }
        input[type="submit"]:hover { background-color: #0056b3; }
        .error { color: red; font-size: 14px; margin-bottom: 10px; }
        a { color: #007bff; text-decoration: underline; font-size: 14px; }
        a:hover { color: #0056b3; }
        /* プレースホルダーの色をグレー（#555）に */
        input::placeholder, select option[disabled] {
            color: #555;
            opacity: 1; /* Firefox対策 */
        }
    </style>
</head>
<body>
    <%@ include file="sidebar.jsp" %>
    <%@ include file="header.jsp" %>

    <div class="content">
        <br><br><br><br>
        <h1>学生情報登録</h1>

        <%-- エラーメッセージの表示 --%>
        <% String error = (String) request.getAttribute("error"); %>
        <% String errorMessage = (String) request.getAttribute("errorMessage"); %>
        <% if (error != null && !error.isEmpty()) { %>
            <p class="error">エラー: <%= errorMessage != null ? errorMessage : "登録に失敗しました。管理者にお問い合わせください。" %></p>
        <% } %>

        <%-- 学生登録フォーム --%>
        <form action="${pageContext.request.contextPath}/StudentCreateExecuteAction" method="post">
            <div class="form-group">
                <label for="entranceYear">入学年度
                <select id="entranceYear" name="entrance_year" required>
                    <option value="" disabled selected>-------------</option>
                    <%
                    String selectedYear = request.getParameter("entrance_year");
                    for (int year = 2020; year <= 2030; year++) {
                        String selected = (selectedYear != null && selectedYear.equals(String.valueOf(year))) ? "selected" : "";
                        out.println("<option value='" + year + "' " + selected + ">" + year + "</option>");
                    }
                    %>
                </select>
                </label>
            </div>
            <div class="form-group">
                <label for="studentNumber">学生番号
                <input type="text" id="studentNumber" name="student_number" required maxlength="10"
                       placeholder="学生番号を入力してください"
                       value="<%= request.getParameter("student_number") != null ? request.getParameter("student_number") : "" %>">
                </label>
            </div>
            <div class="form-group">
                <label for="studentName">氏名
                <input type="text" id="studentName" name="student_name" required maxlength="50"
                       placeholder="氏名を入力してください"
                       value="<%= request.getParameter("student_name") != null ? request.getParameter("student_name") : "" %>">
                </label>
            </div>
            <div class="form-group">
                <label for="classNum">クラス
                <select id="classNum" name="class_num" required>
                    <option value="" disabled selected>クラスを選択</option>
                    <%
                    List<String> classNumbers = (List<String>) request.getAttribute("classNumbers");
                    String selectedClassNum = request.getParameter("class_num");
                    if (classNumbers != null) {
                        for (String classNum : classNumbers) {
                            String selected = (selectedClassNum != null && classNum.equals(selectedClassNum)) ? "selected" : "";
                            out.println("<option value='" + classNum + "' " + selected + ">" + classNum + "</option>");
                        }
                    }
                    %>
                </select>
                </label>
            </div>
            <div class="form-group">
                <input type="submit" value="登録して終了">
            </div>
        </form>

        <div class="link">
            <a href="${pageContext.request.contextPath}/StudentListAction">戻る</a>
        </div>
    </div>

    <%@ include file="footer.jsp" %>
</body>
</html>