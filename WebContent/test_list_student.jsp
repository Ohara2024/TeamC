<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.sql.* %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>得点管理システム</title>
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
            margin-left: 200px;
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
        <%
        String errorMsg = (String)request.getAttribute("errorMsg");
        if (errorMsg != null && !errorMsg.isEmpty()) {
            out.println("<p class='error'>" + errorMsg + "</p>");
        }
        %>

        <!-- 検索フォーム -->
        <form action="testListStudentExecute" method="post">
            <label>入学年度:</label>
            <select name="ent_year">
                <option value="">選択してください</option>
                <%
                Connection conn = null;
                Statement stmt = null;
                ResultSet rs = null;
                try {
                    Class.forName("org.h2.Driver");
                    conn = DriverManager.getConnection("jdbc:h2:~/exam;CHARACTER_ENCODING=UTF8", "sa", "");
                    stmt = conn.createStatement();
                    rs = stmt.executeQuery("SELECT DISTINCT ENT_YEAR FROM Student WHERE ENT_YEAR IS NOT NULL ORDER BY ENT_YEAR");
                    while (rs.next()) {
                        int year = rs.getInt("ENT_YEAR");
                        out.println("<option value='" + year + "'>" + year + "</option>");
                    }
                } catch (Exception e) {
                    out.println("<p class='error'>エラー: " + e.getMessage() + "</p>");
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                    if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
                    if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
                }
                %>
            </select>

            <label>クラス:</label>
            <select name="class_num">
                <option value="">選択してください</option>
                <%
                try {
                    Class.forName("org.h2.Driver");
                    conn = DriverManager.getConnection("jdbc:h2:~/exam;CHARACTER_ENCODING=UTF8", "sa", "");
                    stmt = conn.createStatement();
                    rs = stmt.executeQuery("SELECT CLASS_NUM FROM CLASS_NUM ORDER BY CLASS_NUM");
                    while (rs.next()) {
                        String classNum = rs.getString("CLASS_NUM");
                        out.println("<option value='" + classNum + "'>" + classNum + "</option>");
                    }
                } catch (Exception e) {
                    out.println("<p class='error'>エラー: " + e.getMessage() + "</p>");
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                    if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
                    if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
                }
                %>
            </select>

            <label>科目:</label>
            <select name="subject_cd">
                <option value="">選択してください</option>
                <%
                try {
                    Class.forName("org.h2.Driver");
                    conn = DriverManager.getConnection("jdbc:h2:~/exam;CHARACTER_ENCODING=UTF8", "sa", "");
                    stmt = conn.createStatement();
                    rs = stmt.executeQuery("SELECT SCHOOL_CD, CD, NAME AS SUBJECT_NAME FROM SUBJECT ORDER BY SCHOOL_CD, CD");
                    while (rs.next()) {
                        String schoolCd = rs.getString("SCHOOL_CD");
                        String cd = rs.getString("CD");
                        String subjectName = rs.getString("SUBJECT_NAME");
                        String value = schoolCd + "_" + cd;
                        out.println("<option value='" + value + "'>" + subjectName + "</option>");
                    }
                } catch (Exception e) {
                    out.println("<p class='error'>エラー: " + e.getMessage() + "</p>");
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                    if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
                    if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
                }
                %>
            </select>

            <label>学生番号:</label>
            <input type="text" name="student_no" value="">

            <input type="submit" value="検索">
        </form>

        <!-- 検索結果 -->
        <%
        // 検索結果はサーブレット（testListStudentExecute）で処理されるため、ここでは仮に表示例
        // 実際の検索結果表示はサーブレットから渡されたデータを想定
        List<Map<String, Object>> results = (List<Map<String, Object>>)request.getAttribute("results");
        if (results != null && !results.isEmpty()) {
        %>
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
                    <%
                    for (Map<String, Object> result : results) {
                        out.println("<tr>");
                        out.println("<td>" + (result.get("entYear") != null ? result.get("entYear") : "") + "</td>");
                        out.println("<td>" + (result.get("classNum") != null ? result.get("classNum") : "") + "</td>");
                        out.println("<td>" + (result.get("studentNo") != null ? result.get("studentNo") : "") + "</td>");
                        out.println("<td>" + (result.get("studentName") != null ? result.get("studentName") : "") + "</td>");
                        out.println("<td>" + (result.get("subjectName") != null ? result.get("subjectName") : "") + "</td>");
                        out.println("<td>" + (result.get("test1Point") != null ? result.get("test1Point") : "-") + "</td>");
                        out.println("<td>" + (result.get("test2Point") != null ? result.get("test2Point") : "-") + "</td>");
                        out.println("</tr>");
                    }
                    %>
                </tbody>
            </table>
        <%
        }
        %>
    </main>
    <%@ include file="footer.jsp" %>
</body>
</html>