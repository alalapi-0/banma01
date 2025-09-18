<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>斑马学员论坛--注册</title>
    <link rel="stylesheet" type="text/css" href="<c:url value='/assets/css/style.css'/>">
    <script>
        function checkRegister() {
            var f = document.forms['regForm'];
            if (!f.username.value) { alert('用户名不能为空'); return false; }
            if (!f.password.value) { alert('密码不能为空'); return false; }
            // 如需确认密码：if (f.password.value !== f.confirm.value) { alert('两次密码不一致'); return false; }
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
    <c:out value="JSTL OK"/>

</div>
<br>

<div>&gt;&gt;<b><a href="<c:url value='/'/>">论坛首页</a></b></div>

<div class="t" align="center" style="margin-top:15px">
    <form name="regForm" method="post" action="<c:url value='/auth/register'/>" onsubmit="return checkRegister()">
        <br> 用户名 &nbsp;
        <input class="input" tabindex="1" maxlength="20" size="35" type="text" name="username">
        <br> 密　码 &nbsp;
        <input class="input" tabindex="2" maxlength="20" size="40" type="password" name="password">
        <!-- 如果老师素材有性别/头像等字段，也可在此加对应 input，后端按需读取 -->
        <br>
        <input class="btn" tabindex="6" value="注 册" type="submit">
    </form>
</div>

<br>
<center class="gray">2018 Tokyo Banma education Co.,Ltd 版权所有</center>
</body>
</html>
