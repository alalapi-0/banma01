<%-- 设置页面编码 --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- 引入 JSTL 核心标签 --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- 引入 JSTL 格式化标签 --%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- 计算上下文路径 --%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<%-- 从请求范围读取当前板块对象 --%>
<c:set var="board" value="${requestScope.board}" />
<%-- 兼容地获取板块 ID，可能来自 board 或单独的参数 --%>
<c:set var="boardId" value="${not empty board ? board.id : requestScope.boardId}" />
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3c.org/TR/1999/REC-html401-19991224/loose.dtd">
<html>
<head>
    <!-- 页面标题 -->
    <title>斑马学员论坛--帖子列表</title>
    <!-- 声明内容类型 -->
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <!-- 引入通用样式 -->
    <link rel="stylesheet" type="text/css" href="${ctx}/assets/css/style.css">
</head>
<body>
<%-- 引入页头 --%>
<%@ include file="/WEB-INF/views/_inc/header.jsp" %>
<div class="nav">
    &gt;&gt;<b><a href="${ctx}/">论坛首页</a></b>
    <%-- 根据板块信息渲染导航 --%>
    <c:choose>
        <c:when test="${not empty board}">
            <c:if test="${not empty board.parentName}">
                &gt;&gt; <b>${board.parentName}</b>
            </c:if>
            &gt;&gt; <b>${board.name}</b>
        </c:when>
        <c:otherwise>
            &gt;&gt; <b>帖子列表</b>
        </c:otherwise>
    </c:choose>
</div>
<div class="list-actions">
    <%-- 仅登录用户可以看到发帖按钮 --%>
    <c:if test="${not empty sessionScope.user}">
        <c:choose>
            <c:when test="${not empty boardId}">
                <a href="${ctx}/post/new?bid=${boardId}"><img src="${ctx}/assets/images/post.gif" alt="发表帖子"></a>
            </c:when>
            <c:otherwise>
                <a href="${ctx}/post/new"><img src="${ctx}/assets/images/post.gif" alt="发表帖子"></a>
            </c:otherwise>
        </c:choose>
    </c:if>
</div>
<div class="nav" style="text-align:right;width:960px;">
    <%-- 简单展示上一页下一页的占位链接 --%>
    <c:choose>
        <c:when test="${not empty boardId}">
            <a href="${ctx}/post/list?bid=${boardId}">上一页</a>| <a href="${ctx}/post/list?bid=${boardId}">下一页</a>
        </c:when>
        <c:otherwise>
            <a href="${ctx}/post/list">上一页</a>| <a href="${ctx}/post/list">下一页</a>
        </c:otherwise>
    </c:choose>
</div>
<div class="t">
    <table cellSpacing="0" cellPadding="0" width="100%">
        <tbody>
        <tr>
            <th style="width:100%" colSpan="4"><span>&nbsp;</span></th>
        </tr>
        <tr class="tr2">
            <td>&nbsp;</td>
            <td style="width:80%" align="middle">文章</td>
            <td style="width:10%" align="middle">作者</td>
            <td style="width:10%" align="middle">回复</td>
        </tr>
        <%-- 根据不同情况展示表格内容 --%>
        <c:choose>
            <c:when test="${dbError}">
                <tr class="tr3">
                    <td colspan="4" style="text-align:center;">
                        <span class="gray">${dbErrorMessage}</span>
                    </td>
                </tr>
            </c:when>
            <c:when test="${not empty posts}">
                <%-- 遍历帖子列表 --%>
                <c:forEach var="p" items="${posts}">
                    <tr class="tr3">
                        <td><img src="${ctx}/assets/images/topic.gif" alt=""></td>
                        <td style="font-size:15px">
                            <a href="${ctx}/post/detail?id=${p.id}">${p.title}</a><br>
                            <span class="gray"><fmt:formatDate value="${p.createTime}" pattern="yyyy-MM-dd HH:mm" /></span>
                        </td>
                        <td align="middle">${p.author}</td>
                        <td align="middle">${p.replyCount}</td>
                    </tr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr class="tr3">
                    <td colspan="4" style="text-align:center;">
                        <span class="gray">该板块暂时没有帖子，欢迎率先发帖~</span>
                    </td>
                </tr>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>
</div>
<%-- 引入页脚 --%>
<%@ include file="/WEB-INF/views/_inc/footer.jsp" %>
</body>
</html>
