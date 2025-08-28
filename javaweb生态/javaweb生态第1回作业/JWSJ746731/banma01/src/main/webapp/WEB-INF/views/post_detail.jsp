<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <title>${post.title}</title>
  <link rel="stylesheet" type="text/css" href="<c:url value='/assets/css/style.css'/>">
</head>
<body>
<div><img src="<c:url value='/assets/images/logo.png'/>" width="123" height="45"></div>

<div class="h">
  <a href="<c:url value='/'/>">论坛首页</a> |
  <a href="<c:url value='/post/list?boardId=${param.boardId}'/>">返回列表</a>
</div>

<h2>${post.title}</h2>
<div class="gray">作者：${post.author}　时间：${post.createTime}</div>
<pre style="white-space:pre-wrap;">${post.content}</pre>

<!-- 仅作者可见的删帖按钮 -->
<c:if test="${not empty user && user.id == post.userId}">
  <form method="post" action="<c:url value='/post/delete'/>" onsubmit="return confirm('确定删除此帖？')">
    <input type="hidden" name="id" value="${post.id}">
    <button class="btn" type="submit">删除本帖</button>
  </form>
</c:if>

<h3>回帖</h3>
<ul>
  <c:forEach items="${comments}" var="cmt">
    <li>
      <b>${cmt.userName}：</b>
      <span>${cmt.content}</span>
      <span class="gray">（${cmt.createTime}）</span>
    </li>
  </c:forEach>
  <c:if test="${empty comments}">
    <li class="gray">暂无回复</li>
  </c:if>
</ul>

<c:if test="${not empty user}">
  <form method="post" action="<c:url value='/comment/add'/>">
    <input type="hidden" name="postId" value="${post.id}">
    <textarea name="content" rows="4" cols="80" required></textarea><br>
    <button class="btn" type="submit">发表评论</button>
  </form>
</c:if>
<c:if test="${empty user}">
  <a href="<c:url value='/auth/login'/>">登录后评论</a>
</c:if>
</body>
</html>
