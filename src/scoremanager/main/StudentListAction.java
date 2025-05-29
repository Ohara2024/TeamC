package scoremanager.main;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Student;
import dao.StudentDao;

@WebServlet("/StudentListAction")
public class StudentListAction extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(StudentListAction.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String entYearParam = request.getParameter("entYear");
        String classNumParam = request.getParameter("classNum");
        String isAttendParam = request.getParameter("isAttend");

        // セッションからschoolCdを取得
        HttpSession session = request.getSession();
        String schoolCd = (String) session.getAttribute("schoolCd");

        LOGGER.info("セッションから取得したschoolCd: " + schoolCd);
        LOGGER.info("リクエストパラメータ: entYear=" + entYearParam + ", classNum=" + classNumParam + ", isAttend=" + isAttendParam);

        // schoolCdがnullの場合のフォールバック
        if (schoolCd == null || schoolCd.isEmpty()) {
            LOGGER.warning("schoolCdがnullまたは空です。デフォルト値 'oom' を使用");
            schoolCd = "oom";
            session.setAttribute("schoolCd", schoolCd);
        }

        // schoolCdが有効かチェック
        if (!"oom".equals(schoolCd) && !"tky".equals(schoolCd)) {
            LOGGER.warning("無効なschoolCd: " + schoolCd);
            request.setAttribute("error", "ログイン情報が無効です。再度ログインしてください");
            request.getRequestDispatcher("/gakusei/login.jsp").forward(request, response);
            return;
        }

        // 初回リクエストの場合、schoolCdをclassNumParamに設定
        boolean isInitialRequest = (classNumParam == null || classNumParam.isEmpty()) &&
                                  (entYearParam == null || entYearParam.isEmpty()) &&
                                  (isAttendParam == null || isAttendParam.isEmpty());
        if (isInitialRequest) {
            classNumParam = schoolCd;
            LOGGER.info("初回リクエスト: classNumParamをschoolCdに設定: " + classNumParam);
        }

        List<Student> students = null;
        int resultCount = 0;
        String error = null;

        try {
            StudentDao dao = new StudentDao();
            // フィルタ条件を適用
            Boolean isAttend = isAttendParam != null && !isAttendParam.isEmpty() ? Boolean.parseBoolean(isAttendParam) : null;
            students = dao.filter(entYearParam, classNumParam, isAttend, schoolCd);
            resultCount = students != null ? students.size() : 0;
            LOGGER.info("取得した学生数: " + resultCount);
        } catch (SQLException e) {
            LOGGER.severe("データベースエラー: SQLState=" + e.getSQLState() + ", ErrorCode=" + e.getErrorCode() + ", Message=" + e.getMessage());
            error = "データベースエラー: " + e.getMessage();
        } catch (Exception e) {
            LOGGER.severe("予期しないエラー: " + e.getMessage());
            error = "エラー: " + e.getMessage();
        }

        // JSPに渡す属性を設定
        request.setAttribute("students", students);
        request.setAttribute("resultCount", resultCount);
        request.setAttribute("entYear", entYearParam);
        request.setAttribute("classNum", classNumParam);
        request.setAttribute("isAttend", isAttendParam);
        request.setAttribute("error", error);

        LOGGER.info("JSPフォワード開始: student_list.jsp");
        request.getRequestDispatcher("student_list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}