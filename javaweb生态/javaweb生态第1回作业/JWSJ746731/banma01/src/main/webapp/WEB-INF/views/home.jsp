<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>论坛首页</title>
    <link rel="stylesheet" type="text/css" href="<c:url value='/assets/css/style.css'/>">
</head>
<body>
<div><img src="<c:url value='/assets/images/logo.png'/>" width="123" height="45"></div>

<div class="h">
    <c:choose>
        <c:when test="${not empty sessionScope.user}">
            欢迎你，${sessionScope.user.username} |
            <a href="<c:url value='/auth/logout'/>">退出</a>
        </c:when>
        <c:otherwise>
            您尚未　
            <a href="<c:url value='/auth/login'/>">登录</a> &nbsp;|&nbsp;
            <a href="<c:url value='/auth/register'/>">注册</a>
        </c:otherwise>
    </c:choose>
</div>

<!-- 示例：几个板块入口（先写死，等做数据库后可动态渲染） -->
<h3>板块</h3>
<ul>
    <li><a href="<c:url value='/post/list?boardId=1'/>">Java</a></li>
    <li><a href="<c:url value='/post/list?boardId=2'/>">Web 前端</a></li>
    <li><a href="<c:url value='/post/list?boardId=3'/>">数据库</a></li>
</ul>

<!-- 入口：直接去发帖（默认某个板块） -->
<p>
    <a class="btn" href="<c:url value='/post/new?boardId=1'/>">发布新帖</a>
</p>
</body>
</html>
