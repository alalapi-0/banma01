package com.banma.forum.dao; // 将数据库帮助类放在 dao 包中

import java.sql.*; // 引入 JDBC 相关的接口和实现类
import java.util.Properties; // 引入 Properties 用于加载外部配置

// DB 类负责集中管理数据库连接的创建逻辑
public class DB {
    // 保存数据库连接的 URL、用户名、密码和驱动类名
    private static String URL, USER, PWD, DRIVER;

    // 静态代码块在类第一次被加载时执行，用来初始化数据库配置
    static {
        try {
            Properties p = new Properties(); // 创建 Properties 容器
            // 通过类加载器读取 classpath 下的 jdbc.properties 文件
            p.load(DB.class.getClassLoader().getResourceAsStream("jdbc.properties"));
            URL = p.getProperty("jdbc.url"); // 读取数据库连接地址
            USER = p.getProperty("jdbc.user"); // 读取数据库用户名
            PWD = p.getProperty("jdbc.password"); // 读取数据库密码
            DRIVER = p.getProperty("jdbc.driver"); // 读取 JDBC 驱动类名
            Class.forName(DRIVER); // 显式加载驱动类，确保驱动注册到 DriverManager
        } catch (Exception e) {
            // 如果配置文件缺失或驱动加载失败，则抛出运行时异常提醒开发者
            throw new RuntimeException("加载数据库配置失败", e);
        }
    }

    // 对外提供获取数据库连接的方法，调用者记得使用后关闭连接
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PWD); // 使用事先读取的配置创建连接
    }
}
