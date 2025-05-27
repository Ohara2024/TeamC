<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="menu.jsp" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>学生追加フォーム</title>
</head>
<body>
    <form action="StudentAddResult.jsp" method="POST">
    <p>追加する学生の情報を入力してください</p>
        <table>
            <tr>
                <td><label for="student_id">学生番号:</label></td>
                <td><input type="text" id="student_id" name="student_id" required></td>
            </tr>
            <tr>
                <td><label for="name">学生名:</label></td>
                <td><input type="text" id="name" name="name" required></td>
            </tr>
            <tr>
                <td><label for="course">コース名:</label></td>
                <td>
                    <select id="course" name="course" required>
                        <option value="システム開発コース">システム開発コース</option>
                        <option value="AIシステム・データサイエンスコース">AIシステム・データサイエンスコース</option>
                    </select>
                </td>
            </tr>
        </table>
        <button type="submit">追加</button>
    </form>
</body>
</html>
