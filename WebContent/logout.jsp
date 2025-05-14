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
      background-color: #f9f9f9;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
    }

    .message-box {
      background-color: #fff;
      padding: 40px 50px;
      border-radius: 10px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
      text-align: center;
    }

    h1 {
      font-size: 24px;
      margin-bottom: 20px;
    }

    .btn {
      display: inline-block;
      padding: 10px 20px;
      background-color: #0077cc;
      color: white;
      text-decoration: none;
      border-radius: 5px;
      margin-top: 20px;
    }

    .btn:hover {
      background-color: #005fa3;
    }
  </style>
</head>
<body>

<div class="message-box">
  <h1>ログアウトしました</h1>
  <a href="login.jsp" class="btn">ログイン画面へ</a>
</div>

</body>
</html>
