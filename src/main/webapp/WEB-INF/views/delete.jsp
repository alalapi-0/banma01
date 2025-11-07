<%-- 设置页面编码 --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- 引入 JSTL 核心标签 --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- 计算上下文路径 --%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3c.org/TR/1999/REC-html401-19991224/loose.dtd">
<html>
<head>
    <!-- 页面标题 -->
    <title>确认删除帖子</title>
    <!-- 指定内容类型 -->
    <meta charset="UTF-8">
    <!-- 引入通用样式 -->
    <link rel="stylesheet" type="text/css" href="<c:url value='/static/css/main.css'/>?v=<%= System.currentTimeMillis() %>">
</head>
<body>
<%-- 引入统一页头 --%>
<%@ include file="/WEB-INF/views/_inc/header.jsp" %>
<div style="width:960px;margin:20px auto;">
    <h3>确认删除</h3>
    <p>确定要删除帖子：<strong>${post.title}</strong> ？该操作不可恢复。</p>
    <form action="${ctx}/post/delete" method="post">
        <input type="hidden" name="id" value="${post.id}">
        <button type="submit" class="btn danger">确认删除</button>
        <a class="btn" href="${ctx}/post/detail?id=${post.id}">取消</a>
    </form>
</div>
<%-- 引入统一页脚 --%>
<%@ include file="/WEB-INF/views/_inc/footer.jsp" %>
</body>
</html>
