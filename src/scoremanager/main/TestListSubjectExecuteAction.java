package scoremanager.main;

import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.School;
import bean.Subject;
import bean.Test;
import dao.ClassNumDao;
import dao.SubjectDao;
import dao.TestDao;
import tool.Action;

public class TestListSubjectExecuteAction implements Action {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // パラメータ取得
        String entYearStr = request.getParameter("entYear");
        String classCode = request.getParameter("classCode");
        String subjectCode = request.getParameter("subjectCode");
        String noStr = request.getParameter("no"); // テスト回数（番号）

        // バリデーション
        if (entYearStr == null || entYearStr.isEmpty() ||
            classCode == null || classCode.isEmpty() ||
            subjectCode == null || subjectCode.isEmpty()) {
            
            request.setAttribute("message", "入学年度とクラスと科目は必須です。");
            RequestDispatcher dispatcher = request.getRequestDispatcher("test_list.jsp");
            dispatcher.forward(request, response);
            return;
        }

        int no = 1; // デフォルト回数を1に設定
        if (noStr != null && !noStr.isEmpty()) {
            try {
                no = Integer.parseInt(noStr);
            } catch (NumberFormatException e) {
                request.setAttribute("message", "回数は数値で指定してください。");
                RequestDispatcher dispatcher = request.getRequestDispatcher("test_list.jsp");
                dispatcher.forward(request, response);
                return;
            }
        }

        try {
            int entYear = Integer.parseInt(entYearStr);

            // Daoのインスタンス生成
            TestDao testDao = new TestDao();
            ClassNumDao classDao = new ClassNumDao();
            SubjectDao subjectDao = new SubjectDao();

            // schoolCdをclassCodeから取得
            String schoolCd = classDao.getSchoolCodeByClassCode(classCode);
            if (schoolCd == null) {
                request.setAttribute("message", "該当する学校コードが見つかりません。");
                RequestDispatcher dispatcher = request.getRequestDispatcher("test_list.jsp");
                dispatcher.forward(request, response);
                return;
            }

            // Subjectオブジェクト取得
            Subject selectedSubject = subjectDao.getSubjectById(subjectCode, schoolCd);
            if (selectedSubject == null) {
                request.setAttribute("message", "該当する科目が見つかりません。");
                RequestDispatcher dispatcher = request.getRequestDispatcher("test_list.jsp");
                dispatcher.forward(request, response);
                return;
            }

            // Schoolオブジェクト作成
            School school = new School();
            school.setCd(schoolCd);

            // 成績データ取得（filterメソッドを利用）
            List<Test> tests = testDao.filter(entYear, classCode, selectedSubject, no, school);

            // クラス情報取得
            bean.ClassNum selectedClass = classDao.getClassByCode(classCode);


            // リクエスト属性にセット
            request.setAttribute("tests", tests);
            request.setAttribute("entYear", entYear);
            request.setAttribute("classCode", classCode);
            request.setAttribute("subjectCode", subjectCode);
            request.setAttribute("no", no);
            request.setAttribute("selectedClass", selectedClass);
            request.setAttribute("selectedSubject", selectedSubject);

            // フォワード先
            RequestDispatcher dispatcher = request.getRequestDispatcher("test_list_student.jsp");
            dispatcher.forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("message", "入学年度は数値で入力してください。");
            RequestDispatcher dispatcher = request.getRequestDispatcher("test_list.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
