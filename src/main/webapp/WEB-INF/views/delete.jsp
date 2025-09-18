<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <title>删除帖子</title>
  <link rel="stylesheet" type="text/css" href="<c:url value='/assets/css/style.css'/>">
</head>
<body>

<div class="nav">
  <a href="<c:url value='/'/>">首页</a> |
  <a href="<c:url value='/post/list'/>">帖子列表</a>
</div>

<hr/>

<h2>确认删除</h2>
<p>你确定要删除帖子 <strong>${post.title}</strong> 吗？此操作不可恢复。</p>

<form method="post" action="<c:url value='/post/delete'/>">
  <input type="hidden" name="id" value="${post.id}"/>
  <input type="submit" value="确认删除"/>
  <a href="<c:url value='/post/detail?id=${post.id}'/>">取消</a>
</form>

</body>
</html>
