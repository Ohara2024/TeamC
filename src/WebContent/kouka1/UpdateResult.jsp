<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="menu.jsp" %>
<%

    String result = request.getParameter("result"); // 成功 or 失敗のフラグ

%>

<!DOCTYPE html>
<html>
<head>
<title>更新結果</title>
<style>

        .content {

            padding: 20px;

        }

        .message {

            font-size: 18px;

            margin-bottom: 20px;

            text-align: left; /* 左詰め */

        }
</style>
</head>
<body>
<div class="content">
<div class="message">
<%

                if ("success".equals(result)) {

            %>

更新が完了しました。
<%

                } else {

            %>

更新に失敗しました。
<%

                }

            %>
</div>
<a href="index.jsp">Topページへ</a>
</div>
</body>
</html>

