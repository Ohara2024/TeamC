<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>得点管理システム</title>
<style>
        body {
            font-family: "Segoe UI", sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
        }
        .header {
            background-color: #e9edf4;
            padding: 20px 0;
            text-align: center;
            font-size: 28px;
            font-weight: bold;
            color: #333;
        }
        .login-box {
            width: 300px;
            margin: 40px auto;
            background-color: #fff;
            padding: 30px;
            box-shadow: 0 0 8px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
        }
        .login-box h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        .form-control {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
        }
        .checkbox-area {
            text-align: left;
            margin-bottom: 20px;
            font-size: 14px;
        }
        .login-button {
            width: 100%;
            padding: 10px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
        }
        .login-button:hover {
            background-color: #0056b3;
        }
        .footer {
            text-align: center;
            color: #777;
            font-size: 12px;
            margin-top: 50px;
        }
</style>
</head>
<body>
    <div class="header">得点管理システム</div>

    <div class="login-box">
        <h2>ログイン</h2>
        <% String error = (String) request.getAttribute("error"); %>
        <% if (error != null) { %>
            <div style="color: red; text-align: center; margin-bottom: 10px;">
                <%= error %>
            </div>
        <% } %>

        <!-- 修正: action属性はrequest.getContextPath()を使用し、動的にコンテキストパスを取得 -->
        <!-- 注意: 404エラーが続く場合、Tomcatのwebapps/TeamC/またはTeamC.warが正しくデプロイされているか確認してください -->
        <!-- 例: http://localhost:8080/TeamC/FrontController にアクセス可能かテスト -->
        <form action="<%= request.getContextPath() %>/FrontController" method="post">
            <input type="hidden" name="action" value="main.Login">
            <input type="text" name="id" class="form-control" placeholder="ID" required>
            <input type="password" name="password" class="form-control" id="passwordField" placeholder="パスワード" required>
            <div class="checkbox-area">
                <input type="checkbox" onclick="togglePassword()"> パスワードを表示
            </div>
            <input type="submit" value="ログイン" class="login-button">
        </form>

        <div class="footer">
            © 2023 TIC<br>大原学園
        </div>
    </div>

    <script>
        function togglePassword() {
            var field = document.getElementById("passwordField");
            if (field.type === "password") {
                field.type = "text";
            } else {
                field.type = "password";
            }
        }
    </script>
</body>
</html>