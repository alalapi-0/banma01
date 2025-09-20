<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ include file="/WEB-INF/views/_inc/header.jspf" %>

<div class="breadcrumb">
  >> 论坛首页 >> ${board.name}
  <c:if test="${not empty sessionScope.user}">
    <a class="btn primary right" href="${pageContext.request.contextPath}/post/new?bid=${board.bid}">发表帖子</a>
  </c:if>
</div>

<table class="table">
  <thead>
  <tr><th>主题</th><th width="160">最后发表</th></tr>
  </thead>
  <tbody>
  <c:forEach var="p" items="${posts}">
    <tr>
      <td>
        <a href="${pageContext.request.contextPath}/post/detail?id=${p.tid}">${p.title}</a>
      </td>
      <td>
        <fmt:formatDate value="${p.updateTime}" pattern="yyyy-MM-dd HH:mm" />
      </td>
    </tr>
  </c:forEach>
  </tbody>
</table>

<%@ include file="/WEB-INF/views/_inc/footer.jspf" %>
