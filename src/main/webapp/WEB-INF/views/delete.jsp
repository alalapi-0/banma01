<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="breadcrumb" scope="request">
    >> <a href="${pageContext.request.contextPath}/post/detail?id=${post.id}"><c:out value="${post.title}"/></a>
    >> 删除确认
</c:set>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>删除帖子 - 斑马教育 论坛</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/_inc/header.jspf"/>

<div class="wrap">
    <div class="panel">
        <div class="hd">确认删除</div>
        <div class="bd">
            <p>确定要删除帖子：<strong><c:out value="${post.title}"/></strong>？该操作不可恢复。</p>
            <form action="${pageContext.request.contextPath}/post/delete" method="post" style="margin-top:16px;">
                <input type="hidden" name="id" value="${post.id}">
                <button type="submit" class="btn danger">确认删除</button>
                <a class="btn secondary" href="${pageContext.request.contextPath}/post/detail?id=${post.id}" style="margin-left:12px;">取消</a>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/_inc/footer.jspf"/>
</body>
</html>
