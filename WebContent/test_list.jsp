<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>成績一覧（科目）</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            padding: 20px;
        }
        .main-content {
            margin-left: 220px;
            padding: 10px;
        }
        h2 {
            margin-bottom: 20px;
            color: #333;
        }
        h3 {
            margin: 15px 0;
            color: #333;
            font-size: 1.2em;
        }
        .filter-section {
            background-color: #fff;
            padding: 15px;
            margin-bottom: 15px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .filter-section label {
            margin-right: 10px;
            font-weight: bold;
            color: #555;
        }
        .filter-section select, .filter-section input[type="text"] {
            padding: 8px;
            margin-right: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            background-color: #f9f9f9;
            width: 150px;
        }
        .filter-section input[type="submit"] {
            padding: 8px 15px;
            background-color: #666;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .filter-section input[type="submit"]:hover {
            background-color: #555;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background-color: #fff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
            color: #333;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        .message {
            color: #d9534f;
            margin-top: 10px;
            font-weight: bold;
            display: inline-block;
            padding: 5px 10px;
            background-color: #f8d7da;
            border-radius: 4px;
        }
        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
            }
            .sidebar {
                display: none;
            }
        }
    </style>
</head>
<body>
<%@ include file="header.jsp" %>
<%@ include file="sidebar.jsp" %>

<div class="main-content">
    <h2>成績一覧</h2>

    <!-- 科目情報 (一段目) -->
    <h3>成績参照</h3>
    <div class="filter-section">
        <form method="get">
            <label>科目情報</label>
            <label>入学年度</label>
            <select name="ent_year">
                <option value="">--------</option>
                <%
                String selectedEntYear = request.getParameter("ent_year") != null ? request.getParameter("ent_year") : "";
                Connection conn = null;
                Statement stmt = null;
                ResultSet rs = null;
                try {
                    Class.forName("org.h2.Driver");
                    conn = DriverManager.getConnection("jdbc:h2:~/seiseki;CHARACTER_ENCODING=UTF8", "sa", "");
                    stmt = conn.createStatement();
                    rs = stmt.executeQuery("SELECT DISTINCT ENT_YEAR FROM Student WHERE ENT_YEAR IS NOT NULL ORDER BY ENT_YEAR");
                    while (rs.next()) {
                        int year = rs.getInt("ENT_YEAR");
                        String selected = String.valueOf(year).equals(selectedEntYear) ? "selected" : "";
                        out.println("<option value='" + year + "' " + selected + ">" + year + "</option>");
                    }
                } catch(Exception e) {
                    out.println("<p class='message'>エラー: " + e.getMessage() + "</p>");
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                    if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
                    if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
                }
                %>
            </select>

            <label>クラス</label>
            <select name="class_num">
                <option value="">--------</option>
                <%
                String selectedClassNum = request.getParameter("class_num") != null ? request.getParameter("class_num") : "";
                try {
                    Class.forName("org.h2.Driver");
                    conn = DriverManager.getConnection("jdbc:h2:~/seiseki;CHARACTER_ENCODING=UTF8", "sa", "");
                    stmt = conn.createStatement();
                    rs = stmt.executeQuery("SELECT CLASS_NUM FROM CLASS_NUM ORDER BY CLASS_NUM");
                    while (rs.next()) {
                        String classNum = rs.getString("CLASS_NUM");
                        String selected = classNum.equals(selectedClassNum) ? "selected" : "";
                        out.println("<option value='" + classNum + "' " + selected + ">" + classNum + "</option>");
                    }
                } catch(Exception e) {
                    out.println("<p class='message'>エラー: " + e.getMessage() + "</p>");
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                    if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
                    if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
                }
                %>
            </select>

            <label>科目</label>
            <select name="subject_cd">
                <option value="">--------</option>
                <%
                String selectedSubjectCd = request.getParameter("subject_cd") != null ? request.getParameter("subject_cd") : "";
                try {
                    Class.forName("org.h2.Driver");
                    conn = DriverManager.getConnection("jdbc:h2:~/seiseki;CHARACTER_ENCODING=UTF8", "sa", "");
                    stmt = conn.createStatement();
                    rs = stmt.executeQuery("SELECT SCHOOL_CD, CD, NAME AS SUBJECT_NAME FROM SUBJECT ORDER BY SCHOOL_CD, CD");
                    while (rs.next()) {
                        String schoolCd = rs.getString("SCHOOL_CD");
                        String cd = rs.getString("CD");
                        String subjectName = rs.getString("SUBJECT_NAME");
                        String value = schoolCd + "_" + cd;
                        String selected = value.equals(selectedSubjectCd) ? "selected" : "";
                        out.println("<option value='" + value + "' " + selected + ">" + subjectName + "</option>");
                    }
                } catch(Exception e) {
                    out.println("<p class='message'>エラー: " + e.getMessage() + "</p>");
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                    if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
                    if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
                }
                %>
            </select>

            <input type="submit" value="検索">
            <%
            boolean searched = (request.getParameter("ent_year") != null && !request.getParameter("ent_year").isEmpty()) ||
                              (request.getParameter("class_num") != null && !request.getParameter("class_num").isEmpty()) ||
                              (request.getParameter("student_no") != null && !request.getParameter("student_no").isEmpty()) ||
                              (request.getParameter("subject_cd") != null && !request.getParameter("subject_cd").isEmpty());

            boolean allSubjectConditionsEmpty = (request.getParameter("ent_year") == null || request.getParameter("ent_year").isEmpty()) &&
                                               (request.getParameter("class_num") == null || request.getParameter("class_num").isEmpty()) &&
                                               (request.getParameter("subject_cd") == null || request.getParameter("subject_cd").isEmpty());

            if (searched && allSubjectConditionsEmpty && (request.getParameter("student_no") == null || request.getParameter("student_no").isEmpty())) {
                out.println("<p class='message'>① 入学年度とクラスと科目を選択してください</p>");
            }
            %>
        </form>
    </div>

    <!-- 学生情報 (二段目) -->
    <div class="filter-section">
        <form method="get">
            <label>学生情報</label>
            <label>学生番号</label>
            <input type="text" name="student_no" value="<%= request.getParameter("student_no") != null ? request.getParameter("student_no") : "" %>" placeholder="学生番号を入力">
            <input type="submit" value="検索">
        </form>
    </div>

    <%
    if (searched && !allSubjectConditionsEmpty || (request.getParameter("student_no") != null && !request.getParameter("student_no").isEmpty())) {
        try {
            Class.forName("org.h2.Driver");
            conn = DriverManager.getConnection("jdbc:h2:~/seiseki;CHARACTER_ENCODING=UTF8", "sa", "");
            stmt = conn.createStatement();
            String query = "SELECT S.ENT_YEAR, T.CLASS_NUM, T.STUDENT_NO, S.NAME AS STUDENT_NAME, SU.NAME AS SUBJECT_NAME, T.NO, T.POINT " +
                           "FROM TEST T " +
                           "JOIN STUDENT S ON T.STUDENT_NO = S.NO " +
                           "JOIN SUBJECT SU ON T.SCHOOL_CD = SU.SCHOOL_CD AND T.SUBJECT_CD = SU.CD " +
                           "WHERE 1=1";
            if (request.getParameter("ent_year") != null && !request.getParameter("ent_year").isEmpty()) {
                query += " AND S.ENT_YEAR = " + request.getParameter("ent_year");
            }
            if (request.getParameter("class_num") != null && !request.getParameter("class_num").isEmpty()) {
                query += " AND T.CLASS_NUM = '" + request.getParameter("class_num") + "'";
            }
            if (request.getParameter("student_no") != null && !request.getParameter("student_no").isEmpty()) {
                query += " AND T.STUDENT_NO = '" + request.getParameter("student_no") + "'";
            }
            if (request.getParameter("subject_cd") != null && !request.getParameter("subject_cd").isEmpty()) {
                String[] subjectParts = request.getParameter("subject_cd").split("_");
                query += " AND T.SCHOOL_CD = '" + subjectParts[0] + "' AND T.SUBJECT_CD = '" + subjectParts[1] + "'";
            }
            rs = stmt.executeQuery(query);

            java.util.Map<String, java.util.Map<String, java.util.Map<String, Object>>> groupedData = new java.util.HashMap<>();
            while (rs.next()) {
                String studentNo = rs.getString("STUDENT_NO");
                String subjectName = rs.getString("SUBJECT_NAME");
                int entYear = rs.getInt("ENT_YEAR");
                String classNum = rs.getString("CLASS_NUM");
                String studentName = rs.getString("STUDENT_NAME");
                int testNo = rs.getInt("NO");
                Integer point = rs.getObject("POINT") != null ? rs.getInt("POINT") : null;

                groupedData.putIfAbsent(studentNo, new java.util.HashMap<String, java.util.Map<String, Object>>());
                groupedData.get(studentNo).putIfAbsent(subjectName, new java.util.HashMap<String, Object>());

                java.util.Map<String, Object> subjectData = groupedData.get(studentNo).get(subjectName);
                if (!subjectData.containsKey("ENT_YEAR")) {
                    subjectData.put("ENT_YEAR", entYear);
                }
                if (!subjectData.containsKey("CLASS_NUM")) {
                    subjectData.put("CLASS_NUM", classNum != null ? classNum : "未設定");
                }
                if (!subjectData.containsKey("STUDENT_NAME")) {
                    subjectData.put("STUDENT_NAME", studentName != null ? studentName : "不明");
                }
                subjectData.put("TEST_" + testNo, point);
            }

            if (groupedData.isEmpty()) {
                out.println("<p class='message'>学生情報が存在しませんでした</p>");
            } else {
                %>
                <table>
                    <tr>
                        <th>入学年度</th>
                        <th>クラス</th>
                        <th>学生番号</th>
                        <th>名前</th>
                        <th>科目</th>
                        <th>1回目</th>
                        <th>2回目</th>
                    </tr>
                    <%
                    for (String studentNo : groupedData.keySet()) {
                        for (String subjectName : groupedData.get(studentNo).keySet()) {
                            java.util.Map<String, Object> data = groupedData.get(studentNo).get(subjectName);
                            out.println("<tr>");
                            out.println("<td>" + (data.get("ENT_YEAR") != null ? data.get("ENT_YEAR") : "未設定") + "</td>");
                            out.println("<td>" + (data.get("CLASS_NUM") != null ? data.get("CLASS_NUM") : "未設定") + "</td>");
                            out.println("<td>" + studentNo + "</td>");
                            out.println("<td>" + (data.get("STUDENT_NAME") != null ? data.get("STUDENT_NAME") : "不明") + "</td>");
                            out.println("<td>" + subjectName + "</td>");
                            out.println("<td>" + (data.get("TEST_1") != null ? data.get("TEST_1") : "") + "</td>");
                            out.println("<td>" + (data.get("TEST_2") != null ? data.get("TEST_2") : "") + "</td>");
                            out.println("</tr>");
                        }
                    }
                    %>
                </table>
                <%
            }
        } catch(Exception e) {
            out.println("<p class='message'>エラー: " + e.getMessage() + "</p>");
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
            if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
        }
    } else if (!searched) {
        out.println("<p class='message'>検索条件を指定してください。</p>");
    }
    %>
</div>

<%@ include file="footer.jsp" %>
</body>
</html>