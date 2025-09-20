<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3c.org/TR/1999/REC-html401-19991224/loose.dtd">
<html>
<head>
    <title>斑马学员论坛--看贴</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" type="text/css" href="${ctx}/assets/css/style.css">
</head>
<body>
<%@ include file="/WEB-INF/views/_inc/header.jsp" %>
<div class="nav">&gt;&gt;<b><a href="${ctx}/">论坛首页</a></b>&gt;&gt; <b>${post.boardName}</b></div>
<div class="list-actions">
    <a href="#reply-form"><img src="${ctx}/assets/images/reply.gif" alt="回复"></a>
    <a href="${ctx}/post/new"><img src="${ctx}/assets/images/post.gif" alt="发帖"></a>
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
    <div class="t">
        <table style="border-top-width:0px;table-layout:fixed" cellSpacing="0" cellPadding="0" width="100%">
            <tbody>
            <tr class="tr1">
                <th style="width:20%"><b>${post.author}</b><br><img src="${ctx}/assets/images/1.gif" alt="头像"><br>注册:--<br></th>
                <th>
                    <h4>${post.title}</h4>
                    <div><pre><c:out value="${post.content}" /></pre></div>
                    <div class="tipad gray">发表：[<fmt:formatDate value="${post.createTime}" pattern="yyyy-MM-dd HH:mm" />]</div>
                </th>
            </tr>
            </tbody>
        </table>
    </div>
    <c:forEach var="r" items="${comments}">
        <div class="t">
            <table style="border-top-width:0px;table-layout:fixed" cellSpacing="0" cellPadding="0" width="100%">
                <tbody>
                <tr class="tr1">
                    <th style="width:20%"><b>${r.author}</b><br><img src="${ctx}/assets/images/2.gif" alt="头像"><br>注册:--<br></th>
                    <th>
                        <h4>re：</h4>
                        <div><pre><c:out value="${r.content}" /></pre></div>
                        <div class="tipad gray">发表：[<fmt:formatDate value="${r.createTime}" pattern="yyyy-MM-dd HH:mm" />]</div>
                    </th>
                </tr>
                </tbody>
            </table>
        </div>
    </c:forEach>
</div>
<div class="nav" style="text-align:right;width:960px;"> <a href="${ctx}/post/detail?id=${post.id}">上一页</a>| <a href="${ctx}/post/detail?id=${post.id}">下一页</a> </div>
<c:if test="${not empty sessionScope.user}">
    <div class="reply-form" id="reply-form">
        <form action="${ctx}/comment/add" method="post">
            <input type="hidden" name="postId" value="${post.id}">
            <textarea name="content" rows="6" maxlength="1000" placeholder="写下你的回复……"></textarea><br>
            <button type="submit" class="btn">提 交</button>
        </form>
    </div>
</c:if>
<%@ include file="/WEB-INF/views/_inc/footer.jsp" %>
</body>
</html>
