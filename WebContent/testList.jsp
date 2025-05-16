<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.*" %>
<html>
<head>
    <title>テスト一覧</title>
    <style>
        table { border-collapse: collapse; width: 80%; margin: 20px auto; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: center; }
        th { background-color: #f0f0f0; }
    </style>
</head>
<body>
<h2 style="text-align:center;">成績一覧</h2>

<table>
    <tr>
        <th>学生ID</th>
        <th>学生名</th>
        <th>学校名</th>
        <th>科目</th>
        <th>点数</th>
    </tr>

    <%
        List<Test> tests = (List<Test>) request.getAttribute("tests");
        if (tests != null) {
            for (Test test : tests) {
                Student student = test.getStudent();
                Subject subject = test.getSubject();
                School school = test.getSchool();
    %>
    <tr>
        <td><%= student.getId() %></td>
        <td><%= student.getName() %></td>
        <td><%= school.getName() %></td>
        <td><%= subject.getName() %></td>
        <td><%= test.getScore() %></td>
    </tr>
    <%
            }
        }
    %>
</table>

</body>
</html>
