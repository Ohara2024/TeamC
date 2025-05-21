<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>得点管理システム</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; }
        .content { margin-left: 220px; padding: 20px; }
        h1 { color: #000; margin-top: 0; font-size: 26px; background-color: #f0f0f0; padding: 10px; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; }
        input[type="text"], select {
            width: 100%; max-width: 100%; padding: 10px; height: 40px;
            border: 1px solid #ccc; border-radius: 3px; font-size: 14px;
            display: block; margin-top: 5px; box-sizing: border-box;
        }
        input[type="submit"] {
            background-color: #007bff; color: white; padding: 10px 20px;
            border: none; cursor: pointer; border-radius: 4px;
        }
        input[type="submit"]:hover { background-color: #0056b3; }
        a { color: #007bff; text-decoration: none; }
        a:hover { text-decoration: underline; }
        .error { color: red; }
        .readonly { padding: 5px; width: 200px; display: inline-block; }
    </style>
</head>
<body>
    <%@ include file="sidebar.jsp" %>
    <%@ include file="header.jsp" %>

    <div class="content">
        <br><br><br><br>
        <h1>学生情報更新</h1>

        <%
            String url = "jdbc:h2:tcp://localhost/~/seiseki";
            String user = "sa";
            String password = "";
            String studentNo = request.getParameter("studentNo");
            String entYear = "";
            String no = "";
            String name = "";
            String classNum = "";
            String schoolCd = "";

            if (studentNo == null || studentNo.isEmpty()) {
                out.println("<p class='error'>学生番号が指定されていません。</p>");
            } else {
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;

                try {
                    Class.forName("org.h2.Driver");
                    conn = DriverManager.getConnection(url, user, password);
                    String query = "SELECT ENT_YEAR, NO, NAME, CLASS_NUM, SCHOOL_CD FROM STUDENT WHERE NO = ?";
                    pstmt = conn.prepareStatement(query);
                    pstmt.setString(1, studentNo);
                    rs = pstmt.executeQuery();
                    if (rs.next()) {
                        entYear = rs.getString("ENT_YEAR");
                        no = rs.getString("NO");
                        name = rs.getString("NAME") != null ? rs.getString("NAME") : "";
                        classNum = rs.getString("CLASS_NUM") != null ? rs.getString("CLASS_NUM") : "";
                        schoolCd = rs.getString("SCHOOL_CD") != null ? rs.getString("SCHOOL_CD") : "";
                    } else {
                        out.println("<p class='error'>指定された学生が見つかりません。</p>");
                    }
                } catch (SQLException | ClassNotFoundException e) {
                    out.println("<p class='error'>データベース接続エラー: " + e.getMessage() + "</p>");
                } finally {
                    try { if (rs != null) rs.close(); } catch (SQLException ignored) {}
                    try { if (pstmt != null) pstmt.close(); } catch (SQLException ignored) {}
                    try { if (conn != null) conn.close(); } catch (SQLException ignored) {}
                }
            }

            String inputName = request.getParameter("name") != null ? request.getParameter("name") : name;
            String inputClassNum = request.getParameter("class_num") != null ? request.getParameter("class_num") : classNum;
        %>

        <% String error = request.getParameter("error");
           if (error != null) { %>
            <p class="error">
                <%= "invalid".equals(error) ? "入力内容が無効です。すべての項目を正しく入力してください。" :
                    "database".equals(error) ? "データベースエラーが発生しました。管理者にお問い合わせください。" :
                    "エラーが発生しました。もう一度入力してください。" %>
            </p>
        <% } %>

        <form action="StudentServlet" method="post" onsubmit="return validateForm()">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="student_number" value="<%= no %>">
            <input type="hidden" name="ent_year" value="<%= entYear %>">
            <input type="hidden" name="school_cd" id="school_cd" value="<%= schoolCd %>">

            <div class="form-group">
                <label for="ent_year">入学年度<br>
                <span class="readonly"><%= entYear %></span>
                </label>
            </div>

            <div class="form-group">
                <label for="student_number">学生番号<br>
                <span class="readonly"><%= no %></span>
                </label>
            </div>

            <div class="form-group">
                <label for="name">氏名
                <input type="text" name="name" id="name" value="<%= inputName %>" required />
                </label>
            </div>

            <div class="form-group">
                <label for="class_num">クラス
                <select name="class_num" id="class_num" required onchange="updateSchoolCd()">
                    <option value="">------</option>
                    <%
                        Connection conn = null;
                        PreparedStatement pstmt = null;
                        ResultSet rs = null;
                        try {
                            Class.forName("org.h2.Driver");
                            conn = DriverManager.getConnection(url, user, password);
                            pstmt = conn.prepareStatement("SELECT SCHOOL_CD, CLASS_NUM FROM CLASS_NUM ORDER BY CLASS_NUM");
                            rs = pstmt.executeQuery();
                            while (rs.next()) {
                                String dbSchoolCd = rs.getString("SCHOOL_CD");
                                String dbClassNum = rs.getString("CLASS_NUM");
                                String selected = (inputClassNum != null && dbClassNum != null && dbClassNum.equals(inputClassNum)) ? "selected" : "";
                    %>
                        <option value="<%= dbClassNum != null ? dbClassNum : "" %>" data-school-cd="<%= dbSchoolCd != null ? dbSchoolCd : "" %>" <%= selected %>><%= dbClassNum != null ? dbClassNum : "" %></option>
                    <%
                            }
                        } catch (SQLException | ClassNotFoundException e) {
                            out.println("<p class='error'>データベース接続エラー: " + e.getMessage() + "</p>");
                        } finally {
                            try { if (rs != null) rs.close(); } catch (SQLException ignored) {}
                            try { if (pstmt != null) pstmt.close(); } catch (SQLException ignored) {}
                            try { if (conn != null) conn.close(); } catch (SQLException ignored) {}
                        }
                    %>
                </select>
                </label>
            </div>

            <input type="submit" value="変更">
        </form>

        <a href="student_list.jsp">戻る</a>
    </div>

    <script>
        function updateSchoolCd() {
            let select = document.getElementById('class_num');
            let selectedOption = select.options[select.selectedIndex];
            let schoolCd = selectedOption ? selectedOption.getAttribute('data-school-cd') : '';
            document.getElementById('school_cd').value = schoolCd || '';
        }

        function validateForm() {
            let isValid = true;

            let name = document.getElementById('name').value.trim();
            if (!name) {
                alert('氏名を入力してください。');
                isValid = false;
            } else if (name.length > 10) {
                alert('氏名は10文字以内で入力してください。');
                isValid = false;
            }

            let classNum = document.getElementById('class_num').value;
            if (!classNum) {
                alert('クラスを選択してください。');
                isValid = false;
            }

            return isValid;
        }

        window.onload = function() {
            updateSchoolCd();
        };
    </script>

    <%@ include file="footer.jsp" %>
</body>
</html>
