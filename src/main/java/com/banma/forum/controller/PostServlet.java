package com.banma.forum.controller;

import com.banma.forum.dao.BoardDao;
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
    private final BoardDao boardDao = new BoardDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getPathInfo();
        Integer currentBoardId = null;
        Map<String, Object> currentBoard = null;

        try {
            if ("/new".equals(path)) {
                prepareBoardForm(req, extractBoardId(req));
                req.getRequestDispatcher("/WEB-INF/views/post.jsp").forward(req, resp);
                return;
            }

            if ("/detail".equals(path)) {
                int id = parseIntOr404(req.getParameter("id"), resp);
                if (id < 0) return;

                Map<String,Object> post = postDao.findDetail(id);
                if (post == null) { resp.sendError(404); return; }

                Object boardIdObj = post.get("boardId");
                if (boardIdObj instanceof Number) {
                    storeLastBoard(req, ((Number) boardIdObj).intValue());
                }

                req.setAttribute("post", post);
                req.setAttribute("comments", replyDao.listByPost(id));
                req.getRequestDispatcher("/WEB-INF/views/post_detail.jsp").forward(req, resp);
                return;
            }

            if ("/list".equals(path) || path == null || "/".equals(path)) {
                currentBoardId = extractBoardId(req);
                if (currentBoardId == null) { resp.sendError(404); return; }

                currentBoard = boardDao.findById(currentBoardId);
                if (currentBoard == null || currentBoard.get("parentId") == null) {
                    resp.sendError(404);
                    return;
                }

                req.setAttribute("board", currentBoard);
                req.setAttribute("boardId", currentBoardId);
                req.setAttribute("posts", postDao.listByBoard(currentBoardId, 0, 100));
                storeLastBoard(req, currentBoardId);
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
                if (currentBoard != null) {
                    req.setAttribute("board", currentBoard);
                    req.setAttribute("boardId", currentBoardId);
                }
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
                Integer boardId = extractBoardId(req);
                if (boardId == null && session != null) {
                    Object last = session.getAttribute("lastBoardId");
                    if (last instanceof Number) {
                        boardId = ((Number) last).intValue();
                    }
                }

                if (boardId == null) {
                    req.setAttribute("msg", "请选择要发布的板块");
                    prepareBoardForm(req, null);
                    req.getRequestDispatcher("/WEB-INF/views/post.jsp").forward(req, resp);
                    return;
                }

                Map<String,Object> board = boardDao.findById(boardId);
                if (board == null || board.get("parentId") == null) {
                    req.setAttribute("msg", "板块不存在或不可发帖");
                    prepareBoardForm(req, boardId);
                    req.getRequestDispatcher("/WEB-INF/views/post.jsp").forward(req, resp);
                    return;
                }

                if (isEmpty(title) || isEmpty(content)) {
                    req.setAttribute("msg", "标题和内容不能为空");
                    prepareBoardForm(req, boardId);
                    req.getRequestDispatcher("/WEB-INF/views/post.jsp").forward(req, resp);
                    return;
                }

                int tid = postDao.create(current.getId(), boardId, title, content);
                storeLastBoard(req, boardId);
                resp.sendRedirect(req.getContextPath()+"/post/detail?id="+tid);
                return;
            }

            if ("/delete".equals(path)) {
                int id = parseIntOr404(req.getParameter("id"), resp);
                if (id < 0) return;

                Map<String,Object> post = postDao.findDetail(id);
                Integer boardId = null;
                if (post != null) {
                    Object boardObj = post.get("boardId");
                    if (boardObj instanceof Number) {
                        boardId = ((Number) boardObj).intValue();
                    }
                }

                boolean ok = postDao.deleteByAuthor(id, current.getId());
                if (!ok) { resp.sendError(403, "无法删除：不是作者或帖子不存在"); return; }
                if (boardId != null) {
                    storeLastBoard(req, boardId);
                    resp.sendRedirect(req.getContextPath()+"/post/list?bid="+boardId);
                } else {
                    resp.sendRedirect(req.getContextPath()+"/post/list");
                }
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
    private Integer extractBoardId(HttpServletRequest req) {
        String s = req.getParameter("bid");
        if (s == null || s.trim().isEmpty()) {
            s = req.getParameter("boardId");
        }
        if (s == null || s.trim().isEmpty()) {
            return null;
        }
        try {
            return Integer.valueOf(s.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private void prepareBoardForm(HttpServletRequest req, Integer requestedBoardId) throws SQLException {
        List<Map<String, Object>> boards = boardDao.listLeafBoards();
        req.setAttribute("boards", boards);

        Integer selectedId = requestedBoardId;
        if (selectedId == null) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                Object last = session.getAttribute("lastBoardId");
                if (last instanceof Number) {
                    selectedId = ((Number) last).intValue();
                }
            }
        }

        Map<String, Object> selectedBoard = null;
        if (selectedId != null) {
            for (Map<String, Object> board : boards) {
                if (Objects.equals(board.get("id"), selectedId)) {
                    selectedBoard = board;
                    break;
                }
            }
        }

        if (selectedBoard == null && !boards.isEmpty()) {
            selectedBoard = boards.get(0);
            selectedId = (Integer) selectedBoard.get("id");
        }

        req.setAttribute("selectedBoardId", selectedId);
        req.setAttribute("selectedBoard", selectedBoard);
    }

    private void storeLastBoard(HttpServletRequest req, int boardId) {
        HttpSession session = req.getSession();
        session.setAttribute("lastBoardId", boardId);
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
