<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.sql.*" %>
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
        <form action="test_list_student.jsp" method="post">
            <label>入学年度:</label>
            <select name="ent_year">
                <option value="">選択してください</option>
                <%
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                try {
                    Class.forName("org.h2.Driver");
                    conn = DriverManager.getConnection("jdbc:h2:~/seiseki;CHARACTER_ENCODING=UTF8", "sa", "");
                    pstmt = conn.prepareStatement("SELECT DISTINCT ENT_YEAR FROM Student WHERE ENT_YEAR IS NOT NULL ORDER BY ENT_YEAR");
                    rs = pstmt.executeQuery();
                    while (rs.next()) {
                        int year = rs.getInt("ENT_YEAR");
                        String selected = year == Integer.parseInt(request.getParameter("ent_year") != null ? request.getParameter("ent_year") : "0") ? "selected" : "";
                        out.println("<option value='" + year + "' " + selected + ">" + year + "</option>");
                    }
                } catch (Exception e) {
                    out.println("<p class='error'>入学年度取得エラー: " + e.getMessage() + "</p>");
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
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
                    conn = DriverManager.getConnection("jdbc:h2:~/seiseki;CHARACTER_ENCODING=UTF8", "sa", "");
                    pstmt = conn.prepareStatement("SELECT CLASS_NUM FROM CLASS_NUM ORDER BY CLASS_NUM");
                    rs = pstmt.executeQuery();
                    while (rs.next()) {
                        String classNum = rs.getString("CLASS_NUM");
                        String selected = classNum.equals(request.getParameter("class_num")) ? "selected" : "";
                        out.println("<option value='" + classNum + "' " + selected + ">" + classNum + "</option>");
                    }
                } catch (Exception e) {
                    out.println("<p class='error'>クラス取得エラー: " + e.getMessage() + "</p>");
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
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
                    conn = DriverManager.getConnection("jdbc:h2:~/seiseki;CHARACTER_ENCODING=UTF8", "sa", "");
                    pstmt = conn.prepareStatement("SELECT SCHOOL_CD, CD, NAME AS SUBJECT_NAME FROM SUBJECT ORDER BY SCHOOL_CD, CD");
                    rs = pstmt.executeQuery();
                    while (rs.next()) {
                        String schoolCd = rs.getString("SCHOOL_CD");
                        String cd = rs.getString("CD");
                        String subjectName = rs.getString("SUBJECT_NAME");
                        String value = schoolCd + "_" + cd;
                        String selected = value.equals(request.getParameter("subject_cd")) ? "selected" : "";
                        out.println("<option value='" + value + "' " + selected + ">" + subjectName + "</option>");
                    }
                } catch (Exception e) {
                    out.println("<p class='error'>科目取得エラー: " + e.getMessage() + "</p>");
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
                    if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
                }
                %>
            </select>

            <label>学生番号:</label>
            <input type="text" name="student_no" value="<%= request.getParameter("student_no") != null ? request.getParameter("student_no") : "" %>">

            <input type="submit" value="検索">
        </form>

        <!-- 検索結果 -->
        <%
        boolean searched = request.getMethod().equalsIgnoreCase("POST") &&
                          ((request.getParameter("ent_year") != null && !request.getParameter("ent_year").isEmpty()) ||
                           (request.getParameter("class_num") != null && !request.getParameter("class_num").isEmpty()) ||
                           (request.getParameter("subject_cd") != null && !request.getParameter("subject_cd").isEmpty()) ||
                           (request.getParameter("student_no") != null && !request.getParameter("student_no").isEmpty()));

        if (searched) {
            try {
                Class.forName("org.h2.Driver");
                conn = DriverManager.getConnection("jdbc:h2:~/seiseki;CHARACTER_ENCODING=UTF8", "sa", "");

                StringBuilder query = new StringBuilder(
                    "SELECT S.ENT_YEAR, T.CLASS_NUM, T.STUDENT_NO, S.NAME AS STUDENT_NAME, SU.NAME AS SUBJECT_NAME, T.NO, T.POINT " +
                    "FROM TEST T " +
                    "JOIN STUDENT S ON T.STUDENT_NO = S.NO " +
                    "JOIN SUBJECT SU ON T.SCHOOL_CD = SU.SCHOOL_CD AND T.SUBJECT_CD = SU.CD " +
                    "WHERE 1=1"
                );
                List<String> params = new ArrayList<>();

                if (request.getParameter("ent_year") != null && !request.getParameter("ent_year").isEmpty()) {
                    query.append(" AND S.ENT_YEAR = ?");
                    params.add(request.getParameter("ent_year"));
                }
                if (request.getParameter("class_num") != null && !request.getParameter("class_num").isEmpty()) {
                    query.append(" AND T.CLASS_NUM = ?");
                    params.add(request.getParameter("class_num"));
                }
                if (request.getParameter("student_no") != null && !request.getParameter("student_no").isEmpty()) {
                    query.append(" AND T.STUDENT_NO = ?");
                    params.add(request.getParameter("student_no"));
                }
                if (request.getParameter("subject_cd") != null && !request.getParameter("subject_cd").isEmpty()) {
                    String[] subjectParts = request.getParameter("subject_cd").split("_");
                    query.append(" AND T.SCHOOL_CD = ? AND T.SUBJECT_CD = ?");
                    params.add(subjectParts[0]);
                    params.add(subjectParts[1]);
                }

                pstmt = conn.prepareStatement(query.toString());
                for (int i = 0; i < params.size(); i++) {
                    pstmt.setString(i + 1, params.get(i));
                }

                rs = pstmt.executeQuery();

                Map<String, Map<String, Map<String, Object>>> groupedData = new HashMap<>();
                while (rs.next()) {
                    String studentNo = rs.getString("STUDENT_NO");
                    String subjectName = rs.getString("SUBJECT_NAME");
                    int entYear = rs.getInt("ENT_YEAR");
                    String classNum = rs.getString("CLASS_NUM");
                    String studentName = rs.getString("STUDENT_NAME");
                    int testNo = rs.getInt("NO");
                    Integer point = rs.getObject("POINT") != null ? rs.getInt("POINT") : null;

                    groupedData.putIfAbsent(studentNo, new HashMap<>());
                    groupedData.get(studentNo).putIfAbsent(subjectName, new HashMap<>());

                    Map<String, Object> subjectData = groupedData.get(studentNo).get(subjectName);
                    subjectData.putIfAbsent("ENT_YEAR", entYear);
                    subjectData.putIfAbsent("CLASS_NUM", classNum != null ? classNum : "未設定");
                    subjectData.putIfAbsent("STUDENT_NAME", studentName != null ? studentName : "不明");
                    subjectData.put("TEST_" + testNo, point);
                }

                if (groupedData.isEmpty()) {
                    out.println("<p class='error'>検索結果が見つかりませんでした。データが存在するか確認してください。</p>");
                } else {
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
                            for (String studentNo : groupedData.keySet()) {
                                for (String subjectName : groupedData.get(studentNo).keySet()) {
                                    Map<String, Object> data = groupedData.get(studentNo).get(subjectName);
                                    out.println("<tr>");
                                    out.println("<td>" + (data.get("ENT_YEAR") != null ? data.get("ENT_YEAR") : "未設定") + "</td>");
                                    out.println("<td>" + (data.get("CLASS_NUM") != null ? data.get("CLASS_NUM") : "未設定") + "</td>");
                                    out.println("<td>" + studentNo + "</td>");
                                    out.println("<td>" + (data.get("STUDENT_NAME") != null ? data.get("STUDENT_NAME") : "不明") + "</td>");
                                    out.println("<td>" + subjectName + "</td>");
                                    out.println("<td>" + (data.get("TEST_1") != null ? data.get("TEST_1") : "-") + "</td>");
                                    out.println("<td>" + (data.get("TEST_2") != null ? data.get("TEST_2") : "-") + "</td>");
                                    out.println("</tr>");
                                }
                            }
                            %>
                        </tbody>
                    </table>
                    <%
                }
            } catch (Exception e) {
                out.println("<p class='error'>検索エラー: " + e.getMessage() + "</p>");
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
                if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
            }
        }
        %>
    </main>
    <%@ include file="footer.jsp" %>
</body>
</html>