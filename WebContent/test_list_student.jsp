<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>成績一覧</title>
    <style>
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #999; padding: 8px; text-align: left; }
        th { background-color: #eee; }
    </style>
</head>
<body>

<h2>成績一覧</h2>

<p>
    入学年度: <%= request.getAttribute("entYear") %> <br/>
    クラス: <%= request.getAttribute("classCode") %> <br/>
    科目: <% 
        bean.Subject subj = (bean.Subject)request.getAttribute("selectedSubject");
        if(subj != null){
            out.print(subj.getName());
        }
    %> <br/>
    テスト回数: <%= request.getAttribute("no") %> 回目
</p>

<table>
    <thead>
        <tr>
            <th>学生番号</th>
            <th>学生名</th>
            <th>クラス番号</th>
            <th>得点</th>
        </tr>
    </thead>
    <tbody>
        <%
            java.util.List<bean.Test> tests = (java.util.List<bean.Test>) request.getAttribute("tests");
            if(tests != null && !tests.isEmpty()){
                for(bean.Test test : tests){
        %>
        <tr>
            <td><%= test.getStudent().getNo() %></td>
            <td><%= test.getStudent().getName() %></td>
            <td><%= test.getClassNum() %></td>
            <td>
                <%
                    int point = test.getPoint();
                    if(point >= 0){
                        out.print(point);
                    } else {
                        out.print("未登録");
                    }
                %>
            </td>
        </tr>
        <%
                }
            } else {
        %>
        <tr>
            <td colspan="4">該当する成績がありません。</td>
        </tr>
        <%
            }
        %>
    </tbody>
</table>

<p>
    <a href="test_list.jsp">検索画面に戻る</a>
</p>

</body>
</html>
