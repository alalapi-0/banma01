<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>斑马学员论坛--登录</title>
    <link rel="stylesheet" type="text/css" href="<c:url value='/assets/css/style.css'/>">
    <script>
        function checkLogin() {
            var f = document.forms['loginForm'];
            if (!f.username.value) { alert('用户名不能为空'); return false; }
            if (!f.password.value) { alert('密码不能为空'); return false; }
            return true;
        }
    </script>
</head>
<body>
<div><img src="<c:url value='/assets/images/logo.png'/>" width="123" height="45"></div>

<div class="h">
    您尚未　
    <a href="<c:url value='/auth/login'/>">登录</a> &nbsp;|&nbsp;
    <a href="<c:url value='/auth/register'/>">注册</a> |
</div>
<br>

<div>&gt;&gt;<b><a href="<c:url value='/'/>">论坛首页</a></b></div>

<div class="t" align="center" style="margin-top:15px">
    <form name="loginForm" method="post" action="<c:url value='/auth/login'/>" onsubmit="return checkLogin()">
        <br> 用户名 &nbsp;
        <input class="input" tabindex="1" maxlength="20" size="35" type="text" name="username">
        <br> 密　码 &nbsp;
        <input class="input" tabindex="2" maxlength="20" size="40" type="password" name="password">
        <br>
        <input class="btn" tabindex="6" value="登 录" type="submit">
    </form>
</div>

<br>
<center class="gray">2018 Tokyo Banma education Co.,Ltd 版权所有</center>
</body>
</html>
