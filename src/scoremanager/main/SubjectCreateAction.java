package scoremanager.main;

import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.School;
import bean.Subject;
import bean.Teacher;
import dao.SubjectDao;

@WebServlet("/SubjectCreate.action")
public class SubjectCreateAction extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(SubjectCreateAction.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String subjectCd = request.getParameter("subjectcd");
        String subjectName = request.getParameter("subjectName");

        // 入力バリデーション
        if (subjectCd == null || subjectCd.trim().isEmpty() || subjectName == null || subjectName.trim().isEmpty()) {
            request.setAttribute("error", "科目コードと科目名は必須です");
            request.setAttribute("subjectCd", subjectCd);
            request.setAttribute("subjectName", subjectName);
            request.getRequestDispatcher("/subject_create.jsp").forward(request, response);
            return;
        }

        if (!subjectCd.matches("[a-zA-Z0-9]{3}")) {
            request.setAttribute("error", "科目コードは英数字3文字で入力してください");
            request.setAttribute("subjectCd", subjectCd);
            request.setAttribute("subjectName", subjectName);
            request.getRequestDispatcher("/subject_create.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession();
        Teacher teacher = (Teacher) session.getAttribute("teacher");

        if (teacher == null) {
            LOGGER.warning("Teacher not found in session");
            response.sendRedirect("login.jsp?error=session_expired");
            return;
        }

        if (teacher.getSchool() == null) {
            LOGGER.warning("School not found in Teacher object");
            request.setAttribute("error", "学校情報が見つかりません。ログインし直してください");
            request.setAttribute("subjectCd", subjectCd);
            request.setAttribute("subjectName", subjectName);
            request.getRequestDispatcher("/subject_create.jsp").forward(request, response);
            return;
        }

        String schoolCd = teacher.getSchool().getCd();
        LOGGER.info("Registering subject: cd=" + subjectCd + ", name=" + subjectName + ", schoolCd=" + schoolCd);

        try {
            Subject subject = new Subject();
            subject.setCd(subjectCd.trim());
            subject.setName(subjectName.trim());

            School school = new School();
            school.setCd(schoolCd);
            subject.setSchool(school);

            SubjectDao dao = new SubjectDao();
            dao.insert(subject);

            response.sendRedirect("subject_create_done.jsp");

        } catch (SQLException e) {
            String errorMsg = "科目の登録中にエラーが発生しました";
            if (e.getSQLState().equals("23505")) { // H2の一意制約違反
                errorMsg = "この科目コードはすでに登録されています";
            }
            LOGGER.severe("SQLException: SQLState=" + e.getSQLState() + ", ErrorCode=" + e.getErrorCode() + ", Message=" + e.getMessage());
            request.setAttribute("error", errorMsg);
            request.setAttribute("subjectCd", subjectCd);
            request.setAttribute("subjectName", subjectName);
            request.getRequestDispatcher("/subject_create.jsp").forward(request, response);
        }
    }
}