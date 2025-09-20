<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${empty ctx}">
    <c:set var="ctx" value="${pageContext.request.contextPath}" scope="request"/>
</c:if>

<div class="footer gray">2018 Tokyo Banma education Co.,Ltd 版权所有</div>
