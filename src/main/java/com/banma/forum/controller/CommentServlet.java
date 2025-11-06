package com.banma.forum.controller; // 指定评论相关 Servlet 所在的包

import com.banma.forum.dao.ReplyDao; // 引入回复数据访问对象，用于增删回复
import com.banma.forum.model.User; // 引入用户实体类以读取当前登录用户

import javax.servlet.ServletException; // 导入 Servlet 异常
import javax.servlet.http.*; // 导入 HTTP Servlet 基础类
import java.io.IOException; // 导入 IO 异常
import java.sql.SQLException; // 导入数据库异常

// CommentServlet 处理添加与删除回复的 POST 请求
public class CommentServlet extends HttpServlet {
    private final ReplyDao replyDao = new ReplyDao(); // 初始化数据访问对象

    @Override // 覆写 doPost 处理表单提交
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false); // 尝试获取现有会话
        User u = session != null ? (User) session.getAttribute("user") : null; // 从会话中读取当前用户
        if (u == null) { resp.sendRedirect(req.getContextPath()+"/auth/login"); return; } // 未登录则重定向到登录页
        String path = req.getPathInfo(); // 获取操作路径，例如 /add
        try { // 依据子路径执行新增或删除回复逻辑
            if ("/add".equals(path)) { // 处理新增回复
                int postId = Integer.parseInt(req.getParameter("postId")); // 解析帖子 ID
                String content = req.getParameter("content"); // 读取回复内容
                replyDao.add(postId, u.getId(), content); // 调用 DAO 写入数据库
                resp.sendRedirect(req.getContextPath()+"/post/detail?id="+postId); // 操作完成后回到帖子详情
                return; // 结束处理
            }

            if ("/delete".equals(path)) { // 处理删除回复
                int replyId = Integer.parseInt(req.getParameter("id")); // 解析回复 ID
                Integer postId = replyDao.findPostId(replyId); // 查询该回复属于哪个帖子
                if (postId == null) { // 没有找到对应帖子
                    resp.sendError(404, "回复不存在"); // 返回 404 提示
                    return; // 结束处理
                }
                boolean ok = replyDao.deleteByPostOwner(replyId, u.getId()); // 检查是否为帖子作者并删除
                if (!ok) { // 删除失败说明没有权限
                    resp.sendError(403, "无权限删除该回复"); // 返回 403 状态
                    return; // 结束处理
                }
                resp.sendRedirect(req.getContextPath()+"/post/detail?id="+postId); // 删除成功后回到帖子详情
                return; // 结束处理
            }

            resp.sendError(404); // 未匹配到的路径返回 404
        } catch (NumberFormatException e) { // 捕获数字格式异常
            resp.sendError(400, "请求参数不合法"); // 返回 400 状态
        } catch (SQLException e) { // 捕获数据库访问异常
            throw new ServletException(e); // 包装成 ServletException 交给容器
        }
    }
}
