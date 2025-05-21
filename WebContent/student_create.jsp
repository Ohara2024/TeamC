```jsp
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>得点管理システム</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; }
        .content { margin-left: 200px; padding: 20px; min-height: calc(100vh - 40px); margin-top: 50px; padding-top: 20px; width: calc(100% - 200px); box-sizing: border-box; }
        h1 { color: #000000; margin-top: 0; font-size: 30px; background-color: #f0f0f0; padding: 10px; }
        .form-group { margin-top: 10px; padding: 8px; border-radius: 4px; margin-bottom: 15px; }
        label { display: inline-block; width: 120px; font-weight: bold; vertical-align: top; }
        input[type="text"], select { width: 100%; max-width: 100%; padding: 5px; border: 1px solid #ccc; border-radius: 3px; font-size: 14px; display: block; margin-top: 5px; }
        input[type="submit"] { background-color: #4C4C4C; color: white; padding: 8px 20px; border: none; border-radius: 3px; cursor: pointer; font-size: 14px; }
        input[type="submit"]:hover { background-color: #323232; }
        a { color: #007bff; text-decoration: none; font-size: 14px; }
        a:hover { text-decoration: underline; }
        .warning { color: #ffcc00; font-size: 14px; margin-top: 5px; display: none; }
        .form-group.has-warning { margin-bottom: 30px; }
        .error { color: red; font-size: 14px; }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>
    <%@ include file="sidebar.jsp" %>

    <div class="content">
        <br><br>
        <h1>学生情報登録</h1>

        <% String error = request.getParameter("error"); %>
        <% if (error != null) { %>
            <p class="error">
                <%= "invalid".equals(error) ? "入力内容が無効です。すべての項目を正しく入力してください。" :
                    "duplicate".equals(error) ? "学生番号が重複しています。" :
                    "database".equals(error) ? "データベースエラーが発生しました。管理者にお問い合わせください。" :
                    "エラーが発生しました。もう一度入力してください。" %>
            </p>
        <% } %>

        <form action="StudentCreateExecuteAction" method="POST" onsubmit="return validateForm()">
            <input type="hidden" name="action" value="create_done">

            <div class="form-group">
                <label for="entrance_year">入学年度</label>
                <select name="entrance_year" id="entrance_year" required>
                    <option value="">------</option>
                    <% int currentYear = java.time.Year.now().getValue();
                       String selectedYear = request.getParameter("entrance_year") != null ? request.getParameter("entrance_year") : "";
                       for (int year = currentYear; year >= 2000; year--) { %>
                        <option value="<%= year %>" <%= year == Integer.parseInt(selectedYear != "" ? selectedYear : "0") ? "selected" : "" %>><%= year %></option>
                    <% } %>
                </select>
                <span id="entrance_year_warning" class="warning">入学年度を選択してください</span>
            </div>

            <div class="form-group">
                <label for="student_number">学生番号</label>
                <input type="text" name="student_number" id="student_number" required placeholder="学生番号を入力してください" value="<%= request.getParameter("student_number") != null ? request.getParameter("student_number") : "" %>" />
                <span id="student_number_warning" class="warning">このフィールドを入力してください。</span>
                <span id="student_number_duplicate" class="warning">学生番号が重複しています</span>
            </div>

            <div class="form-group">
                <label for="student_name">氏名</label>
                <input type="text" name="student_name" id="student_name" required placeholder="氏名を入力してください" value="<%= request.getParameter("student_name") != null ? request.getParameter("student_name") : "" %>" />
                <span id="student_name_warning" class="warning">このフィールドを入力してください。</span>
            </div>

            <div class="form-group">
                <label for="class_num">クラス</label>
                <select name="class_num" id="class_num" required onchange="updateSchoolCd()">
                    <option value="">------</option>
                    <% List<String> classNumbers = (List<String>) request.getAttribute("classNumbers");
                       String selectedClass = request.getParameter("class_num") != null ? request.getParameter("class_num") : "";
                       if (classNumbers != null) {
                           for (String classNum : classNumbers) { %>
                               <option value="<%= classNum %>" <%= classNum.equals(selectedClass) ? "selected" : "" %>><%= classNum %></option>
                    <%   }
                       } %>
                </select>
                <input type="hidden" name="school_cd" id="school_cd" value="<%= request.getParameter("school_cd") != null ? request.getParameter("school_cd") : "" %>">
                <span id="class_num_warning" class="warning">クラスを選択してください</span>
            </div>

            <div class="form-group">
                <input type="submit" class="action-btn" value="登録して終了">
            </div>
        </form>

        <a href="StudentListAction">戻る</a>
    </div>

    <script>
        function updateSchoolCd() {
            // クライアント側でのschool_cd更新は簡略化（サーバー側で処理）
            let select = document.getElementById('class_num');
            document.getElementById('school_cd').value = select.value; // 仮の値
        }

        function updateFormGroupClasses() {
            let entranceYearGroup = document.getElementById('entrance_year').parentElement;
            entranceYearGroup.classList.toggle('has-warning', document.getElementById('entrance_year_warning').style.display === 'block');

            let studentNumberGroup = document.getElementById('student_number').parentElement;
            studentNumberGroup.classList.toggle('has-warning',
                document.getElementById('student_number_warning').style.display === 'block' ||
                document.getElementById('student_number_duplicate').style.display === 'block');

            let studentNameGroup = document.getElementById('student_name').parentElement;
            studentNameGroup.classList.toggle('has-warning', document.getElementById('student_name_warning').style.display === 'block');

            let classNumGroup = document.getElementById('class_num').parentElement;
            classNumGroup.classList.toggle('has-warning', document.getElementById('class_num_warning').style.display === 'block');
        }

        function validateForm() {
            let isValid = true;
            document.getElementById('entrance_year_warning').style.display = 'none';
            document.getElementById('student_number_warning').style.display = 'none';
            document.getElementById('student_number_duplicate').style.display = 'none';
            document.getElementById('student_name_warning').style.display = 'none';
            document.getElementById('class_num_warning').style.display = 'none';

            let entranceYear = document.getElementById('entrance_year').value;
            if (!entranceYear) {
                document.getElementById('entrance_year_warning').style.display = 'block';
                isValid = false;
            }

            let studentNumber = document.getElementById('student_number').value.trim();
            if (!studentNumber) {
                document.getElementById('student_number_warning').style.display = 'block';
                isValid = false;
            } else if (studentNumber.length > 10) {
                alert('学生番号は10文字以内で入力してください。');
                isValid = false;
            }

            let studentName = document.getElementById('student_name').value.trim();
            if (!studentName) {
                document.getElementById('student_name_warning').style.display = 'block';
                isValid = false;
            } else if (studentName.length > 10) {
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
            <% if ("duplicate".equals(request.getParameter("error"))) { %>
                document.getElementById('student_number_duplicate').style.display = 'block';
                updateFormGroupClasses();
            <% } %>
        };

        document.getElementById('entrance_year').addEventListener('change', function() {
            document.getElementById('entrance_year_warning').style.display = this.value ? 'none' : 'block';
            updateFormGroupClasses();
        });

        document.getElementById('student_number').addEventListener('input', function() {
            document.getElementById('student_number_warning').style.display = this.value.trim() ? 'none' : 'block';
            updateFormGroupClasses();
        });

        document.getElementById('student_name').addEventListener('input', function() {
            document.getElementById('student_name_warning').style.display = this.value.trim() ? 'none' : 'block';
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
```