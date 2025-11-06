package com.banma.forum.controller; // 指定帖子相关 Servlet 的包

import com.banma.forum.dao.BoardDao; // 引入板块 DAO 以读取板块数据
import com.banma.forum.dao.PostDao; // 引入帖子 DAO 以处理帖子 CRUD
import com.banma.forum.dao.ReplyDao; // 引入回复 DAO 以加载评论列表
import com.banma.forum.model.User; // 引入用户实体判断登录状态

import javax.servlet.ServletException; // 导入 Servlet 异常
import javax.servlet.http.*; // 导入 HTTP Servlet 基础类
import java.io.IOException; // 导入 IO 异常
import java.sql.SQLException; // 导入 SQL 异常
import java.util.*; // 导入集合工具类

// PostServlet 统一处理发帖、列表、详情以及删除逻辑
public class PostServlet extends HttpServlet {
    private final PostDao postDao = new PostDao(); // 帖子数据访问对象
    private final ReplyDao replyDao = new ReplyDao(); // 回复数据访问对象
    private final BoardDao boardDao = new BoardDao(); // 板块数据访问对象

    @Override // 覆写 GET 请求处理页面展示
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getPathInfo(); // 获取 /post 后面的路径部分
        Integer currentBoardId = null; // 预留变量保存当前板块 ID
        Map<String, Object> currentBoard = null; // 预留变量保存当前板块信息

        try { // 根据不同的路径处理不同的页面展示场景
            if ("/new".equals(path)) { // 请求发帖页
                prepareBoardForm(req, extractBoardId(req)); // 准备板块列表与默认选项
                req.getRequestDispatcher("/WEB-INF/views/post.jsp").forward(req, resp); // 转发到发帖 JSP
                return; // 结束处理
            }

            if ("/detail".equals(path)) { // 请求帖子详情
                int id = parseIntOr404(req.getParameter("id"), resp); // 解析帖子 ID
                if (id < 0) return; // 如果解析失败 parseIntOr404 已返回错误

                Map<String,Object> post = postDao.findDetail(id); // 查询帖子详情
                if (post == null) { resp.sendError(404); return; } // 未找到帖子直接返回 404

                Object boardIdObj = post.get("boardId"); // 取出帖子所属板块
                if (boardIdObj instanceof Number) { // 如果包含合法的板块 ID
                    storeLastBoard(req, ((Number) boardIdObj).intValue()); // 保存到 session 中方便下次默认选择
                }

                req.setAttribute("post", post); // 将帖子详情传给 JSP
                req.setAttribute("comments", replyDao.listByPost(id)); // 加载所有回复列表
                req.getRequestDispatcher("/WEB-INF/views/post_detail.jsp").forward(req, resp); // 转发到详情页
                return; // 结束处理
            }

            if ("/list".equals(path) || path == null || "/".equals(path)) { // 请求帖子列表
                currentBoardId = extractBoardId(req); // 从参数中提取板块 ID
                if (currentBoardId == null) { resp.sendError(404); return; } // 没有指定板块则返回 404

                currentBoard = boardDao.findById(currentBoardId); // 查询板块信息
                if (currentBoard == null || currentBoard.get("parentId") == null) { // 不是叶子板块或不存在
                    resp.sendError(404); // 返回 404
                    return; // 结束处理
                }

                req.setAttribute("board", currentBoard); // 传递当前板块信息
                req.setAttribute("boardId", currentBoardId); // 传递板块 ID
                req.setAttribute("posts", postDao.listByBoard(currentBoardId, 0, 100)); // 查询帖子列表
                storeLastBoard(req, currentBoardId); // 记录最近浏览的板块
                req.getRequestDispatcher("/WEB-INF/views/list.jsp").forward(req, resp); // 转发到列表页面
                return; // 结束处理
            }

            if ("/delete".equals(path)) { // 请求删除确认页
                HttpSession session = req.getSession(false); // 获取当前会话
                User current = session != null ? (User) session.getAttribute("user") : null; // 从会话中取出用户
                if (current == null) { resp.sendRedirect(req.getContextPath()+"/auth/login"); return; } // 未登录则跳转登录

                int id = parseIntOr404(req.getParameter("id"), resp); // 解析帖子 ID
                if (id < 0) return; // 解析失败时结束

                Map<String,Object> post = postDao.findDetail(id); // 查询帖子详情
                if (post == null) { resp.sendError(404); return; } // 帖子不存在返回 404

                int authorId = (int) post.get("authorId"); // 取得帖子作者 ID
                if (authorId != current.getId()) { resp.sendError(403, "无权限删除"); return; } // 非作者禁止访问

                req.setAttribute("post", post); // 传递帖子信息给确认页面
                req.getRequestDispatcher("/WEB-INF/views/delete.jsp").forward(req, resp); // 转发到确认页
                return; // 结束处理
            }

            resp.sendError(404); // 不支持的路径返回 404
        } catch (SQLException e) { // 捕获数据库异常
            if (isConnectionFailure(e)) { // 检测是否为数据库连接问题
                log("数据库连接失败", e); // 记录日志
                if (currentBoard != null) { // 如果之前已经查询到板块信息
                    req.setAttribute("board", currentBoard); // 将板块信息放回请求
                    req.setAttribute("boardId", currentBoardId); // 同步板块 ID
                }
                handleDatabaseFailure(req, resp, path); // 统一处理数据库故障
                return; // 结束处理
            }
            throw new ServletException(e); // 其他异常继续抛出
        }
    }

    @Override // 覆写 POST 请求处理发帖与删除动作
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getPathInfo(); // 获取动作路径
        HttpSession session = req.getSession(false); // 获取当前会话
        User current = session != null ? (User) session.getAttribute("user") : null; // 从会话取出用户
        if (current == null) { resp.sendRedirect(req.getContextPath()+"/auth/login"); return; } // 未登录则跳转登录

        try { // 根据子路径执行创建或删除逻辑
            if ("/create".equals(path)) { // 处理创建帖子
                String title = trim(req.getParameter("title")); // 读取并去除标题两端空格
                String content = trim(req.getParameter("content")); // 读取并去除内容两端空格
                Integer boardId = extractBoardId(req); // 获取板块 ID

                if (isEmpty(title) || isEmpty(content) || boardId == null) { // 参数校验
                    req.setAttribute("msg", "请填写完整的标题、内容和板块"); // 设置错误提示
                    prepareBoardForm(req, boardId); // 重新准备表单需要的数据
                    req.getRequestDispatcher("/WEB-INF/views/post.jsp").forward(req, resp); // 返回发帖页
                    return; // 结束处理
                }

                int newId = postDao.create(current.getId(), boardId, title, content); // 调用 DAO 创建帖子
                storeLastBoard(req, boardId); // 保存最后选择的板块
                resp.sendRedirect(req.getContextPath()+"/post/detail?id="+newId); // 重定向到新帖详情
                return; // 结束处理
            }

            if ("/delete".equals(path)) { // 处理删除帖子
                int id = parseIntOr404(req.getParameter("id"), resp); // 解析帖子 ID
                if (id < 0) return; // 解析失败时结束

                Map<String,Object> post = postDao.findDetail(id); // 查询帖子详情，确认所属板块
                Integer boardId = null; // 准备保存板块 ID
                if (post != null) { // 如果能查到帖子
                    Object boardObj = post.get("boardId"); // 取出板块字段
                    if (boardObj instanceof Number) { // 检查类型
                        boardId = ((Number) boardObj).intValue(); // 转换成整数
                    }
                }

                boolean ok = postDao.deleteByAuthor(id, current.getId()); // 尝试删除帖子
                if (!ok) { resp.sendError(403, "无法删除：不是作者或帖子不存在"); return; } // 删除失败时返回 403
                if (boardId != null) { // 如果知道所属板块
                    storeLastBoard(req, boardId); // 记录板块 ID
                    resp.sendRedirect(req.getContextPath()+"/post/list?bid="+boardId); // 回到该板块列表
                } else {
                    resp.sendRedirect(req.getContextPath()+"/post/list"); // 否则回到默认列表
                }
                return; // 结束处理
            }

            resp.sendError(404); // 未定义的路径返回 404
        } catch (SQLException e) { // 捕获数据库异常
            if (isConnectionFailure(e)) { // 判断是否为连接问题
                log("数据库连接失败", e); // 记录日志
                handleDatabaseFailure(req, resp, path); // 转发到错误页面或返回错误码
                return; // 结束处理
            }
            throw new ServletException(e); // 其他异常继续抛出
        }
    }

    // ---------- 工具方法区域 ----------
    private int parseIntOr404(String s, HttpServletResponse resp) throws IOException {
        if (s == null) { resp.sendError(404); return -1; } // 参数缺失返回 404
        try { return Integer.parseInt(s); } catch (NumberFormatException e) { resp.sendError(404); return -1; } // 格式不对也返回 404
    }
    private Integer extractBoardId(HttpServletRequest req) {
        String s = req.getParameter("bid"); // 优先尝试读取 bid 参数
        if (s == null || s.trim().isEmpty()) { // 如果没有则尝试 boardId
            s = req.getParameter("boardId");
        }
        if (s == null || s.trim().isEmpty()) { // 仍然没有则返回 null
            return null;
        }
        try {
            return Integer.valueOf(s.trim()); // 转换成整数
        } catch (NumberFormatException e) {
            return null; // 转换失败视为没有提供
        }
    }

    private void prepareBoardForm(HttpServletRequest req, Integer requestedBoardId) throws SQLException {
        List<Map<String, Object>> boards = boardDao.listLeafBoards(); // 加载所有可发帖板块
        req.setAttribute("boards", boards); // 将板块列表放入请求

        Integer selectedId = requestedBoardId; // 初始化默认选中的板块
        if (selectedId == null) { // 如果没有指定
            HttpSession session = req.getSession(false); // 检查会话是否保存过记录
            if (session != null) {
                Object last = session.getAttribute("lastBoardId"); // 读取之前浏览的板块
                if (last instanceof Number) {
                    selectedId = ((Number) last).intValue(); // 使用历史板块作为默认值
                }
            }
        }

        Map<String, Object> selectedBoard = null; // 保存选中的板块对象
        if (selectedId != null) { // 如果有默认板块
            for (Map<String, Object> board : boards) { // 遍历所有板块
                if (Objects.equals(board.get("id"), selectedId)) { // 找到与默认值匹配的板块
                    selectedBoard = board; // 保存该板块
                    break; // 停止遍历
                }
            }
        }

        if (selectedBoard == null && !boards.isEmpty()) { // 如果没有匹配并且列表不为空
            selectedBoard = boards.get(0); // 默认选择第一项
            selectedId = (Integer) selectedBoard.get("id"); // 更新默认 ID
        }

        req.setAttribute("selectedBoardId", selectedId); // 将默认板块 ID 写入请求
        req.setAttribute("selectedBoard", selectedBoard); // 将默认板块对象写入请求
    }

    private void storeLastBoard(HttpServletRequest req, int boardId) {
        HttpSession session = req.getSession(); // 获取会话（若不存在会新建）
        session.setAttribute("lastBoardId", boardId); // 将板块 ID 存入会话
    }
    private boolean isEmpty(String s){ return s==null || s.trim().isEmpty(); } // 判断字符串是否为空
    private String trim(String s){ return s==null? null : s.trim(); } // 安全地去除字符串两端空白

    private void handleDatabaseFailure(HttpServletRequest req, HttpServletResponse resp, String path)
            throws ServletException, IOException {
        req.setAttribute("dbError", true); // 标记存在数据库错误
        req.setAttribute("dbErrorMessage", "暂时无法连接数据库，请稍后再试。"); // 提供错误提示

        if ("/create".equals(path)) { // 如果发帖时出错
            req.setAttribute("msg", req.getAttribute("dbErrorMessage")); // 将错误提示展示给用户
            req.getRequestDispatcher("/WEB-INF/views/post.jsp").forward(req, resp); // 返回发帖页
            return; // 结束处理
        }

        if (path == null || "/".equals(path) || "/list".equals(path)) { // 如果是列表相关请求
            req.getRequestDispatcher("/WEB-INF/views/list.jsp").forward(req, resp); // 转发到列表页
            return; // 结束处理
        }

        resp.sendError(503, "数据库暂时不可用，请稍后再试。"); // 其他情况返回 503
    }

    private boolean isConnectionFailure(Throwable t) {
        while (t != null) { // 遍历异常链
            if (t instanceof java.net.ConnectException) return true; // 网络连接异常
            if (t instanceof java.sql.SQLNonTransientConnectionException) return true; // JDBC 非暂时性连接异常
            String name = t.getClass().getName(); // 读取异常类名
            if (name.contains("CommunicationsException") || name.contains("ConnectionException")) {
                return true; // MySQL 常见的连接问题
            }
            t = t.getCause(); // 查看更深层的原因
        }
        return false; // 未检测到连接故障
    }
}
