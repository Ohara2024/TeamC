package scoremanager.main;

import java.io.IOException;
<<<<<<< HEAD
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
=======
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * 学生一覧を表示するアクション。
 */
@WebServlet("/StudentListAction")
public class StudentListAction extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String DB_URL = "jdbc:h2:tcp://localhost/~/exam;IFEXISTS=TRUE;DB_CLOSE_ON_EXIT=TRUE";
    private static final String DB_USER = "sa";
    private static final String DB_PASSWORD = "";
    private static final int MAX_RECONNECT_ATTEMPTS = 3;
    private static final Logger LOGGER = Logger.getLogger(StudentListAction.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String entYearParam = request.getParameter("entYear");
        String classNumParam = request.getParameter("classNum");
        String isAttendParam = request.getParameter("isAttend");

        // セッションからSCHOOL_CDを取得
        HttpSession session = request.getSession();
        String schoolCd = (String) session.getAttribute("schoolCd");

        LOGGER.info("セッションから取得したschoolCd: " + schoolCd);
        LOGGER.info("リクエストパラメータ: entYear=" + entYearParam + ", classNum=" + classNumParam + ", isAttend=" + isAttendParam);

        // SCHOOL_CDが取得できない、または無効な場合、エラーを設定してリダイレクト
        if (schoolCd == null || (!"oom".equals(schoolCd) && !"tky".equals(schoolCd))) {
            LOGGER.warning("無効またはSCHOOL_CDが見つかりません: " + schoolCd);
            request.setAttribute("error", "ログイン情報が無効です。再度ログインしてください");
            request.getRequestDispatcher("/gakusei/login.jsp").forward(request, response);
            return;
        }

        // 初回リクエストの場合、SCHOOL_CDをclassNumParamとして設定
        boolean isInitialRequest = (classNumParam == null || classNumParam.isEmpty()) &&
                                  (entYearParam == null || entYearParam.isEmpty()) &&
                                  (isAttendParam == null || isAttendParam.isEmpty());
        if (isInitialRequest) {
            classNumParam = schoolCd;
            LOGGER.info("初回リクエスト: classNumParamをschoolCdに設定: " + classNumParam);
        }

        List<Student> students = new ArrayList<>();
        int resultCount = 0;
        String error = null;

        Connection conn = null;
        int reconnectAttempts = 0;

        while (reconnectAttempts < MAX_RECONNECT_ATTEMPTS) {
            try {
                // H2ドライバのロード
                Class.forName("org.h2.Driver");
                conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                conn.setAutoCommit(true);

                // 学生一覧を取得
                StringBuilder query = new StringBuilder("SELECT NO, NAME, ENT_YEAR, CLASS_NUM, IS_ATTEND, SCHOOL_CD FROM STUDENT WHERE 1=1");
                List<String> params = new ArrayList<>();

                // フィルタの設定
                if (entYearParam != null && !entYearParam.isEmpty()) {
                    query.append(" AND ENT_YEAR = ?");
                    params.add(entYearParam);
                }
                if (classNumParam != null && !classNumParam.isEmpty()) {
                    // SCHOOL_CD (oom, tky) または CLASS_NUM (101, 131, 201) を判別
                    if ("oom".equals(classNumParam) || "tky".equals(classNumParam)) {
                        query.append(" AND SCHOOL_CD = ?");
                        params.add(classNumParam);
                    } else {
                        query.append(" AND CLASS_NUM = ?");
                        params.add(classNumParam);
                    }
                }
                if (isAttendParam != null && !isAttendParam.isEmpty()) {
                    query.append(" AND IS_ATTEND = TRUE");
                }

                LOGGER.info("実行クエリ: " + query.toString());
                LOGGER.info("パラメータ: " + params);

                try (PreparedStatement pstmt = conn.prepareStatement(
                        query.toString(),
                        ResultSet.TYPE_SCROLL_INSENSITIVE,
                        ResultSet.CONCUR_READ_ONLY)) {
                    for (int i = 0; i < params.size(); i++) {
                        pstmt.setString(i + 1, params.get(i));
                    }

                    ResultSet rs = pstmt.executeQuery();
                    while (rs.next()) {
                        Student student = new Student();
                        student.setNo(rs.getString("NO"));
                        student.setName(rs.getString("NAME"));
                        student.setEntYear(rs.getString("ENT_YEAR"));
                        student.setClassNum(rs.getString("CLASS_NUM"));
                        student.setAttend(rs.getBoolean("IS_ATTEND"));
                        student.setSchoolCd(rs.getString("SCHOOL_CD"));
                        students.add(student);
                        resultCount++;
                    }
                    LOGGER.info("取得した学生数: " + resultCount);
                }

                // JSPに渡す属性を設定
                request.setAttribute("students", students);
                request.setAttribute("resultCount", resultCount);
                request.setAttribute("entYear", entYearParam);
                request.setAttribute("classNum", classNumParam);
                request.setAttribute("isAttend", isAttendParam);
                break;
            } catch (ClassNotFoundException e) {
                LOGGER.severe("ClassNotFoundException: " + e.getMessage());
                error = "H2ドライバが見つかりません: " + e.getMessage();
                break;
            } catch (SQLException e) {
                LOGGER.severe("SQLException: SQLState=" + e.getSQLState() + ", ErrorCode=" + e.getErrorCode() + ", Message=" + e.getMessage());
                error = "データベースエラー: " + e.getMessage();
                if (e.getErrorCode() == 90020) {
                    reconnectAttempts++;
                    if (reconnectAttempts < MAX_RECONNECT_ATTEMPTS) {
                        try {
                            Thread.sleep(1000);
                        } catch (InterruptedException ignored) {}
                        continue;
                    }
                }
                break;
            } finally {
                if (conn != null) {
                    try {
                        conn.close();
                        LOGGER.info("データベース接続を閉じました");
                    } catch (SQLException e) {
                        LOGGER.severe("接続のクローズに失敗: " + e.getMessage());
                    }
                }
            }
        }

        if (error != null) {
            LOGGER.severe("エラー発生: " + error);
            request.setAttribute("error", error);
        }
        request.getRequestDispatcher("student_list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    // 学生データを保持する内部クラス
    public static class Student {
        private String entYear;
        private String no;
        private String name;
        private String classNum;
        private boolean isAttend;
        private String schoolCd;

        public String getEntYear() { return entYear; }
        public void setEntYear(String entYear) { this.entYear = entYear; }
        public String getNo() { return no; }
        public void setNo(String no) { this.no = no; }
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        public String getClassNum() { return classNum; }
        public void setClassNum(String classNum) { this.classNum = classNum; }
        public boolean isAttend() { return isAttend; }
        public void setAttend(boolean isAttend) { this.isAttend = isAttend; }
        public String getSchoolCd() { return schoolCd; }
        public void setSchoolCd(String schoolCd) { this.schoolCd = schoolCd; }
>>>>>>> branch 'TeamCマージ' of https://github.com/Ohara2024/TeamC
    }
}