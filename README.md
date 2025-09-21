# 斑马学员论坛项目学习笔记

本仓库包含一个使用 **Servlet + JSP + JDBC** 开发的传统 Java Web 论坛示例。为了方便学习，仓库中的每个源码文件几乎都加入了逐行注释，帮助你快速理解每一段代码的作用。本说明文档则补充了整体结构、环境搭建步骤，以及从零开始创建并运行项目的完整流程。

## 项目结构速览

```
banma01/
├── pom.xml                     # Maven 配置，定义依赖与插件
├── README.md                   # 当前学习说明
├── src/
│   ├── main/java/              # Java 源码（Servlet、DAO、过滤器、实体）
│   ├── main/resources/         # 数据库配置、建表 SQL
│   └── main/webapp/            # JSP 视图与静态资源
└── ...
```

核心 Java 包划分如下：

- `com.banma.forum.controller`：包含 `HomeServlet`、`PostServlet`、`AuthServlet`、`CommentServlet`，负责 HTTP 请求处理与流程控制。
- `com.banma.forum.dao`：包含 `DB`、`UserDao`、`PostDao`、`BoardDao`、`ReplyDao`，封装数据库访问逻辑。
- `com.banma.forum.filter`：包含 `EncodingFilter`，统一解决请求与响应编码问题。
- `com.banma.forum.model`：目前仅有 `User` 实体类，用来在 Session 中存储用户信息。

## 搭建环境与运行项目的完整步骤

下面的步骤展示了如果你从零开始搭建此项目，可以依次完成的操作。每一步都给出了必要的命令或注意事项，确保能够成功跑通整个示例。

1. **准备基础开发环境**
   - 安装 JDK 8（建议 1.8 以上）。可通过 `java -version` 检查。
   - 安装 Apache Maven（3.6+）。可通过 `mvn -version` 检查。
   - 安装 MySQL 8，并确保可以通过命令行或图形工具连接数据库。

2. **创建 Maven Web 项目骨架**
   - 在命令行执行：
     ```bash
     mvn archetype:generate -DgroupId=com.banma -DartifactId=banma01 -DarchetypeArtifactId=maven-archetype-webapp -DinteractiveMode=false
     ```
   - 进入项目目录 `cd banma01`，此时 Maven 会生成基本目录结构。

3. **配置 `pom.xml`**
   - 设置 `groupId`、`artifactId`、`version`、`packaging` 等基本信息。
   - 在 `<dependencies>` 中加入 Servlet API、JSTL、MySQL 驱动、Spring Security Crypto（用于密码哈希）以及 JUnit。
   - 在 `<build>` 中配置 `maven-compiler-plugin`（Java 8 编译）与 `maven-resources-plugin`（统一资源编码）。

4. **整理目录结构**
   - 确保存在以下目录：
     - `src/main/java`：放置 Java 源码。
     - `src/main/resources`：放置配置与 SQL 脚本。
     - `src/main/webapp`：放置 JSP、静态资源与 `WEB-INF`。

5. **添加数据库访问工具类与 DAO**
   - 在 `src/main/java/com/banma/forum/dao` 下创建：
     - `DB.java`：读取 `jdbc.properties`，通过 `DriverManager` 获取连接。
     - `UserDao`、`PostDao`、`BoardDao`、`ReplyDao`：封装对应的 CRUD 操作。

6. **编写实体类**
   - 在 `com.banma.forum.model` 包中创建 `User` 类，包含 id、username、password、gender、avatar 等字段及 getter/setter。

7. **编写过滤器与 Servlet**
   - `EncodingFilter`：在 `doFilter` 中设置请求与响应编码为 UTF-8。
   - `HomeServlet`：查询板块数据并转发至首页。
   - `PostServlet`：负责发帖、列表、详情、删除的全部逻辑。
   - `CommentServlet`：处理新增回复与删除回复。
   - `AuthServlet`：处理登录、注册、退出，操作 `UserDao`。

8. **准备 JSP 视图**
   - 在 `src/main/webapp/WEB-INF/views` 下编写 JSP：`home.jsp`、`post.jsp`、`list.jsp`、`post_detail.jsp`、`delete.jsp`、`login.jsp`、`register.jsp`，以及公共的 `_inc/header.jsp`、`_inc/footer.jsp`。
   - 在 JSP 中使用 JSTL 标签实现条件渲染与循环，展示 DAO 返回的数据。

9. **配置 `web.xml`**
   - 注册 `EncodingFilter` 并映射到 `/*`。
   - 为每个 Servlet 指定 `<servlet>` 与 `<servlet-mapping>`，例如 `/home`、`/post/*`、`/auth/*`、`/comment/*`。
   - 设置 `welcome-file` 为 `index.jsp`，并在 `index.jsp` 内部转发到 `/home`。

10. **配置数据库连接与初始化脚本**
    - 在 `src/main/resources/jdbc.properties` 中写入数据库地址、用户名、密码、驱动类。
    - 在 `src/main/resources/sql/forum_schema.sql` 准备建库建表脚本，内含基础演示数据。

11. **初始化数据库**
    - 登录 MySQL 后执行脚本：
      ```bash
      mysql -u root -p < src/main/resources/sql/forum_schema.sql
      ```
    - 确认 `banma_forum` 数据库中生成了 `users`、`tiezi`、`huifu`、`bankuai` 等表与示例数据。

12. **导入项目到 IDE（可选）**
    - 使用 IntelliJ IDEA 或 Eclipse 作为 Maven 项目导入，确认依赖能够正确下载。

13. **构建项目**
    - 在命令行执行：
      ```bash
      mvn clean package
      ```
    - 生成的 `banma01.war` 会出现在 `target/` 目录。

14. **部署到 Servlet 容器**
    - 使用 Apache Tomcat 8+，将 `target/banma01.war` 拷贝到 Tomcat 的 `webapps` 目录。
    - 启动 Tomcat，等待 `localhost:8080/banma01` 可访问。

15. **体验功能**
    - 访问 `http://localhost:8080/banma01/`，默认跳转到首页。
    - 使用 `users` 表中的示例账号（如 `accp/123456`）登录，体验发帖、回复、删除等功能。

16. **后续扩展建议**
    - 将明文密码改为 `BCryptPasswordEncoder` 加密存储。
    - 为分页、搜索、权限等功能编写更多 DAO 与 Servlet。
    - 引入前端框架或 Vue/React 重构 JSP 页面。

## 请求处理流程概览

1. 浏览器请求 `/home` → `HomeServlet` 查询板块列表 → 转发到 `home.jsp` 渲染。
2. 用户点击某个板块，访问 `/post/list?bid=xx` → `PostServlet#doGet` 读取帖子列表 → `list.jsp` 显示帖子。
3. 点击帖子标题访问 `/post/detail?id=xx` → `PostServlet` 加载帖子详情和回复 → `post_detail.jsp` 展示。
4. 登录、注册请求 `/auth/login` 或 `/auth/register` → `AuthServlet#doPost` 与 `UserDao` 交互 → 成功后重定向到首页。
5. 发表帖子 `/post/create` 或删除帖子 `/post/delete` → `PostServlet#doPost` 调用 `PostDao` 持久化。
6. 回复帖子 `/comment/add` 或删除回复 `/comment/delete` → `CommentServlet` 操作 `ReplyDao` 完成 CRUD。
7. 所有请求在到达 Servlet 前都会通过 `EncodingFilter`，确保 UTF-8 编码一致。

## 常见问题排查

- **页面出现乱码**：确认 `EncodingFilter` 已注册且浏览器访问路径经过过滤器；检查 JSP 顶部的 `pageEncoding`。
- **数据库连接失败**：检查 `jdbc.properties` 与实际 MySQL 账号一致，并确认 `mysql-connector-j` 版本兼容。
- **构建失败**：运行 `mvn -U clean package` 以强制更新依赖；确认 JDK 版本为 1.8。
- **登录失败**：示例数据中的密码仍为明文 `123456`；若你修改了密码存储方式，需要同步调整校验逻辑。

## 进一步学习建议

- 阅读 `PostServlet` 与各个 DAO 的逐行注释，弄清楚 JDBC 与 Servlet 的协作方式。
- 试着使用 `PreparedStatement` 手写新的查询或分页逻辑。
- 将 JSP 中的重复布局抽离成标签文件或使用模板引擎（如 Thymeleaf）。
- 引入 Spring MVC / Spring Boot 重构项目，比较配置与代码结构的差异。

希望这些注释与文档能帮助你全面掌握该项目的实现细节与运行流程，祝学习顺利！
