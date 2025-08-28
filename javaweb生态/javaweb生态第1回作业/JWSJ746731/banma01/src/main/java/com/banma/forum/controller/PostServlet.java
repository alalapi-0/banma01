package com.banma.forum.controller;

import com.banma.forum.store.MemoryStore;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

public class PostServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo(); // /new /detail /list
        if ("/new".equals(path)) {
            req.getRequestDispatcher("/WEB-INF/views/post.jsp").forward(req, resp);

        } else if ("/detail".equals(path)) {
            int id = Integer.parseInt(req.getParameter("id"));
            MemoryStore.Post p = MemoryStore.getPost(id);
            if (p == null) { resp.sendError(404); return; }
            req.setAttribute("post", p);
            req.setAttribute("comments", MemoryStore.listComments(id));
            req.getRequestDispatcher("/WEB-INF/views/post_detail.jsp").forward(req, resp);

        } else if ("/list".equals(path)) {
            List<MemoryStore.Post> list = MemoryStore.listPosts();
            List<Map<String,Object>> view = new ArrayList<>();
            for (MemoryStore.Post p : list) {
                Map<String,Object> m = new HashMap<>();
                m.put("id", p.getId());
                m.put("title", p.getTitle());
                MemoryStore.User u = MemoryStore.users.get(p.getUserId());
                m.put("author", u==null?("用户#"+p.getUserId()):u.getUsername());
                m.put("replyCount", MemoryStore.listComments(p.getId()).size());
                m.put("createTime", "");
                view.add(m);
            }
            req.setAttribute("posts", view);
            req.getRequestDispatcher("/WEB-INF/views/list.jsp").forward(req, resp);

        } else {
            resp.sendError(404);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo(); // /create or /delete
        MemoryStore.User u = (MemoryStore.User) req.getSession().getAttribute("user");
        if (u == null) { resp.sendRedirect(req.getContextPath()+"/auth/login"); return; }

        if ("/create".equals(path)) {
            String title = req.getParameter("title");
            String content = req.getParameter("content");
            MemoryStore.Post p = MemoryStore.createPost(u.getId(), title, content);
            resp.sendRedirect(req.getContextPath()+"/post/detail?id="+p.getId());

        } else if ("/delete".equals(path)) {
            int id = Integer.parseInt(req.getParameter("id"));
            boolean ok = MemoryStore.deletePost(id, u.getId());
            resp.sendRedirect(req.getContextPath()+"/?del="+ok);

        } else {
            resp.sendError(404);
        }
    }
}
