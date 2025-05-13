<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<div class="header">
    <h1>　得点管理システム</h1>
    <div class="header-actions">
        <a href="#" class="btn">テスト</a>
        <a href="#" class="btn">ログアウト</a>
    </div>
</div>
<style>
    .header {
        background-color: #e6f0fa;
        padding: 10px 20px;
        width: 100%;
        display: flex;
        justify-content: space-between;
        color: #000000;
        align-items: center;
        position: fixed;
        top: 0;
        left: 0;
        z-index: 1000;
        height: 90px;
        box-sizing: border-box;
    }
    .header h1 {
    	background-color: #e6f0fa;
        color: #000000;
        margin: 0;
        font-size: 35px;
    }
    .header-actions {
        display: flex;
        gap: 10px;
    }
    .btn {
        background-color: #007bff;
        color: white;
        padding: 5px 10px;
        text-decoration: none;
        border-radius: 3px;
        font-size: 12px;
    }
    .btn:hover {
        background-color: #0056b3;
    }
</style>