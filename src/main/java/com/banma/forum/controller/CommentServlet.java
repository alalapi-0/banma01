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
        try {
            if ("/add".equals(path)) {
                int postId = Integer.parseInt(req.getParameter("postId"));
                String content = req.getParameter("content");
                replyDao.add(postId, u.getId(), content);
                resp.sendRedirect(req.getContextPath()+"/post/detail?id="+postId);
                return;
            }

            if ("/delete".equals(path)) {
                int replyId = Integer.parseInt(req.getParameter("id"));
                Integer postId = replyDao.findPostId(replyId);
                if (postId == null) {
                    resp.sendError(404, "回复不存在");
                    return;
                }
                boolean ok = replyDao.deleteByPostOwner(replyId, u.getId());
                if (!ok) {
                    resp.sendError(403, "无权限删除该回复");
                    return;
                }
                resp.sendRedirect(req.getContextPath()+"/post/detail?id="+postId);
                return;
            }

            resp.sendError(404);
        } catch (NumberFormatException e) {
            resp.sendError(400, "请求参数不合法");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
