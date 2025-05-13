<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>成績管理 - 検索</title>
    <style>
        body { font-family: Arial, sans-serif; }
        .main { padding: 20px; }
        .filter-form { display: flex; gap: 10px; margin-bottom: 20px; }
        select, input[type="number"] { padding: 5px; background-color: white; } /* 背景色を白に変更 */
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        .button { padding: 5px 10px; background-color: #ccc; border: none; cursor: pointer; }
        .highlight { background-color: yellow; }
    </style>
</head>
<body>
<div class="main">
    <h2>成績管理</h2>

    <!-- フィルタリングフォーム -->
    <form method="get" class="filter-form">
        <div>
            入学年度:
            <select name="ent_year">
                <option value="">すべて</option>
                <%
                Connection conn = null;
                Statement stmt = null;
                ResultSet rs = null;
                try {
                    Class.forName("org.h2.Driver");
                    conn = DriverManager.getConnection("jdbc:h2:~/seiseki", "sa", "");
                    stmt = conn.createStatement();
                    rs = stmt.executeQuery("SELECT DISTINCT ENT_YEAR FROM STUDENT ORDER BY ENT_YEAR");
                    while(rs.next()) {
                        String year = rs.getString("ENT_YEAR");
                        out.println("<option value=\"" + year + "\">" + year + "</option>");
                    }
                } catch(Exception e) {
                    out.println("エラー: " + e.getMessage());
                } finally {
                    if(rs != null) rs.close();
                    if(stmt != null) stmt.close();
                    if(conn != null) conn.close();
                }
                %>
            </select>
        </div>
        <div>
            クラス:
            <select name="class_num">
                <option value="">すべて</option>
                <%
                try {
                    Class.forName("org.h2.Driver");
                    conn = DriverManager.getConnection("jdbc:h2:~/seiseki", "sa", "");
                    stmt = conn.createStatement();
                    rs = stmt.executeQuery("SELECT DISTINCT CLASS_NUM FROM CLASS_NUM ORDER BY CLASS_NUM");
                    while(rs.next()) {
                        String classNum = rs.getString("CLASS_NUM");
                        out.println("<option value=\"" + classNum + "\">" + classNum + "</option>");
                    }
                } catch(Exception e) {
                    out.println("エラー: " + e.getMessage());
                } finally {
                    if(rs != null) rs.close();
                    if(stmt != null) stmt.close();
                    if(conn != null) conn.close();
                }
                %>
            </select>
        </div>
        <div>
            科目:
            <select name="subject_cd">
                <option value="">すべて</option>
                <%
                try {
                    Class.forName("org.h2.Driver");
                    conn = DriverManager.getConnection("jdbc:h2:~/seiseki", "sa", "");
                    stmt = conn.createStatement();
                    rs = stmt.executeQuery("SELECT DISTINCT CD, NAME FROM SUBJECT ORDER BY CD");
                    while(rs.next()) {
                        String cd = rs.getString("CD");
                        String name = rs.getString("NAME");
                        out.println("<option value=\"" + cd + "\">" + name + "</option>");
                    }
                } catch(Exception e) {
                    out.println("エラー: " + e.getMessage());
                } finally {
                    if(rs != null) rs.close();
                    if(stmt != null) stmt.close();
                    if(conn != null) conn.close();
                }
                %>
            </select>
        </div>
        <div>
            回数:
            <select name="no">
                <option value="">すべて</option>
                <option value="1">1</option>
                <option value="2">2</option>
            </select>
        </div>
        <input type="submit" value="検索" class="button">
    </form>

    <!-- 点数更新処理 -->
    <%
    if("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("action") != null && request.getParameter("action").equals("update")) {
        Connection connUpdate = null;
        try {
            Class.forName("org.h2.Driver");
            connUpdate = DriverManager.getConnection("jdbc:h2:~/seiseki", "sa", "");
            String sql = "UPDATE TEST SET POINT = ? WHERE STUDENT_NO = ? AND SUBJECT_CD = ? AND SCHOOL_CD = ? AND NO = ?";
            PreparedStatement pstmt = connUpdate.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(request.getParameter("point")));
            pstmt.setString(2, request.getParameter("student_no"));
            pstmt.setString(3, request.getParameter("subject_cd"));
            pstmt.setString(4, request.getParameter("school_cd"));
            pstmt.setInt(5, Integer.parseInt(request.getParameter("no")));
            pstmt.executeUpdate();
        } catch(Exception e) {
            out.println("更新エラー: " + e.getMessage());
        } finally {
            if(connUpdate != null) connUpdate.close();
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
    <table>
        <tr>
            <th>入学年度</th>
            <th>クラス</th>
            <th>生徒番号</th>
            <th>科目名</th>
            <th>点数</th>
            <th>回数</th>
        </tr>
        <%
        try {
            Class.forName("org.h2.Driver");
            conn = DriverManager.getConnection("jdbc:h2:~/seiseki", "sa", "");
            stmt = conn.createStatement();

            // 検索クエリの構築
            StringBuilder query = new StringBuilder("SELECT T.STUDENT_NO, T.SUBJECT_CD, T.SCHOOL_CD, T.NO, T.POINT, T.CLASS_NUM, S.NAME AS SUBJECT_NAME, ST.ENT_YEAR ");
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
            while(rs.next()) {
                out.println("<tr>");
                out.println("<td>" + rs.getInt("ENT_YEAR") + "</td>");
                out.println("<td>" + rs.getString("CLASS_NUM") + "</td>");
                out.println("<td>" + rs.getString("STUDENT_NO") + "</td>");
                out.println("<td>" + rs.getString("SUBJECT_NAME") + "</td>");
                out.println("<td>");
                out.println("<form method='post'>");
                out.println("<input type='number' name='point' value='" + rs.getInt("POINT") + "' min='0' max='100' class='highlight' required>");
                out.println("<input type='hidden' name='student_no' value='" + rs.getString("STUDENT_NO") + "'>");
                out.println("<input type='hidden' name='subject_cd' value='" + rs.getString("SUBJECT_CD") + "'>");
                out.println("<input type='hidden' name='school_cd' value='" + rs.getString("SCHOOL_CD") + "'>");
                out.println("<input type='hidden' name='no' value='" + rs.getInt("NO") + "'>");
                out.println("</td>");
                out.println("<td>" + rs.getInt("NO") + "</td>");
                out.println("</form></tr>");
            }
        } catch(Exception e) {
            out.println("検索エラー: " + e.getMessage());
        } finally {
            if(rs != null) rs.close();
            if(stmt != null) stmt.close();
            if(conn != null) conn.close();
        }
        %>
    </table>
    <form method="post" action="seiseki_regist_done.jsp">
        <input type="hidden" name="action" value="update">
        <input type="submit" value="更新を終了" class="button">
    </form>
    <%
    } else {
        out.println("<p>検索条件を指定して検索してください。</p>");
    }
    %>
</div>
</body>
</html>