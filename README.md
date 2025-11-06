# 斑马学员论坛项目综述

本仓库记录了一个通过多轮 Prompt 辅助搭建的 **Servlet + JSP + JDBC** 传统 Java Web 论坛示例。项目从最初的骨架逐步完善，已经具备登录、注册、发帖、回帖、删帖、删回复等核心功能，并补充了详尽的环境检测工具与中文注释说明，方便零基础的同学理解整个运行流程。本 README 会从技术栈、环境准备、迭代历史、代码结构、运行步骤、请求执行轨迹等角度对当前状态进行完整总结。

## 1. 当前状态与演进过程回顾

1. **初始阶段**：根据 Servlet WebApp 原型创建项目骨架，完成 Maven 基础配置并引入 Servlet/JSP/MySQL 依赖。
2. **功能搭建阶段**：按功能划分完成 DAO、Servlet、JSP 视图的编写，实现帖子与回复的 CRUD 逻辑，并补全 `web.xml`、资源文件等配置。
3. **体验提升阶段**：引入环境自检程序 `EnvironmentCheckApplication`，通过 `EncodingFilter` 解决中文编码问题，完善 JSP 中的标签使用与样式展示。
4. **文档与注释阶段**：在所有源码中增加中文注释，对 README 进行细致扩写，确保任何读者都能从环境搭建到运行调试完整走通项目。

## 2. 技术栈一览

- **后端框架**：原生 Servlet + JSP + JSTL。
- **数据访问层**：JDBC、PreparedStatement、MySQL。
- **构建工具**：Apache Maven。
- **运行容器**：Apache Tomcat 或任何兼容 Servlet 3.0 的容器。
- **辅助工具**：`EnvironmentCheckApplication` 用于启动前检测环境是否满足运行条件。
- **数据库**：MySQL 8.x，配合 `forum_schema.sql` 初始化示例数据。
- **前端技术**：JSP 模板 + 原生 HTML/CSS，使用 JSTL 标签进行动态渲染。

## 3. 环境准备清单

| 组件 | 建议版本 | 说明 |
| ---- | -------- | ---- |
| JDK | 1.8 及以上 | `mvn`、Tomcat 均依赖 JDK，请通过 `java -version` 检查 |
| Maven | 3.6+ | 负责依赖下载与构建 |
| MySQL | 8.x | 存储论坛数据，运行 `forum_schema.sql` 可快速初始化 |
| Servlet 容器 | Tomcat 8+ | 部署 WAR 包或以 IDE 内置 Tomcat 运行 |
| IDE（可选） | IntelliJ IDEA / Eclipse | 便于代码阅读与调试 |

额外推荐安装 `mysql` 命令行客户端（或图形工具）以执行 SQL 脚本。

## 4. 项目结构速览

```
banma01/
├── pom.xml                     # Maven 项目描述文件，声明依赖与插件
├── README.md                   # 当前总结文档
├── src/
│   ├── main/java/              # Java 源码（Servlet、DAO、过滤器、实体、工具）
│   │   └── com/banma/forum/
│   │       ├── EnvironmentCheckApplication.java  # 环境自检入口
│   │       ├── controller/                       # 各类 Servlet 控制器
│   │       ├── dao/                              # 数据访问对象集合
│   │       ├── filter/                           # 统一编码过滤器
│   │       └── model/                            # 实体类
│   ├── main/resources/         # 配置文件与 SQL 脚本
│   └── main/webapp/            # JSP 视图、静态资源、web.xml
└── target/                     # Maven 构建输出目录（执行构建后出现）
```

核心包职责说明：

- `com.banma.forum.controller`：`HomeServlet`、`PostServlet`、`AuthServlet`、`CommentServlet` 负责处理 HTTP 请求并调用 DAO 层完成业务流程。
- `com.banma.forum.dao`：封装所有数据库操作，包括 `DB` 工具类、`UserDao`、`PostDao`、`BoardDao`、`ReplyDao` 等。
- `com.banma.forum.filter`：`EncodingFilter` 统一设置请求与响应字符集。
- `com.banma.forum.model`：目前包含 `User` 实体，存放在 Session 中的用户信息。
- `src/main/webapp/WEB-INF/views`：所有 JSP 视图文件，使用 JSTL 标签渲染动态数据。

## 5. 运行前的环境体检（可选但推荐）

执行 `EnvironmentCheckApplication` 可快速确认本机是否满足最低要求：

```bash
mvn -q exec:java -Dexec.mainClass="com.banma.forum.EnvironmentCheckApplication"
```

它会检查 JDK、Maven、网络连通性、`JAVA_HOME`、MySQL JDBC 驱动等信息，并给出 PASS/FAIL/WARN 报告。

## 6. 从零搭建与运行的完整步骤

1. **克隆或下载本仓库**
   ```bash
   git clone https://example.com/banma01.git
   cd banma01
   ```

2. **安装依赖并编译**
   ```bash
   mvn clean package
   ```
   Maven 会下载所有依赖，生成 `target/banma01.war`。

3. **初始化数据库**
   - 在 MySQL 中执行 `src/main/resources/sql/forum_schema.sql`。
   - 脚本会创建 `banma_forum` 数据库及 `users`、`bankuai`、`tiezi`、`huifu` 等表，并插入示例数据。

4. **配置数据库连接**
   - 修改 `src/main/resources/jdbc.properties` 中的 `jdbc.url`、`jdbc.user`、`jdbc.password` 与实际环境一致。

5. **部署到 Tomcat**
   - 将 `target/banma01.war` 拷贝到 Tomcat `webapps/` 目录，或在 IDE 中添加 Tomcat 运行配置。
   - 启动 Tomcat，等待日志提示应用启动完成。

6. **访问项目**
   - 浏览器打开 `http://localhost:8080/banma01/`，自动转发至 `/home`。
   - 使用示例账号 `accp/123456` 登录，即可体验发帖、回帖等功能。

> 若部署在其他端口或上下文路径，请将上述 URL 中的端口、上下文进行相应调整。

## 7. 项目功能与使用指南

| 功能 | 使用入口 | 用户操作流程 |
| ---- | -------- | ------------ |
| 首页浏览 | `/home` | 展示各技术分类下的子板块，若数据库无数据则显示静态示例 |
| 板块帖子列表 | `/post/list?bid=板块ID` | 查看指定板块的帖子，支持从首页点击跳转 |
| 帖子详情 | `/post/detail?id=帖子ID` | 展示正文与回复列表，同时提供回复表单 |
| 发帖 | `/post/new` 页面 + `/post/create` 提交 | 登录后填写标题、内容、所属板块即可创建新帖 |
| 删帖 | `/post/delete?id=帖子ID` | 仅作者本人可访问确认页面并执行删除操作 |
| 添加回复 | `/comment/add` | 登录后在详情页填写回复内容提交 |
| 删除回复 | `/comment/delete?id=回复ID` | 帖子的作者可删除任意回复 |
| 登录/退出 | `/auth/login`、`/auth/logout` | 使用示例账号登录；退出会清除 Session |
| 注册 | `/auth/register` | 填写用户名、密码、性别、头像后创建新账号 |

所有功能页面都在 `WEB-INF/views` 目录下对应的 JSP 中实现，控制器负责准备数据，JSP 只负责展示。

## 8. 代码执行流程详解（按功能分解）

### 8.1 应用启动

1. Tomcat 读取 `web.xml`，注册 `EncodingFilter` 与四个 Servlet。
2. 访问根路径 `/` 时，`index.jsp` 立即通过 `<jsp:forward>` 将请求转发到 `/home`。
3. `EncodingFilter#doFilter` 在所有请求进入 Servlet 之前设置 UTF-8 编码。

### 8.2 首页 `HomeServlet`

1. `HomeServlet#doGet` 依次调用 `BoardDao#listChildrenWithStats`，查询 `.NET`、`Java`、`数据库`、`兴趣` 四个分类的子板块数据。
2. 若数据库连接失败，捕获异常并在请求中写入 `dbError` 标记与提示文案。
3. 请求被转发到 `home.jsp`，根据是否存在 `dbError` 决定显示动态数据或静态示例。

### 8.3 帖子功能 `PostServlet`

#### 列表展示
1. `doGet` 中当 `path` 为 `/list` 时，从查询参数中读取 `bid`。
2. 调用 `BoardDao#findById` 校验板块是否存在且为叶子节点。
3. 调用 `PostDao#listByBoard` 获取帖子列表并传递给 `list.jsp`。
4. 记录最近访问的板块 ID，便于下次发帖默认选择。

#### 发帖
1. 当 `path` 为 `/new` 时先调用 `prepareBoardForm` 准备板块下拉列表，转发到 `post.jsp`。
2. `doPost` 中 `path` 为 `/create` 时读取表单的标题、内容、板块 ID。
3. 校验参数后调用 `PostDao#create` 写入数据库，获取新帖 ID。
4. 重定向到 `/post/detail?id=新帖ID`。

#### 帖子详情
1. `path` 为 `/detail` 时，根据 `id` 查询帖子详情 `PostDao#findDetail`。
2. 同时调用 `ReplyDao#listByPost` 加载回复列表。
3. 将数据传递给 `post_detail.jsp` 展示。

#### 删除帖子
1. `path` 为 `/delete` 且为 GET 请求时，加载帖子详情，校验当前用户是否作者。
2. 转发到 `delete.jsp` 显示确认页面。
3. POST 请求 `/post/delete` 时再次校验并调用 `PostDao#deleteByAuthor` 删除帖子及其回复。

### 8.4 回复功能 `CommentServlet`

1. POST `/comment/add`：读取帖子 ID 与内容，调用 `ReplyDao#add` 保存，随后重定向回帖子详情页。
2. POST `/comment/delete`：根据回复 ID 查询帖子 ID，校验当前用户是否该帖作者，调用 `ReplyDao#deleteByPostOwner` 删除。

### 8.5 登录与注册 `AuthServlet`

1. GET `/auth/login` 或 `/auth/register`：分别转发到登录或注册 JSP。
2. POST `/auth/login`：读取用户名密码，调用 `UserDao#findByName` 校验，成功后将 `User` 放入 Session。
3. POST `/auth/register`：检查用户名是否重复，补齐默认性别和头像，调用 `UserDao#createUser` 写入数据库，成功后自动登录。
4. GET `/auth/logout`：销毁 Session，重定向回首页。

### 8.6 统一编码 `EncodingFilter`

1. 对每次请求调用 `setCharacterEncoding("UTF-8")`，保证表单参数不会乱码。
2. 在响应未设置 `Content-Type` 时补充 `text/html;charset=UTF-8`。

## 9. 常见问题与排查建议

- **页面出现乱码**：确认 `EncodingFilter` 已映射到 `/*`，并检查 JSP 顶部的 `pageEncoding` 设置。
- **数据库连接失败**：核对 `jdbc.properties`、MySQL 服务状态，以及 `mysql-connector-j` 版本与 MySQL 服务器兼容。
- **构建失败或依赖下载缓慢**：可以使用 `mvn -U clean package` 强制更新依赖，必要时配置国内镜像。
- **登录失败**：示例数据中密码为明文 `123456`；若自行实现加密需同步调整登录验证逻辑。
- **权限错误**：删帖/删回复的权限判断发生在 Servlet 中，请确认当前登录用户是否满足条件。

## 10. 后续扩展方向

- 引入 `BCryptPasswordEncoder` 进行密码加密存储。
- 增加分页、搜索、置顶、积分等论坛常见功能。
- 结合前端框架（如 Vue、React）重构 JSP 层，实现前后端分离。
- 将项目迁移到 Spring MVC 或 Spring Boot，对比配置与开发效率的差异。

通过本 README 与源码中的中文注释，你可以从零基础逐步了解 Java Web 论坛的开发流程，祝学习愉快！
