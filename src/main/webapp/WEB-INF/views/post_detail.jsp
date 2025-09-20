<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>

<c:if test="${not empty post}">
    <c:set var="breadcrumb" scope="request">
        >> <a href="${pageContext.request.contextPath}/post/list?bid=${post.boardId}"><c:out value="${post.boardName}"/></a>
        >> <c:out value="${post.title}"/>
    </c:set>
</c:if>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><c:out value="${post.title}"/> - 斑马教育 论坛</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<%@ include file="/WEB-INF/views/_inc/header.jspf" %>

<div class="wrap">
    <article class="post">
        <header class="post-header">
            <h2><c:out value="${post.title}"/></h2>
            <div class="meta">
                <span>作者：<c:out value="${post.author}"/></span>
                <span class="sep">|</span>
                <span>时间：<fmt:formatDate value="${post.createTime}" pattern="yyyy-MM-dd HH:mm"/></span>
                <c:if test="${sessionScope.user != null && sessionScope.user.id == post.authorId}">
                    <span class="sep">|</span>
                    <a class="danger" href="${pageContext.request.contextPath}/post/delete?id=${post.id}">删除</a>
                </c:if>
            </div>
        </header>
        <div class="content"><c:out value="${post.content}"/></div>
    </article>

    <section class="replies">
        <h3>回复</h3>
        <c:forEach var="r" items="${replies}">
            <div class="reply">
                <div class="author"><c:out value="${r.author}"/></div>
                <div class="time"><fmt:formatDate value="${r.createTime}" pattern="yyyy-MM-dd HH:mm"/></div>
                <div class="content"><c:out value="${r.content}"/></div>
            </div>
        </c:forEach>
        <c:if test="${empty replies}">
            <div class="reply empty">暂时还没有回复，欢迎抢沙发！</div>
        </c:if>
    </section>

    <c:if test="${not empty sessionScope.user}">
        <section class="reply-form">
            <c:if test="${param.error == 'empty'}">
                <div class="tip" style="color:#c00;margin-bottom:12px;">回复内容不能为空。</div>
            </c:if>
            <c:if test="${param.error == 'toolong'}">
                <div class="tip" style="color:#c00;margin-bottom:12px;">回复内容不能超过 1000 字。</div>
            </c:if>
            <form action="${pageContext.request.contextPath}/comment/add" method="post">
                <input type="hidden" name="postId" value="${post.id}">
                <textarea name="content" rows="6" maxlength="1000" required placeholder="写下你的回复……"></textarea>
                <div class="actions">
                    <button type="submit" class="btn">提交</button>
                </div>
            </form>
        </section>
    </c:if>
    <c:if test="${empty sessionScope.user}">
        <div class="tip" style="margin-top:16px;">
            请先<a href="${pageContext.request.contextPath}/auth/login">登录</a>后再回复。
        </div>
    </c:if>
</div>

<%@ include file="/WEB-INF/views/_inc/footer.jspf" %>
</body>
</html>
