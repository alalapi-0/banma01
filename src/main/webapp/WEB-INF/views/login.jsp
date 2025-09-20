<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>登录 - 斑马教育 论坛</title>
    <link rel="stylesheet" href="${ctx}/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/_inc/header.jspf"/>

<div class="panel">
    <div class="hd">登录</div>
    <div class="bd">
        <form class="form" method="post" action="${ctx}/auth/login">
            <c:if test="${not empty requestScope.msg}">
                <div class="tip" style="margin:4px 0 12px;color:#c00;">${msg}</div>
            </c:if>

            <div class="row">
                <label>用户名</label>
                <input type="text" name="username" value="${param.username}" required>
            </div>
            <div class="row">
                <label>密 码</label>
                <input type="password" name="password" required>
            </div>
            <div class="actions">
                <button class="btn" type="submit">登录</button>
                <a class="btn secondary" href="${ctx}/auth/register">去注册</a>
            </div>
        </form>
    </div>
</div>

<jsp:include page="/WEB-INF/views/_inc/footer.jspf"/>
</body>
</html>
