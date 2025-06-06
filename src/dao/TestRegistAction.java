package dao;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.swing.Action;

/**
 * テスト登録の基底アクション
 */
public abstract class TestRegistAction implements Action {
    public void execute(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 基底アクションでの共通処理（必要に応じて）
        String actionType = request.getParameter("actionType");
        if ("execute".equals(actionType)) {
            executeRegist(request, response);
        } else {
            // デフォルトの表示処理（例：登録フォームの表示）
            request.getRequestDispatcher("/test_regist.jsp").forward(request, response);
        }
    }

    /**
     * テスト登録の実行処理（サブクラスで実装）
     */
    protected abstract void executeRegist(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException;
}