<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>得点管理システム</title>
    <style>
        body {
            font-family: "Meiryo", sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
        }

        .header {
            background-color: #e6f0fa;
            padding: 10px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            height: 90px;
            box-sizing: border-box;
        }

        .header h1 {
            margin: 0;
            font-size: 28px;
            color: #000;
        }

        .header-right {
            font-size: 14px;
        }

        .header-right a {
            color: #007bff;
            text-decoration: none;
            margin-left: 10px;
        }

        .container {
            max-width: 1000px;
            margin: 120px auto 40px;
            text-align: center;
        }

        .menu-title {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 30px;
        }

        .menu-grid {
            display: flex;
            justify-content: center;
            gap: 30px;
            flex-wrap: wrap;
        }

        .card {
            width: 200px;
            height: 160px;
            border-radius: 16px;
            padding: 15px;
            color: #000;
            box-shadow: 3px 3px 10px rgba(0, 0, 0, 0.2);
        }

        .student {
            background-color: #e8c2c2;
        }

        .score {
            background-color: #cce7cc;
        }

        .subject {
            background-color: #cfcfed;
        }

        .card h3 {
            margin-top: 0;
            font-size: 18px;
        }

        .card a {
            display: block;
            color: #007bff;
            text-decoration: none;
            margin-top: 10px;
        }

        footer {
            margin-top: 60px;
            text-align: center;
            font-size: 12px;
            color: #777;
        }
    </style>
</head>
<body>

<%@ include file="sidebar.jsp" %>
<%@ include file="header.jsp" %>

<div class="container">
    <div class="menu-title">メニュー</div>
    <div class="menu-grid">
        <div class="card student">
            <h3>学生管理</h3>
            <a href="student_list.jsp">学生管理</a>
        </div>

        <div class="card score">
            <h3>成績管理</h3>
            <a href="test_regist.jsp">成績登録</a>
            <a href="test_list.jsp">成績参照</a>
        </div>

        <div class="card subject">
            <h3>科目管理</h3>
            <a href="${pageContext.request.contextPath}/SubjectList.action">科目管理</a>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>

</body>
</html>
