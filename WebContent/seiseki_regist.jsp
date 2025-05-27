<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, scoremanager.main.DBConnection" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8"> <!-- 文字エンコーディングをUTF-8に設定 -->
    <title>成績管理</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f0f0f0; margin: 0; }
        .main { padding: 20px; max-width: 800px; margin: 0 auto; background: #fff; border: 1px solid #ccc; }
        .filter-form { display: flex; gap: 10px; margin-bottom: 20px; padding: 10px; background: #f9f9f9; border: 1px solid #ddd; align-items: flex-end; justify-content: space-between; }
        .filter-form .filter-group { display: flex; gap: 40px; }
        .filter-form .filter-group div { display: flex; flex-direction: column; align-items: flex-start; gap: 2px; }
        select, input[type="number"] { padding: 5px; border: 1px solid #ccc; border-radius: 4px; background-color: white; }
        table { border-collapse: collapse; width: 100%; border: 1px solid #ddd; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; font-size: 14px; }
        th { background-color: #f2f2f2; font-weight: bold; }
        .button { padding: 6px 12px; background-color: #d3d3d3; border: none; border-radius: 4px; cursor: pointer; }
    </style>
</head>
<body>
<%@ include file="sidebar.jsp" %>
<%@ include file="header.jsp" %>

<div class="main">
    <br><br><br><br>
    <!-- フィルタリングフォーム -->
    <form method="get" class="filter-form">
        <div class="filter-group">
            <div>
                <label>入学年度:</label>
                <select name="ent_year">
                    <option value="">すべて</option>
                    <%
                    Connection conn = null;
                    Statement stmt = null;
                    ResultSet rs = null;
                    try {
                        conn = DBConnection.getConnection();
                        stmt = conn.createStatement();
                        rs = stmt.executeQuery("SELECT DISTINCT ENT_YEAR FROM STUDENT ORDER BY ENT_YEAR");
                        while(rs.next()) {
                            String year = rs.getString("ENT_YEAR");
                            out.println("<option value=\"" + year + "\">" + year + "</option>");
                        }
                    } catch(Exception e) {
                        out.println("エラー: " + e.getMessage());
                    } finally {
                        if(rs != null) try { rs.close(); } catch(SQLException ignored) {}
                        if(stmt != null) try { stmt.close(); } catch(SQLException ignored) {}
                        if(conn != null) try { conn.close(); } catch(SQLException ignored) {}
                    }
                    %>
                </select>
            </div>
            <div>
                <label>クラス:</label>
                <select name="class_num">
                    <option value="">すべて</option>
                    <%
                    try {
                        conn = DBConnection.getConnection();
                        stmt = conn.createStatement();
                        rs = stmt.executeQuery("SELECT DISTINCT CLASS_NUM FROM CLASS_NUM ORDER BY CLASS_NUM");
                        while(rs.next()) {
                            String classNum = rs.getString("CLASS_NUM");
                            out.println("<option value=\"" + classNum + "\">" + classNum + "</option>");
                        }
                    } catch(Exception e) {
                        out.println("エラー: " + e.getMessage());
                    } finally {
                        if(rs != null) try { rs.close(); } catch(SQLException ignored) {}
                        if(stmt != null) try { stmt.close(); } catch(SQLException ignored) {}
                        if(conn != null) try { conn.close(); } catch(SQLException ignored) {}
                    }
                    %>
                </select>
            </div>
            <div>
                <label>科目:</label>
                <select name="subject_cd">
                    <option value="">すべて</option>
                    <%
                    try {
                        conn = DBConnection.getConnection();
                        stmt = conn.createStatement();
                        rs = stmt.executeQuery("SELECT DISTINCT CD, NAME FROM SUBJECT ORDER BY CD");
                        while(rs.next()) {
                            String cd = rs.getString("CD");
                            String subjectName = rs.getString("NAME");
                            out.println("<option value=\"" + cd + "\">" + subjectName + "</option>");
                        }
                    } catch(Exception e) {
                        out.println("エラー: " + e.getMessage());
                    } finally {
                        if(rs != null) try { rs.close(); } catch(SQLException ignored) {}
                        if(stmt != null) try { stmt.close(); } catch(SQLException ignored) {}
                        if(conn != null) try { conn.close(); } catch(SQLException ignored) {}
                    }
                    %>
                </select>
            </div>
            <div>
                <label>回数:</label>
                <select name="no">
                    <option value="">すべて</option>
                    <option value="1">1</option>
                    <option value="2">2</option>
                </select>
            </div>
        </div>
        <div>
            <input type="submit" value="検索" class="button">
        </div>
    </form>

    <!-- 点数更新処理 -->
    <%
    response.setContentType("text/html; charset=UTF-8"); // レスポンスのエンコーディングを明示
    if("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("action") != null && request.getParameter("action").equals("update")) {
        Connection connUpdate = null;
        PreparedStatement pstmt = null;
        try {
            connUpdate = DBConnection.getConnection();
            String sql = "UPDATE TEST SET POINT = ? WHERE STUDENT_NO = ? AND SUBJECT_CD = ? AND SCHOOL_CD = ? AND NO = ?";
            pstmt = connUpdate.prepareStatement(sql);

            int index = 0;
            while(request.getParameter("point[" + index + "]") != null) {
                String point = request.getParameter("point[" + index + "]");
                String studentNo = request.getParameter("student_no[" + index + "]");
                String subjectCd = request.getParameter("subject_cd[" + index + "]");
                String schoolCd = request.getParameter("school_cd[" + index + "]");
                String no = request.getParameter("no[" + index + "]");

                pstmt.setInt(1, Integer.parseInt(point));
                pstmt.setString(2, studentNo);
                pstmt.setString(3, subjectCd);
                pstmt.setString(4, schoolCd);
                pstmt.setInt(5, Integer.parseInt(no));
                pstmt.executeUpdate();
                index++;
            }
            response.sendRedirect("seiseki_regist_done.jsp");
        } catch(Exception e) {
            out.println("更新エラー: " + e.getMessage());
        } finally {
            if(pstmt != null) try { pstmt.close(); } catch(SQLException ignored) {}
            if(connUpdate != null) try { connUpdate.close(); } catch(SQLException ignored) {}
        }
    }
    %>

    <!-- 検索結果表示（検索実行後にのみ表示） -->
    <%
    boolean hasSearchParams = request.getParameter("ent_year") != null ||
                              request.getParameter("class_num") != null ||
                              request.getParameter("subject_cd") != null ||
                              request.getParameter("no") != null;
    if(hasSearchParams) {
    %>
    <form method="post" action="seiseki_regist.jsp">
        <table>
            <tr>
                <th>入学年度</th>
                <th>クラス</th>
                <th>生徒番号</th>
                <th>生徒名</th>
                <th>科目名</th>
                <th>点数</th>
            </tr>
            <%
            try {
                conn = DBConnection.getConnection();
                stmt = conn.createStatement();

                StringBuilder query = new StringBuilder("SELECT T.STUDENT_NO, T.SUBJECT_CD, T.SCHOOL_CD, T.NO, T.POINT, T.CLASS_NUM, S.NAME AS SUBJECT_NAME, ST.ENT_YEAR, ST.NAME AS STUDENT_NAME ");
                query.append("FROM TEST T ");
                query.append("JOIN SUBJECT S ON T.SUBJECT_CD = S.CD AND T.SCHOOL_CD = S.SCHOOL_CD ");
                query.append("JOIN STUDENT ST ON T.STUDENT_NO = ST.NO WHERE 1=1");

                if(request.getParameter("ent_year") != null && !request.getParameter("ent_year").isEmpty()) {
                    query.append(" AND ST.ENT_YEAR = ").append(request.getParameter("ent_year"));
                }
                if(request.getParameter("class_num") != null && !request.getParameter("class_num").isEmpty()) {
                    query.append(" AND T.CLASS_NUM = '").append(request.getParameter("class_num")).append("'");
                }
                if(request.getParameter("subject_cd") != null && !request.getParameter("subject_cd").isEmpty()) {
                    query.append(" AND T.SUBJECT_CD = '").append(request.getParameter("subject_cd")).append("'");
                }
                if(request.getParameter("no") != null && !request.getParameter("no").isEmpty()) {
                    query.append(" AND T.NO = ").append(request.getParameter("no"));
                }

                rs = stmt.executeQuery(query.toString());
                int index = 0;
                while(rs.next()) {
                    out.println("<tr>");
                    out.println("<td>" + rs.getInt("ENT_YEAR") + "</td>");
                    out.println("<td>" + rs.getString("CLASS_NUM") + "</td>");
                    out.println("<td>" + rs.getString("STUDENT_NO") + "</td>");
                    out.println("<td>" + rs.getString("STUDENT_NAME") + "</td>");
                    out.println("<td>" + rs.getString("SUBJECT_NAME") + "</td>");
                    out.println("<td>");
                    out.println("<input type='number' name='point[" + index + "]' value='" + rs.getInt("POINT") + "' min='0' max='100' required>");
                    out.println("<input type='hidden' name='student_no[" + index + "]' value='" + rs.getString("STUDENT_NO") + "'>");
                    out.println("<input type='hidden' name='subject_cd[" + index + "]' value='" + rs.getString("SUBJECT_CD") + "'>");
                    out.println("<input type='hidden' name='school_cd[" + index + "]' value='" + rs.getString("SCHOOL_CD") + "'>");
                    out.println("<input type='hidden' name='no[" + index + "]' value='" + rs.getInt("NO") + "'>");
                    out.println("</td>");
                    out.println("</tr>");
                    index++;
                }
            } catch(Exception e) {
                out.println("検索エラー: " + e.getMessage());
            } finally {
                if(rs != null) try { rs.close(); } catch(SQLException ignored) {}
                if(stmt != null) try { stmt.close(); } catch(SQLException ignored) {}
                if(conn != null) try { conn.close(); } catch(SQLException ignored) {}
            }
            %>
        </table>
        <input type="hidden" name="action" value="update">
        <input type="submit" value="更新を終了" class="button" style="margin-top: 10px;">
    </form>
    <%
    } else {
        out.println("<p>検索条件を指定して検索してください。</p>");
    }
    %>
</div>
<%@ include file="footer.jsp" %>
</body>
</html>