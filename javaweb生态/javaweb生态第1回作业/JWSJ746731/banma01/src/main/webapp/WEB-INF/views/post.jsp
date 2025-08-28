<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
  <title>发表新帖</title>
  <link rel="stylesheet" type="text/css" href="<c:url value='/assets/css/style.css'/>">
</head>
<body>

<div class="nav">
  <a href="<c:url value='/'/>">首页</a> |
  <a href="<c:url value='/post/list'/>">帖子列表</a>
</div>

<hr/>

<h2>发表新帖</h2>

<c:if test="${not empty msg}">
  <div style="color:red;">${msg}</div>
</c:if>

<form method="post" action="<c:url value='/post/create'/>">
  <div>
    标题：<br/>
    <input type="text" name="title" size="60"/>
  </div>
  <br/>
  <div>
    内容：<br/>
    <textarea name="content" rows="10" cols="80"></textarea>
  </div>
  <br/>
  <input type="submit" value="发 表"/>
</form>

</body>
</html>
