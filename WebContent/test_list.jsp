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
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                int reconnectAttempts = 0;
                boolean connected = false;
                while (reconnectAttempts < 3) {
                    try {
                        Class.forName("org.h2.Driver");
                        conn = DriverManager.getConnection("jdbc:h2:tcp://localhost/~/exam;IFEXISTS=TRUE;DB_CLOSE_ON_EXIT=TRUE", "sa", "");
                        conn.setAutoCommit(true);
                        pstmt = conn.prepareStatement("SELECT DISTINCT ENT_YEAR FROM Student WHERE ENT_YEAR IS NOT NULL ORDER BY ENT_YEAR");
                        rs = pstmt.executeQuery();
                        while (rs.next()) {
                            int year = rs.getInt("ENT_YEAR");
                            String selected = String.valueOf(year).equals(selectedEntYear) ? "selected" : "";
                            out.println("<option value='" + year + "' " + selected + ">" + year + "</option>");
                        }
                        connected = true;
                        break;
                    } catch (SQLException e) {
                        e.printStackTrace();
                        if (e.getErrorCode() == 90020) { // Database may be already in use
                            reconnectAttempts++;
                            if (reconnectAttempts < 3) {
                                try { Thread.sleep(1000); } catch (InterruptedException ignored) {}
                                continue;
                            }
                        }
                        out.println("<p class='message'>入学年度取得エラー: " + e.getMessage() + "</p>");
                        break;
                    } catch (Exception e) {
                        e.printStackTrace();
                        out.println("<p class='message'>入学年度取得エラー: " + e.getMessage() + "</p>");
                        break;
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
                        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
                    }
                }
                if (!connected) {
                    out.println("<p class='message'>入学年度取得に失敗しました。データベース接続を確認してください。</p>");
                }
                %>
            </select>

            <label>クラス</label>
            <select name="class_num">
                <option value="">--------</option>
                <%
                String selectedClassNum = request.getParameter("class_num") != null ? request.getParameter("class_num") : "";
                reconnectAttempts = 0;
                connected = false;
                while (reconnectAttempts < 3) {
                    try {
                        Class.forName("org.h2.Driver");
                        conn = DriverManager.getConnection("jdbc:h2:tcp://localhost/~/exam;IFEXISTS=TRUE;DB_CLOSE_ON_EXIT=TRUE", "sa", "");
                        conn.setAutoCommit(true);
                        pstmt = conn.prepareStatement("SELECT CLASS_NUM FROM CLASS_NUM ORDER BY CLASS_NUM");
                        rs = pstmt.executeQuery();
                        while (rs.next()) {
                            String classNum = rs.getString("CLASS_NUM");
                            String selected = classNum.equals(selectedClassNum) ? "selected" : "";
                            out.println("<option value='" + classNum + "' " + selected + ">" + classNum + "</option>");
                        }
                        connected = true;
                        break;
                    } catch (SQLException e) {
                        e.printStackTrace();
                        if (e.getErrorCode() == 90020) {
                            reconnectAttempts++;
                            if (reconnectAttempts < 3) {
                                try { Thread.sleep(1000); } catch (InterruptedException ignored) {}
                                continue;
                            }
                        }
                        out.println("<p class='message'>クラス取得エラー: " + e.getMessage() + "</p>");
                        break;
                    } catch (Exception e) {
                        e.printStackTrace();
                        out.println("<p class='message'>クラス取得エラー: " + e.getMessage() + "</p>");
                        break;
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
                        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
                    }
                }
                if (!connected) {
                    out.println("<p class='message'>クラス取得に失敗しました。データベース接続を確認してください。</p>");
                }
                %>
            </select>

            <label>科目</label>
            <select name="subject_cd">
                <option value="">--------</option>
                <%
                String selectedSubjectCd = request.getParameter("subject_cd") != null ? request.getParameter("subject_cd") : "";
                reconnectAttempts = 0;
                connected = false;
                while (reconnectAttempts < 3) {
                    try {
                        Class.forName("org.h2.Driver");
                        conn = DriverManager.getConnection("jdbc:h2:tcp://localhost/~/exam;IFEXISTS=TRUE;DB_CLOSE_ON_EXIT=TRUE", "sa", "");
                        conn.setAutoCommit(true);
                        pstmt = conn.prepareStatement("SELECT SCHOOL_CD, CD, NAME AS SUBJECT_NAME FROM SUBJECT ORDER BY SCHOOL_CD, CD");
                        rs = pstmt.executeQuery();
                        while (rs.next()) {
                            String schoolCd = rs.getString("SCHOOL_CD");
                            String cd = rs.getString("CD");
                            String subjectName = rs.getString("SUBJECT_NAME");
                            String value = schoolCd + "_" + cd;
                            String selected = value.equals(selectedSubjectCd) ? "selected" : "";
                            out.println("<option value='" + value + "' " + selected + ">" + subjectName + "</option>");
                        }
                        connected = true;
                        break;
                    } catch (SQLException e) {
                        e.printStackTrace();
                        if (e.getErrorCode() == 90020) {
                            reconnectAttempts++;
                            if (reconnectAttempts < 3) {
                                try { Thread.sleep(1000); } catch (InterruptedException ignored) {}
                                continue;
                            }
                        }
                        out.println("<p class='message'>科目取得エラー: " + e.getMessage() + "</p>");
                        break;
                    } catch (Exception e) {
                        e.printStackTrace();
                        out.println("<p class='message'>科目取得エラー: " + e.getMessage() + "</p>");
                        break;
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
                        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
                    }
                }
                if (!connected) {
                    out.println("<p class='message'>科目取得に失敗しました。データベース接続を確認してください。</p>");
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
        reconnectAttempts = 0;
        connected = false;
        while (reconnectAttempts < 3) {
            try {
                Class.forName("org.h2.Driver");
                conn = DriverManager.getConnection("jdbc:h2:tcp://localhost/~/exam;IFEXISTS=TRUE;DB_CLOSE_ON_EXIT=TRUE", "sa", "");
                conn.setAutoCommit(true);
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

                    groupedData.putIfAbsent(studentNo, new HashMap<String, Map<String, Object>>());
                    groupedData.get(studentNo).putIfAbsent(subjectName, new HashMap<String, Object>());

                    Map<String, Object> subjectData = groupedData.get(studentNo).get(subjectName);
                    subjectData.putIfAbsent("ENT_YEAR", entYear);
                    subjectData.putIfAbsent("CLASS_NUM", classNum != null ? classNum : "未設定");
                    subjectData.putIfAbsent("STUDENT_NAME", studentName != null ? studentName : "不明");
                    subjectData.put("TEST_" + testNo, point);
                }

                if (groupedData.isEmpty()) {
                    out.println("<p class='message'>学生情報が存在しませんでした。データベースに適切なデータがあるか確認してください。</p>");
                    // デバッグ用: テーブルデータの存在確認
                    try {
                        pstmt = conn.prepareStatement("SELECT COUNT(*) AS cnt FROM TEST");
                        rs = pstmt.executeQuery();
                        if (rs.next()) {
                            out.println("<p class='message'>TESTテーブルレコード数: " + rs.getInt("cnt") + "</p>");
                        }
                        pstmt = conn.prepareStatement("SELECT COUNT(*) AS cnt FROM STUDENT");
                        rs = pstmt.executeQuery();
                        if (rs.next()) {
                            out.println("<p class='message'>STUDENTテーブルレコード数: " + rs.getInt("cnt") + "</p>");
                        }
                        pstmt = conn.prepareStatement("SELECT COUNT(*) AS cnt FROM SUBJECT");
                        rs = pstmt.executeQuery();
                        if (rs.next()) {
                            out.println("<p class='message'>SUBJECTテーブルレコード数: " + rs.getInt("cnt") + "</p>");
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        out.println("<p class='message'>デバッグエラー: " + e.getMessage() + "</p>");
                    }
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
                    </table>
                    <%
                }
                connected = true;
                break;
            } catch (SQLException e) {
                e.printStackTrace();
                if (e.getErrorCode() == 90020) {
                    reconnectAttempts++;
                    if (reconnectAttempts < 3) {
                        try { Thread.sleep(1000); } catch (InterruptedException ignored) {}
                        continue;
                    }
                }
                out.println("<p class='message'>検索エラー: " + e.getMessage() + "</p>");
                break;
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p class='message'>検索エラー: " + e.getMessage() + "</p>");
                break;
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
                if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
            }
        }
        if (!connected) {
            out.println("<p class='message'>検索に失敗しました。データベース接続を確認してください。</p>");
        }
    } else if (!searched) {
        out.println("<p class='message'>検索条件を指定してください。</p>");
    }
    %>
</div>

<%@ include file="footer.jsp" %>
</body>
</html>