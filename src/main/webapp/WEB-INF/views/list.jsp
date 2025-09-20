<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>

<c:choose>
    <c:when test="${not empty board}">
        <c:set var="breadcrumb" scope="request">
            >> <a href="${pageContext.request.contextPath}/post/list?bid=${board.id}"><c:out value="${board.name}"/></a>
        </c:set>
    </c:when>
    <c:otherwise>
        <c:set var="breadcrumb" scope="request">>> 全部帖子</c:set>
    </c:otherwise>
</c:choose>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>
        <c:choose>
            <c:when test="${not empty board}"><c:out value="${board.name}"/> - 斑马教育 论坛</c:when>
            <c:otherwise>帖子列表 - 斑马教育 论坛</c:otherwise>
        </c:choose>
    </title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/_inc/header.jspf"/>

<div class="wrap">
    <div class="board">
        <div class="hd" style="display:flex;justify-content:space-between;align-items:center;">
            <span>
                <c:choose>
                    <c:when test="${not empty board}"><c:out value="${board.name}"/></c:when>
                    <c:otherwise>全部帖子</c:otherwise>
                </c:choose>
            </span>
            <c:if test="${not empty sessionScope.user}">
                <c:choose>
                    <c:when test="${not empty board}">
                        <c:url var="newPostUrl" value="/post/new">
                            <c:param name="bid" value="${board.id}"/>
                        </c:url>
                    </c:when>
                    <c:otherwise>
                        <c:url var="newPostUrl" value="/post/new"/>
                    </c:otherwise>
                </c:choose>
                <a class="btn" href="${pageContext.request.contextPath}${newPostUrl}">发表帖子</a>
            </c:if>
        </div>

        <table class="table">
            <thead>
            <tr>
                <th>主题</th>
                <th style="width:140px;">作者</th>
                <th style="width:120px;">回复</th>
                <th style="width:180px;">发布时间</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="p" items="${posts}">
                <tr>
                    <td>
                        <a href="${pageContext.request.contextPath}/post/detail?id=${p.id}"><c:out value="${p.title}"/></a>
                </td>
                    <td><c:out value="${p.author}"/></td>
                    <td><c:out value="${p.replyCount}"/></td>
                    <td><fmt:formatDate value="${p.createTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                </tr>
            </c:forEach>
            <c:if test="${empty posts}">
                <tr>
                    <td colspan="4" style="text-align:center;color:#7d97ba;">暂无帖子，快来抢沙发吧！</td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/WEB-INF/views/_inc/footer.jspf"/>
</body>
</html>
