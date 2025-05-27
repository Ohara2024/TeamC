package tool;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

// すべてのリクエストを受け取るフロントコントローラー

@WebServlet("/FrontController")

public class FrontController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public FrontController() {

        super();

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)

            throws ServletException, IOException {

        try {

            doProcess(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

        }

    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)

            throws ServletException, IOException {

        try {

            doProcess(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

        }

    }

    // 共通処理

    protected void doProcess(HttpServletRequest request, HttpServletResponse response) throws Exception {

    	System.out.println("FrontController: doProcess called");



        // 文字コード設定

        request.setCharacterEncoding("UTF-8");

        // パラメータからAction名取得

        String actionName = request.getParameter("action");

        System.out.println("📦 actionパラメータ = " + actionName);

        if (actionName == null || actionName.isEmpty()) {

            System.out.println("⚠️ actionが指定されていないのでlogin.jspへフォワード");

            request.getRequestDispatcher("login.jsp").forward(request, response);

            return;

        }

        try {

            // パッケージ名+Actionクラス名を組み立て

            String className = "scoremanager." + actionName + "Action";

            System.out.println("🔧 クラス名 = " + className);

            // リフレクションでActionインスタンス生成

            Class<?> clazz = Class.forName(className);

            Action action = (Action) clazz.getDeclaredConstructor().newInstance();

            // execute()呼び出し

            System.out.println("🚀 execute()実行");

            action.execute(request, response);

        } catch (Exception e) {

            System.out.println("❌ 例外発生: " + e.getMessage());

            e.printStackTrace(); // 詳細出力

            throw e;

        }

    }

    }

