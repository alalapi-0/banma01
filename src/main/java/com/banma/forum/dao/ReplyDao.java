package com.banma.forum.dao; // 指定回复数据访问对象的包位置

import java.sql.*; // 导入 JDBC 相关的接口与类
import java.util.*; // 导入集合类，方便将结果封装为 Map
import java.util.logging.Level;
import java.util.logging.Logger;

// ReplyDao 负责处理帖子回复的增删查操作
public class ReplyDao {
    private static final Logger log = Logger.getLogger(ReplyDao.class.getName());

    // 查询某个帖子下的所有回复，结果包含作者信息
    public List<Map<String,Object>> listByPost(int tid) throws SQLException {
        String sql = "SELECT h.hid, h.content, h.createTime, u.username AS author, h.uid, u.headimage " +
                "FROM huifu h JOIN users u ON u.uid=h.uid " +
                "WHERE h.tid=? ORDER BY h.createTime ASC"; // 构建查询回复的 SQL
        List<Map<String,Object>> list = new ArrayList<>(); // 创建结果列表
        try (Connection c = DB.getConnection(); // 获取数据库连接
             PreparedStatement ps = c.prepareStatement(sql)) { // 准备语句
            ps.setInt(1, tid); // 设置帖子 ID
            try (ResultSet rs = ps.executeQuery()) { // 执行查询
                while (rs.next()) { // 遍历每条回复
                    Map<String,Object> m = new HashMap<>(); // 创建一个 Map 保存当前回复
                    m.put("id", rs.getInt("hid")); // 保存回复 ID
                    m.put("content", rs.getString("content")); // 保存回复内容
                    m.put("createTime", rs.getTimestamp("createTime")); // 保存回复时间
                    m.put("author", rs.getString("author")); // 保存作者名字
                    m.put("authorId", rs.getInt("uid")); // 保存作者 ID
                    String avatar = rs.getString("headimage"); // 读取作者头像
                    m.put("authorAvatar", avatar != null ? avatar : "1.gif"); // 若为空则使用默认头像
                    list.add(m); // 将当前回复加入集合
                }
            }
        } catch (SQLException e) {
            log.log(Level.SEVERE, "listByPost failed, tid=" + tid, e);
            throw e;
        }
        return list; // 返回全部回复
    }

    // 新增一条回复，返回数据库生成的回复 ID
    public int add(int tid, int uid, String content) throws SQLException {
        String sql = "INSERT INTO huifu(content, tid, uid) VALUES (?,?,?)"; // 插入回复的 SQL
        try (Connection c = DB.getConnection(); // 获取连接
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) { // 请求返回主键
            ps.setString(1, content); // 写入回复内容
            ps.setInt(2, tid); // 写入所属帖子 ID
            ps.setInt(3, uid); // 写入回复作者 ID
            ps.executeUpdate(); // 执行插入
            try (ResultSet rs = ps.getGeneratedKeys()) { // 读取自增主键
                return rs.next()? rs.getInt(1):0; // 有主键则返回，没有则返回 0
            }
        } catch (SQLException e) {
            log.log(Level.SEVERE, "add reply failed, tid=" + tid + ", uid=" + uid, e);
            throw e;
        }
    }

    // 根据回复 ID 找到对应的帖子 ID，删除或跳转时会用到
    public Integer findPostId(int replyId) throws SQLException {
        String sql = "SELECT tid FROM huifu WHERE hid=?"; // 查询语句
        try (Connection c = DB.getConnection(); // 获取连接
             PreparedStatement ps = c.prepareStatement(sql)) { // 准备语句
            ps.setInt(1, replyId); // 写入回复 ID
            try (ResultSet rs = ps.executeQuery()) { // 执行查询
                if (rs.next()) { // 找到记录
                    return rs.getInt("tid"); // 返回帖子 ID
                }
                return null; // 没有找到则返回 null
            }
        } catch (SQLException e) {
            log.log(Level.SEVERE, "findPostId failed, replyId=" + replyId, e);
            throw e;
        }
    }

    // 允许帖子作者删除任意回复，使用帖子作者的 UID 作为权限判断
    public boolean deleteByPostOwner(int replyId, int ownerUid) throws SQLException {
        String sql = "DELETE h FROM huifu h JOIN tiezi t ON t.tid=h.tid WHERE h.hid=? AND t.uid=?"; // 删除回复的 SQL
        try (Connection c = DB.getConnection(); // 获取连接
             PreparedStatement ps = c.prepareStatement(sql)) { // 准备语句
            ps.setInt(1, replyId); // 指定要删除的回复 ID
            ps.setInt(2, ownerUid); // 指定帖子的作者 ID
            return ps.executeUpdate() > 0; // 根据受影响行数判断是否成功
        } catch (SQLException e) {
            log.log(Level.SEVERE, "deleteByPostOwner failed, replyId=" + replyId + ", ownerUid=" + ownerUid, e);
            throw e;
        }
    }
}
