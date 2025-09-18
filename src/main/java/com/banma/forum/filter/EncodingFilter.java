package com.banma.forum.filter;

import javax.servlet.*;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class EncodingFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 读取初始化参数
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain)
            throws IOException, ServletException {

        // 请求体编码（POST 表单）
        req.setCharacterEncoding("UTF-8");

        // 响应字符集
        resp.setCharacterEncoding("UTF-8");

        // 告诉浏览器用 UTF-8 渲染
        if (resp instanceof HttpServletResponse) {
            HttpServletResponse httpResp = (HttpServletResponse) resp;
            // 仅当还没设置过类型时设置为 text/html；避免影响下载、图片等静态资源
            if (httpResp.getContentType() == null) {
                httpResp.setContentType("text/html;charset=UTF-8");
            }
        }

        chain.doFilter(req, resp);
    }

    @Override
    public void destroy() {
        // 释放资源
    }
}
