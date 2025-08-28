package com.banma.forum.controller;

import com.banma.forum.store.MemoryStore;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

/**
 * 帖子相关路由控制（含“删除确认页”两步流程）：
 *
 * GET  /post/new                 -> 打开发帖页（/WEB-INF/views/post.jsp）
 * POST /post/create              -> 提交发帖，成功后重定向 /post/detail?id=新帖ID
 *
 * GET  /post/detail?id={id}      -> 帖子详情（含评论），转发 /WEB-INF/views/post_detail.jsp
 * GET  /post/list                -> 帖子列表，转发 /WEB-INF/views/list.jsp
 *
 * GET  /post/delete?id={id}      -> 删帖确认页（仅作者可见），转发 /WEB-INF/views/delete.jsp
 * POST /post/delete              -> 真正删除（仅作者可删），成功后重定向 /post/list
 *
 * 说明：使用 MemoryStore 作为内存“数据库”，重启后数据会清空。
 */
public class PostServlet extends HttpServlet {

    // --------------- GET：页面展示 ---------------
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getPathInfo(); // 可能为 /new /detail /list /delete 或 null

        if ("/new".equals(path)) {
            // 发帖页
            req.getRequestDispatcher("/WEB-INF/views/post.jsp").forward(req, resp);
            return;
        }

        if ("/detail".equals(path)) {
            // 详情页：?id=xxx
            int id = parseIntOrBadRequest(req.getParameter("id"), resp);
            if (id < 0) return;

            MemoryStore.Post p = MemoryStore.getPost(id);
            if (p == null) { resp.sendError(HttpServletResponse.SC_NOT_FOUND); return; }

            req.setAttribute("post", p);
            req.setAttribute("comments", MemoryStore.listComments(id));
            req.getRequestDispatcher("/WEB-INF/views/post_detail.jsp").forward(req, resp);
            return;
        }

        if ("/list".equals(path) || path == null || "/".equals(path)) {
            // 列表页：按 createTime 倒序
            List<MemoryStore.Post> list = new ArrayList<>(MemoryStore.listPosts());
            list.sort((a, b) -> {
                Date da = a.getCreateTime(), db = b.getCreateTime();
                if (da == null && db == null) return 0;
                if (da == null) return 1;
                if (db == null) return -1;
                return db.compareTo(da);
            });
            req.setAttribute("posts", list);
            req.getRequestDispatcher("/WEB-INF/views/list.jsp").forward(req, resp);
            return;
        }

        if ("/delete".equals(path)) {
            // 删除确认页（仅作者可见）
            int id = parseIntOrBadRequest(req.getParameter("id"), resp);
            if (id < 0) return;

            MemoryStore.User current = (MemoryStore.User) req.getSession().getAttribute("user");
            if (current == null) { resp.sendRedirect(req.getContextPath() + "/auth/login"); return; }

            MemoryStore.Post p = MemoryStore.getPost(id);
            if (p == null) { resp.sendError(HttpServletResponse.SC_NOT_FOUND); return; }
            if (p.getUserId() != current.getId()) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "无法删除：不是作者");
                return;
            }

            req.setAttribute("post", p);
            req.getRequestDispatcher("/WEB-INF/views/delete.jsp").forward(req, resp);
            return;
        }

        // 其它未支持
        resp.sendError(HttpServletResponse.SC_NOT_FOUND);
    }

    // --------------- POST：数据提交 ---------------
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getPathInfo(); // /create 或 /delete 等

        // 需要登录
        MemoryStore.User current = (MemoryStore.User) req.getSession().getAttribute("user");
        if (current == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        if ("/create".equals(path)) {
            // 创建帖子
            String title = trimOrNull(req.getParameter("title"));
            String content = trimOrNull(req.getParameter("content"));

            if (isEmpty(title) || isEmpty(content)) {
                req.setAttribute("msg", "标题和内容不能为空");
                req.getRequestDispatcher("/WEB-INF/views/post.jsp").forward(req, resp);
                return;
            }

            MemoryStore.Post p = MemoryStore.createPost(current.getId(), title, content);
            resp.sendRedirect(req.getContextPath() + "/post/detail?id=" + p.getId());
            return;
        }

        if ("/delete".equals(path)) {
            // 真正删除
            int id = parseIntOrBadRequest(req.getParameter("id"), resp);
            if (id < 0) return;

            boolean ok = MemoryStore.deletePost(id, current.getId());
            if (!ok) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "无法删除：不是作者或帖子不存在");
                return;
            }
            resp.sendRedirect(req.getContextPath() + "/post/list");
            return;
        }

        resp.sendError(HttpServletResponse.SC_NOT_FOUND);
    }

    // --------------- 工具方法 ---------------
    /** 将字符串安全解析为 int；失败时返回 400 */
    private int parseIntOrBadRequest(String s, HttpServletResponse resp) throws IOException {
        if (s == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "缺少必要参数 id");
            return -1;
        }
        try {
            return Integer.parseInt(s);
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "参数 id 非法：" + s);
            return -1;
        }
    }

    /** 去首尾空格；空串返回 null */
    private String trimOrNull(String s) {
        if (s == null) return null;
        String t = s.trim();
        return t.isEmpty() ? null : t;
    }

    /** 判空 */
    private boolean isEmpty(String s) {
        return s == null || s.trim().isEmpty();
    }
}
