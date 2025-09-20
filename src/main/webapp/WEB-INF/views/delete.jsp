<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/_inc/header.jspf" %>

<h3>确认删除</h3>
<p>确定要删除帖子：<strong>${post.title}</strong> ？该操作不可恢复。</p>
<form action="${pageContext.request.contextPath}/post/delete" method="post">
  <input type="hidden" name="id" value="${post.tid}">
  <button type="submit" class="btn danger">确认删除</button>
  <a class="btn" href="${pageContext.request.contextPath}/post/detail?id=${post.tid}">取消</a>
</form>

<%@ include file="/WEB-INF/views/_inc/footer.jspf" %>
