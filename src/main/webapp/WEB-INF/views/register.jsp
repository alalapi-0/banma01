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
    <title>斑马学员论坛--注册</title>
    <!-- 指定内容类型 -->
    <meta charset="UTF-8">
    <!-- 引入通用样式 -->
    <link rel="stylesheet" type="text/css" href="<c:url value='/static/css/main.css'/>?v=${pageContext.request.time}">
    <script type="text/javascript">
        // 注册表单的基础校验
        function check() {
            if (document.regForm.username.value === "") {
                alert("用户名不能为空");
                return false;
            }
            if (document.regForm.password.value === "") {
                alert("密码不能为空");
                return false;
            }
            if (document.regForm.password.value !== document.regForm.repassword.value) {
                alert("2次密码不一样");
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
    <form name="regForm" method="post" action="${ctx}/auth/register" onsubmit="return check();">
        <br>用&nbsp;户&nbsp;名 &nbsp;<input class="input" tabindex="1" maxlength="20" size="35" name="username" type="text"> <br>
        密&nbsp;&nbsp;&nbsp;&nbsp;码 &nbsp;<input class="input" tabindex="2" maxlength="20" size="40" name="password" type="password"> <br>
        重复密码 &nbsp;<input class="input" tabindex="3" maxlength="20" size="40" name="repassword" type="password"> <br>
        性别 &nbsp; 女<input value="女" type="radio" name="gender"> 男<input value="男" checked type="radio" name="gender"> <br>
        请选择头像 <br>
        <div class="avatar-list">
            <%-- 提供 15 个可选头像 --%>
            <c:forEach var="i" begin="1" end="15">
                <label class="avatar-option">
                    <input type="radio" name="avatar" value="${i}.gif" <c:if test="${i==1}">checked</c:if>>
                    <img src="<c:url value='/static/img/${i}.gif'/>" alt="头像${i}">
                </label>
            </c:forEach>
        </div>
        <input class="btn" tabindex="4" value="注 册" type="submit">
    </form>
</div>
<%-- 引入统一页脚 --%>
<%@ include file="/WEB-INF/views/_inc/footer.jsp" %>
</body>
</html>
