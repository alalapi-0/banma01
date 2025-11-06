package com.banma.forum.controller; // 指定 Servlet 所在的包

import com.banma.forum.dao.UserDao; // 引入用户数据访问对象以便进行登录注册操作
import com.banma.forum.model.User; // 引入用户实体以在会话中存储

import javax.servlet.ServletException; // 导入 Servlet 异常类型
import javax.servlet.http.*; // 导入 HTTP Servlet 相关的类
import java.io.IOException; // 导入 IO 异常类型

// AuthServlet 负责处理登录、注册与退出逻辑，对应 URL /auth/*
public class AuthServlet extends HttpServlet {
    private UserDao userDao = new UserDao(); // 创建数据访问对象实例，复用进行数据库操作

    @Override // 覆写父类的 doGet 以处理页面展示和退出
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo(); // 取得 /auth 后面的子路径
        if (path == null || "/login".equals(path)) { // 未指定路径或访问 /login
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp); // 转发到登录页面
        } else if ("/register".equals(path)) { // 访问注册页面
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp); // 转发到注册页面
        } else if ("/logout".equals(path)) { // 请求退出登录
            HttpSession s = req.getSession(false); // 如果存在会话就取出
            if (s != null) s.invalidate(); // 销毁会话完成退出
            resp.sendRedirect(req.getContextPath() + "/"); // 回到网站首页
        } else { // 其他未识别的路径
            resp.sendError(404); // 返回 404 状态码
        }
    }

    @Override // 覆写父类的 doPost 以处理表单提交
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getPathInfo(); // 获取请求的子路径判断操作类型
        try { // 依据 action 分支执行登录或注册逻辑
            if ("/login".equals(action)) { // 处理登录
                String u = req.getParameter("username"); // 读取用户名
                String p = req.getParameter("password"); // 读取密码
                User user = userDao.findByName(u); // 根据用户名查询数据库
                if (user != null && user.getPassword().equals(p)) { // 验证用户存在且密码匹配
                    req.getSession(true).setAttribute("user", user); // 登录成功后写入 session
                    resp.sendRedirect(req.getContextPath() + "/"); // 跳转回首页
                } else { // 登录失败
                    req.setAttribute("msg", "登录失败：用户名或密码不正确"); // 携带错误提示
                    req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp); // 返回登录页
                }
            } else if ("/register".equals(action)) { // 处理注册
                String u = req.getParameter("username"); // 读取注册用户名
                String p = req.getParameter("password"); // 读取注册密码
                User exist = userDao.findByName(u); // 检查用户名是否已存在
                if (exist != null) { // 若存在
                    req.setAttribute("msg", "用户名已存在"); // 设置提示信息
                    req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp); // 返回注册页面
                    return; // 结束注册流程
                }
                String gender = req.getParameter("gender"); // 读取性别
                if (gender == null || gender.trim().isEmpty()) { // 如果性别为空
                    gender = "保密"; // 使用默认值
                }
                String avatar = req.getParameter("avatar"); // 读取头像
                if (avatar == null || avatar.trim().isEmpty()) { // 如果未提供头像
                    avatar = "1.gif"; // 使用默认头像
                }
                User user = userDao.createUser(u, p, gender, avatar); // 创建新用户
                if (user == null) { // 如果创建失败
                    req.setAttribute("msg", "注册失败，请稍后重试"); // 设置提示
                    req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp); // 返回注册页
                    return; // 结束处理
                }
                req.getSession(true).setAttribute("user", user); // 注册成功后自动登录
                resp.sendRedirect(req.getContextPath() + "/"); // 跳转回首页
            } else { // 其他未定义的动作
                resp.sendError(404); // 返回 404 状态
            }
        } catch (Exception e) { // 捕获数据访问层可能抛出的异常
            throw new ServletException(e); // 包装成 ServletException 交给容器处理
        }
    }
}
