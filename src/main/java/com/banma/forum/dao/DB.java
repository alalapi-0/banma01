package com.banma.forum.dao;

import java.sql.*;
import java.util.Properties;

public class DB {
    private static String URL, USER, PWD, DRIVER;

    static {
        try {
            Properties p = new Properties();
            p.load(DB.class.getClassLoader().getResourceAsStream("jdbc.properties"));
            URL = p.getProperty("jdbc.url");
            USER = p.getProperty("jdbc.user");
            PWD = p.getProperty("jdbc.password");
            DRIVER = p.getProperty("jdbc.driver");
            Class.forName(DRIVER);
        } catch (Exception e) {
            throw new RuntimeException("加载数据库配置失败", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PWD);
    }


}
