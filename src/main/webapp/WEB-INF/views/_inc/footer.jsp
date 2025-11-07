<%-- 设置 JSP 输出编码 --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- 引入 JSTL 核心标签库，复用 ctx 变量的处理方式 --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- 如果请求范围内没有 ctx，则从 request 中取出上下文路径 --%>
<c:if test="${empty ctx}">
    <c:set var="ctx" value="${pageContext.request.contextPath}" scope="request"/>
</c:if>

<%-- 页脚区域显示版权信息 --%>
<div class="footer gray">2018 Tokyo Banma education Co.,Ltd 版权所有</div>
<script src="<c:url value='/static/js/app.js'/>"></script>
