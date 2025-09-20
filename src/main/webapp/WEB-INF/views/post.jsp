<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="breadcrumb" scope="request">>> 发布新帖</c:set>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>发帖 - 斑马教育 论坛</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<%@ include file="/WEB-INF/views/_inc/header.jspf" %>

<div class="wrap">
  <div class="board">
    <div class="hd">发表帖子</div>
    <div class="form" style="width:940px;">
      <form method="post" action="${pageContext.request.contextPath}/post/create">
        <!-- 保留 bid（所属板块） -->
        <input type="hidden" name="bid" value="${not empty param.bid ? param.bid : boardId}" />
        <c:if test="${not empty board}">
          <div class="tip" style="margin-left:80px;margin-bottom:12px;">将发布到：<c:out value="${board.name}"/></div>
        </c:if>
        <c:if test="${not empty requestScope.msg}">
          <div class="tip" style="margin-left:80px;margin-bottom:12px;color:#c00;"><c:out value="${msg}"/></div>
        </c:if>
        <div class="row">
          <label>标 题</label>
          <input type="text" name="title" maxlength="100" required>
        </div>
        <div class="row">
          <label>内 容</label>
          <textarea name="content" maxlength="1000" required></textarea>
        </div>
        <div class="tip" style="margin-left:80px;">(不能大于:1000字)</div>
        <div class="actions" style="margin-left:80px;">
          <button class="btn" type="submit">提交</button>
          <button class="btn secondary" type="reset">重置</button>
        </div>
      </form>
    </div>
  </div>
</div>

<%@ include file="/WEB-INF/views/_inc/footer.jspf" %>
</body>
</html>
