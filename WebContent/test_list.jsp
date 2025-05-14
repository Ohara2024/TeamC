<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, bean.ScoreBean" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>成績検索フォーム</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 20px 20px 0;
        }
        .search-section {
            background-color: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .form-group {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
        }
        .form-group label {
            width: 100px;
            font-weight: bold;
            margin-right: 10px;
        }
        .form-group input[type="text"] {
            flex: 1;
            padding: 5px;
            border: 1px solid #ced4da;
            border-radius: 4px;
        }
        .form-group button {
            padding: 5px 15px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-left: 10px;
        }
        .form-group button:hover {
            background-color: #0056b3;
        }
        .result-section {
            margin-top: 10px;
            display: none;
        }
        .result-section.active {
            display: block;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        th, td {
            border: 1px solid #dee2e6;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f8f9fa;
        }
        .error-message {
            color: red;
            margin: 5px 0;
        }
    </style>
</head>
<body>
    <div class="search-section">
        <!-- クラス単位の成績検索 -->
        <div class="form-group">
            <label>入学年度:</label>
            <input type="text" name="entYear" placeholder="例: 2022">
            <label>クラス番号:</label>
            <input type="text" name="classNum" placeholder="例: 201">
            <label>科目名:</label>
            <input type="text" name="subject" placeholder="例: 数学">
            <button type="submit" formaction="ScoreSearchServlet" formmethod="get" onclick="showResult('classResult')">検索</button>
        </div>
        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
            <p class="error-message"><%= error %></p>
        <%
            }
            List<ScoreBean> classScoreList = (List<ScoreBean>) request.getAttribute("classScoreList");
            if (classScoreList != null) {
        %>
            <div id="classResult" class="result-section active">
                <h3>クラス別成績一覧</h3>
                <table>
                    <tr>
                        <th>学生番号</th>
                        <th>学生名</th>
                        <th>得点</th>
                    </tr>
                    <%
                        try {
                            if (classScoreList != null && !classScoreList.isEmpty()) {
                                for (ScoreBean score : classScoreList) {
                                    if (score != null) {
                    %>
                    <tr>
                        <td><%= score.getNo() != null ? score.getNo() : "N/A" %></td>
                        <td><%= score.getName() != null ? score.getName() : "N/A" %></td>
                        <td><%= score.getScore() %></td>
                    </tr>
                    <%
                                    }
                                }
                            } else {
                    %>
                    <tr>
                        <td colspan="3">該当する成績データが見つかりませんでした。</td>
                    </tr>
                    <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                    %>
                    <tr>
                        <td colspan="3" class="error-message">エラーが発生しました: <%= e.getMessage() %></td>
                    </tr>
                    <%
                        }
                    %>
                </table>
            </div>
        <%
            }
        %>

        <!-- 学生単位の成績検索 -->
        <div class="form-group">
            <label>学生番号:</label>
            <input type="text" name="studentNo" placeholder="例: 2225001">
            <button type="submit" formaction="ScoreSearchByStudentServlet" formmethod="post" onclick="showResult('studentResult')">検索</button>
        </div>
        <%
            String studentError = (String) request.getAttribute("studentError");
            if (studentError != null) {
        %>
            <p class="error-message"><%= studentError %></p>
        <%
            }
            List<ScoreBean> studentScoreList = (List<ScoreBean>) request.getAttribute("studentScoreList");
            String studentNo = (String) request.getAttribute("studentNo");
            if (studentScoreList != null) {
        %>
            <div id="studentResult" class="result-section active">
                <h3>学生別成績一覧</h3>
                <% if (studentNo != null) { %>
                    <p>学生番号: <%= studentNo %></p>
                <% } %>
                <table>
                    <tr>
                        <th>学生番号</th>
                        <th>学生名</th>
                        <th>科目名</th>
                        <th>試験番号</th>
                        <th>得点</th>
                    </tr>
                    <%
                        try {
                            if (studentScoreList != null && !studentScoreList.isEmpty()) {
                                for (ScoreBean score : studentScoreList) {
                                    if (score != null) {
                    %>
                    <tr>
                        <td><%= score.getNo() != null ? score.getNo() : "N/A" %></td>
                        <td><%= score.getName() != null ? score.getName() : "N/A" %></td>
                        <td><%= score.getSubjectName() != null ? score.getSubjectName() : "N/A" %></td>
                        <td><%= score.getTestNo() %></td>
                        <td><%= score.getScore() %></td>
                    </tr>
                    <%
                                    }
                                }
                            } else if (studentNo != null) {
                    %>
                    <tr>
                        <td colspan="5">該当する成績データが見つかりませんでした。</td>
                    </tr>
                    <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                    %>
                    <tr>
                        <td colspan="5" class="error-message">エラーが発生しました: <%= e.getMessage() %></td>
                    </tr>
                    <%
                        }
                    %>
                </table>
            </div>
        <%
            }
        %>
    </div>

    <script>
        function showResult(id) {
            document.querySelectorAll('.result-section').forEach(section => {
                section.classList.remove('active');
            });
            document.getElementById(id).classList.add('active');
        }
    </script>
</body>
</html>