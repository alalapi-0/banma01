package com.banma.forum.filter; // 声明该过滤器所在的包，方便类被容器扫描到

import javax.servlet.*; // 引入 Filter、ServletRequest、ServletResponse 等接口定义
import javax.servlet.http.HttpServletResponse; // 引入响应对象的具体实现类型以便设置响应头
import java.io.IOException; // 引入 IO 异常类型，过滤器在处理链路时可能抛出

// EncodingFilter 会在请求进入 Servlet 之前统一设置字符集
public class EncodingFilter implements Filter {

    @Override // 标记重写 Filter 接口中的 init 方法
    public void init(FilterConfig filterConfig) throws ServletException {
        // 该过滤器不需要读取初始化参数，因此这里保持空实现
    }

    @Override // 重写 Filter 接口中的核心方法 doFilter
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain)
            throws IOException, ServletException {

        // 将请求体的编码设置为 UTF-8，确保读取表单时不会乱码
        req.setCharacterEncoding("UTF-8");

        // 将响应的字符编码设置为 UTF-8，让返回的文本内容保持一致
        resp.setCharacterEncoding("UTF-8");

        // 如果当前响应对象是 HTTP 协议的实现，我们再补充响应头
        if (resp instanceof HttpServletResponse) {
            HttpServletResponse httpResp = (HttpServletResponse) resp; // 向下转型以访问 HTTP 专有方法
            // 只在响应尚未设置内容类型时附加 text/html，避免覆盖文件下载等特殊类型
            if (httpResp.getContentType() == null) {
                httpResp.setContentType("text/html;charset=UTF-8"); // 同时告知浏览器文本类型与编码
            }
        }

        // 将请求交给下一个过滤器或最终的 Servlet 继续处理
        chain.doFilter(req, resp);
    }

    @Override // 重写 Filter 接口中的 destroy 方法
    public void destroy() {
        // 本过滤器没有需要释放的资源，空实现即可
    }
}
