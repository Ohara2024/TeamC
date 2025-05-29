package scoremanager.main;

import java.io.IOException;
import java.sql.SQLException;

import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Test;
import dao.TestDao;
import tool.Action;

/**
 * テスト登録の実行処理を行うアクション
 */
@WebServlet("/TestRegisterExecute.action")
public class TestRegisterExecuteAction extends TestRegisterAction {
    @Override
    protected void executeRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // リクエストからパラメータを取得
        String studentNo = request.getParameter("studentNo");
        String subjectCd = request.getParameter("subjectCd");
        String schoolCd = request.getParameter("schoolCd");
        String classNum = request.getParameter("classNum");
        String noStr = request.getParameter("no");
        String pointStr = request.getParameter("point");

        // 入力値のバリデーション
        try {
            if (studentNo == null || subjectCd == null || schoolCd == null || classNum == null ||
                noStr == null || pointStr == null) {
                request.setAttribute("error", "無効な入力です。すべての項目を入力してください。");
                request.getRequestDispatcher("/seiseki_regist.jsp").forward(request, response);
                return;
            }

            int no = Integer.parseInt(noStr);
            int point = Integer.parseInt(pointStr);

            if (no <= 0 || point < 0 || point > 100) {
                request.setAttribute("error", "無効な入力です。得点は0～100の範囲で、テスト回数は1以上で入力してください。");
                request.getRequestDispatcher("/seiseki_regist.jsp").forward(request, response);
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

            // データベースに登録
            TestDao testDao = new TestDao();
            testDao.insert(test);
            request.setAttribute("message", "テストデータが正常に登録されました。");
        } catch (NumberFormatException e) {
            request.setAttribute("error", "テスト回数または得点は数値で入力してください。");
        } catch (SQLException | NamingException e) {
            request.setAttribute("error", "登録に失敗しました: データベースエラー");
        }

        request.getRequestDispatcher("/seiseki_regist.jsp").forward(request, response);
    }
}