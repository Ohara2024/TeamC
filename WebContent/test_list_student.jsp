<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>得点管理システム - 成績検索</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0; padding: 0;
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
            width: 100%; border-collapse: collapse; margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd; padding: 8px; text-align: left;
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

        <%-- エラーメッセージ表示 --%>
        <%
            String errorMsg = (String) request.getAttribute("errorMsg");
            if (errorMsg != null && !errorMsg.isEmpty()) {
        %>
            <p class="error"><%= errorMsg %></p>
        <%
            }
        %>

        <%
            // 入力値の保持用（リクエストスコープから取得）
            String selEntYear = request.getParameter("ent_year") != null ? request.getParameter("ent_year") : "";
            String selClassNum = request.getParameter("class_num") != null ? request.getParameter("class_num") : "";
            String selSubjectCd = request.getParameter("subject_cd") != null ? request.getParameter("subject_cd") : "";
            String studentNo = request.getParameter("student_no") != null ? request.getParameter("student_no") : "";
        %>

        <form action="testListStudentExecute" method="post">
            <label>入学年度:</label>
            <select name="ent_year">
                <option value="">選択してください</option>
                <%
                    Connection conn = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;
                    try {
                        Class.forName("org.h2.Driver");
                        conn = DriverManager.getConnection("jdbc:h2:~/exam;CHARACTER_ENCODING=UTF8", "sa", "");

                        ps = conn.prepareStatement("SELECT DISTINCT ENT_YEAR FROM STUDENT WHERE ENT_YEAR IS NOT NULL ORDER BY ENT_YEAR");
                        rs = ps.executeQuery();
                        while (rs.next()) {
                            int year = rs.getInt("ENT_YEAR");
                            String selected = selEntYear.equals(String.valueOf(year)) ? "selected" : "";
                            out.println("<option value='" + year + "' " + selected + ">" + year + "</option>");
                        }
                        rs.close();
                        ps.close();
        %>
            </select>

            <label>クラス:</label>
            <select name="class_num">
                <option value="">選択してください</option>
                <%
                        ps = conn.prepareStatement("SELECT NUM FROM CLASS_NUM ORDER BY NUM");
                        rs = ps.executeQuery();
                        while (rs.next()) {
                            String classNum = rs.getString("NUM");
                            String selected = selClassNum.equals(classNum) ? "selected" : "";
                            out.println("<option value='" + classNum + "' " + selected + ">" + classNum + "</option>");
                        }
                        rs.close();
                        ps.close();
                %>
            </select>

            <label>科目:</label>
            <select name="subject_cd">
                <option value="">選択してください</option>
                <%
                        ps = conn.prepareStatement("SELECT SCHOOL_CD, CD, NAME FROM SUBJECT ORDER BY SCHOOL_CD, CD");
                        rs = ps.executeQuery();
                        while (rs.next()) {
                            String schoolCd = rs.getString("SCHOOL_CD");
                            String cd = rs.getString("CD");
                            String name = rs.getString("NAME");
                            String val = schoolCd + "_" + cd;
                            String selected = selSubjectCd.equals(val) ? "selected" : "";
                            out.println("<option value='" + val + "' " + selected + ">" + name + "</option>");
                        }
                        rs.close();
                        ps.close();
                    } catch (Exception e) {
                        out.println("<p class='error'>エラー: " + e.getMessage() + "</p>");
                    } finally {
                        if (rs != null) try { rs.close(); } catch (Exception ignored) {}
                        if (ps != null) try { ps.close(); } catch (Exception ignored) {}
                        if (conn != null) try { conn.close(); } catch (Exception ignored) {}
                    }
                %>
            </select>

            <label>学生番号:</label>
            <input type="text" name="student_no" value="<%= studentNo %>">

            <input type="submit" value="検索">
        </form>

        <%-- 検索結果表示 --%>
        <%
            List<Map<String,Object>> results = (List<Map<String,Object>>) request.getAttribute("results");
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
                        for (Map<String,Object> r : results) {
                    %>
                    <tr>
                        <td><%= r.get("entYear") != null ? r.get("entYear") : "" %></td>
                        <td><%= r.get("classNum") != null ? r.get("classNum") : "" %></td>
                        <td><%= r.get("studentNo") != null ? r.get("studentNo") : "" %></td>
                        <td><%= r.get("studentName") != null ? r.get("studentName") : "" %></td>
                        <td><%= r.get("subjectName") != null ? r.get("subjectName") : "" %></td>
                        <td><%= r.get("test1Point") != null ? r.get("test1Point") : "-" %></td>
                        <td><%= r.get("test2Point") != null ? r.get("test2Point") : "-" %></td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        <%
            } else if (results != null) {
        %>
            <p>該当する成績がありません。</p>
        <%
            }
        %>

    </main>
    <%@ include file="footer.jsp" %>
</body>
</html>
