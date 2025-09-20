package com.banma.forum.controller;

import com.banma.forum.dao.ReplyDao;
import com.banma.forum.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

public class CommentServlet extends HttpServlet {
    private final ReplyDao replyDao = new ReplyDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User u = session != null ? (User) session.getAttribute("user") : null;
        if (u == null) { resp.sendRedirect(req.getContextPath()+"/auth/login"); return; }
        String path = req.getPathInfo(); // /add
        if ("/add".equals(path)) {
            try {
                int postId = Integer.parseInt(req.getParameter("postId"));
                String content = trim(req.getParameter("content"));

                if (content == null || content.isEmpty()) {
                    resp.sendRedirect(req.getContextPath()+"/post/detail?id="+postId+"&error=empty");
                    return;
                }

                if (content.length() > 1000) {
                    resp.sendRedirect(req.getContextPath()+"/post/detail?id="+postId+"&error=toolong");
                    return;
                }

                replyDao.add(postId, u.getId(), content);
                resp.sendRedirect(req.getContextPath()+"/post/detail?id="+postId);
            } catch (NumberFormatException e) {
                resp.sendError(400, "帖子ID不合法");
            } catch (SQLException e) {
                throw new ServletException(e);
            }
        } else {
            resp.sendError(404);
        }
    }

    private String trim(String s) {
        return s == null ? null : s.trim();
    }
}
