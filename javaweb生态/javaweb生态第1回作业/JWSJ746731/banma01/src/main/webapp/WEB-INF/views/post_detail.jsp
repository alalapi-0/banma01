<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
  <title>帖子详情</title>
  <link rel="stylesheet" type="text/css" href="<c:url value='/assets/css/style.css'/>">
</head>
<body>

<div class="nav">
  <a href="<c:url value='/'/>">首页</a> |
  <a href="<c:url value='/post/list'/>">帖子列表</a> |
  <a href="<c:url value='/post/new'/>">发帖</a>
</div>

<hr/>

<h2>${post.title}</h2>
<div class="gray">
  作者：${post.author}
  &nbsp; 时间：
  <fmt:formatDate value="${post.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
</div>

<pre style="white-space:pre-wrap;">${post.content}</pre>

<!-- 仅作者本人可见的删除按钮 -->
<c:if test="${not empty sessionScope.user and sessionScope.user.id == post.userId}">
  <form method="get" action="<c:url value='/post/delete'/>">
    <input type="hidden" name="id" value="${post.id}"/>
    <input type="submit" value="删除帖子"/>
  </form>
</c:if>

<hr/>

<h3>评论</h3>
<c:if test="${empty comments}">
  <p class="gray">还没有评论，快来抢沙发吧！</p>
</c:if>
<ul>
  <c:forEach items="${comments}" var="c">
    <li>
      用户ID: ${c.userId} &nbsp;
      内容：${c.content}
    </li>
  </c:forEach>
</ul>

<!-- 登录用户才可回复 -->
<c:if test="${not empty sessionScope.user}">
  <form method="post" action="<c:url value='/comment/add'/>">
    <input type="hidden" name="postId" value="${post.id}"/>
    <textarea name="content" rows="4" cols="60"></textarea><br/>
    <input type="submit" value="发表评论"/>
  </form>
</c:if>

</body>
</html>
