package scoremanager;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Teacher;
import dao.TeacherDao;
import tool.Action;

public class LoginAction implements Action {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String id = request.getParameter("id");
        String password = request.getParameter("password");

        TeacherDao dao = new TeacherDao();
        Teacher teacher = dao.login(id, password);

        if (teacher != null) {
            teacher.setAuthenticated(true);
            request.getSession().setAttribute("teacher", teacher);
            // ログイン成功ならメニューへ
            RequestDispatcher rd = request.getRequestDispatcher("gakusei/menu.jsp");
            rd.forward(request, response);
        } else {
            // ログイン失敗ならログイン画面にエラーメッセージ
            request.setAttribute("error", "IDかパスワードが違います");
            RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
            rd.forward(request, response);
        }
    }
}
