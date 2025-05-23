package scoremanager.main;

import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Subject;
import bean.Test;
import tool.Action;

public class TestListSubjectExecuteAction extends Action {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // パラメータ取得
        String entYearStr = request.getParameter("entYear");
        String classCode = request.getParameter("classCode");
        String subjectCode = request.getParameter("subjectCode");

        // バリデーション
        if (entYearStr == null || classCode == null || subjectCode == null ||
                entYearStr.isEmpty() || classCode.isEmpty() || subjectCode.isEmpty()) {
            request.setAttribute("message", "入学年度とクラスと科目を選択してください。");
            RequestDispatcher dispatcher = request.getRequestDispatcher("test_list.jsp");
            dispatcher.forward(request, response);
            return;
        }

        try {
            int entYear = Integer.parseInt(entYearStr);

            // 成績データ取得
            TestDAO testDao = new TestDAO();
            List<Test> tests = testDao.getTestsByConditions(entYear, classCode, subjectCode);

            // 表示用データ取得
            ClassNumDAO classDao = new ClassNumDAO();
            SubjectDAO subjectDao = new SubjectDAO();
            Class selectedClass = classDao.getClassByCode(classCode);
            Subject selectedSubject = subjectDao.getSubjectByCode(subjectCode);

            // リクエストにセット
            request.setAttribute("tests", tests);
            request.setAttribute("entYear", entYear);
            request.setAttribute("classCode", classCode);
            request.setAttribute("subjectCode", subjectCode);
            request.setAttribute("selectedClass", selectedClass);
            request.setAttribute("selectedSubject", selectedSubject);

            // フォワード
            RequestDispatcher dispatcher = request.getRequestDispatcher("test_list_student.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
