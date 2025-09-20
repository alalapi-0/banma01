<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>发帖 - 斑马教育 论坛</title>
  <link rel="stylesheet" href="${ctx}/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/_inc/header.jspf"/>

<div class="wrap">
  <div class="board">
    <div class="hd">发表帖子</div>
    <div class="form" style="width:940px;">
      <form method="post" action="${ctx}/post/add">
        <!-- 保留 bid（所属板块） -->
        <input type="hidden" name="bid" value="${param.bid}" />
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

<jsp:include page="/WEB-INF/views/_inc/footer.jspf"/>
</body>
</html>
