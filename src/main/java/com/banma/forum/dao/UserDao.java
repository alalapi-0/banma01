package com.banma.forum.dao;

import com.banma.forum.model.User;

import java.sql.*;

public class UserDao {
    // 建议抽成常量，避免每次拼接字符串
    private static final String URL =
            "jdbc:mysql://127.0.0.1:3306/banma_forum"
                    + "?useUnicode=true"
                    + "&characterEncoding=UTF-8"     // JDBC 端用 UTF-8
                    + "&useSSL=false"
                    + "&serverTimezone=Asia/Shanghai"
                    + "&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASS = "alalapi";

    private Connection getConn() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(URL, USER, PASS);
    }

    /** 根据用户名查找用户 */
    public User findByName(String username) throws Exception {
        final String sql = "SELECT uid, username, password FROM users WHERE username = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("uid"));
                    u.setUsername(rs.getString("username"));
                    u.setPassword(rs.getString("password"));
                    return u;
                }
                return null;
            }
        }
    }

    /** 创建用户（注册） */
    public User createUser(String username, String pwd) throws Exception {
        // createTime 列有默认值，这里不写也行：INSERT (username, password) VALUES(?,?)
        final String sql = "INSERT INTO users(username, password, createTime) VALUES(?,?,NOW())";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, username);
            ps.setString(2, pwd);
            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        User u = new User();
                        u.setId(rs.getInt(1));
                        u.setUsername(username);
                        u.setPassword(pwd);
                        return u;
                    }
                }
            }
            return null;
        } catch (SQLIntegrityConstraintViolationException dup) {
            // 违反唯一约束（用户名重复）
            return null;
        }
    }
}
