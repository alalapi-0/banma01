package com.banma.forum.controller;

import com.banma.forum.dao.PostDao;
import com.banma.forum.dao.ReplyDao;
import com.banma.forum.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.*;

/**
 * 路由：
 * GET  /post/new           -> 发帖页
 * POST /post/create        -> 提交发帖
 * GET  /post/detail?id=xx  -> 帖子详情 + 回复列表
 * GET  /post/list          -> 帖子列表
 * GET  /post/delete?id=xx  -> 删帖确认页（仅作者）
 * POST /post/delete        -> 真正删除（仅作者）
 */
public class PostServlet extends HttpServlet {
    private final PostDao postDao = new PostDao();
    private final ReplyDao replyDao = new ReplyDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getPathInfo();

        try {
            if ("/new".equals(path)) {
                // 打开发帖页
                req.getRequestDispatcher("/WEB-INF/views/post.jsp").forward(req, resp);
                return;
            }

            if ("/detail".equals(path)) {
                int id = parseIntOr404(req.getParameter("id"), resp);
                if (id < 0) return;

                Map<String,Object> post = postDao.findDetail(id);
                if (post == null) { resp.sendError(404); return; }

                req.setAttribute("post", post);
                req.setAttribute("comments", replyDao.listByPost(id));
                req.getRequestDispatcher("/WEB-INF/views/post_detail.jsp").forward(req, resp);
                return;
            }

            if ("/list".equals(path) || path == null || "/".equals(path)) {
                req.setAttribute("posts", postDao.list(0, 100));
                req.getRequestDispatcher("/WEB-INF/views/list.jsp").forward(req, resp);
                return;
            }

            if ("/delete".equals(path)) {
                // 展示确认页（仅作者能看到按钮，但这里仍要校验）
                HttpSession session = req.getSession(false);
                User current = session != null ? (User) session.getAttribute("user") : null;
                if (current == null) { resp.sendRedirect(req.getContextPath()+"/auth/login"); return; }

                int id = parseIntOr404(req.getParameter("id"), resp);
                if (id < 0) return;

                Map<String,Object> post = postDao.findDetail(id);
                if (post == null) { resp.sendError(404); return; }

                int authorId = (int) post.get("authorId");
                if (authorId != current.getId()) { resp.sendError(403, "无权限删除"); return; }

                req.setAttribute("post", post);
                req.getRequestDispatcher("/WEB-INF/views/delete.jsp").forward(req, resp);
                return;
            }

            resp.sendError(404);
        } catch (SQLException e) {
            if (isConnectionFailure(e)) {
                log("数据库连接失败", e);
                handleDatabaseFailure(req, resp, path);
                return;
            }
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getPathInfo();
        HttpSession session = req.getSession(false);
        User current = session != null ? (User) session.getAttribute("user") : null;
        if (current == null) { resp.sendRedirect(req.getContextPath()+"/auth/login"); return; }

        try {
            if ("/create".equals(path)) {
                String title = trim(req.getParameter("title"));
                String content = trim(req.getParameter("content"));
                // 可以从页面带一个板块 bid；若暂时没有，就给个 Java 板块 6 的默认值
                int bid = parseIntOrDefault(req.getParameter("bid"), 6);

                if (isEmpty(title) || isEmpty(content)) {
                    req.setAttribute("msg", "标题和内容不能为空");
                    req.getRequestDispatcher("/WEB-INF/views/post.jsp").forward(req, resp);
                    return;
                }

                int tid = postDao.create(current.getId(), bid, title, content);
                resp.sendRedirect(req.getContextPath()+"/post/detail?id="+tid);
                return;
            }

            if ("/delete".equals(path)) {
                int id = parseIntOr404(req.getParameter("id"), resp);
                if (id < 0) return;

                boolean ok = postDao.deleteByAuthor(id, current.getId());
                if (!ok) { resp.sendError(403, "无法删除：不是作者或帖子不存在"); return; }
                resp.sendRedirect(req.getContextPath()+"/post/list");
                return;
            }

            resp.sendError(404);
        } catch (SQLException e) {
            if (isConnectionFailure(e)) {
                log("数据库连接失败", e);
                handleDatabaseFailure(req, resp, path);
                return;
            }
            throw new ServletException(e);
        }
    }

    // ---------- 工具 ----------
    private int parseIntOr404(String s, HttpServletResponse resp) throws IOException {
        if (s == null) { resp.sendError(404); return -1; }
        try { return Integer.parseInt(s); } catch (NumberFormatException e) { resp.sendError(404); return -1; }
    }
    private int parseIntOrDefault(String s, int def) {
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }
    private boolean isEmpty(String s){ return s==null || s.trim().isEmpty(); }
    private String trim(String s){ return s==null? null : s.trim(); }

    private void handleDatabaseFailure(HttpServletRequest req, HttpServletResponse resp, String path)
            throws ServletException, IOException {
        req.setAttribute("dbError", true);
        req.setAttribute("dbErrorMessage", "暂时无法连接数据库，请稍后再试。");

        if ("/create".equals(path)) {
            req.setAttribute("msg", req.getAttribute("dbErrorMessage"));
            req.getRequestDispatcher("/WEB-INF/views/post.jsp").forward(req, resp);
            return;
        }

        if (path == null || "/".equals(path) || "/list".equals(path)) {
            req.getRequestDispatcher("/WEB-INF/views/list.jsp").forward(req, resp);
            return;
        }

        resp.sendError(503, "数据库暂时不可用，请稍后再试。");
    }

    private boolean isConnectionFailure(Throwable t) {
        while (t != null) {
            if (t instanceof java.net.ConnectException) return true;
            if (t instanceof java.sql.SQLNonTransientConnectionException) return true;
            String name = t.getClass().getName();
            if (name.contains("CommunicationsException") || name.contains("ConnectionException")) {
                return true;
            }
            t = t.getCause();
        }
        return false;
    }
}
