<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3c.org/TR/1999/REC-html401-19991224/loose.dtd">
<html>
<head>
    <title>斑马学员论坛--注册</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" type="text/css" href="${ctx}/assets/css/style.css">
    <script type="text/javascript">
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
<%@ include file="/WEB-INF/views/_inc/header.jspf" %>
<div class="nav">&gt;&gt;<b><a href="${ctx}/">论坛首页</a></b></div>
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
            <c:forEach var="i" begin="1" end="15">
                <label class="avatar-option">
                    <input type="radio" name="avatar" value="${i}.gif" <c:if test="${i==1}">checked</c:if>>
                    <img src="${ctx}/assets/images/${i}.gif" alt="头像${i}">
                </label>
            </c:forEach>
        </div>
        <input class="btn" tabindex="4" value="注 册" type="submit">
    </form>
</div>
<%@ include file="/WEB-INF/views/_inc/footer.jspf" %>
</body>
</html>
