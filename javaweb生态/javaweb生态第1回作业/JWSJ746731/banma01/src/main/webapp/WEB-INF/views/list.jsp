<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <title>帖子列表</title>
  <link rel="stylesheet" type="text/css" href="<c:url value='/assets/css/style.css'/>">
</head>
<body>
<div><img src="<c:url value='/assets/images/logo.png'/>" width="123" height="45"></div>

<div class="h">
  <a href="<c:url value='/'/>">论坛首页</a> |
  <a href="<c:url value='/auth/login'/>">登录</a> |
  <a href="<c:url value='/auth/register'/>">注册</a>
</div>

<div style="margin:10px 0;">
  <b>板块：</b> ${board.name} &nbsp;
  <a href="<c:url value='/post/new?boardId=${param.boardId}'/>">
    <img src="<c:url value='/assets/images/post.gif'/>" alt="发帖">
  </a>
</div>

<table class="t" width="100%" cellpadding="6">
  <thead>
  <tr>
    <th align="left">标题</th>
    <th width="120">作者</th>
    <th width="80">回复</th>
    <th width="180">发表时间</th>
  </tr>
  </thead>
  <tbody>
  <c:forEach items="${posts}" var="p">
    <tr>
      <td>
        <a href="<c:url value='/post/detail?id=${p.id}'/>">${p.title}</a>
      </td>
      <td align="center">${p.author}</td>
      <td align="center">${p.replyCount}</td>
      <td align="center">${p.createTime}</td>
    </tr>
  </c:forEach>
  <c:if test="${empty posts}">
    <tr><td colspan="4" align="center" style="color:#999;">暂时没有帖子</td></tr>
  </c:if>
  </tbody>
</table>
</body>
</html>
