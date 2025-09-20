package com.banma.forum.controller;

import com.banma.forum.dao.BoardDao;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Collections;

public class HomeServlet extends HttpServlet {
    private final BoardDao boardDao = new BoardDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("netBoards", boardDao.listChildrenWithStats(1));
            req.setAttribute("javaBoards", boardDao.listChildrenWithStats(6));
            req.setAttribute("dbBoards", boardDao.listChildrenWithStats(11));
            req.setAttribute("funBoards", boardDao.listChildrenWithStats(14));
        } catch (SQLException e) {
            if (isConnectionFailure(e)) {
                log("数据库连接失败", e);
                req.setAttribute("dbError", true);
                req.setAttribute("dbErrorMessage", "暂时无法连接数据库，请稍后再试。");
                req.setAttribute("netBoards", Collections.emptyList());
                req.setAttribute("javaBoards", Collections.emptyList());
                req.setAttribute("dbBoards", Collections.emptyList());
                req.setAttribute("funBoards", Collections.emptyList());
            } else {
                throw new ServletException(e);
            }
        }

        req.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(req, resp);
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
