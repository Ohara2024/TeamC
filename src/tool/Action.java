package tool;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import scoremanager.main.TestRegisterAction;
import scoremanager.main.TestRegisterExecuteAction;

public class Action {
    private static final Map<String, Action> actions = new HashMap<>();

    static {
        // actionパッケージのアクション
        actions.put("studentList", new Action());
        // scoremanager.mainパッケージのアクション
        actions("testRegister", new TestRegisterAction() {
            @Override
            protected void executeRegister(HttpServletRequest request, HttpServletResponse response)
                    throws ServletException, IOException {
                // TestRegisterActionのデフォルト実装（必要に応じてカスタマイズ）
                new TestRegisterExecuteAction().execute(request, response);
            }
        });
        actions("testRegisterExecute", new TestRegisterExecuteAction());
    }

    public static Action getAction(String actionName) {
        return actions.get(actionName);
    }

	private static void actions(String string, Object testRegisterExecuteAction) {
		// TODO 自動生成されたメソッド・スタブ

	}
}