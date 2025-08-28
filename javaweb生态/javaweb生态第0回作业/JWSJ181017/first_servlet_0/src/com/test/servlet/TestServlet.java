package com.test.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/test") // 不建议用 .html 结尾，容易和静态资源混淆
public class TestServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // GET 场景主要看服务器的URIEncoding设置；这里保留也无妨
        request.setCharacterEncoding("UTF-8");

        // 先设 contentType（包含 charset），再 getWriter（和视频一致）
        response.setContentType("text/html; charset=UTF-8");

        String id = request.getParameter("id");

        try (PrintWriter out = response.getWriter()) { // 用 try-with-resources 自动 close
            if (id == null || id.isEmpty()) {
                out.write("ID参数缺失。");
                out.flush();
                return;
            }

            try {
                int idInt = Integer.parseInt(id);
                System.out.println(idInt); // 控制台打印
                // 成功时也回一点信息，方便你在页面看到结果
                out.write("解析成功，id = " + idInt);
            } catch (NumberFormatException e) {
                e.printStackTrace();
                // 和老师视频里的文案一致（中文提示）
                out.write("您输入的数字不合法");
            }

            out.flush(); // 明确刷新
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
