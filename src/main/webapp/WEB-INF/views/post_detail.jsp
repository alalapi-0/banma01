<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ include file="/WEB-INF/views/_inc/header.jspf" %>

<div class="breadcrumb">
  >> 论坛首页 >> ${board.name} >> ${post.title}
</div>

<article class="post">
  <header class="post-header">
    <h2>${post.title}</h2>
    <div class="meta">
      <span>作者：${post.authorName}</span>
      <span class="sep">|</span>
      <span>时间：<fmt:formatDate value="${post.createTime}" pattern="yyyy-MM-dd HH:mm"/></span>
      <c:if test="${sessionScope.user != null && sessionScope.user.id == post.uid}">
        <span class="sep">|</span>
        <a class="danger" href="${pageContext.request.contextPath}/post/delete?id=${post.tid}"
           onclick="return confirm('确定删除该帖子？');">删除</a>
      </c:if>
    </div>
  </header>
  <div class="content">${post.content}</div>
</article>

<section class="replies">
  <h3>回复</h3>
  <c:forEach var="r" items="${replies}">
    <div class="reply">
      <div class="author">${r.userName}</div>
      <div class="time"><fmt:formatDate value="${r.createTime}" pattern="yyyy-MM-dd HH:mm"/></div>
      <div class="content">${r.content}</div>
    </div>
  </c:forEach>
</section>

<c:if test="${not empty sessionScope.user}">
  <section class="reply-form">
    <form action="${pageContext.request.contextPath}/comment/add" method="post">
      <input type="hidden" name="postId" value="${post.tid}">
      <textarea name="content" rows="6" maxlength="1000" required placeholder="写下你的回复……"></textarea>
      <button type="submit" class="btn primary">提交</button>
    </form>
  </section>
</c:if>

<%@ include file="/WEB-INF/views/_inc/footer.jspf" %>
