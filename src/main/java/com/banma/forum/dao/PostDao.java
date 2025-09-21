package com.banma.forum.dao; // 指定 PostDao 的包位置，方便与其他 DAO 归类

import java.sql.*; // 导入 JDBC 中增删改查需要用到的核心类
import java.util.*; // 导入集合工具类，方便用 Map 和 List 封装结果

// PostDao 负责处理与帖子相关的数据库操作
public class PostDao {

    // 新增帖子，并返回数据库自动生成的帖子 ID
    public int create(int uid, int bid, String title, String content) throws SQLException {
        String sql = "INSERT INTO tiezi(title, content, uid, bid) VALUES (?,?,?,?)"; // 使用占位符准备 SQL
        try (Connection c = DB.getConnection(); // 申请数据库连接
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) { // 请求返回自增主键
            ps.setString(1, title); // 将帖子标题填充到第一个占位符
            ps.setString(2, content); // 将帖子内容填充到第二个占位符
            ps.setInt(3, uid); // 将作者 ID 填充到第三个占位符
            ps.setInt(4, bid); // 将所属板块 ID 填充到第四个占位符
            ps.executeUpdate(); // 执行插入操作
            try (ResultSet rs = ps.getGeneratedKeys()) { // 读取数据库生成的主键
                return rs.next() ? rs.getInt(1) : 0; // 如果存在主键则返回，否则返回 0
            }
        }
    }

    // 查询某个板块下的帖子列表，并分页返回
    public List<Map<String,Object>> listByBoard(int boardId, int offset, int pageSize) throws SQLException {
        String sql = "SELECT t.tid, t.title, t.createTime, u.username AS author, " +
                "(SELECT COUNT(*) FROM huifu h WHERE h.tid=t.tid) AS replyCount " +
                "FROM tiezi t JOIN users u ON u.uid=t.uid " +
                "WHERE t.bid=? ORDER BY t.createTime DESC LIMIT ?,?"; // 拼接 SQL 语句
        List<Map<String,Object>> res = new ArrayList<>(); // 创建结果集合
        try (Connection c = DB.getConnection(); // 获取数据库连接
             PreparedStatement ps = c.prepareStatement(sql)) { // 准备执行查询
            ps.setInt(1, boardId); // 将板块 ID 填充到第一个占位符
            ps.setInt(2, offset); // 指定从第几条数据开始读取
            ps.setInt(3, pageSize); // 指定一次读取多少条数据
            try (ResultSet rs = ps.executeQuery()) { // 执行查询并获取结果集
                while (rs.next()) { // 遍历结果集中的每一行
                    Map<String,Object> m = new HashMap<>(); // 为当前行创建一个 Map
                    m.put("id", rs.getInt("tid")); // 保存帖子 ID
                    m.put("title", rs.getString("title")); // 保存帖子标题
                    m.put("createTime", rs.getTimestamp("createTime")); // 保存发帖时间
                    m.put("author", rs.getString("author")); // 保存作者名称
                    m.put("replyCount", rs.getInt("replyCount")); // 保存回复数量
                    res.add(m); // 将当前帖子信息加入结果列表
                }
            }
        }
        return res; // 返回封装好的帖子列表
    }

    // 根据帖子 ID 查询帖子详情，包括作者和板块信息
    public Map<String,Object> findDetail(int tid) throws SQLException {
        String sql = "SELECT t.tid, t.title, t.content, t.createTime, t.uid, " +
                "u.username AS author, u.headimage AS authorAvatar, b.name AS boardName, b.bid AS boardId " +
                "FROM tiezi t JOIN users u ON u.uid=t.uid " +
                "JOIN bankuai b ON b.bid=t.bid WHERE t.tid=?"; // 构造查询详情的 SQL
        try (Connection c = DB.getConnection(); // 拿到数据库连接
             PreparedStatement ps = c.prepareStatement(sql)) { // 准备查询语句
            ps.setInt(1, tid); // 将帖子 ID 写入查询条件
            try (ResultSet rs = ps.executeQuery()) { // 执行查询
                if (!rs.next()) return null; // 如果没有找到记录，则返回 null
                Map<String,Object> m = new HashMap<>(); // 准备封装详情数据
                m.put("id", rs.getInt("tid")); // 帖子 ID
                m.put("title", rs.getString("title")); // 帖子标题
                m.put("content", rs.getString("content")); // 帖子正文
                m.put("createTime", rs.getTimestamp("createTime")); // 创建时间
                m.put("authorId", rs.getInt("uid")); // 作者 ID
                m.put("author", rs.getString("author")); // 作者名称
                String avatar = rs.getString("authorAvatar"); // 读取作者头像路径
                m.put("authorAvatar", avatar != null ? avatar : "1.gif"); // 如果没有头像则使用默认图
                m.put("boardName", rs.getString("boardName")); // 所属板块名称
                m.put("boardId", rs.getInt("boardId")); // 板块 ID
                return m; // 返回封装好的详情信息
            }
        }
    }

    // 删除帖子：只有作者本人可以删除，顺便删掉回复
    public boolean deleteByAuthor(int tid, int authorUid) throws SQLException {
        String sql = "DELETE t, h FROM tiezi t LEFT JOIN huifu h ON h.tid=t.tid WHERE t.tid=? AND t.uid=?"; // 构造连表删除 SQL
        try (Connection c = DB.getConnection(); // 获取连接
             PreparedStatement ps = c.prepareStatement(sql)) { // 准备执行删除
            ps.setInt(1, tid); // 指定要删除的帖子 ID
            ps.setInt(2, authorUid); // 指定必须匹配的作者 ID
            return ps.executeUpdate() > 0; // 执行删除并根据受影响行数判断是否成功
        }
    }
}
