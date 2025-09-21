package com.banma.forum.dao; // 指定用户数据访问对象所在的包

import com.banma.forum.model.User; // 引入用户实体类，方便封装查询结果

import java.sql.*; // 导入 JDBC 相关的接口和类

// UserDao 负责读写 users 表中的数据
public class UserDao {
    // 提供一个私有方法统一创建数据库连接
    private Connection getConn() throws SQLException {
        return DB.getConnection(); // 复用 DB 工具类提供的连接方法
    }

    // 按用户名查询用户信息，如果不存在则返回 null
    public User findByName(String username) throws Exception {
        final String sql = "SELECT uid, username, password, sex, headimage FROM users WHERE username = ?"; // 预定义 SQL
        try (Connection conn = getConn(); // 获取数据库连接
             PreparedStatement ps = conn.prepareStatement(sql)) { // 准备执行语句
            ps.setString(1, username); // 将用户名写入占位符
            try (ResultSet rs = ps.executeQuery()) { // 执行查询
                if (rs.next()) { // 如果查询到记录
                    User u = new User(); // 创建用户实体
                    u.setId(rs.getInt("uid")); // 写入用户主键
                    u.setUsername(rs.getString("username")); // 写入用户名
                    u.setPassword(rs.getString("password")); // 写入密码哈希
                    String gender = rs.getString("sex"); // 读取性别字段
                    u.setGender(gender != null ? gender : "保密"); // 若为空则设置默认值
                    String avatar = rs.getString("headimage"); // 读取头像字段
                    u.setAvatar(avatar != null ? avatar : "1.gif"); // 若为空则使用默认头像
                    return u; // 返回封装好的用户对象
                }
                return null; // 没有查到记录时返回 null
            }
        }
    }

    // 创建新用户，用于注册场景，成功时返回完整的用户对象
    public User createUser(String username, String pwd, String gender, String avatar) throws Exception {
        if (gender == null || gender.trim().isEmpty()) { // 如果没有提供性别
            gender = "保密"; // 使用默认值
        }
        if (avatar == null || avatar.trim().isEmpty()) { // 如果没有提供头像
            avatar = "1.gif"; // 使用默认头像
        }
        final String sql = "INSERT INTO users(username, password, sex, headimage, createTime) VALUES(?,?,?,?,NOW())"; // 插入 SQL
        try (Connection conn = getConn(); // 获取连接
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) { // 请求返回主键
            ps.setString(1, username); // 设置用户名
            ps.setString(2, pwd); // 设置密码哈希
            ps.setString(3, gender); // 设置性别
            ps.setString(4, avatar); // 设置头像路径
            int rows = ps.executeUpdate(); // 执行插入操作
            if (rows > 0) { // 如果插入成功
                try (ResultSet rs = ps.getGeneratedKeys()) { // 读取生成的主键
                    if (rs.next()) { // 如果确实返回了主键
                        User u = new User(); // 创建返回的用户对象
                        u.setId(rs.getInt(1)); // 写入数据库生成的 ID
                        u.setUsername(username); // 保存用户名
                        u.setPassword(pwd); // 保存密码哈希
                        u.setGender(gender); // 保存性别
                        u.setAvatar(avatar); // 保存头像
                        return u; // 返回刚注册的用户
                    }
                }
            }
            return null; // 走到这里说明插入失败或未返回主键
        } catch (SQLIntegrityConstraintViolationException dup) { // 捕获唯一约束异常
            return null; // 用户名重复时返回 null 表示注册失败
        }
    }
}
