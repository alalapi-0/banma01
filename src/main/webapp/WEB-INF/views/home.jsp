<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>斑马教育 论坛</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

<!-- 头部（注意：header.jspf 里不要再写 taglib 指令） -->
<jsp:include page="/WEB-INF/views/_inc/header.jspf"/>

<div class="wrap">

    <!-- ============ .NET 技术 ============ -->
    <div class="board">
        <div class="hd">.NET技术</div>
        <table class="table">
            <thead>
            <tr>
                <th style="width:80px;">&nbsp;</th>
                <th>论坛</th>
                <th style="width:120px;">主题</th>
                <th style="width:320px;">最后发表</th>
            </tr>
            </thead>
            <tbody>
            <!-- 动态循环（如果 servlet 设置了 netBoards 列表） -->
            <c:forEach items="${netBoards}" var="b">
                <tr>
                    <td class="board-icon"><img src="${pageContext.request.contextPath}/assets/images/board.gif" alt=""></td>
                    <td><a href="${pageContext.request.contextPath}/post/list?bid=${b.id}"><c:out value="${b.name}"/></a></td>
                    <td><c:out value="${b.topicCount}"/></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/post/detail?id=${b.lastPostId}"><c:out value="${b.lastPostTitle}"/></a>
                        <span class="tip"><c:out value="${b.lastPostUser}"/> [ <c:out value="${b.lastPostTime}"/> ]</span>
                    </td>
                </tr>
            </c:forEach>
            <!-- 没有数据时展示一行示例，保证页面不空白 -->
            <c:if test="${empty netBoards}">
                <tr>
                    <td class="board-icon"><img src="${pageContext.request.contextPath}/assets/images/board.gif" alt=""></td>
                    <td><a href="${pageContext.request.contextPath}/post/list?bid=2">C#技术</a></td>
                    <td>30</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/post/detail?id=1001">c#是微软开发的语言</a>
                        <span class="tip">accp [ 2007-07-30 10:25 ]</span>
                    </td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>

    <!-- ============ Java 技术 ============ -->
    <div class="board">
        <div class="hd">Java技术</div>
        <table class="table">
            <thead>
            <tr>
                <th style="width:80px;">&nbsp;</th>
                <th>论坛</th>
                <th style="width:120px;">主题</th>
                <th style="width:320px;">最后发表</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${javaBoards}" var="b">
                <tr>
                    <td class="board-icon"><img src="${pageContext.request.contextPath}/assets/images/board.gif" alt=""></td>
                    <td><a href="${pageContext.request.contextPath}/post/list?bid=${b.id}"><c:out value="${b.name}"/></a></td>
                    <td><c:out value="${b.topicCount}"/></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/post/detail?id=${b.lastPostId}"><c:out value="${b.lastPostTitle}"/></a>
                        <span class="tip"><c:out value="${b.lastPostUser}"/> [ <c:out value="${b.lastPostTime}"/> ]</span>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty javaBoards}">
                <tr>
                    <td class="board-icon"><img src="${pageContext.request.contextPath}/assets/images/board.gif" alt=""></td>
                    <td><a href="${pageContext.request.contextPath}/post/list?bid=7">Java基础</a></td>
                    <td>2</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/post/detail?id=2001">你是谁，得斯阿学习Java</a>
                        <span class="tip">aptech [ 2007-07-30 10:29 ]</span>
                    </td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>

    <!-- ============ 数据库技术 ============ -->
    <div class="board">
        <div class="hd">数据库技术</div>
        <table class="table">
            <thead>
            <tr>
                <th style="width:80px;">&nbsp;</th>
                <th>论坛</th>
                <th style="width:120px;">主题</th>
                <th style="width:320px;">最后发表</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${dbBoards}" var="b">
                <tr>
                    <td class="board-icon"><img src="${pageContext.request.contextPath}/assets/images/board.gif" alt=""></td>
                    <td><a href="${pageContext.request.contextPath}/post/list?bid=${b.id}"><c:out value="${b.name}"/></a></td>
                    <td><c:out value="${b.topicCount}"/></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/post/detail?id=${b.lastPostId}"><c:out value="${b.lastPostTitle}"/></a>
                        <span class="tip"><c:out value="${b.lastPostUser}"/> [ <c:out value="${b.lastPostTime}"/> ]</span>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty dbBoards}">
                <tr>
                    <td class="board-icon"><img src="${pageContext.request.contextPath}/assets/images/board.gif" alt=""></td>
                    <td><a href="${pageContext.request.contextPath}/post/list?bid=12">SQL Server基础</a></td>
                    <td>2</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/post/detail?id=3001">记得SQL很容易</a>
                        <span class="tip">aptech [ 2007-07-30 10:30 ]</span>
                    </td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>

    <!-- ============ 娱乐 ============ -->
    <div class="board">
        <div class="hd">娱乐</div>
        <table class="table">
            <thead>
            <tr>
                <th style="width:80px;">&nbsp;</th>
                <th>论坛</th>
                <th style="width:120px;">主题</th>
                <th style="width:320px;">最后发表</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${funBoards}" var="b">
                <tr>
                    <td class="board-icon"><img src="${pageContext.request.contextPath}/assets/images/board.gif" alt=""></td>
                    <td><a href="${pageContext.request.contextPath}/post/list?bid=${b.id}"><c:out value="${b.name}"/></a></td>
                    <td><c:out value="${b.topicCount}"/></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/post/detail?id=${b.lastPostId}"><c:out value="${b.lastPostTitle}"/></a>
                        <span class="tip"><c:out value="${b.lastPostUser}"/> [ <c:out value="${b.lastPostTime}"/> ]</span>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty funBoards}">
                <tr>
                    <td class="board-icon"><img src="${pageContext.request.contextPath}/assets/images/board.gif" alt=""></td>
                    <td><a href="${pageContext.request.contextPath}/post/list?bid=15">灌水乐园</a></td>
                    <td>25</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/post/detail?id=4001">你好</a>
                        <span class="tip">accp [ 2007-09-27 15:09 ]</span>
                    </td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>

</div>

<!-- 页脚 -->
<jsp:include page="/WEB-INF/views/_inc/footer.jspf"/>

</body>
</html>
