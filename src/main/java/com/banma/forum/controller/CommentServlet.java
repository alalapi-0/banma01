package com.banma.forum.controller;

import com.banma.forum.store.MemoryStore;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class CommentServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        MemoryStore.User u = (MemoryStore.User) req.getSession().getAttribute("user");
        if (u == null) { resp.sendRedirect(req.getContextPath()+"/auth/login"); return; }
        String path = req.getPathInfo(); // /add
        if ("/add".equals(path)) {
            int postId = Integer.parseInt(req.getParameter("postId"));
            String content = req.getParameter("content");
            MemoryStore.addComment(postId, u.getId(), content);
            resp.sendRedirect(req.getContextPath()+"/post/detail?id="+postId);
        } else {
            resp.sendError(404);
        }
    }
}
