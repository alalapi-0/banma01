package com.test.servlet;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(urlPatterns = "/hello", loadOnStartup = 0)
public class HelloServlet extends HttpServlet {

    public HelloServlet(){
        System.out.println("Constructor");
    }

    public void init() throws ServletException {
        System.out.println("init");
    }

    public void destroy() {
        System.out.println("destroy");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("hello servlet");
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        this.doGet(request, response);
    }
}
