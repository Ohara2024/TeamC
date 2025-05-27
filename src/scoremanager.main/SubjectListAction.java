package scoremanager.main;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Subject;
import dao.SubjectDao;

@WebServlet("/SubjectList.action")
public class SubjectListAction extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            SubjectDao dao = new SubjectDao();
            List<Subject> subjects = dao.findAll();
            request.setAttribute("subjects", subjects);
        } catch (Exception e) {
            request.setAttribute("error", "科目情報の取得に失敗しました。");
            e.printStackTrace();
        }
        request.getRequestDispatcher("subject_list.jsp").forward(request, response);
    }
}
