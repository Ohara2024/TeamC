<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="menu.jsp" %>
<%@ include file="../header.html" %>

<p>追加する学生の情報を入力してください。</p>
<form action="/kouka1/Insert" method="post">
    <div>
        <label for="STUDENT_ID">学生番号:</label>
        <input type="text" id="STUDENT_ID" name="STUDENT_ID" required>
    </div>
    <div>
        <label for="STUDENT_NAME">学生名:</label>
        <input type="text" id="STUDENT_NAME" name="STUDENT_NAME" required>
    </div>
    <div>
        <label for="COURSE_ID">コース名:</label>
        <select id="COURSE_ID" name="COURSE_ID" required>
            <option value="1">システム開発コース</option>
            <option value="2">AIシステム・データサイエンスコース</option>
        </select>
    </div>
    <input type="submit" value="送信">
</form>

<%@ include file="../footer.html" %>
