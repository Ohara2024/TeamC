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

import bean.Student;
import dao.StudentDao;
import dao.StudentDao.ClassNum;

/**
 * 学生更新フォームを表示するアクション。
 */
@WebServlet("/StudentUpdateAction")
public class StudentUpdateAction extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(StudentUpdateAction.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String studentNo = request.getParameter("studentNo");
        LOGGER.info("Received studentNo: " + studentNo);

        if (studentNo == null || studentNo.isEmpty()) {
            LOGGER.warning("Error: studentNo is null or empty");
            request.setAttribute("error", "学生番号が指定されていません。");
            request.getRequestDispatcher("student_update.jsp").forward(request, response);
            return;
        }

        Student student = null;
        List<ClassNum> classNumbers = null;
        String error = null;

        try {
            StudentDao dao = new StudentDao();
            // 学生情報取得
            student = dao.findByNo(studentNo);
            if (student == null) {
                LOGGER.warning("No student found for NO: " + studentNo);
                error = "指定された学生が見つかりません。";
            } else {
                LOGGER.info("Found student with NO: " + studentNo + ", schoolCd: " + student.getSchoolCd());
            }

            // クラス番号一覧を取得
            classNumbers = dao.getClassNumbers();
            LOGGER.info("Loaded " + (classNumbers != null ? classNumbers.size() : 0) + " class numbers");
        } catch (SQLException e) {
            LOGGER.severe("データベースエラー: SQLState=" + e.getSQLState() + ", ErrorCode=" + e.getErrorCode() + ", Message=" + e.getMessage());
            error = "データベースエラー: " + e.getMessage();
        } catch (Exception e) {
            LOGGER.severe("予期しないエラー: " + e.getMessage());
            error = "予期しないエラー: " + e.getMessage();
        }

        request.setAttribute("student", student);
        request.setAttribute("classNumbers", classNumbers);
        request.setAttribute("error", error);
        LOGGER.info("Forwarding to student_update.jsp");
        request.getRequestDispatcher("student_update.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}