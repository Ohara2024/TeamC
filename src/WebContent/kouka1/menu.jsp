<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>学生管理システム - メニュー</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            margin: 0;
            padding: 0;
        }
        .menu {
            width: 15%;
            background-color: #f4f4f4;
            border-right: 2px solid #000;
            padding: 10px;
            box-sizing: border-box;
            height: 100vh; /* メニューの高さを画面全体に */
        }
        .menu ul {
            list-style-type: none;
            padding: 0;
        }
        .menu ul li {
            margin-bottom: 10px;
            position: relative;
        }

        /* メニューリンク */
        .menu ul li a {
            text-decoration: none;
            color: purple; /* 初期状態で紫色 */
            font-weight: bold;
            text-decoration: underline;
        }

        /* メニューリンクにホバーした時 */
        .menu ul li a:hover {
            color: #007BFF;
        }

        /* 学生管理の文字 */
        #footer {
            font-weight: bold;
            font-size: 12px;
            margin-top: 20px;
        }

        /* 選択されている場合、色を変更 */
        .menu ul li a.selected {
            color: black; /* 選択された場合は黒色に */
        }

        /* メニューの前に・を追加 */
        .menu ul li::before {
            content: "・"; /* ・を追加 */
            margin-right: 5px; /* ・と文字の間に少しスペースを空ける */
        }
    </style>
</head>
<body>

    <div class="menu">
        <h1>メニュー</h1>  <!-- メニュータイトル -->
        <h3>学生管理</h3>
        <!-- メニューリンク -->
        <ul>
            <li><a href="StudentList.jsp" class="<%= (request.getRequestURI().endsWith("StudentList.jsp") ? "selected" : "") %>">学生一覧</a></li>
            <li><a href="StudentAdd.jsp" class="<%= (request.getRequestURI().endsWith("StudentAdd.jsp") ? "selected" : "") %>">学生追加</a></li>
            <li><a href="StudentUpdate.jsp" class="<%= (request.getRequestURI().endsWith("StudentUpdate.jsp") ? "selected" : "") %>">学生更新</a></li>
            <li><a href="StudentDelete.jsp" class="<%= (request.getRequestURI().endsWith("StudentDelete.jsp") ? "selected" : "") %>">学生削除</a></li>
        </ul>

    </div>



</body>
</html>