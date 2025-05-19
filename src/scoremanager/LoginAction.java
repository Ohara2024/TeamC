package scoremanager;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Teacher;
import dao.TeacherDao;
import tool.Action;

public class LoginAction implements Action {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String id = request.getParameter("id");
        String password = request.getParameter("password");

        TeacherDao dao = new TeacherDao();
        Teacher teacher = dao.login(id, password);  // メソッド名修正（findByLogin → login）

        if (teacher != null) {
            HttpSession session = request.getSession();
            session.setAttribute("name", teacher.getName());  // 名前をセッションに保存
            session.setAttribute("teacher", teacher);         // オブジェクトも保存（任意）

            response.sendRedirect("gakusei/menu.jsp");
        } else {
            // ログイン失敗ならエラーを設定してログイン画面にフォワード
            request.setAttribute("error", "IDかパスワードが違います");
            RequestDispatcher rd = request.getRequestDispatcher("/gakusei/login.jsp");
            rd.forward(request, response);
        }
    }
}
