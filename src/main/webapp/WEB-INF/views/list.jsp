<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
  <title>帖子列表</title>
  <link rel="stylesheet" type="text/css" href="<c:url value='/assets/css/style.css'/>">
</head>
<body>

<div class="nav">
  <a href="<c:url value='/'/>">首页</a> |
  <a href="<c:url value='/post/new'/>">发帖</a>
</div>

<hr/>

<table class="t" width="100%" cellpadding="6" border="1">
  <thead>
  <tr>
    <th align="left">标题</th>
    <th width="120">作者</th>
    <th width="180">时间</th>
  </tr>
  </thead>
  <tbody>
  <c:forEach items="${posts}" var="p">
    <tr>
      <td>
        <a href="<c:url value='/post/detail?id=${p.id}'/>">${p.title}</a>
      </td>
      <td align="center">${p.author}</td>
      <td align="center">
        <fmt:formatDate value="${p.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
      </td>
    </tr>
  </c:forEach>

  <c:if test="${empty posts}">
    <tr>
      <td colspan="3" align="center" class="gray">暂时没有帖子</td>
    </tr>
  </c:if>
  </tbody>
</table>

</body>
</html>
