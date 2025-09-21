package com.banma.forum.model; // 声明该类所在的包路径，保证与文件夹结构一致

// 该类描述数据库 user 表中的一行记录
public class User {
    // id 字段保存用户在数据库中的主键编号
    private int id;
    // username 字段保存用户的登录名
    private String username;
    // password 字段保存已经加密过的密码
    private String password;
    // gender 字段保存用户的性别信息
    private String gender;
    // avatar 字段保存头像图片的访问路径
    private String avatar;

    // 返回当前对象的主键编号
    public int getId() {
        return id; // 直接返回成员变量 id
    }

    // 为当前对象设置主键编号
    public void setId(int id) {
        this.id = id; // 使用 this 关键字将方法参数写入成员变量
    }

    // 返回当前对象的用户名
    public String getUsername() {
        return username; // 直接返回成员变量 username
    }

    // 为当前对象写入用户名
    public void setUsername(String username) {
        this.username = username; // 保存传入的用户名
    }

    // 返回当前对象的密码哈希
    public String getPassword() {
        return password; // 直接返回成员变量 password
    }

    // 写入密码哈希值
    public void setPassword(String password) {
        this.password = password; // 将加密后的密码保存下来
    }

    // 返回当前对象记录的性别
    public String getGender() {
        return gender; // 返回成员变量 gender
    }

    // 更新性别字段
    public void setGender(String gender) {
        this.gender = gender; // 将传入的性别字符串保存
    }

    // 返回头像图片路径
    public String getAvatar() {
        return avatar; // 返回成员变量 avatar
    }

    // 写入头像路径
    public void setAvatar(String avatar) {
        this.avatar = avatar; // 保存传入的头像地址
    }
}
