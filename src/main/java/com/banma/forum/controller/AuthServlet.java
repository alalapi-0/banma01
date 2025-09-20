package com.banma.forum.controller;

import com.banma.forum.dao.UserDao;
import com.banma.forum.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * AuthServlet：处理登录/注册/登出
 * URL 映射：/auth/*
 */
public class AuthServlet extends HttpServlet {
    private UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null || "/login".equals(path)) {
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
        } else if ("/register".equals(path)) {
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
        } else if ("/logout".equals(path)) {
            HttpSession s = req.getSession(false);
            if (s != null) s.invalidate();
            resp.sendRedirect(req.getContextPath() + "/");
        } else {
            resp.sendError(404);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getPathInfo();
        try {
            if ("/login".equals(action)) {
                String u = req.getParameter("username");
                String p = req.getParameter("password");
                User user = userDao.findByName(u);
                if (user != null && user.getPassword().equals(p)) {
                    req.getSession(true).setAttribute("user", user);
                    resp.sendRedirect(req.getContextPath() + "/");
                } else {
                    req.setAttribute("msg", "登录失败：用户名或密码不正确");
                    req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
                }
            } else if ("/register".equals(action)) {
                String u = req.getParameter("username");
                String p = req.getParameter("password");
                User exist = userDao.findByName(u);
                if (exist != null) {
                    req.setAttribute("msg", "用户名已存在");
                    req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
                    return;
                }
                User user = userDao.createUser(u, p);
                req.getSession(true).setAttribute("user", user);
                resp.sendRedirect(req.getContextPath() + "/");
            } else {
                resp.sendError(404);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
