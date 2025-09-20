<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>注册 - 斑马教育 论坛</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<%@ include file="/WEB-INF/views/_inc/header.jspf" %>

<div class="panel">
    <div class="hd">注册</div>
    <div class="bd">
        <form class="form" method="post" action="${pageContext.request.contextPath}/auth/register">
            <c:if test="${not empty requestScope.msg}">
                <div class="tip" style="margin:4px 0 12px;color:#c00;"><c:out value="${msg}"/></div>
            </c:if>
            <div class="row">
                <label>用户名</label>
                <input type="text" name="username" required>
            </div>
            <div class="row">
                <label>密 码</label>
                <input type="password" name="password" required>
            </div>
            <div class="row">
                <label>重复密码</label>
                <input type="password" name="repassword" required>
            </div>
            <div class="row">
                <label>性 别</label>
                <label style="margin-right:12px;"><input type="radio" name="sex" value="女"> 女</label>
                <label style="margin-right:12px;"><input type="radio" name="sex" value="男"> 男</label>
                <label><input type="radio" name="sex" value="保密" checked> 保密</label>
            </div>

            <div class="row" style="align-items:flex-start;">
                <label>选择头像</label>
                <div class="avatars">
                    <c:forEach var="i" begin="1" end="15">
                        <label class="avatar">
                            <input type="radio" name="headimage" value="/assets/images/${i}.gif" <c:if test="${i==1}">checked</c:if> />
                            <img src="${pageContext.request.contextPath}/assets/images/${i}.gif" alt="头像${i}">
                        </label>
                    </c:forEach>
                </div>
            </div>

            <div class="actions" style="margin-left:80px;">
                <button class="btn" type="submit">注册</button>
            </div>
        </form>
    </div>
</div>

<%@ include file="/WEB-INF/views/_inc/footer.jspf" %>
</body>
</html>
