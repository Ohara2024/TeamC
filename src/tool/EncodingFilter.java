package tool;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

public class EncodingFilter implements Filter {
    private String encoding = "UTF-8";

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 初期化処理（必要に応じてweb.xmlからエンコーディングを取得）
        String encodingParam = filterConfig.getInitParameter("encoding");
        if (encodingParam != null) {
            encoding = encodingParam;
        }
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        // リクエストのエンコーディングを設定
        request.setCharacterEncoding(encoding);
        // レスポンスのエンコーディングを設定
        response.setCharacterEncoding(encoding);
        // 次のフィルターまたはサーブレットに処理を渡す
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // 後処理（必要に応じて実装）
    }
}