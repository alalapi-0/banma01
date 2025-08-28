<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <title>发布新帖</title>
  <link rel="stylesheet" type="text/css" href="<c:url value='/assets/css/style.css'/>">
  <script>
    function checkPost(){
      var f = document.forms['postForm'];
      if(!f.title.value){ alert('标题不能为空'); return false; }
      if(!f.content.value){ alert('内容不能为空'); return false; }
      return true;
    }
  </script>
</head>
<body>
<div><img src="<c:url value='/assets/images/logo.png'/>" width="123" height="45"></div>

<div class="h">
  <a href="<c:url value='/'/>">论坛首页</a> |
  <a href="<c:url value='/auth/login'/>">登录</a> |
  <a href="<c:url value='/auth/register'/>">注册</a>
</div>

<!-- boardId 从 ?boardId=xxx 取；也可以改为下拉板块 -->
<div class="t" align="center" style="margin-top:15px">
  <form name="postForm" method="post" action="<c:url value='/post/create'/>" onsubmit="return checkPost()">
    <input type="hidden" name="boardId" value="${param.boardId}">
    <p>标题：<input class="input" name="title" maxlength="80" size="60" /></p>
    <p>内容：</p>
    <p><textarea name="content" rows="12" cols="80" class="input"></textarea></p>
    <p><button class="btn" type="submit">发 布</button></p>
  </form>
</div>
</body>
</html>
