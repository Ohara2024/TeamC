<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%

  // セッションを無効化

  session.invalidate();

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ログアウト</title>
<style>

    body {

      font-family: 'Meiryo', sans-serif;

      margin: 0;

      padding: 0;

      background-color: #fff;

    }

    header {

      background: linear-gradient(to bottom, #e6efff, #ffffff);

      padding: 20px;

      text-align: center;

      font-size: 24px;

      font-weight: bold;

      color: #333;

      border-bottom: 1px solid #ccc;

    }

    .container {

      max-width: 600px;

      margin: 40px auto;

      text-align: center;

    }

    .box {

      border: 1px solid #ccc;

      margin: 10px 0;

      padding: 15px;

      font-size: 16px;

    }

    .box.logout {

      background-color: #f5f5f5;

      font-weight: bold;

    }

    .box.message {

      background-color: #a3d8a5;

      color: #333;

    }

    .login-link {

      font-size: 14px;

      color: #0077cc;

      text-decoration: none;

    }

    .login-link:hover {

      text-decoration: underline;

    }

    footer {

      background-color: #e4e4e4;

      text-align: center;

      padding: 10px;

      font-size: 12px;

      margin-top: 50px;

      color: #555;

    }

    .circle {

      display: inline-block;

      border: 2px solid red;

      color: red;

      font-weight: bold;

      border-radius: 50%;

      width: 24px;

      height: 24px;

      line-height: 20px;

      text-align: center;

      margin-right: 10px;

    }
</style>
</head>
<body>

<header>得点管理システム</header>

<div class="container">
<div class="box logout">ログアウト</div>
<div class="box message">ログアウトしました</div>
<div><a href="login.jsp" class="login-link">ログイン</a></div>
</div>

<footer>

  © 2023 TIC<br>大原学園
</footer>

</body>
</html>

