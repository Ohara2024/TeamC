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
        .warning { color: #ffcc00; font-size: 14px; margin-top: 5px; display: none; }
        .form-group.has-warning { margin-bottom: 30px; }
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
            String studentNo = request.getParameter("studentNo");
            String entYear = "";
            String no = "";
            String name = "";
            String classNum = "";
            String schoolCd = "";

            if (studentNo == null || studentNo.isEmpty()) {
                out.println("<p class='error'>学生番号が指定されていません。</p>");
            } else {
                String url = "jdbc:h2:tcp://localhost/~/seiseki";
                String user = "sa";
                String password = "";
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
                        name = rs.getString("NAME");
                        classNum = rs.getString("CLASS_NUM");
                        schoolCd = rs.getString("SCHOOL_CD");
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
                <span id="name_warning" class="warning">このフィールドを入力してください。</span>
                </label>
            </div>

            <div class="form-group">
                <label for="class_num">クラス
                <select name="class_num" id="class_num" required onchange="updateSchoolCd()">
                    <option value="">------</option>
                    <%
                        String url = "jdbc:h2:tcp://localhost/~/seiseki";
                        String user = "sa";
                        String password = "";
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
                                String selected = dbClassNum.equals(inputClassNum) ? "selected" : "";
                    %>
                        <option value="<%= dbClassNum %>" data-school-cd="<%= dbSchoolCd %>" <%= selected %>><%= dbClassNum %></option>
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
                <span id="class_num_warning" class="warning">クラスを選択してください</span>
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
            document.getElementById('school_cd').value = schoolCd;
        }

        function updateFormGroupClasses() {
            let nameGroup = document.getElementById('name').parentElement;
            nameGroup.classList.toggle('has-warning', document.getElementById('name_warning').style.display === 'block');

            let classNumGroup = document.getElementById('class_num').parentElement;
            classNumGroup.classList.toggle('has-warning', document.getElementById('class_num_warning').style.display === 'block');
        }

        function validateForm() {
            let isValid = true;
            document.getElementById('name_warning').style.display = 'none';
            document.getElementById('class_num_warning').style.display = 'none';

            let name = document.getElementById('name').value.trim();
            if (!name) {
                document.getElementById('name_warning').style.display = 'block';
                isValid = false;
            } else if (name.length > 10) {
                alert('氏名は10文字以内で入力してください。');
                isValid = false;
            }

            let classNum = document.getElementById('class_num').value;
            if (!classNum) {
                document.getElementById('class_num_warning').style.display = 'block';
                isValid = false;
            }

            updateFormGroupClasses();
            return isValid;
        }

        window.onload = function() {
            updateSchoolCd();
        };

        document.getElementById('name').addEventListener('input', function() {
            document.getElementById('name_warning').style.display = this.value.trim() ? 'none' : 'block';
            updateFormGroupClasses();
        });

        document.getElementById('class_num').addEventListener('change', function() {
            document.getElementById('class_num_warning').style.display = this.value ? 'none' : 'block';
            updateFormGroupClasses();
        });
    </script>

    <%@ include file="footer.jsp" %>
</body>
</html>