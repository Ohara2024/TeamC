 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<title>得点管理システム</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; background: #fff; }
        .banner { background-color: #D4E8D4; padding: 10px; border: 1px solid #ccc; text-align: center; font-size: 18px; margin-bottom: 20px; }
        .main { padding: 20px; max-width: 800px; margin: 0 auto; text-align: left; }
        .button { padding: 6px 12px; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; color: black; background: none; margin-right: 10px; }
    </style>
<head>
<title>成績管理 - 完了</title>
<style>

        body { font-family: Arial, sans-serif; margin: 0; background: #fff; }

        .banner { background-color: #D4E8D4; padding: 10px; border: 1px solid #ccc; text-align: center; font-size: 18px; margin-bottom: 20px; }

        .main { padding: 20px; max-width: 800px; margin: 0 auto; text-align: left; }

        .button { padding: 6px 12px; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; color: black; background: none; margin-right: 10px; }
</style>
</head>
<body>
<%@ include file="header.jsp" %>
<%@ include file="sidebar.jsp" %>
<br><br><br><br><br>
    <div class="banner">登録を完了しました</div>
    <div class="main">
        <a href="test_regist.jsp" class="button">戻る</a>
        <a href="test_regist.jsp" class="button">成績管理</a>
    </div>
    <%@ include file="footer.jsp" %>
</body>
<body>
<div class="banner">登録を完了しました</div>
<div class="main">
<a href="javascript:history.back()" class="button">戻る</a>
<a href="test_regist.jsp" class="button">成績管理</a>
</div>
</body>
</html>
