package com.banma.forum.dao;

import java.sql.*;
import java.util.*;

/**
 * 帖子数据访问：对应表 tiezi / users / huifu
 * 说明：
 * - 返回 Map<String,Object> 以减少你新增 model 类的工作量
 * - Map 的 key 与 JSP 中使用的 EL 名称保持一致
 */
public class PostDao {

    /** 发帖：返回新帖 tid */
    public int create(int uid, int bid, String title, String content) throws SQLException {
        String sql = "INSERT INTO tiezi(title, content, uid, bid) VALUES (?,?,?,?)";
        try (Connection c = DB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, title);
            ps.setString(2, content);
            ps.setInt(3, uid);
            ps.setInt(4, bid);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    /** 列表：按板块筛选，含作者与回复数，时间倒序 */
    public List<Map<String,Object>> listByBoard(int boardId, int offset, int pageSize) throws SQLException {
        String sql = "SELECT t.tid, t.title, t.createTime, u.username AS author, " +
                "(SELECT COUNT(*) FROM huifu h WHERE h.tid=t.tid) AS replyCount " +
                "FROM tiezi t JOIN users u ON u.uid=t.uid " +
                "WHERE t.bid=? ORDER BY t.createTime DESC LIMIT ?,?";
        List<Map<String,Object>> res = new ArrayList<>();
        try (Connection c = DB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, boardId);
            ps.setInt(2, offset);
            ps.setInt(3, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String,Object> m = new HashMap<>();
                    m.put("id", rs.getInt("tid"));
                    m.put("title", rs.getString("title"));
                    m.put("createTime", rs.getTimestamp("createTime"));
                    m.put("author", rs.getString("author"));
                    m.put("replyCount", rs.getInt("replyCount"));
                    res.add(m);
                }
            }
        }
        return res;
    }

    /** 详情：含作者名、作者ID、板块名 */
    public Map<String,Object> findDetail(int tid) throws SQLException {
        String sql = "SELECT t.tid, t.title, t.content, t.createTime, t.uid, " +
                "u.username AS author, u.headimage AS authorAvatar, b.name AS boardName, b.bid AS boardId " +
                "FROM tiezi t JOIN users u ON u.uid=t.uid " +
                "JOIN bankuai b ON b.bid=t.bid WHERE t.tid=?";
        try (Connection c = DB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, tid);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                Map<String,Object> m = new HashMap<>();
                m.put("id", rs.getInt("tid"));
                m.put("title", rs.getString("title"));
                m.put("content", rs.getString("content"));
                m.put("createTime", rs.getTimestamp("createTime"));
                m.put("authorId", rs.getInt("uid"));
                m.put("author", rs.getString("author"));
                String avatar = rs.getString("authorAvatar");
                m.put("authorAvatar", avatar != null ? avatar : "1.gif");
                m.put("boardName", rs.getString("boardName"));
                m.put("boardId", rs.getInt("boardId"));
                return m;
            }
        }
    }

    /** 只有作者本人可删；同时清理帖子下的回复 */
    public boolean deleteByAuthor(int tid, int authorUid) throws SQLException {
        String sql = "DELETE t, h FROM tiezi t LEFT JOIN huifu h ON h.tid=t.tid WHERE t.tid=? AND t.uid=?";
        try (Connection c = DB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, tid);
            ps.setInt(2, authorUid);
            return ps.executeUpdate() > 0;
        }
    }
}
