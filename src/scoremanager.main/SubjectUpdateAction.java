package scoremanager.main;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.School;
import bean.Subject;
import dao.SubjectDao;

@WebServlet("/SubjectUpdate.action")
public class SubjectUpdateAction extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String cd = request.getParameter("subjectcd");
        String name = request.getParameter("subjectName");

        // schoolCd は不要なので取得・設定しない

        request.setAttribute("subjectcd", cd);
        request.setAttribute("subjectName", name);

        request.getRequestDispatcher("/subject_update.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String cd = request.getParameter("subjectcd");
        String name = request.getParameter("subjectName");
        String schoolCd = request.getParameter("schoolCd");

        // ここでデバッグ出力！
        System.out.println("POST: subjectcd = " + cd);
        System.out.println("POST: subjectName = " + name);
        System.out.println("POST: schoolCd = " + schoolCd);

        try {
            Subject subject = new Subject();
            subject.setCd(cd);
            subject.setName(name);

            // schoolCd が null のままだと更新されません！
            if (schoolCd != null && !schoolCd.isEmpty()) {
                School school = new School();
                school.setCd(schoolCd);
                subject.setSchool(school);
            } else {
                throw new Exception("schoolCd が null または空文字です");
            }

            SubjectDao dao = new SubjectDao();
            dao.update(subject);

            response.sendRedirect("subject_update_done.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "更新中にエラーが発生しました");
            request.getRequestDispatcher("/subject_update.jsp").forward(request, response);
        }
    }

}
