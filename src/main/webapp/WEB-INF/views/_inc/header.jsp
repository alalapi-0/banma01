<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${empty ctx}">
    <c:set var="ctx" value="${pageContext.request.contextPath}" scope="request"/>
</c:if>

<!-- 顶部 Logo -->
<div class="logo-bar">
    <img src="${ctx}/assets/images/logo.png" width="123" height="45" alt="斑马学员论坛">
</div>

<!-- 登录/注册/登出状态条 -->
<div class="h">
    <c:choose>
        <c:when test="${not empty sessionScope.user}">
            您好：<strong>${sessionScope.user.username}</strong> &nbsp;|&nbsp;
            <a href="${ctx}/auth/logout">登出</a> |
        </c:when>
        <c:otherwise>
            您尚未&nbsp;<a href="${ctx}/auth/login">登录</a> &nbsp;|&nbsp;
            <a href="${ctx}/auth/register">注册</a> |
        </c:otherwise>
    </c:choose>
</div>
