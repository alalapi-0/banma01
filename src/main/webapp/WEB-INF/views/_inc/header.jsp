<%-- 告诉 JSP 引擎页面输出 UTF-8 文本，并在编译时使用 UTF-8 --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- 引入 JSTL 核心标签库，以便使用 c:if 等标签 --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- 如果请求域中还没有上下文路径变量，则创建一个 ctx 方便后续引用 --%>
<c:if test="${empty ctx}">
    <c:set var="ctx" value="${pageContext.request.contextPath}" scope="request"/>
</c:if>

<%-- 顶部 Logo 区域，点击后跳转到首页 --%>
<div class="logo-bar">

    <a href="${ctx}/home"><%-- 将 logo 包裹在链接中 --%>
        <img src="${ctx}/assets/images/logo.png" width="123" height="45" alt="斑马学员论坛"><%-- 显示网站 Logo 图片 --%>

    </a>
</div>

<%-- 登录状态条，根据 session 中是否存在 user 展示不同入口 --%>
<div class="h">
    <c:choose>
        <c:when test="${not empty sessionScope.user}"><%-- 已登录用户 --%>
            您好：<strong>${sessionScope.user.username}</strong> &nbsp;|&nbsp;
            <a href="${ctx}/auth/logout">登出</a> |<%-- 提供登出链接 --%>
        </c:when>
        <c:otherwise><%-- 未登录用户 --%>
            您尚未&nbsp;<a href="${ctx}/auth/login">登录</a> &nbsp;|&nbsp;
            <a href="${ctx}/auth/register">注册</a> |<%-- 提供注册入口 --%>
        </c:otherwise>
    </c:choose>
</div>
