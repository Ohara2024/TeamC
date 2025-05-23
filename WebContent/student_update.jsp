<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="seiseki.StudentListAction.Student, seiseki.StudentUpdateAction.ClassNum, java.util.List" %>
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

        <% String error = (String) request.getAttribute("error"); %>
        <% if (error != null) { %>
            <p class="error"><%= error %></p>
        <% } %>

        <% Student student = (Student) request.getAttribute("student"); %>
        <% if (student == null) { %>
            <p class="error">指定された学生が見つかりません。</p>
        <% } else { %>
            <form action="StudentUpdateExecuteAction" method="post" onsubmit="return validateForm()">
                <input type="hidden" name="student_number" value="<%= student.getNo() %>">
                <input type="hidden" name="ent_year" value="<%= student.getEntYear() %>">
                <input type="hidden" name="school_cd" id="school_cd" value="<%= student.getSchoolCd() != null ? student.getSchoolCd() : "" %>">

                <div class="form-group">
                    <label for="ent_year">入学年度<br>
                    <span class="readonly"><%= student.getEntYear() %></span>
                    </label>
                </div>

                <div class="form-group">
                    <label for="student_number">学生番号<br>
                    <span class="readonly"><%= student.getNo() %></span>
                    </label>
                </div>

                <div class="form-group">
                    <label for="name">氏名
                    <input type="text" name="name" id="name" value="<%= student.getName() != null ? student.getName() : "" %>" required />
                    </label>
                </div>

                <div class="form-group">
                    <label for="class_num">クラス
                    <select name="class_num" id="class_num" required onchange="updateSchoolCd()">
                        <option value="">------</option>
                        <% List<ClassNum> classNumbers = (List<ClassNum>) request.getAttribute("classNumbers");
                           String inputClassNum = request.getParameter("class_num") != null ? request.getParameter("class_num") : student.getClassNum();
                           if (classNumbers != null) {
                               for (ClassNum classNum : classNumbers) {
                                   String selected = (inputClassNum != null && classNum.getClassNum() != null && classNum.getClassNum().equals(inputClassNum)) ? "selected" : "";
                        %>
                            <option value="<%= classNum.getClassNum() != null ? classNum.getClassNum() : "" %>" data-school-cd="<%= classNum.getSchoolCd() != null ? classNum.getSchoolCd() : "" %>" <%= selected %>><%= classNum.getClassNum() != null ? classNum.getClassNum() : "" %></option>
                        <%   }
                           } %>
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