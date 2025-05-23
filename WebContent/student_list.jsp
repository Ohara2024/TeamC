<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*, java.sql.*" %>
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
        <a href="StudentCreateAction">新規登録</a>
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
                        String selected = String.valueOf(year).equals(selectedYear) ? "selected" : "";
                        out.println("<option value='" + year + "' " + selected + ">" + year + "</option>");
                    }
                    %>
                </select>
            </div>
            <div class="form-group">
                <label for="classNum">クラス</label>
                <select name="classNum" id="classNum">
                    <option value="">--------</option>
                    <%
                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;
                    String selectedClass = request.getParameter("classNum") != null ? request.getParameter("classNum") : "";
                    try {
                        Class.forName("org.h2.Driver");
                        conn = DriverManager.getConnection("jdbc:h2:~/exam", "sa", "");
                        pstmt = conn.prepareStatement("SELECT CLASS_NUM FROM CLASS_NUM ORDER BY CLASS_NUM");
                        rs = pstmt.executeQuery();
                        while (rs.next()) {
                            String classNum = rs.getString("CLASS_NUM");
                            String selected = classNum.equals(selectedClass) ? "selected" : "";
                            out.println("<option value='" + classNum + "' " + selected + ">" + classNum + "</option>");
                        }
                    } catch(Exception e) {
                        out.println("<p class='error'>クラス取得エラー: " + e.getMessage() + "</p>");
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
                        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
                    }
                    %>
                </select>
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
    String error = null;
    List<Map<String, Object>> students = new ArrayList<>();
    Integer resultCount = 0;
    try {
        Class.forName("org.h2.Driver");
        conn = DriverManager.getConnection("jdbc:h2:~/exam", "sa", "");
        StringBuilder query = new StringBuilder("SELECT NO, ENT_YEAR, NAME, CLASS_NUM, IS_ATTEND FROM STUDENT WHERE 1=1");
        List<String> params = new ArrayList<>();

        if (request.getParameter("entYear") != null && !request.getParameter("entYear").isEmpty()) {
            query.append(" AND ENT_YEAR = ?");
            params.add(request.getParameter("entYear"));
        }
        if (request.getParameter("classNum") != null && !request.getParameter("classNum").isEmpty()) {
            query.append(" AND CLASS_NUM = ?");
            params.add(request.getParameter("classNum"));
        }
        if ("1".equals(request.getParameter("isAttend"))) {
            query.append(" AND IS_ATTEND = ?");
            params.add("true");
        }

        pstmt = conn.prepareStatement(query.toString());
        for (int i = 0; i < params.size(); i++) {
            pstmt.setString(i + 1, params.get(i));
        }
        rs = pstmt.executeQuery();

        while (rs.next()) {
            Map<String, Object> student = new HashMap<>();
            student.put("NO", rs.getString("NO"));
            student.put("ENT_YEAR", rs.getInt("ENT_YEAR"));
            student.put("NAME", rs.getString("NAME"));
            student.put("CLASS_NUM", rs.getString("CLASS_NUM"));
            student.put("IS_ATTEND", rs.getBoolean("IS_ATTEND"));
            students.add(student);
        }
        resultCount = students.size();
    } catch (Exception e) {
        error = "検索エラー: " + e.getMessage();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
    }
    %>

    <% if (error != null) { %>
        <p class="error"><%= error %></p>
    <% } %>

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
                <% for (Map<String, Object> student : students) { %>
                    <tr>
                        <td><%= student.get("ENT_YEAR") %></td>
                        <td><%= student.get("NO") %></td>
                        <td><%= student.get("NAME") %></td>
                        <td><%= student.get("CLASS_NUM") %></td>
                        <td><%= (Boolean)student.get("IS_ATTEND") ? "○" : "×" %></td>
                        <td><a href="StudentUpdateAction?studentNo=<%= student.get("NO") %>">変更</a></td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    <% } %>
</div>

<%@ include file="footer.jsp" %>
</body>
</html>