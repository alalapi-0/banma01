package com.banma.forum.store;

import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;

public class MemoryStore {

    // ==== 数据模型（补充了构造器与 getter） ====
    public static class User {
        private int id;
        private String username;
        private String password;

        public User() {} // 给反射/工具用
        public User(int id, String username, String password) {
            this.id = id;
            this.username = username;
            this.password = password;
        }

        public int getId() { return id; }
        public String getUsername() { return username; }
        public String getPassword() { return password; }

        @Override public String toString() { return username; }
    }

    public static class Post {
        private int id;
        private int userId;
        private String title;
        private String content;

        public Post() {}
        public Post(int id, int userId, String title, String content) {
            this.id = id; this.userId = userId; this.title = title; this.content = content;
        }

        public int getId() { return id; }
        public int getUserId() { return userId; }
        public String getTitle() { return title; }
        public String getContent() { return content; }
    }

    public static class Comment {
        private int id;
        private int postId;
        private int userId;
        private String content;

        public Comment() {}
        public Comment(int id, int postId, int userId, String content) {
            this.id = id; this.postId = postId; this.userId = userId; this.content = content;
        }

        public int getId() { return id; }
        public int getPostId() { return postId; }
        public int getUserId() { return userId; }
        public String getContent() { return content; }
    }

    // ==== 内存“数据库” ====
    public static final Map<String, User> usersByName = new HashMap<>();
    public static final Map<Integer, User> users = new HashMap<>();
    public static final Map<Integer, Post> posts = new LinkedHashMap<>();
    public static final Map<Integer, List<Comment>> commentsByPost = new HashMap<>();

    private static final AtomicInteger uid = new AtomicInteger(1);
    private static final AtomicInteger pid = new AtomicInteger(1);
    private static final AtomicInteger cid = new AtomicInteger(1);

    // ==== 用户 ====
    public static User createUser(String name, String pwd) {
        if (usersByName.containsKey(name)) return null;
        User u = new User(uid.getAndIncrement(), name, pwd);
        users.put(u.getId(), u);
        usersByName.put(name, u);
        return u;
    }

    public static User findUser(String name) { return usersByName.get(name); }

    // ==== 帖子 ====
    public static Post createPost(int userId, String title, String content) {
        Post p = new Post(pid.getAndIncrement(), userId, title, content);
        posts.put(p.getId(), p);
        return p;
    }

    public static Post getPost(int id) { return posts.get(id); }

    public static List<Post> listPosts() { return new ArrayList<>(posts.values()); }

    // ==== 评论 ====
    public static void addComment(int postId, int userId, String content) {
        Comment c = new Comment(cid.getAndIncrement(), postId, userId, content);
        commentsByPost.computeIfAbsent(postId, k -> new ArrayList<>()).add(c);
    }

    public static List<Comment> listComments(int postId) {
        return commentsByPost.getOrDefault(postId, Collections.emptyList());
    }

    // ==== 删帖（作者权限 + 级联删评论） ====
    public static boolean deletePost(int postId, int userId) {
        Post p = posts.get(postId);
        if (p == null || p.getUserId() != userId) return false;
        posts.remove(postId);
        commentsByPost.remove(postId);
        return true;
    }
}
