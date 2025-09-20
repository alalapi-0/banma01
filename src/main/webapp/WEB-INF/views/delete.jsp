<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3c.org/TR/1999/REC-html401-19991224/loose.dtd">
<html>
<head>
    <title>确认删除帖子</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" type="text/css" href="${ctx}/assets/css/style.css">
</head>
<body>
<%@ include file="/WEB-INF/views/_inc/header.jsp" %>
<div style="width:960px;margin:20px auto;">
    <h3>确认删除</h3>
    <p>确定要删除帖子：<strong>${post.title}</strong> ？该操作不可恢复。</p>
    <form action="${ctx}/post/delete" method="post">
        <input type="hidden" name="id" value="${post.tid}">
        <button type="submit" class="btn danger">确认删除</button>
        <a class="btn" href="${ctx}/post/detail?id=${post.tid}">取消</a>
    </form>
</div>
<%@ include file="/WEB-INF/views/_inc/footer.jsp" %>
</body>
</html>
