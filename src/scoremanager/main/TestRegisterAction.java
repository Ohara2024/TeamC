package scoremanager.main;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * テスト登録の基底アクション
 */
public abstract class TestRegisterAction extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String actionType = request.getParameter("actionType");
        if ("execute".equals(actionType)) {
            executeRegister(request, response);
        } else {
            request.getRequestDispatcher("/test_register.jsp").forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    /**
     * テスト登録の実行処理（サブクラスで実装）
     */
    protected abstract void executeRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException;
}