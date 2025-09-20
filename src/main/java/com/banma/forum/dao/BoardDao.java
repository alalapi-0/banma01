package com.banma.forum.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

/** 板块数据访问 */
public class BoardDao {

    /** 根据板块 ID 查询板块信息 */
    public Map<String, Object> findById(int bid) throws SQLException {
        final String sql = "SELECT bid, name FROM bankuai WHERE bid=?";
        try (Connection c = DB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, bid);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                Map<String, Object> board = new HashMap<>();
                board.put("id", rs.getInt("bid"));
                board.put("name", rs.getString("name"));
                return board;
            }
        }
    }
}
