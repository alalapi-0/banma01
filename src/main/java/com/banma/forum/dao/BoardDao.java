package com.banma.forum.dao; // 指定板块数据访问对象所在包

import java.sql.*; // 引入 JDBC 相关类型
import java.util.*; // 引入集合类型，方便封装查询结果
import java.util.logging.Level;
import java.util.logging.Logger;

// BoardDao 负责读取论坛板块的结构和统计信息
public class BoardDao {
    private static final Logger log = Logger.getLogger(BoardDao.class.getName());

    // 查询某个父板块下子板块的统计信息
    public List<Map<String, Object>> listChildrenWithStats(int parentId) throws SQLException {
        String sql = "SELECT b.bid, b.name, COUNT(t.tid) AS topicCount, " +
                "MAX(t.createTime) AS lastPostTime, " +
                "(SELECT t2.tid FROM tiezi t2 WHERE t2.bid = b.bid ORDER BY t2.createTime DESC, t2.tid DESC LIMIT 1) AS lastPostId, " +
                "(SELECT t3.title FROM tiezi t3 WHERE t3.bid = b.bid ORDER BY t3.createTime DESC, t3.tid DESC LIMIT 1) AS lastPostTitle, " +
                "(SELECT u.username FROM tiezi t4 JOIN users u ON u.uid = t4.uid WHERE t4.bid = b.bid ORDER BY t4.createTime DESC, t4.tid DESC LIMIT 1) AS lastPostUser " +
                "FROM bankuai b LEFT JOIN tiezi t ON t.bid = b.bid " +
                "WHERE b.pid = ? GROUP BY b.bid, b.name ORDER BY b.bid"; // 构建统计 SQL

        List<Map<String, Object>> res = new ArrayList<>(); // 准备返回的结果集合
        try (Connection conn = DB.getConnection(); // 获取数据库连接
             PreparedStatement ps = conn.prepareStatement(sql)) { // 准备查询语句
            ps.setInt(1, parentId); // 设置父板块 ID
            try (ResultSet rs = ps.executeQuery()) { // 执行查询
                while (rs.next()) { // 遍历所有子板块
                    Map<String, Object> m = new HashMap<>(); // 为当前行创建 Map 容器
                    m.put("id", rs.getInt("bid")); // 保存子板块 ID
                    m.put("name", rs.getString("name")); // 保存子板块名称
                    m.put("topicCount", rs.getInt("topicCount")); // 保存帖子数量

                    int lastPostId = rs.getInt("lastPostId"); // 读取最新帖子 ID
                    if (rs.wasNull()) { // 如果为 NULL 说明没有帖子
                        m.put("lastPostId", null); // 用 null 标记不存在
                    } else {
                        m.put("lastPostId", lastPostId); // 存在则写入 ID
                    }

                    m.put("lastPostTitle", rs.getString("lastPostTitle")); // 保存最新帖子的标题
                    m.put("lastPostUser", rs.getString("lastPostUser")); // 保存最新帖子的作者
                    Timestamp lastPostTime = rs.getTimestamp("lastPostTime"); // 读取最新发帖时间
                    m.put("lastPostTime", lastPostTime); // 允许为 null，表示没有帖子
                    res.add(m); // 将当前子板块加入结果集
                }
            }
        } catch (SQLException e) {
            log.log(Level.SEVERE, "listChildrenWithStats failed, parentId=" + parentId, e);
            throw e;
        }
        return res; // 返回全部子板块信息
    }

    // 根据板块 ID 查询板块自身和父板块名称
    public Map<String, Object> findById(int boardId) throws SQLException {
        String sql = "SELECT b.bid, b.name, b.pid, p.name AS parentName " +
                "FROM bankuai b LEFT JOIN bankuai p ON b.pid = p.bid WHERE b.bid = ?"; // 查询板块信息
        try (Connection conn = DB.getConnection(); // 获取连接
             PreparedStatement ps = conn.prepareStatement(sql)) { // 准备语句
            ps.setInt(1, boardId); // 设置板块 ID
            try (ResultSet rs = ps.executeQuery()) { // 执行查询
                if (!rs.next()) { // 没有查到任何数据
                    return null; // 返回 null
                }
                Map<String, Object> board = new HashMap<>(); // 创建结果容器
                board.put("id", rs.getInt("bid")); // 写入板块 ID
                board.put("name", rs.getString("name")); // 写入板块名称
                int pid = rs.getInt("pid"); // 读取父板块 ID
                board.put("parentId", rs.wasNull() ? null : pid); // 如果没有父板块则写入 null
                board.put("parentName", rs.getString("parentName")); // 写入父板块名称
                return board; // 返回封装好的结果
            }
        } catch (SQLException e) {
            log.log(Level.SEVERE, "findById failed, boardId=" + boardId, e);
            throw e;
        }
    }

    // 返回所有叶子板块（真正可以发帖的版块）
    public List<Map<String, Object>> listLeafBoards() throws SQLException {
        String sql = "SELECT b.bid, b.name, b.pid, p.name AS parentName " +
                "FROM bankuai b LEFT JOIN bankuai p ON b.pid = p.bid " +
                "WHERE b.pid IS NOT NULL ORDER BY p.bid, b.bid"; // 构造 SQL 查询
        List<Map<String, Object>> res = new ArrayList<>(); // 准备结果列表
        try (Connection conn = DB.getConnection(); // 获取连接
             PreparedStatement ps = conn.prepareStatement(sql); // 准备语句
             ResultSet rs = ps.executeQuery()) { // 立即执行查询
            while (rs.next()) { // 遍历每个叶子板块
                Map<String, Object> board = new HashMap<>(); // 创建容器存放当前行数据
                board.put("id", rs.getInt("bid")); // 写入板块 ID
                board.put("name", rs.getString("name")); // 写入板块名称
                int pid = rs.getInt("pid"); // 读取父板块 ID
                board.put("parentId", rs.wasNull() ? null : pid); // 如果父 ID 为空则存 null
                board.put("parentName", rs.getString("parentName")); // 写入父板块名称
                res.add(board); // 将当前板块加入集合
            }
        } catch (SQLException e) {
            log.log(Level.SEVERE, "listLeafBoards failed", e);
            throw e;
        }
        return res; // 返回所有叶子板块信息
    }
}
