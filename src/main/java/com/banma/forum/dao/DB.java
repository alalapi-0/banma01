package com.banma.forum.dao;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

public final class DB {
    private static final Logger log = Logger.getLogger(DB.class.getName());

    private static final Properties CONFIG = loadConfig();
    private static final String URL = System.getProperty("DB_URL",
        CONFIG.getProperty("jdbc.url",
            "jdbc:mysql://127.0.0.1:3306/banma_forum?useSSL=false&characterEncoding=UTF-8&serverTimezone=UTC"));
    private static final String USER = System.getProperty("DB_USER",
        CONFIG.getProperty("jdbc.user", "root"));
    private static final String PASS = System.getProperty("DB_PASS",
        CONFIG.getProperty("jdbc.password", "root"));
    private static final String DRIVER = System.getProperty("DB_DRIVER",
        CONFIG.getProperty("jdbc.driver", "com.mysql.cj.jdbc.Driver"));

    static {
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            throw new IllegalStateException("JDBC driver not found", e);
        }
    }

    private DB() {
    }

    private static Properties loadConfig() {
        Properties props = new Properties();
        try (InputStream in = DB.class.getClassLoader().getResourceAsStream("jdbc.properties")) {
            if (in != null) {
                props.load(in);
            } else {
                log.fine("jdbc.properties not found on classpath, using defaults");
            }
        } catch (IOException e) {
            log.log(Level.WARNING, "Failed to load jdbc.properties, using defaults", e);
        }
        return props;
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
