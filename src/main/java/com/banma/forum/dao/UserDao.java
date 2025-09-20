package com.banma.forum.dao;

import com.banma.forum.model.User;

import java.sql.*;

public class UserDao {
    private Connection getConn() throws SQLException {
        return DB.getConnection();
    }

    /** 根据用户名查找用户 */
    public User findByName(String username) throws Exception {
        final String sql = "SELECT uid, username, password, sex, headimage FROM users WHERE username = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("uid"));
                    u.setUsername(rs.getString("username"));
                    u.setPassword(rs.getString("password"));
                    String gender = rs.getString("sex");
                    u.setGender(gender != null ? gender : "保密");
                    String avatar = rs.getString("headimage");
                    u.setAvatar(avatar != null ? avatar : "1.gif");
                    return u;
                }
                return null;
            }
        }
    }

    /** 创建用户（注册） */
    public User createUser(String username, String pwd, String gender, String avatar) throws Exception {
        if (gender == null || gender.trim().isEmpty()) {
            gender = "保密";
        }
        if (avatar == null || avatar.trim().isEmpty()) {
            avatar = "1.gif";
        }
        final String sql = "INSERT INTO users(username, password, sex, headimage, createTime) VALUES(?,?,?,?,NOW())";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, username);
            ps.setString(2, pwd);
            ps.setString(3, gender);
            ps.setString(4, avatar);
            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        User u = new User();
                        u.setId(rs.getInt(1));
                        u.setUsername(username);
                        u.setPassword(pwd);
                        u.setGender(gender);
                        u.setAvatar(avatar);
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
