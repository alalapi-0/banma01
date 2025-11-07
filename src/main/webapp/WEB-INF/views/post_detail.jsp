<%-- 设置页面编码 --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- 引入 JSTL 核心标签库 --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- 引入 JSTL 格式化标签库 --%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- 计算上下文路径 --%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<%-- 提取帖子所属的板块 ID，方便生成链接 --%>
<c:set var="boardId" value="${post.boardId}" />
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3c.org/TR/1999/REC-html401-19991224/loose.dtd">
<html>
<head>
    <!-- 页面标题 -->
    <title>斑马学员论坛--看贴</title>
    <!-- 指定内容类型 -->
    <meta charset="UTF-8">
    <!-- 引入全站样式 -->
    <link rel="stylesheet" type="text/css" href="<c:url value='/static/css/main.css'/>?v=${pageContext.request.time}">
</head>
<body>
<%-- 引入通用页头 --%>
<%@ include file="/WEB-INF/views/_inc/header.jsp" %>
<div class="nav">&gt;&gt;<b><a href="${ctx}/">论坛首页</a></b>&gt;&gt;
    <%-- 根据是否能生成列表链接来渲染导航 --%>
    <c:choose>
        <c:when test="${not empty boardId}">
            <b><a href="${ctx}/post/list?bid=${boardId}">${post.boardName}</a></b>
        </c:when>
        <c:otherwise>
            <b>${post.boardName}</b>
        </c:otherwise>
    </c:choose>
</div>
<div class="list-actions">
    <!-- 回复按钮锚点指向页面底部的表单 -->
    <a href="#reply-form"><img src="<c:url value='/static/img/reply.gif'/>" alt="回复"></a>
    <%-- 发帖按钮，根据是否知道板块 ID 决定链接 --%>
    <c:choose>
        <c:when test="${not empty boardId}">
            <a href="${ctx}/post/new?bid=${boardId}"><img src="<c:url value='/static/img/post.gif'/>" alt="发帖"></a>
        </c:when>
        <c:otherwise>
            <a href="${ctx}/post/new"><img src="<c:url value='/static/img/post.gif'/>" alt="发帖"></a>
        </c:otherwise>
    </c:choose>
    <%-- 如果当前登录用户是作者，则提供删除链接 --%>
    <c:if test="${not empty sessionScope.user && sessionScope.user.id == post.authorId}">
        <a href="${ctx}/post/delete?id=${post.id}" style="margin-left:10px;color:#c00;">删除帖子</a>
    </c:if>
</div>
<div class="nav" style="text-align:right;width:960px;"> <a href="${ctx}/post/detail?id=${post.id}">上一页</a>| <a href="${ctx}/post/detail?id=${post.id}">下一页</a> </div>
<div>
    <div class="t">
        <table cellSpacing="0" cellPadding="0" width="100%">
            <tbody>
            <tr class="tr2">
                <td><strong>本页主题: ${post.title}</strong></td>
            </tr>
            <tr class="tr3">
                <td>&nbsp;</td>
            </tr>
            </tbody>
        </table>
    </div>
    <%-- 计算作者头像，如果没有则使用默认图 --%>
    <c:set var="postAvatar" value="${empty post.authorAvatar ? '1.gif' : post.authorAvatar}" />
    <div class="t">
        <table style="border-top-width:0px;table-layout:fixed" cellSpacing="0" cellPadding="0" width="100%">
            <tbody>
            <tr class="tr1">
                <th style="width:20%"><b>${post.author}</b><br><img src="<c:url value='/static/img/${postAvatar}'/>" alt="头像"><br>注册:--<br></th>
                <th>
                    <h4>${post.title}</h4>
                    <div><pre><c:out value="${post.content}" /></pre></div>
                    <div class="tipad gray">发表：[<fmt:formatDate value="${post.createTime}" pattern="yyyy-MM-dd HH:mm" />]</div>
                </th>
            </tr>
            </tbody>
        </table>
    </div>
    <%-- 遍历回复列表 --%>
    <c:forEach var="r" items="${comments}">
        <%-- 每条回复也需要准备头像路径 --%>
        <c:set var="replyAvatar" value="${empty r.authorAvatar ? '1.gif' : r.authorAvatar}" />
        <div class="t">
            <table style="border-top-width:0px;table-layout:fixed" cellSpacing="0" cellPadding="0" width="100%">
                <tbody>
                <tr class="tr1">
                    <th style="width:20%"><b>${r.author}</b><br><img src="<c:url value='/static/img/${replyAvatar}'/>" alt="头像"><br>注册:--<br></th>
                    <th>
                        <h4>re：</h4>
                        <div><pre><c:out value="${r.content}" /></pre></div>
                        <div class="tipad gray">发表：[<fmt:formatDate value="${r.createTime}" pattern="yyyy-MM-dd HH:mm" />]</div>
                        <%-- 帖子作者可以删除任意回复 --%>
                        <c:if test="${not empty sessionScope.user && sessionScope.user.id == post.authorId}">
                            <form action="${ctx}/comment/delete" method="post" style="margin-top:8px;">
                                <input type="hidden" name="id" value="${r.id}">
                                <button type="submit" class="btn danger" style="padding:2px 8px;">删除回复</button>
                            </form>
                        </c:if>
                    </th>
                </tr>
                </tbody>
            </table>
        </div>
    </c:forEach>
</div>
<div class="nav" style="text-align:right;width:960px;"> <a href="${ctx}/post/detail?id=${post.id}">上一页</a>| <a href="${ctx}/post/detail?id=${post.id}">下一页</a> </div>
<%-- 登录用户才展示回复表单 --%>
<c:if test="${not empty sessionScope.user}">
    <div class="reply-form" id="reply-form">
        <form action="${ctx}/comment/add" method="post">
            <input type="hidden" name="postId" value="${post.id}">
            <textarea name="content" rows="6" maxlength="1000" placeholder="写下你的回复……"></textarea><br>
            <button type="submit" class="btn">提 交</button>
        </form>
    </div>
</c:if>
<%-- 引入通用页脚 --%>
<%@ include file="/WEB-INF/views/_inc/footer.jsp" %>
</body>
</html>
