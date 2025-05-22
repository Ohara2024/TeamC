<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>成績参照</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }
        header {
            background-color: #f8f8f8;
            padding: 10px;
            text-align: center;
        }
        main {
            margin-left: 200px; /* サイドバーの幅に合わせる */
            padding: 20px;
        }
        .error {
            color: red;
            margin-bottom: 10px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        form {
            margin-bottom: 20px;
        }
        select, input[type="text"], input[type="submit"] {
            padding: 5px;
            margin-right: 10px;
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>
    <%@ include file="sidebar.jsp" %>
    <main>
        <h1>成績参照</h1>
        
        <!-- エラーメッセージ -->
        <c:if test="${not empty errorMsg}">
            <p class="error"><c:out value="${errorMsg}" /></p>
        </c:if>
        
        <!-- 検索フォーム -->
        <form action="testListStudentExecute" method="post">
            <label>入学年度:</label>
            <select name="ent_year">
                <option value="">選択してください</option>
                <c:forEach var="year" items="${entYearList}">
                    <option value="${year}"><c:out value="${year}" /></option>
                </c:forEach>
            </select>
            
            <label>クラス:</label>
            <select name="class_num">
                <option value="">選択してください</option>
                <c:forEach var="classNum" items="${classNumList}">
                    <option value="${classNum.classNum}">
                        <c:out value="${classNum.classNum}" />
                    </option>
                </c:forEach>
            </select>
            
            <label>科目:</label>
            <select name="subject_cd">
                <option value="">選択してください</option>
                <c:forEach var="subject" items="${subjectList}">
                    <option value="${subject.schoolCd}_${subject.cd}">
                        <c:out value="${subject.name}" />
                    </option>
                </c:forEach>
            </select>
            
            <label>学生番号:</label>
            <input type="text" name="student_no" value="">
            
            <input type="submit" value="検索">
        </form>
        
        <!-- 検索結果 -->
        <c:if test="${not empty results}">
            <table>
                <thead>
                    <tr>
                        <th>入学年度</th>
                        <th>クラス</th>
                        <th>学生番号</th>
                        <th>学生名</th>
                        <th>科目名</th>
                        <th>1回目</th>
                        <th>2回目</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="result" items="${results}">
                        <tr>
                            <td><c:out value="${result.entYear}" /></td>
                            <td><c:out value="${result.classNum}" /></td>
                            <td><c:out value="${result.studentNo}" /></td>
                            <td><c:out value="${result.studentName}" /></td>
                            <td><c:out value="${result.subjectName}" /></td>
                            <td><c:out value="${result.test1Point != null ? result.test1Point : '-'}" /></td>
                            <td><c:out value="${result.test2Point != null ? result.test1Point : '-'}" /></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:if>
    </main>
    <%@ include file="footer.jsp" %>
</body>
</html>