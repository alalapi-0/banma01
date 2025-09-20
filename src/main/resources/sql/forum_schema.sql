-- 建库（如果你已经有库，可以跳过这一句）
CREATE DATABASE IF NOT EXISTS banma_forum
    DEFAULT CHARACTER SET utf8mb4
    COLLATE utf8mb4_0900_ai_ci;

-- 切换数据库
USE banma_forum;

-- 保证字符集
SET NAMES utf8mb4;

-- -------------------------------
-- 表结构
-- -------------------------------

-- 板块表
DROP TABLE IF EXISTS `bankuai`;
CREATE TABLE `bankuai` (
                           `bid` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '板块编号',
                           `name` VARCHAR(64) NOT NULL COMMENT '板块名称',
                           `pid` INT UNSIGNED NULL DEFAULT NULL COMMENT '父级板块ID',
                           PRIMARY KEY (`bid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='板块表';

-- 初始化数据
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

-- 回复表
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

-- 帖子表
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

-- 用户表（user 是关键字，改名为 users）
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
                         `uid` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '用户ID',
                         `username` VARCHAR(32) NOT NULL UNIQUE COMMENT '用户名',
                         `password` VARCHAR(255) NOT NULL COMMENT '密码',
                         `sex` ENUM('男','女','保密') DEFAULT '保密' COMMENT '性别',
                         `headimage` VARCHAR(255) DEFAULT NULL COMMENT '用户头像',
                         `createTime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
                         PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户信息表';
