-- 创建 banma_forum 数据库（如果不存在），并指定字符集为 utf8mb4 以完整支持中文与 emoji
CREATE DATABASE IF NOT EXISTS banma_forum
    DEFAULT CHARACTER SET utf8mb4
    COLLATE utf8mb4_0900_ai_ci;

-- 选择刚刚创建的数据库供后续语句使用
USE banma_forum;

-- 确认客户端与服务器的通讯字符集为 utf8mb4，避免插入中文时出现乱码
SET NAMES utf8mb4;

-- --------------------------------
-- 定义板块信息表 bankuai
-- --------------------------------
DROP TABLE IF EXISTS `bankuai`; -- 如果已存在则先删除，方便重新初始化
CREATE TABLE `bankuai` (
    `bid` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '板块编号',
    `name` VARCHAR(64) NOT NULL COMMENT '板块名称',
    `pid` INT UNSIGNED NULL DEFAULT NULL COMMENT '父级板块ID',
    PRIMARY KEY (`bid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='板块表';

-- 插入演示用的板块层级数据，含主分类与子板块
INSERT INTO `bankuai`(bid,name,pid) VALUES
    (1,'.NET技术',NULL),
    (2,'C#语言',1),
    (3,'WinForms',1),
    (4,'ADO.NET',1),
    (5,'ASP.NET',1),
    (6,'Java技术',NULL),
    (7,'Java基础',6),
    (8,'JSP技术',6),
    (9,'Servlet技术',6),
    (10,'Eclipse应用',6),
    (11,'数据库技术',NULL),
    (12,'SQL Server基础',11),
    (13,'SQL Server高级',11),
    (14,'娱乐',NULL),
    (15,'灌水乐园',14);

-- --------------------------------
-- 定义回复表 huifu，用于存储帖子下的每条评论
-- --------------------------------
DROP TABLE IF EXISTS `huifu`;
CREATE TABLE `huifu` (
    `hid` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '回复ID',
    `content` TEXT NOT NULL COMMENT '回复内容',
    `tid` INT UNSIGNED NOT NULL COMMENT '帖子ID',
    `uid` INT UNSIGNED NOT NULL COMMENT '回复用户ID',
    `createTime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '回复时间',
    `updateTime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    PRIMARY KEY (`hid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='帖子回复表';

-- --------------------------------
-- 定义帖子表 tiezi，保存帖子主题及正文
-- --------------------------------
DROP TABLE IF EXISTS `tiezi`;
CREATE TABLE `tiezi` (
    `tid` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '帖子ID',
    `title` VARCHAR(100) NOT NULL COMMENT '帖子标题',
    `createTime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发帖时间',
    `updateTime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    `content` MEDIUMTEXT COMMENT '帖子内容',
    `uid` INT UNSIGNED NOT NULL COMMENT '发帖人ID',
    `bid` INT UNSIGNED NOT NULL COMMENT '所属板块ID',
    PRIMARY KEY (`tid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='帖子详情表';

-- --------------------------------
-- 定义用户表 users，存放账号信息
-- --------------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
    `uid` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '用户ID',
    `username` VARCHAR(32) NOT NULL UNIQUE COMMENT '用户名',
    `password` VARCHAR(255) NOT NULL COMMENT '密码',
    `sex` ENUM('男','女','保密') DEFAULT '保密' COMMENT '性别',
    `headimage` VARCHAR(255) NOT NULL DEFAULT '1.gif' COMMENT '用户头像',
    `createTime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
    PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户信息表';

-- 插入示例用户数据，便于开发时直接登录测试
INSERT INTO `users`(uid, username, password, sex, headimage, createTime) VALUES
    (1,'accp','123456','保密','1.gif','2007-07-01 09:00:00'),
    (2,'goodman','123456','保密','2.gif','2007-07-10 09:00:00'),
    (3,'aptech','123456','保密','3.gif','2007-07-20 09:00:00'),
    (4,'qq','123456','保密','4.gif','2007-09-01 09:00:00'),
    (5,'class','123456','保密','5.gif','2007-07-18 09:00:00');

-- 插入示例帖子数据，方便本地调试展示效果
INSERT INTO `tiezi`(tid, title, content, createTime, updateTime, uid, bid) VALUES
    (20,'你好！','示例帖子内容，欢迎回复。','2007-06-20 09:00:00','2007-06-20 09:00:00',2,2),
    (24,'C#语言测试帖6','示例帖子内容，欢迎回复。','2007-06-24 09:00:00','2007-06-24 09:00:00',2,2),
    (25,'C#语言测试帖7','示例帖子内容，欢迎回复。','2007-06-25 09:00:00','2007-06-25 09:00:00',2,2),
    (26,'C#语言测试帖8','示例帖子内容，欢迎回复。','2007-06-26 09:00:00','2007-06-26 09:00:00',2,2),
    (27,'C#语言测试帖9','示例帖子内容，欢迎回复。','2007-06-27 09:00:00','2007-06-27 09:00:00',2,2),
    (28,'C#语言测试帖10','示例帖子内容，欢迎回复。','2007-06-28 09:00:00','2007-06-28 09:00:00',2,2),
    (29,'C#语言测试帖11','示例帖子内容，欢迎回复。','2007-06-29 09:00:00','2007-06-29 09:00:00',2,2),
    (30,'C#语言测试帖12','示例帖子内容，欢迎回复。','2007-06-30 09:00:00','2007-06-30 09:00:00',2,2),
    (31,'C#语言测试帖13','示例帖子内容，欢迎回复。','2007-07-01 09:00:00','2007-07-01 09:00:00',2,2),
    (32,'C#语言测试帖14','示例帖子内容，欢迎回复。','2007-07-02 09:00:00','2007-07-02 09:00:00',2,2),
    (33,'C#语言测试帖15','示例帖子内容，欢迎回复。','2007-07-03 09:00:00','2007-07-03 09:00:00',2,2),
    (80,'C#语言 问题集锦1','示例帖子内容，欢迎回复。','2007-07-10 09:00:00','2007-07-10 09:00:00',2,2),
    (81,'C#语言 问题集锦2','示例帖子内容，欢迎回复。','2007-07-11 09:00:00','2007-07-11 09:00:00',2,2),
    (82,'C#语言 问题集锦3','示例帖子内容，欢迎回复。','2007-07-12 09:00:00','2007-07-12 09:00:00',2,2),
    (91,'JSP论坛测试','示例帖子内容，欢迎回复。','2007-07-20 09:00:00','2007-07-20 09:00:00',1,2),
    (92,'JSP论坛测试','示例帖子内容，欢迎回复。','2007-07-20 10:00:00','2007-07-20 10:00:00',5,2),
    (94,'','示例帖子内容，欢迎回复。','2007-07-30 08:33:00','2007-07-30 08:33:00',2,4),
    (95,'大家不好','示例帖子内容，欢迎回复。','2007-07-22 09:00:00','2007-07-22 09:00:00',2,2),
    (98,'c#是一门很好的语言','示例帖子内容，欢迎回复。','2007-07-24 09:00:00','2007-07-24 09:00:00',2,2),
    (99,'c#是微软开发的语言','示例帖子内容，欢迎回复。','2007-07-24 10:00:00','2007-07-24 10:00:00',2,2),
    (100,'c#是微软开发的语言','示例帖子内容，欢迎回复。','2007-07-30 10:25:00','2007-07-30 10:25:00',1,2),
    (101,'谁帮我看看我的程序','示例帖子内容，欢迎回复。','2007-07-30 10:27:00','2007-07-30 10:27:00',1,3),
    (102,'我是新手，我刚开始学习Java','示例帖子内容，欢迎回复。','2007-07-30 10:29:00','2007-07-30 10:29:00',3,7),
    (103,'这段SQL错在哪了?','示例帖子内容，欢迎回复。','2007-07-30 10:30:00','2007-07-30 10:30:00',3,12),
    (104,'这段代码是什么意思','示例帖子内容，欢迎回复。','2007-07-30 10:31:00','2007-07-30 10:31:00',3,5),
    (107,'这段sql有什么问题','示例帖子内容，欢迎回复。','2007-08-09 10:12:00','2007-08-09 10:12:00',3,13),
    (111,'你好','示例帖子内容，欢迎回复。','2007-09-27 14:33:00','2007-09-27 14:33:00',4,8),
    (113,'你好','示例帖子内容，欢迎回复。','2007-09-27 15:09:00','2007-09-27 15:09:00',1,15);
