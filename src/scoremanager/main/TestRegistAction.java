package scoremanager.main;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * テスト登録の基底アクション
 */
public abstract class TestRegistAction extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String actionType = request.getParameter("actionType");
        if ("execute".equals(actionType)) {
            executeRegist(request, response);
        } else {
            request.getRequestDispatcher("/test_regist.jsp").forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    /**
     * テスト登録の実行処理（サブクラスで実装）
     */
    protected abstract void executeRegist(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException;
}