package scoremanager;


import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Teacher;
import dao.TeacherDao;
import tool.Action;

public class LoginExecuteAction implements Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
        String id = req.getParameter("id");
        String password = req.getParameter("password");

        TeacherDao dao = new TeacherDao();
        Teacher teacher = dao.login(id, password);

        if (teacher != null) {
            teacher.setAuthenticated(true);
            req.getSession().setAttribute("teacher", teacher);

            // 認証成功 → menu.jspへフォワード
            RequestDispatcher rd = req.getRequestDispatcher("menu.jsp");
            rd.forward(req, res);
        } else {
            req.setAttribute("error", "IDまたはパスワードが間違っています");
            RequestDispatcher dispatcher = req.getRequestDispatcher("/gakusei/login.jsp");
            dispatcher.forward(req, res);
        }


            // 認証失敗 → login.jspへフォワード
         // ログイン失敗時

        }
    }


