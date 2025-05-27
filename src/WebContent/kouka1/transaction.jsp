<%@page contentType="text/html; charset=UTF-8" %>
<%@include file="../header.html" %>

<form action="UpdateResult.jsp" method="post">
お名前　　：<input type="text" name="STUDENT_NAME">
<br>
コース名　：<select id="course" name="COURSE_ID" required>
                        <option value="システム開発コース">システム開発コース</option>
                        <option value="AIシステム・データサイエンスコース">AIシステム・データサイエンスコース</option>
                    </select>
<br>
<input type="submit" value="送信">
</form>

<%@include file="../footer.html" %>