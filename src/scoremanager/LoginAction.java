package scoremanager;

import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Teacher;
import dao.ClassNumDao;
import dao.TeacherDao;
import tool.Action;

public class LoginAction implements Action {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String id = request.getParameter("id");
        String password = request.getParameter("password");

        TeacherDao teacherDao = new TeacherDao();
        Teacher teacher = teacherDao.login(id, password);  // 教員情報の取得（IDとパスワード）

        if (teacher != null) {
            // 教員のschool_cdを取得してクラス番号一覧を取得
            ClassNumDao classNumDao = new ClassNumDao();
            List<String> classNums = classNumDao.filter(teacher.getSchool());

            if (classNums != null && !classNums.isEmpty()) {
                teacher.setClassnum(classNums.get(0));  // 一番目のクラス番号をセット（必要に応じて変更）
            }

            // コンソールで確認用出力
            System.out.println("ログイン成功！");
            System.out.println("ID: " + teacher.getId());
            System.out.println("名前: " + teacher.getName());
            System.out.println("学校コード: " + teacher.getSchoolcd());
            System.out.println("クラス番号: " + teacher.getClassnum());

            // セッションに保存
            HttpSession session = request.getSession();
            session.setAttribute("teacher", teacher);
            session.setAttribute("name", teacher.getName());
            session.setAttribute("schoolcd", teacher.getSchoolcd());
            session.setAttribute("classnum", teacher.getClassnum());

            response.sendRedirect("menu.jsp");
        } else {
            // ログイン失敗
            request.setAttribute("error", "IDかパスワードが違います");
            RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
            rd.forward(request, response);
        }
    }
}
