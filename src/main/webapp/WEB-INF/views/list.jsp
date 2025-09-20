<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3c.org/TR/1999/REC-html401-19991224/loose.dtd">
<html>
<head>
    <title>斑马学员论坛--帖子列表</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" type="text/css" href="${ctx}/assets/css/style.css">
</head>
<body>
<%@ include file="/WEB-INF/views/_inc/header.jspf" %>
<div class="nav">&gt;&gt;<b><a href="${ctx}/">论坛首页</a></b>&gt;&gt; <b>帖子列表</b></div>
<div class="list-actions">
    <c:if test="${not empty sessionScope.user}">
        <a href="${ctx}/post/new"><img src="${ctx}/assets/images/post.gif" alt="发表帖子"></a>
    </c:if>
</div>
<div class="nav" style="text-align:right;width:960px;"> <a href="${ctx}/post/list">上一页</a>| <a href="${ctx}/post/list">下一页</a> </div>
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
        <c:choose>
            <c:when test="${dbError}">
                <tr class="tr3">
                    <td colspan="4" style="text-align:center;">
                        <span class="gray">${dbErrorMessage}</span>
                    </td>
                </tr>
            </c:when>
            <c:when test="${not empty posts}">
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
                    <td><img src="${ctx}/assets/images/topic.gif" alt=""></td>
                    <td style="font-size:15px"><a href="${ctx}/post/detail?id=100">c#是微软开发的语言 </a></td>
                    <td align="middle">accp</td>
                    <td align="middle">0</td>
                </tr>
                <tr class="tr3">
                    <td><img src="${ctx}/assets/images/topic.gif" alt=""></td>
                    <td style="font-size:15px"><a href="${ctx}/post/detail?id=99">c#是微软开发的语言 </a></td>
                    <td align="middle">goodman</td>
                    <td align="middle">0</td>
                </tr>
                <tr class="tr3">
                    <td><img src="${ctx}/assets/images/topic.gif" alt=""></td>
                    <td style="font-size:15px"><a href="${ctx}/post/detail?id=98">c#是一门很好的语言</a> </td>
                    <td align="middle">goodman</td>
                    <td align="middle">0</td>
                </tr>
                <tr class="tr3">
                    <td><img src="${ctx}/assets/images/topic.gif" alt=""></td>
                    <td style="font-size:15px"><a href="${ctx}/post/detail?id=95">大家不好</a> </td>
                    <td align="middle">goodman</td>
                    <td align="middle">0</td>
                </tr>
                <tr class="tr3">
                    <td><img src="${ctx}/assets/images/topic.gif" alt=""></td>
                    <td style="font-size:15px"><a href="${ctx}/post/detail?id=92">JSP论坛测试</a> </td>
                    <td align="middle">class</td>
                    <td align="middle">1</td>
                </tr>
                <tr class="tr3">
                    <td><img src="${ctx}/assets/images/topic.gif" alt=""></td>
                    <td style="font-size:15px"><a href="${ctx}/post/detail?id=91">JSP论坛测试</a> </td>
                    <td align="middle">accp</td>
                    <td align="middle">0</td>
                </tr>
                <tr class="tr3">
                    <td><img src="${ctx}/assets/images/topic.gif" alt=""></td>
                    <td style="font-size:15px"><a href="${ctx}/post/detail?id=82">C#语言 问题集锦3</a> </td>
                    <td align="middle">goodman</td>
                    <td align="middle">12</td>
                </tr>
                <tr class="tr3">
                    <td><img src="${ctx}/assets/images/topic.gif" alt=""></td>
                    <td style="font-size:15px"><a href="${ctx}/post/detail?id=81">C#语言 问题集锦2</a> </td>
                    <td align="middle">goodman</td>
                    <td align="middle">11</td>
                </tr>
                <tr class="tr3">
                    <td><img src="${ctx}/assets/images/topic.gif" alt=""></td>
                    <td style="font-size:15px"><a href="${ctx}/post/detail?id=80">C#语言 问题集锦1</a> </td>
                    <td align="middle">goodman</td>
                    <td align="middle">0</td>
                </tr>
                <tr class="tr3">
                    <td><img src="${ctx}/assets/images/topic.gif" alt=""></td>
                    <td style="font-size:15px"><a href="${ctx}/post/detail?id=33">C#语言测试帖15</a> </td>
                    <td align="middle">goodman</td>
                    <td align="middle">3</td>
                </tr>
                <tr class="tr3">
                    <td><img src="${ctx}/assets/images/topic.gif" alt=""></td>
                    <td style="font-size:15px"><a href="${ctx}/post/detail?id=32">C#语言测试帖14</a> </td>
                    <td align="middle">goodman</td>
                    <td align="middle">0</td>
                </tr>
                <tr class="tr3">
                    <td><img src="${ctx}/assets/images/topic.gif" alt=""></td>
                    <td style="font-size:15px"><a href="${ctx}/post/detail?id=31">C#语言测试帖13</a> </td>
                    <td align="middle">goodman</td>
                    <td align="middle">0</td>
                </tr>
                <tr class="tr3">
                    <td><img src="${ctx}/assets/images/topic.gif" alt=""></td>
                    <td style="font-size:15px"><a href="${ctx}/post/detail?id=30">C#语言测试帖12</a> </td>
                    <td align="middle">goodman</td>
                    <td align="middle">0</td>
                </tr>
                <tr class="tr3">
                    <td><img src="${ctx}/assets/images/topic.gif" alt=""></td>
                    <td style="font-size:15px"><a href="${ctx}/post/detail?id=29">C#语言测试帖11</a> </td>
                    <td align="middle">goodman</td>
                    <td align="middle">0</td>
                </tr>
                <tr class="tr3">
                    <td><img src="${ctx}/assets/images/topic.gif" alt=""></td>
                    <td style="font-size:15px"><a href="${ctx}/post/detail?id=28">C#语言测试帖10</a> </td>
                    <td align="middle">goodman</td>
                    <td align="middle">0</td>
                </tr>
                <tr class="tr3">
                    <td><img src="${ctx}/assets/images/topic.gif" alt=""></td>
                    <td style="font-size:15px"><a href="${ctx}/post/detail?id=27">C#语言测试帖9</a> </td>
                    <td align="middle">goodman</td>
                    <td align="middle">0</td>
                </tr>
                <tr class="tr3">
                    <td><img src="${ctx}/assets/images/topic.gif" alt=""></td>
                    <td style="font-size:15px"><a href="${ctx}/post/detail?id=26">C#语言测试帖8</a> </td>
                    <td align="middle">goodman</td>
                    <td align="middle">0</td>
                </tr>
                <tr class="tr3">
                    <td><img src="${ctx}/assets/images/topic.gif" alt=""></td>
                    <td style="font-size:15px"><a href="${ctx}/post/detail?id=25">C#语言测试帖7</a> </td>
                    <td align="middle">goodman</td>
                    <td align="middle">0</td>
                </tr>
                <tr class="tr3">
                    <td><img src="${ctx}/assets/images/topic.gif" alt=""></td>
                    <td style="font-size:15px"><a href="${ctx}/post/detail?id=24">C#语言测试帖6</a> </td>
                    <td align="middle">goodman</td>
                    <td align="middle">0</td>
                </tr>
                <tr class="tr3">
                    <td><img src="${ctx}/assets/images/topic.gif" alt=""></td>
                    <td style="font-size:15px"><a href="${ctx}/post/detail?id=20">你好！</a> </td>
                    <td align="middle">goodman</td>
                    <td align="middle">0</td>
                </tr>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>
</div>
<%@ include file="/WEB-INF/views/_inc/footer.jspf" %>
</body>
</html>
