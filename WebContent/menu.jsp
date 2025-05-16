<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>メニュー｜得点管理システム</title>
    <style>
        body {
            font-family: "Segoe UI", sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
        }

        .header {
            background-color: #e9edf4;
            padding: 15px 20px;
            font-size: 20px;
            font-weight: bold;
            border-bottom: 1px solid #ccc;
        }

        .menu-container {
            display: flex;
            justify-content: center;
            gap: 20px;
            padding: 50px 0;
        }

        .card {
            width: 200px;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            color: #333;
        }

        .card a {
            display: block;
            margin-top: 10px;
            text-decoration: none;
            color: #0044cc;
        }

        .card a:hover {
            text-decoration: underline;
        }

        .card.student {
            background-color: #e6c3c3;
        }

        .card.score {
            background-color: #c8e6c9;
        }

        .card.subject {
            background-color: #c9c9f3;
        }

        .card-title {
            font-weight: bold;
            font-size: 18px;
        }
    </style>
</head>
<body>

    <div class="header">メニュー</div>

    <div class="menu-container">
        <div class="card student">
            <a class="card-title" href="studentList.jsp">学生管理</a>
        </div>

        <div class="card score">
            <div class="card-title">成績管理</div>
            <a href="scoreRegister.jsp">成績登録</a>
            <a href="scoreSearch.jsp">成績参照</a>
        </div>

        <div class="card subject">
            <a class="card-title" href="subjectlist.jsp">科目管理</a>
        </div>
    </div>

</body>
</html>
