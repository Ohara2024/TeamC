package scoremanager.main;

import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Subject;
import bean.Test;
import dao.ClassNumDao;
import dao.SubjectDao;
import dao.TestDao;
import tool.Action;

public class TestListSubjectExecuteAction implements Action {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        String entYearStr = request.getParameter("entYear");
        String classCode = request.getParameter("classCode");
        String subjectCode = request.getParameter("subjectCode");

        if (entYearStr == null || entYearStr.isEmpty() ||
            classCode == null || classCode.isEmpty() ||
            subjectCode == null || subjectCode.isEmpty()) {
            request.setAttribute("message", "入学年度とクラスと科目を選択してください。");
            RequestDispatcher dispatcher = request.getRequestDispatcher("test_list.jsp");
            dispatcher.forward(request, response);
            return;
        }

        int entYear = Integer.parseInt(entYearStr);

        TestDao testDao = new TestDao();
        ClassNumDao classDao = new ClassNumDao();
        SubjectDao subjectDao = new SubjectDao();

        List<Test> tests = testDao.getTestsByConditions(entYear, classCode, subjectCode);
        bean.Class selectedClass = classDao.getClassByCode(classCode);
        Subject selectedSubject = subjectDao.getSubjectByCode(subjectCode);

        request.setAttribute("tests", tests);
        request.setAttribute("entYear", entYear);
        request.setAttribute("classCode", classCode);
        request.setAttribute("subjectCode", subjectCode);
        request.setAttribute("selectedClass", selectedClass);
        request.setAttribute("selectedSubject", selectedSubject);

        RequestDispatcher dispatcher = request.getRequestDispatcher("test_list_student.jsp");
        dispatcher.forward(request, response);
    }
}
