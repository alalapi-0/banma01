package com.banma.forum.controller;

import com.banma.forum.store.MemoryStore;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class AuthServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo(); // 可能是 null、/login、/register、/logout
        if (path == null || "/login".equals(path)) {
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
        } else if ("/register".equals(path)) {
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
        } else if ("/logout".equals(path)) {
            HttpSession s = req.getSession(false);
            if (s != null) s.invalidate();
            // 退出后回首页
            resp.sendRedirect(req.getContextPath() + "/home");
        } else {
            resp.sendError(404);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getPathInfo(); // /login 或 /register
        if ("/login".equals(action)) {
            String u = req.getParameter("username");
            String p = req.getParameter("password");
            MemoryStore.User user = MemoryStore.findUser(u);
            if (user != null && p != null && p.equals(user.getPassword())) {
                req.getSession(true).setAttribute("user", user);
                // 登录成功 → 跳转到 /home
                resp.sendRedirect(req.getContextPath() + "/home");
            } else {
                req.setAttribute("msg", "登录失败：用户名或密码不正确");
                req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
            }
        } else if ("/register".equals(action)) {
            String u = req.getParameter("username");
            String p = req.getParameter("password");
            MemoryStore.User user = MemoryStore.createUser(u, p);
            if (user == null) {
                req.setAttribute("msg", "用户名已存在");
                req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
                return;
            }
            req.getSession(true).setAttribute("user", user);
            // 注册成功 → 跳转到 /home
            resp.sendRedirect(req.getContextPath() + "/home");
        } else {
            resp.sendError(404);
        }
    }
}
