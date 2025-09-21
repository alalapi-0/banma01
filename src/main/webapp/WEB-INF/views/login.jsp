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
    <title>斑马学员论坛--登录</title>
    <!-- 指定内容类型 -->
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <!-- 引入通用样式 -->
    <link rel="stylesheet" type="text/css" href="${ctx}/assets/css/style.css">
    <script type="text/javascript">
        // 登录表单的简单校验
        function check() {
            if (document.loginForm.username.value === "") {
                alert("用户名不能为空");
                return false;
            }
            if (document.loginForm.password.value === "") {
                alert("密码不能为空");
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
<%-- 引入统一页头 --%>
<%@ include file="/WEB-INF/views/_inc/header.jsp" %>
<div class="nav">&gt;&gt;<b><a href="${ctx}/">论坛首页</a></b></div>
<%-- 如果存在后台提示信息则显示 --%>
<c:if test="${not empty msg}">
    <div class="notice">${msg}</div>
</c:if>
<div class="t" align="center" style="margin-top:15px;">
    <form name="loginForm" method="post" action="${ctx}/auth/login" onsubmit="return check();">
        <br>用户名 &nbsp;<input class="input" tabindex="1" maxlength="20" size="35" type="text" name="username" value="${param.username}"> <br>
        密　码 &nbsp;<input class="input" tabindex="2" maxlength="20" size="40" type="password" name="password"> <br>
        <input class="btn" tabindex="6" value="登 录" type="submit">
    </form>
</div>
<%-- 引入统一页脚 --%>
<%@ include file="/WEB-INF/views/_inc/footer.jsp" %>
</body>
</html>
