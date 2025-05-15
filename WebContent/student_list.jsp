<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>学生管理</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; }
        .content { margin-left: 220px; padding: 20px; }
        h1 { color: #000; margin-top: 0; font-size: 26px; background-color: #f0f0f0; padding: 10px; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        button[type="submit"] { background-color: #4C4C4C; color: white; padding: 8px 20px; border: none; border-radius: 3px; cursor: pointer; font-size: 14px; }
        th, td { padding: 8px; text-align: left; border-width: 1px 0px; border-color: #CCCCCC; border-style: solid; padding: 0.5em; }
        th { background-color: #ffffff; }
        .filter-box {
            border: 1px solid #ccc; padding: 15px; margin: 10px 0 20px 0; display: flex;
            align-items: flex-start; justify-content: space-between; gap: 40px; width: 90%; border-radius: 8px;
        }
        .filter-box label { display: flex; flex-direction: column; font-weight: bold; }
        .filter-box select { margin-top: 10px; padding: 8px; height: 40px; border-radius: 4px; }
        .filter-box .checkbox-label { flex-direction: row; align-items: center; gap: 8px; margin-top: 10px; }
        .filter-box input[type="checkbox"] { margin: 0; }
        .filter-box button { margin-top: 28px; padding: 6px 12px; }
        .action-btn { color: #007bff; text-decoration: underline; background: none; padding: 0; }
        .action-btn:hover { color: #0056 Wb3; text-decoration: underline; }
        .top-actions { margin-bottom: 10px; display: flex; justify-content: flex-end; }
    </style>
</head>
<body>
<%@ include file="sidebar.jsp" %>
<%@ include file="header.jsp" %>

<div class="content">
    <br><br><br><br>
    <h1>学生管理</h1>

    <!-- 新規登録リンク -->
    <div class="top-actions">
        <a href="student_create.jsp" class="action-btn">新規登録</a>
    </div>

    <!-- 絞り込みフォーム -->
    <form method="get">
        <div class="filter-box">
            <label>入学年度
                <select name="entYear">
                    <option value="">--------　　　　　　　　　　　　</option>
                    <option value="2021">2021</option>
                    <option value="2022">2022</option>
                    <option value="2023">2023</option>
                </select>
            </label>
            <label>クラス
                <select name="classNum">
                    <option value="">--------　　　　　　　　　　　　</option>
                    <%
                        String url = "jdbc:h2:tcp://localhost/~/seiseki";
                        String user = "sa";
                        String password = "";
                        Connection conn = null;
                        Statement stmt = null;
                        ResultSet rs = null;
                        try {
                            Class.forName("org.h2.Driver");
                            conn = DriverManager.getConnection(url, user, password);
                            stmt = conn.createStatement();
                            String query = "SELECT DISTINCT CLASS_NUM FROM CLASS_NUM ORDER BY CLASS_NUM";
                            rs = stmt.executeQuery(query);
                            while (rs.next()) {
                                String classNum = rs.getString("CLASS_NUM");
                                String selected = (classNum.equals(request.getParameter("classNum"))) ? "selected" : "";
                    %>
                        <option value="<%= classNum %>" <%= selected %>><%= classNum %></option>
                    <%
                            }
                        } catch (Exception e) {
                            out.println("<p style='color:red;'>エラー: " + e.getMessage() + "</p>");
                        } finally {
                            try { if (rs != null) rs.close(); } catch (SQLException ignored) {}
                            try { if (stmt != null) stmt.close(); } catch (SQLException ignored) {}
                            try { if (conn != null) conn.close(); } catch (SQLException ignored) {}
                        }
                    %>
                </select>
            </label>
            <label class="checkbox-label">
                在学中
                <input type="checkbox" name="isAttend" value="1" <%= "1".equals(request.getParameter("isAttend")) ? "checked" : "" %>>
            </label>
            <button type="submit">絞り込み</button>
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
        <p style="color: #000000;">学生情報が存在しませんでした</p>
    <% } else { %>
        <p>検索結果：<%= resultCount %> 件</p>
        <table>
            <tr>
                <th>入学年度</th>
                <th>学生番号</th>
                <th>氏名</th>
                <th>クラス</th>
                <th>在学中</th>
                <th></th>
            </tr>
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
                    <td><a href="student_update.jsp?studentNo=<%= no %>" class="action-btn">変更</a></td>
                </tr>
            <%
                }
            %>
        </table>
    <% } %>

    <%
        } catch (Exception e) {
            out.println("<p style='color:red;'>エラー: " + e.getMessage() + "</p>");
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