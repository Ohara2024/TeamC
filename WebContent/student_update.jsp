<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
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
        String error = null;
        Map<String, Object> student = null;
        List<Map<String, String>> classNumbers = new ArrayList<>();
        String studentNo = request.getParameter("studentNo");

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

                // 学生情報取得
                if (studentNo != null && !studentNo.isEmpty()) {
                    pstmt = conn.prepareStatement("SELECT NO, ENT_YEAR, NAME, CLASS_NUM, SCHOOL_CD FROM STUDENT WHERE NO = ?");
                    pstmt.setString(1, studentNo);
                    rs = pstmt.executeQuery();
                    if (rs.next()) {
                        student = new HashMap<>();
                        student.put("NO", rs.getString("NO"));
                        student.put("ENT_YEAR", rs.getInt("ENT_YEAR"));
                        student.put("NAME", rs.getString("NAME"));
                        student.put("CLASS_NUM", rs.getString("CLASS_NUM"));
                        student.put("SCHOOL_CD", rs.getString("SCHOOL_CD"));
                    } else {
                        error = "指定された学生が見つかりません。";
                    }
                    rs.close();
                    pstmt.close();
                } else {
                    error = "学生番号が指定されていません。";
                }

                // クラス一覧取得
                pstmt = conn.prepareStatement("SELECT CLASS_NUM, SCHOOL_CD FROM CLASS_NUM ORDER BY CLASS_NUM");
                rs = pstmt.executeQuery();
                while (rs.next()) {
                    Map<String, String> classNum = new HashMap<>();
                    classNum.put("CLASS_NUM", rs.getString("CLASS_NUM"));
                    classNum.put("SCHOOL_CD", rs.getString("SCHOOL_CD"));
                    classNumbers.add(classNum);
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
                error = "データ取得エラー: " + e.getMessage();
                break;
            } catch (Exception e) {
                e.printStackTrace();
                error = "データ取得エラー: " + e.getMessage();
                break;
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
                if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
            }
        }
        if (!connected) {
            error = "データ取得に失敗しました。データベース接続を確認してください。";
        }
        %>

        <% if (error != null) { %>
            <p class="error"><%= error %></p>
        <% } %>

        <% if (student == null) { %>
            <p class="error">指定された学生が見つかりません。</p>
        <% } else { %>
            <form action="StudentUpdateExecuteAction" method="post" onsubmit="return validateForm()">
                <input type="hidden" name="student_number" value="<%= student.get("NO") %>">
                <input type="hidden" name="ent_year" value="<%= student.get("ENT_YEAR") %>">
                <input type="hidden" name="school_cd" id="school_cd" value="<%= student.get("SCHOOL_CD") != null ? student.get("SCHOOL_CD") : "" %>">

                <div class="form-group">
                    <label for="ent_year">入学年度<br>
                    <span class="readonly"><%= student.get("ENT_YEAR") %></span>
                    </label>
                </div>

                <div class="form-group">
                    <label for="student_number">学生番号<br>
                    <span class="readonly"><%= student.get("NO") %></span>
                    </label>
                </div>

                <div class="form-group">
                    <label for="name">氏名
                    <input type="text" name="name" id="name" value="<%= student.get("NAME") != null ? student.get("NAME") : "" %>" required />
                    </label>
                </div>

                <div class="form-group">
                    <label for="class_num">クラス
                    <select name="class_num" id="class_num" required onchange="updateSchoolCd()">
                        <option value="">------</option>
                        <%
                        String inputClassNum = request.getParameter("class_num") != null ? request.getParameter("class_num") : (String)student.get("CLASS_NUM");
                        for (Map<String, String> classNum : classNumbers) {
                            String selected = (inputClassNum != null && classNum.get("CLASS_NUM") != null && classNum.get("CLASS_NUM").equals(inputClassNum)) ? "selected" : "";
                        %>
                            <option value="<%= classNum.get("CLASS_NUM") != null ? classNum.get("CLASS_NUM") : "" %>" data-school-cd="<%= classNum.get("SCHOOL_CD") != null ? classNum.get("SCHOOL_CD") : "" %>" <%= selected %>><%= classNum.get("CLASS_NUM") != null ? classNum.get("CLASS_NUM") : "" %></option>
                        <% } %>
                    </select>
                    </label>
                </div>

                <input type="submit" value="変更">
            </form>
        <% } %>

        <a href="StudentListAction">戻る</a>
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