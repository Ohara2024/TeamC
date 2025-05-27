package scoremanager.main;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.SubjectDao;

@WebServlet("/SubjectDelete.action")
public class SubjectDeleteAction extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {
	    String subjectcd = request.getParameter("subjectcd");
	    String subjectName = request.getParameter("subjectName");
	    String schoolCd = request.getParameter("schoolCd");
	    String error = request.getParameter("error");

	    System.out.println("doGet - subjectcd: " + subjectcd);
	    System.out.println("doGet - subjectName: " + subjectName);
	    System.out.println("doGet - schoolCd: " + schoolCd);

	    request.setAttribute("subjectcd", subjectcd);
	    request.setAttribute("subjectName", subjectName);
	    request.setAttribute("schoolCd", schoolCd);
	    request.setAttribute("error", error);

	    RequestDispatcher dispatcher = request.getRequestDispatcher("/subject_delete.jsp");
	    dispatcher.forward(request, response);
	}

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String subjectcd = request.getParameter("subjectcd");
        String schoolCd = request.getParameter("schoolCd");

        try {
            SubjectDao dao = new SubjectDao();
            boolean success = dao.delete(subjectcd, schoolCd);
            if (success) {
                // 削除完了画面にフォワードまたはリダイレクト
                // リダイレクトの場合（URLが変わる）
                response.sendRedirect(request.getContextPath() + "/subject_delete_done.jsp");

                // またはフォワードの場合（URLは変わらない）
                // RequestDispatcher dispatcher = request.getRequestDispatcher("/subject_delete_done.jsp");
                // dispatcher.forward(request, response);
            } else {
                request.setAttribute("error", "削除に失敗しました。");
                request.setAttribute("subjectcd", subjectcd);
                request.setAttribute("schoolCd", schoolCd);
                doGet(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("subjectcd", subjectcd);
            request.setAttribute("schoolCd", schoolCd);
            request.setAttribute("error", "システムエラーが発生しました。");
            doGet(request, response);
        }
    }
}
