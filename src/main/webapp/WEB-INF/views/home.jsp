<%-- 设置页面输出与编译编码，防止中文乱码 --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- 导入 JSTL 核心标签用于流程控制 --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- 导入 JSTL fmt 标签用于时间格式化 --%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- 读取当前应用的上下文路径，供页面拼接链接 --%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3c.org/TR/1999/REC-html401-19991224/loose.dtd">
<html>
<head>
    <!-- 页面标题 -->
    <title>欢迎访问斑马学员论坛</title>
    <!-- 指定页面的内容类型与编码 -->
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <!-- 引入站点统一的样式文件 -->
    <link rel="stylesheet" type="text/css" href="${ctx}/assets/css/style.css">
</head>
<body>
<%-- 引入通用页头 --%>
<%@ include file="/WEB-INF/views/_inc/header.jsp" %>
<div class="t">
    <!-- 整个板块列表使用一个表格呈现 -->
    <table cellSpacing="0" cellPadding="0" width="100%">
        <tbody>
        <!-- 表头行显示列名称 -->
        <tr class="tr2" align="middle">
            <td colSpan="2">论坛</td>
            <td style="width:5%">主题</td>
            <td style="width:25%">最后发表</td>
        </tr>
        <%-- 如果数据库连接失败则提示错误信息 --%>
        <c:if test="${dbError}">
            <tr class="tr3">
                <td colspan="4" style="text-align:center;">
                    <span class="gray">${dbErrorMessage}</span>
                </td>
            </tr>
        </c:if>
        <%-- 渲染 .NET 技术板块，如果有实时数据 --%>
        <c:choose>
            <c:when test="${not empty netBoards}">
                <tr class="tr3"><td colSpan="4">.NET技术</td></tr>
                <%-- 遍历服务器返回的每一个 .NET 子板块 --%>
                <c:forEach var="b" items="${netBoards}">
                    <tr class="tr3">
                        <td width="5%">&nbsp;</td>
                        <th align="left"><img src="${ctx}/assets/images/board.gif" alt=""> <a href="${ctx}/post/list?bid=${b.id}">${b.name}</a></th>
                        <td align="middle">${b.topicCount}</td>
                        <th>
                            <%-- 展示最近的帖子，如果有数据 --%>
                            <c:choose>
                                <c:when test="${not empty b.lastPostId}">
                                    <span><a href="${ctx}/post/detail?id=${b.lastPostId}">${b.lastPostTitle}</a></span><br>
                                    <span>${b.lastPostUser}</span>
                                    <c:if test="${not empty b.lastPostTime}">
                                        <span class="gray">[ <fmt:formatDate value="${b.lastPostTime}" pattern="yyyy-MM-dd HH:mm" /> ]</span>
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
                <%-- 如果没有数据库数据且也没有错误，展示静态示例内容 --%>
                <c:if test="${not dbError}">
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
                </c:if>
            </c:otherwise>
        </c:choose>

        <%-- 渲染 Java 技术板块，逻辑同上 --%>
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
                                        <span class="gray">[ <fmt:formatDate value="${b.lastPostTime}" pattern="yyyy-MM-dd HH:mm" /> ]</span>
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
                <c:if test="${not dbError}">
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
                </c:if>
            </c:otherwise>
        </c:choose>

        <%-- 渲染数据库技术板块 --%>
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
                                        <span class="gray">[ <fmt:formatDate value="${b.lastPostTime}" pattern="yyyy-MM-dd HH:mm" /> ]</span>
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
                <c:if test="${not dbError}">
                    <tr class="tr3"><td colSpan="4">数据技术</td></tr>
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
                </c:if>
            </c:otherwise>
        </c:choose>

        <%-- 渲染娱乐板块 --%>
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
                                        <span class="gray">[ <fmt:formatDate value="${b.lastPostTime}" pattern="yyyy-MM-dd HH:mm" /> ]</span>
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
                <c:if test="${not dbError}">
                    <tr class="tr3"><td colSpan="4">娱乐</td></tr>
                    <tr class="tr3">
                        <td width="5%">&nbsp;</td>
                        <th align="left"><img src="${ctx}/assets/images/board.gif" alt=""> <a href="${ctx}/post/list?boardId=15">影视音乐</a></th>
                        <td align="middle">5</td>
                        <th><span><a href="${ctx}/post/detail?id=108">最近上映的电影推荐</a></span><br><span>aptech</span> <span class="gray">[ 2007-08-09 11:20 ]</span></th>
                    </tr>
                </c:if>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>
</div>
<%-- 引入通用页脚 --%>
<%@ include file="/WEB-INF/views/_inc/footer.jsp" %>
</body>
</html>
