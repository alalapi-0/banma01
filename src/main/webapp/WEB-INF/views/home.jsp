<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3c.org/TR/1999/REC-html401-19991224/loose.dtd">
<html>
<head>
    <title>欢迎访问斑马学员论坛</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" type="text/css" href="${ctx}/assets/css/style.css">
</head>
<body>
<%@ include file="/WEB-INF/views/_inc/header.jsp" %>
<div class="t">
    <table cellSpacing="0" cellPadding="0" width="100%">
        <tbody>
        <tr class="tr2" align="middle">
            <td colSpan="2">论坛</td>
            <td style="width:5%">主题</td>
            <td style="width:25%">最后发表</td>
        </tr>
        <!-- .NET 技术 -->
        <c:choose>
            <c:when test="${not empty netBoards}">
                <tr class="tr3"><td colSpan="4">.NET技术</td></tr>
                <c:forEach var="b" items="${netBoards}">
                    <tr class="tr3">
                        <td width="5%">&nbsp;</td>
                        <th align="left"><img src="${ctx}/assets/images/board.gif" alt=""> <a href="${ctx}/post/list?bid=${b.id}">${b.name}</a></th>
                        <td align="middle">${b.topicCount}</td>
                        <th>
                            <c:choose>
                                <c:when test="${not empty b.lastPostId}">
                                    <span><a href="${ctx}/post/detail?id=${b.lastPostId}">${b.lastPostTitle}</a></span><br>
                                    <span>${b.lastPostUser}</span>
                                    <c:if test="${not empty b.lastPostTime}">
                                        <span class="gray">[ ${b.lastPostTime} ]</span>
                                    </c:if>
                                </c:when>
                                <c:otherwise>
                                    <span class="gray">暂无帖子</span>
                                </c:otherwise>
                            </c:choose>
                        </th>
                    </tr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr class="tr3"><td colSpan="4">.NET技术</td></tr>
                <tr class="tr3">
                    <td width="5%">&nbsp;</td>
                    <th align="left"><img src="${ctx}/assets/images/board.gif" alt=""> <a href="${ctx}/post/list?boardId=4">C#语言</a></th>
                    <td align="middle">30</td>
                    <th><span><a href="${ctx}/post/detail?id=100">c#是微软开发的语言</a></span><br><span>accp</span> <span class="gray">[ 2007-07-30 10:25 ]</span></th>
                </tr>
                <tr class="tr3">
                    <td width="5%">&nbsp;</td>
                    <th align="left"><img src="${ctx}/assets/images/board.gif" alt=""> <a href="${ctx}/post/list?boardId=5">WinForms</a></th>
                    <td align="middle">7</td>
                    <th><span><a href="${ctx}/post/detail?id=101">谁帮我看看我的程序</a></span><br><span>accp</span> <span class="gray">[ 2007-07-30 10:27 ]</span></th>
                </tr>
                <tr class="tr3">
                    <td width="5%">&nbsp;</td>
                    <th align="left"><img src="${ctx}/assets/images/board.gif" alt=""> <a href="${ctx}/post/list?boardId=6">ADO.NET</a></th>
                    <td align="middle">3</td>
                    <th><span><a href="${ctx}/post/detail?id=94">好</a></span><br><span>goodman</span> <span class="gray">[ 2007-07-30 08:33 ]</span></th>
                </tr>
                <tr class="tr3">
                    <td width="5%">&nbsp;</td>
                    <th align="left"><img src="${ctx}/assets/images/board.gif" alt=""> <a href="${ctx}/post/list?boardId=7">ASP.NET</a></th>
                    <td align="middle">1</td>
                    <th><span><a href="${ctx}/post/detail?id=104">这段代码是什么意思</a></span><br><span>aptech</span> <span class="gray">[ 2007-07-30 10:31 ]</span></th>
                </tr>
            </c:otherwise>
        </c:choose>

        <!-- Java 技术 -->
        <c:choose>
            <c:when test="${not empty javaBoards}">
                <tr class="tr3"><td colSpan="4">Java技术</td></tr>
                <c:forEach var="b" items="${javaBoards}">
                    <tr class="tr3">
                        <td width="5%">&nbsp;</td>
                        <th align="left"><img src="${ctx}/assets/images/board.gif" alt=""> <a href="${ctx}/post/list?bid=${b.id}">${b.name}</a></th>
                        <td align="middle">${b.topicCount}</td>
                        <th>
                            <c:choose>
                                <c:when test="${not empty b.lastPostId}">
                                    <span><a href="${ctx}/post/detail?id=${b.lastPostId}">${b.lastPostTitle}</a></span><br>
                                    <span>${b.lastPostUser}</span>
                                    <c:if test="${not empty b.lastPostTime}">
                                        <span class="gray">[ ${b.lastPostTime} ]</span>
                                    </c:if>
                                </c:when>
                                <c:otherwise>
                                    <span class="gray">暂无帖子</span>
                                </c:otherwise>
                            </c:choose>
                        </th>
                    </tr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr class="tr3"><td colSpan="4">Java技术</td></tr>
                <tr class="tr3">
                    <td width="5%">&nbsp;</td>
                    <th align="left"><img src="${ctx}/assets/images/board.gif" alt=""> <a href="${ctx}/post/list?boardId=8">Java基础</a></th>
                    <td align="middle">2</td>
                    <th><span><a href="${ctx}/post/detail?id=102">我是新手，我刚开始学习Java</a></span><br><span>aptech</span> <span class="gray">[ 2007-07-30 10:29 ]</span></th>
                </tr>
                <tr class="tr3">
                    <td width="5%">&nbsp;</td>
                    <th align="left"><img src="${ctx}/assets/images/board.gif" alt=""> <a href="${ctx}/post/list?boardId=9">JSP技术</a></th>
                    <td align="middle">6</td>
                    <th><span><a href="${ctx}/post/detail?id=111">你好</a></span><br><span>qq</span> <span class="gray">[ 2007-09-27 14:33 ]</span></th>
                </tr>
            </c:otherwise>
        </c:choose>

        <!-- 数据库技术 -->
        <c:choose>
            <c:when test="${not empty dbBoards}">
                <tr class="tr3"><td colSpan="4">数据库技术</td></tr>
                <c:forEach var="b" items="${dbBoards}">
                    <tr class="tr3">
                        <td width="5%">&nbsp;</td>
                        <th align="left"><img src="${ctx}/assets/images/board.gif" alt=""> <a href="${ctx}/post/list?bid=${b.id}">${b.name}</a></th>
                        <td align="middle">${b.topicCount}</td>
                        <th>
                            <c:choose>
                                <c:when test="${not empty b.lastPostId}">
                                    <span><a href="${ctx}/post/detail?id=${b.lastPostId}">${b.lastPostTitle}</a></span><br>
                                    <span>${b.lastPostUser}</span>
                                    <c:if test="${not empty b.lastPostTime}">
                                        <span class="gray">[ ${b.lastPostTime} ]</span>
                                    </c:if>
                                </c:when>
                                <c:otherwise>
                                    <span class="gray">暂无帖子</span>
                                </c:otherwise>
                            </c:choose>
                        </th>
                    </tr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr class="tr3"><td colSpan="4">数据库技术</td></tr>
                <tr class="tr3">
                    <td width="5%">&nbsp;</td>
                    <th align="left"><img src="${ctx}/assets/images/board.gif" alt=""> <a href="${ctx}/post/list?boardId=12">SQL Server基础</a></th>
                    <td align="middle">2</td>
                    <th><span><a href="${ctx}/post/detail?id=103">这段SQL错在哪了?</a></span><br><span>aptech</span> <span class="gray">[ 2007-07-30 10:30 ]</span></th>
                </tr>
                <tr class="tr3">
                    <td width="5%">&nbsp;</td>
                    <th align="left"><img src="${ctx}/assets/images/board.gif" alt=""> <a href="${ctx}/post/list?boardId=13">SQL Server高级</a></th>
                    <td align="middle">3</td>
                    <th><span><a href="${ctx}/post/detail?id=107">这段sql有什么问题</a></span><br><span>aptech</span> <span class="gray">[ 2007-08-09 10:12 ]</span></th>
                </tr>
            </c:otherwise>
        </c:choose>

        <!-- 娱乐 -->
        <c:choose>
            <c:when test="${not empty funBoards}">
                <tr class="tr3"><td colSpan="4">娱乐</td></tr>
                <c:forEach var="b" items="${funBoards}">
                    <tr class="tr3">
                        <td width="5%">&nbsp;</td>
                        <th align="left"><img src="${ctx}/assets/images/board.gif" alt=""> <a href="${ctx}/post/list?bid=${b.id}">${b.name}</a></th>
                        <td align="middle">${b.topicCount}</td>
                        <th>
                            <c:choose>
                                <c:when test="${not empty b.lastPostId}">
                                    <span><a href="${ctx}/post/detail?id=${b.lastPostId}">${b.lastPostTitle}</a></span><br>
                                    <span>${b.lastPostUser}</span>
                                    <c:if test="${not empty b.lastPostTime}">
                                        <span class="gray">[ ${b.lastPostTime} ]</span>
                                    </c:if>
                                </c:when>
                                <c:otherwise>
                                    <span class="gray">暂无帖子</span>
                                </c:otherwise>
                            </c:choose>
                        </th>
                    </tr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr class="tr3"><td colSpan="4">娱乐</td></tr>
                <tr class="tr3">
                    <td width="5%">&nbsp;</td>
                    <th align="left"><img src="${ctx}/assets/images/board.gif" alt=""> <a href="${ctx}/post/list?boardId=15">灌水乐园</a></th>
                    <td align="middle">25</td>
                    <th><span><a href="${ctx}/post/detail?id=113">你好</a></span><br><span>accp</span> <span class="gray">[ 2007-09-27 15:09 ]</span></th>
                </tr>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>
</div>
<%@ include file="/WEB-INF/views/_inc/footer.jsp" %>
</body>
</html>
