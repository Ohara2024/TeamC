<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<div class="sidebar">
    <ul>
    	<br>
    	<br>
        <li><a href="menu.jsp">メニュー</a></li>
        <li><a href="student_list.jsp">学生管理</a></li>
        <li><a href="test_regist.jsp">成績管理</a></li>
        <li><a href="test_regist_create.jsp">　成績登録</a></li>
        <li><a href="test_list#">　成績参照</a></li>
        <li><a href="subject_list.jsp">科目管理</a></li>
    </ul>
</div>
<style>
    .sidebar {
        width: 200px;
        background-color: #ffffff;
        position: fixed;
        top: 40px;
        left: 0;
        height: calc(100vh - 40px);
        padding-top: 10px;
        margin: 10px 0 10px 10px; /* 周囲に余白を追加 */
        border-right: 1px solid #d3d3d3; /* 右側にグレーの細い境界線 */
        overflow-y: auto;
    }
    .sidebar ul {
        list-style-type: none;
        padding: 0;
        margin: 0;
    }
    .sidebar li {
        padding: 10px 20px;
    }
    .sidebar a {
        color: #007bff;
        text-decoration: none;
        font-weight: bold;
        display: block;
    }
    .sidebar a:hover {
        background-color: #e0e0e0;
        text-decoration: underline;
    }
</style>