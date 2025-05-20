<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>得点管理システム - 学生一覧</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; }
        .content { margin-left: 220px; padding: 20px; }
        h1 { color: #000; margin-top: 0; font-size: 26px; background-color: #f0f0f0; padding: 10px; }
        .filter-box { display: flex; gap: 20px; align-items: flex-start; margin-bottom: 20px; padding: 10px; border: 1px solid #ccc; border-radius: 8px; }
        .form-group { margin-top: 0; padding: 0; border-radius: 4px; flex: 1; }
        label { display: inline-block; width: 120px; font-weight: bold; vertical-align: top; }
        input[type="text"], select { width: 100%; max-width: 200px; padding: 5px; border: 1px solid #ccc; border-radius: 3px; font-size: 14px; display: block; margin-top: 5px; }
        input[type="submit"] { background-color: #4C4C4C; color: white; padding: 8px 20px; border: none; border-radius: 3px; cursor: pointer; font-size: 14px; margin-top: 28px; }
        input[type="submit"]:hover { background-color: #323232; }
        a { color: #007bff; text-decoration: underline; font-size: 14px; }
        a:hover { color: #0056b3; text-decoration: underline; }
        .error { color: red; font-size: 14px; }
        .warning { color: #ffcc00; font-size: 14px; margin-top: 5px; display: none; }
        .form-group.has-warning { margin-bottom: 15px; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { padding: 0.5em; text-align: left; border-width: 1px 0px; border-color: #CCCCCC; border-style: solid; font-size: 14px; }
        th { background-color: #ffffff; font-weight: bold; }
        .top-actions { margin-bottom: 10px; display: flex; justify-content: flex-end; }
        .checkbox-label { display: flex; align-items: center; gap: 8px; }
        input[type="checkbox"] { margin: 0; }
    </style>
</head>
<body>
<%@ include file="sidebar.jsp" %>
<%@ include file="header.jsp" %>

<div class="content">
    <br><br><br><br>
    <h1>学生一覧</h1>

    <!-- 新規登録リンク -->
    <div class="top-actions">
        <a href="student_create.jsp">新規登録</a>
    </div>

    <!-- 絞り込みフォーム -->
    <form method="get">
        <div class="filter-box">
            <div class="form-group">
                <label for="entYear">入学年度</label>
                <select name="entYear" id="entYear">
                    <option value="">--------</option>
                    <%
                        int currentYear = java.time.Year.now().getValue();
                        String selectedYear = request.getParameter("entYear") != null ? request.getParameter("entYear") : "";
                        for (int year = currentYear; year >= 2000; year--) {
                    %>
                        <option value="<%= year %>" <%= year == Integer.parseInt(selectedYear != "" ? selectedYear : "0") ? "selected" : "" %>><%= year %></option>
                    <% } %>
                </select>
                <span id="entYear_warning" class="warning">入学年度を選択してください</span>
            </div>
            <div class="form-group">
                <label for="classNum">クラス</label>
                <select name="classNum" id="classNum">
                    <option value="">--------</option>
                    <%
                        String url = "jdbc:h2:tcp://localhost/~/seiseki";
                        String user = "sa";
                        String password = "";
                        Connection conn = null;
                        Statement stmt = null;
                        ResultSet rs = null;
                        String selectedClass = request.getParameter("classNum") != null ? request.getParameter("classNum") : "";
                        try {
                            Class.forName("org.h2.Driver");
                            conn = DriverManager.getConnection(url, user, password);
                            stmt = conn.createStatement();
                            String query = "SELECT DISTINCT CLASS_NUM FROM CLASS_NUM ORDER BY CLASS_NUM";
                            rs = stmt.executeQuery(query);
                            while (rs.next()) {
                                String classNum = rs.getString("CLASS_NUM");
                    %>
                                <option value="<%= classNum %>" <%= classNum.equals(selectedClass) ? "selected" : "" %>><%= classNum %></option>
                    <%
                            }
                        } catch (Exception e) {
                            out.println("<p class='error'>データベース接続エラー: " + e.getMessage() + "</p>");
                        } finally {
                            try { if (rs != null) rs.close(); } catch (SQLException ignored) {}
                            try { if (stmt != null) stmt.close(); } catch (SQLException ignored) {}
                            try { if (conn != null) conn.close(); } catch (SQLException ignored) {}
                        }
                    %>
                </select>
                <span id="classNum_warning" class="warning">クラスを選択してください</span>
            </div>
            <div class="form-group">
                <label for="isAttend" class="checkbox-label">
                    在学中
                    <input type="checkbox" name="isAttend" id="isAttend" value="1" <%= "1".equals(request.getParameter("isAttend")) ? "checked" : "" %>>
                </label>
            </div>
            <div class="form-group">
                <input type="submit" value="絞り込み">
            </div>
        </div>
    </form>

    <%
        conn = null;
        PreparedStatement pstmt = null;
        rs = null;
        int resultCount = 0;

        String entYearParam = request.getParameter("entYear");
        String classNumParam = request.getParameter("classNum");
        String isAttendParam = request.getParameter("isAttend");

        try {
            Class.forName("org.h2.Driver");
            conn = DriverManager.getConnection(url, user, password);

            StringBuilder query = new StringBuilder("SELECT * FROM STUDENT WHERE 1=1");
            if (entYearParam != null && !entYearParam.isEmpty()) {
                query.append(" AND ENT_YEAR = ?");
            }
            if (classNumParam != null && !classNumParam.isEmpty()) {
                query.append(" AND CLASS_NUM = ?");
            }
            if (isAttendParam != null) {
                query.append(" AND IS_ATTEND = TRUE");
            }

            pstmt = conn.prepareStatement(
                query.toString(),
                ResultSet.TYPE_SCROLL_INSENSITIVE,
                ResultSet.CONCUR_READ_ONLY
            );

            int idx = 1;
            if (entYearParam != null && !entYearParam.isEmpty()) {
                pstmt.setString(idx++, entYearParam);
            }
            if (classNumParam != null && !classNumParam.isEmpty()) {
                pstmt.setString(idx++, classNumParam);
            }

            rs = pstmt.executeQuery();

            // 件数カウント
            while (rs.next()) { resultCount++; }
            rs.beforeFirst();
    %>

    <% if (resultCount == 0) { %>
        <p>学生情報が存在しませんでした</p>
    <% } else { %>
        <p>検索結果：<%= resultCount %> 件</p>
        <table>
            <thead>
                <tr>
                    <th>入学年度</th>
                    <th>学生番号</th>
                    <th>氏名</th>
                    <th>クラス</th>
                    <th>在学中</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
                <%
                    while (rs.next()) {
                        String entYear = rs.getString("ENT_YEAR");
                        String no = rs.getString("NO");
                        String name = rs.getString("NAME");
                        String classNum = rs.getString("CLASS_NUM");
                        boolean isAttend = rs.getBoolean("IS_ATTEND");
                %>
                    <tr>
                        <td><%= entYear %></td>
                        <td><%= no %></td>
                        <td><%= name %></td>
                        <td><%= classNum %></td>
                        <td><%= isAttend ? "○" : "×" %></td>
                        <td><a href="student_update.jsp?studentNo=<%= no %>">変更</a></td>
                    </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    <% } %>

    <%
        } catch (Exception e) {
            out.println("<p class='error'>エラー: " + e.getMessage() + "</p>");
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException ignored) {}
            try { if (pstmt != null) pstmt.close(); } catch (SQLException ignored) {}
            try { if (conn != null) conn.close(); } catch (SQLException ignored) {}
        }
    %>
</div>

<%@ include file="footer.jsp" %>
</body>
</html>