package scoremanager.main;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/SubjectCreateForm.action")
public class SubjectCreateForm extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ログインチェックが必要ならここでセッションからユーザー取得して確認する

        // JSPへフォワード
        request.getRequestDispatcher("/subject_create.jsp").forward(request, response);
    }
}
