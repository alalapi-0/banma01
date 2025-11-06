package com.banma.forum.controller; // 指定首页 Servlet 所在包

import com.banma.forum.dao.BoardDao; // 引入板块数据访问对象以读取板块列表

import javax.servlet.*; // 导入 Servlet API
import javax.servlet.http.*; // 导入 HTTP Servlet 基类
import java.io.IOException; // 导入 IO 异常
import java.sql.SQLException; // 导入 SQL 异常
import java.util.Collections; // 导入集合工具类以便提供空列表

// HomeServlet 用于渲染论坛首页
public class HomeServlet extends HttpServlet {
    private final BoardDao boardDao = new BoardDao(); // 初始化 BoardDao 用于读取板块数据

    @Override // 覆写 doGet 响应首页请求
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try { // 从数据库加载各类板块的统计信息
            req.setAttribute("netBoards", boardDao.listChildrenWithStats(1)); // 读取 .NET 板块信息
            req.setAttribute("javaBoards", boardDao.listChildrenWithStats(6)); // 读取 Java 板块信息
            req.setAttribute("dbBoards", boardDao.listChildrenWithStats(11)); // 读取数据库板块信息
            req.setAttribute("funBoards", boardDao.listChildrenWithStats(14)); // 读取兴趣板块信息
        } catch (SQLException e) { // 捕获数据库异常
            if (isConnectionFailure(e)) { // 判断是否为连接失败
                log("数据库连接失败", e); // 记录日志
                req.setAttribute("dbError", true); // 视图中需要显示错误提醒
                req.setAttribute("dbErrorMessage", "暂时无法连接数据库，请稍后再试。"); // 提示信息
                req.setAttribute("netBoards", Collections.emptyList()); // 视图中使用空列表避免报错
                req.setAttribute("javaBoards", Collections.emptyList()); // 同上
                req.setAttribute("dbBoards", Collections.emptyList()); // 同上
                req.setAttribute("funBoards", Collections.emptyList()); // 同上
            } else { // 如果异常类型不是连接问题
                throw new ServletException(e); // 继续向上抛出让容器处理
            }
        }

        req.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(req, resp); // 转发到 JSP 渲染页面，用户得以看到首页
    }

    // 遍历异常链判断是否由数据库连接问题引起
    private boolean isConnectionFailure(Throwable t) {
        while (t != null) { // 循环查看每一层 cause
            if (t instanceof java.net.ConnectException) return true; // Socket 连接错误
            if (t instanceof java.sql.SQLNonTransientConnectionException) return true; // JDBC 连接不可用
            String name = t.getClass().getName(); // 读取异常类名
            if (name.contains("CommunicationsException") || name.contains("ConnectionException")) {
                return true; // 常见的 MySQL 通信异常
            }
            t = t.getCause(); // 查看更深层的原因
        }
        return false; // 未发现连接异常
    }
}
