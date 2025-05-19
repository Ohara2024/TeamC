<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="bean.Test" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>生徒向けテスト一覧</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        table { border-collapse: collapse; width: 80%; margin: 20px 0; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: center; }
        th { background-color: #f2f2f2; }
        input[type="submit"] { padding: 10px 20px; background-color: #4CAF50; color: white; border: none; cursor: pointer; }
        input[type="submit"]:hover { background-color: #45a049; }
    </style>
</head>
<body>
    <h1>生徒向けテスト一覧</h1>
    <% 
        List<Test> testList = null;
        try {
            testList = (List<Test>) request.getAttribute("testListStudent");
        } catch (Exception e) {
            out.println("<p style='color:red;'>エラー: テスト一覧データの取得に失敗しました。" + e.getMessage() + "</p>");
        }
    %>
    <form action="TestListStudentExecuteAction" method="post">
        <table>
            <tr>
                <th>テストID</th>
                <th>テスト名</th>
                <th>選択</th>
            </tr>
            <% 
                if (testList != null && !testList.isEmpty()) {
                    for (Test test : testList) {
                        String testName = (test.getSubject() != null) ? test.getSubject().getName() : "テスト" + test.getNo();
            %>
            <tr>
                <td><%= test.getNo() %></td>
                <td><%= testName %></td>
                <td><input type="radio" name="testId" value="<%= test.getNo() %>" required></td>
            </tr>
            <% 
                    }
                } else {
            %>
            <tr>
                <td colspan="3">利用可能なテストがありません。</td>
            </tr>
            <% 
                }
            %>
        </table>
        <br>
        <% 
            if (testList != null && !testList.isEmpty()) {
        %>
        <input type="submit" value="テストを選択">
        <% 
            }
        %>
    </form>
    <% 
        String selectedTestId = (String) request.getAttribute("selectedTestId");
        String message = (String) request.getAttribute("message");
        if (selectedTestId != null) {
            Test selectedTest = null;
            List<Test> safeTestList = (testList != null) ? testList : new ArrayList<Test>();
            for (Test test : safeTestList) {
                if (test.getNo() == Integer.parseInt(selectedTestId)) {
                    selectedTest = test;
                    break;
                }
            }
            if (selectedTest != null) {
    %>
    <div style="margin-top: 20px; border: 1px solid #ddd; padding: 10px;">
        <h3>選択したテスト</h3>
        <p>テストID: <%= selectedTest.getNo() %></p>
        <p>テスト名: <%= (selectedTest.getSubject() != null) ? selectedTest.getSubject().getName() : "テスト" + selectedTest.getNo() %></p>
        <p>メッセージ: <%= message != null ? message : "テストが選択されました。" %></p>
    </div>
    <% 
            }
        } else if (message != null) {
    %>
    <p style="color: red;"><%= message %></p>
    <% 
        }
    %>
</body>
</html>