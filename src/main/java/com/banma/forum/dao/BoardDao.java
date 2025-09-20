package com.banma.forum.dao;

import java.sql.*;
import java.util.*;

/**
 * 板块数据访问：查询每个子板块的帖子统计
 */
public class BoardDao {

    /**
     * 查询某个父板块下所有子板块的帖子统计信息。
     * 返回的 Map key 与 JSP 中使用的属性名保持一致：
     * id, name, topicCount, lastPostId, lastPostTitle, lastPostUser, lastPostTime
     */
    public List<Map<String, Object>> listChildrenWithStats(int parentId) throws SQLException {
        String sql = "SELECT b.bid, b.name, COUNT(t.tid) AS topicCount, " +
                "MAX(t.createTime) AS lastPostTime, " +
                "(SELECT t2.tid FROM tiezi t2 WHERE t2.bid = b.bid ORDER BY t2.createTime DESC, t2.tid DESC LIMIT 1) AS lastPostId, " +
                "(SELECT t3.title FROM tiezi t3 WHERE t3.bid = b.bid ORDER BY t3.createTime DESC, t3.tid DESC LIMIT 1) AS lastPostTitle, " +
                "(SELECT u.username FROM tiezi t4 JOIN users u ON u.uid = t4.uid WHERE t4.bid = b.bid ORDER BY t4.createTime DESC, t4.tid DESC LIMIT 1) AS lastPostUser " +
                "FROM bankuai b LEFT JOIN tiezi t ON t.bid = b.bid " +
                "WHERE b.pid = ? GROUP BY b.bid, b.name ORDER BY b.bid";

        List<Map<String, Object>> res = new ArrayList<>();
        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, parentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> m = new HashMap<>();
                    m.put("id", rs.getInt("bid"));
                    m.put("name", rs.getString("name"));
                    m.put("topicCount", rs.getInt("topicCount"));

                    int lastPostId = rs.getInt("lastPostId");
                    if (rs.wasNull()) {
                        m.put("lastPostId", null);
                    } else {
                        m.put("lastPostId", lastPostId);
                    }

                    m.put("lastPostTitle", rs.getString("lastPostTitle"));
                    m.put("lastPostUser", rs.getString("lastPostUser"));
                    Timestamp lastPostTime = rs.getTimestamp("lastPostTime");
                    m.put("lastPostTime", lastPostTime);
                    res.add(m);
                }
            }
        }
        return res;
    }
}
