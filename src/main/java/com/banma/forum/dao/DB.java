package com.banma.forum.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public final class DB {
    private static final Logger log = Logger.getLogger(DB.class.getName());

    private static final String URL = System.getProperty("DB_URL",
        "jdbc:mysql://127.0.0.1:3306/banma_forum?useSSL=false&characterEncoding=UTF-8&serverTimezone=UTC");
    private static final String USER = System.getProperty("DB_USER", "root");
    private static final String PASS = System.getProperty("DB_PASS", "root");

    static {
        try {
            Class.forName(System.getProperty("DB_DRIVER", "com.mysql.cj.jdbc.Driver"));
        } catch (ClassNotFoundException e) {
            throw new IllegalStateException("JDBC driver not found", e);
        }
    }

    private DB() {
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }

    public static void closeQuietly(AutoCloseable c) {
        if (c != null) {
            try {
                c.close();
            } catch (Exception e) {
                log.log(Level.WARNING, "closeQuietly failed", e);
            }
        }
    }

    public static void beginTx(Connection c) throws SQLException {
        if (c != null) {
            c.setAutoCommit(false);
        }
    }

    public static void commit(Connection c) {
        if (c != null) {
            try {
                c.commit();
            } catch (SQLException e) {
                log.log(Level.WARNING, "commit failed", e);
            }
        }
    }

    public static void rollback(Connection c) {
        if (c != null) {
            try {
                c.rollback();
            } catch (SQLException e) {
                log.log(Level.WARNING, "rollback failed", e);
            }
        }
    }

    /*
    // 可选升级：启用 HikariCP 连接池
    private static final boolean USE_POOL = "on".equalsIgnoreCase(System.getProperty("DB_POOL"));
    private static final HikariDataSource DS;

    static {
        if (USE_POOL) {
            HikariConfig config = new HikariConfig();
            config.setJdbcUrl(URL);
            config.setUsername(USER);
            config.setPassword(PASS);
            config.setDriverClassName(System.getProperty("DB_DRIVER", "com.mysql.cj.jdbc.Driver"));
            DS = new HikariDataSource(config);
        } else {
            DS = null;
        }
    }

    public static Connection getConnection() throws SQLException {
        if (USE_POOL && DS != null) {
            return DS.getConnection();
        }
        return DriverManager.getConnection(URL, USER, PASS);
    }
    */
}
