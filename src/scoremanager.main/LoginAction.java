package scoremanager.main;

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

        Teacher teacher = dao.login(id, password);

        if (teacher != null) {

            HttpSession session = request.getSession();

            session.setAttribute("name", teacher.getName());

            session.setAttribute("teacher", teacher);

            if (teacher.getSchool() != null) {

                String schoolCd = teacher.getSchool().getCd();

                session.setAttribute("schoolCd", schoolCd);

                // 確認用ログ出力

                System.out.println("ログイン成功！学校コード: " + schoolCd);

            } else {

                System.out.println("学校情報がありません");

            }

            response.sendRedirect("menu.jsp");

        } else {

            request.setAttribute("error", "IDかパスワードが違います");

            RequestDispatcher rd = request.getRequestDispatcher("/gakusei/login.jsp");

            rd.forward(request, response);

        }

    }

}

