package dao;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Test;

/**
 * テスト登録の実行処理を行うアクション
 */
public class TestRegisterExecuteAction implements tool.Action {
    public void execute(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // リクエストからパラメータを取得
        String studentNo = request.getParameter("studentNo");
        String subjectCd = request.getParameter("subjectCd");
        String schoolCd = request.getParameter("schoolCd");
        String classNum = request.getParameter("classNum");
        int no = Integer.parseInt(request.getParameter("no"));
        int point = Integer.parseInt(request.getParameter("point"));

        // 入力値のバリデーション
        if (studentNo == null || subjectCd == null || schoolCd == null || classNum == null ||
            no <= 0 || point < 0 || point > 100) {
            request.setAttribute("error", "無効な入力です。得点は0～100の範囲で入力してください。");
            request.getRequestDispatcher("/test_register.jsp").forward(request, response);
            return;
        }

        // Testオブジェクトを作成
        Test test = new Test();
        test.setStudentNo(studentNo);
        test.setSubjectCd(subjectCd);
        test.setSchoolCd(schoolCd);
        test.setNo(no);
        test.setPoint(point);
        test.setClassNum(classNum);

        try {
            // データベースに登録
            TestDao testDao = new TestDao();
            testDao.insert(test);
            request.setAttribute("message", "テストデータが正常に登録されました。");
            request.getRequestDispatcher("/test_register.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "登録に失敗しました: " + e.getMessage());
            request.getRequestDispatcher("/test_register.jsp").forward(request, response);
        }
    }
}