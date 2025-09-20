package com.banma.forum.dao;

import java.sql.*;
import java.util.*;

/** 回复数据访问：对应表 huifu / users */
public class ReplyDao {

    /** 获取某帖的所有回复（含作者与作者ID） */
    public List<Map<String,Object>> listByPost(int tid) throws SQLException {
        String sql = "SELECT h.hid, h.content, h.createTime, u.username AS author, h.uid " +
                "FROM huifu h JOIN users u ON u.uid=h.uid " +
                "WHERE h.tid=? ORDER BY h.createTime ASC";
        List<Map<String,Object>> list = new ArrayList<>();
        try (Connection c = DB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, tid);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String,Object> m = new HashMap<>();
                    m.put("id", rs.getInt("hid"));
                    m.put("content", rs.getString("content"));
                    m.put("createTime", rs.getTimestamp("createTime"));
                    m.put("author", rs.getString("author"));
                    m.put("authorId", rs.getInt("uid"));
                    list.add(m);
                }
            }
        }
        return list;
    }

    /** 新增回复（供 CommentServlet 使用；这里先给出以便你后续接上） */
    public int add(int tid, int uid, String content) throws SQLException {
        String sql = "INSERT INTO huifu(content, tid, uid) VALUES (?,?,?)";
        try (Connection c = DB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, content);
            ps.setInt(2, tid);
            ps.setInt(3, uid);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                return rs.next()? rs.getInt(1):0;
            }
        }
    }
}
