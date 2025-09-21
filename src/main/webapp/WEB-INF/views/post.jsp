<%-- 设置页面编码 --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- 引入 JSTL 核心标签 --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- 计算上下文路径供后续使用 --%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<%-- 取出已经在请求范围内准备好的默认板块 --%>
<c:set var="selectedBoard" value="${requestScope.selectedBoard}" />
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3c.org/TR/1999/REC-html401-19991224/loose.dtd">
<html>
<head>
    <!-- 页面标题 -->
    <title>斑马学员论坛--发布帖子</title>
    <!-- 明确声明内容类型 -->
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <!-- 引入通用样式 -->
    <link rel="stylesheet" type="text/css" href="${ctx}/assets/css/style.css">
    <script type="text/javascript">
        // 表单提交前的简单前端校验
        function check(){
            if(!document.postForm.bid || document.postForm.bid.value === "") {
                alert("请选择板块");
                return false;
            }
            if(document.postForm.title.value === "") {
                alert("标题不能为空");
                return false;
            }
            if(document.postForm.content.value === "") {
                alert("内容不能为空");
                return false;
            }
            if(document.postForm.content.value.length > 1000) {
                alert("长度不能大于1000");
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
<%-- 引入统一页头 --%>
<%@ include file="/WEB-INF/views/_inc/header.jsp" %>
<div class="nav">&gt;&gt;<b><a href="${ctx}/">论坛首页</a></b></div>
<div class="nav">&gt;&gt; <b>发表帖子</b>
    <%-- 如果已经选定了板块，则显示板块名称 --%>
    <c:if test="${not empty selectedBoard}">
        （
        <c:if test="${not empty selectedBoard.parentName}">${selectedBoard.parentName} - </c:if>
        ${selectedBoard.name}
        ）
    </c:if>
</div>
<%-- 若存在服务器端校验消息则提示出来 --%>
<c:if test="${not empty msg}">
    <div class="notice">${msg}</div>
</c:if>
<div class="t">
    <form name="postForm" method="post" action="${ctx}/post/create" onsubmit="return check();">
        <table cellSpacing="0" cellPadding="0" align="center">
            <tbody>
            <tr class="tr2">
                <td colSpan="3"><b>发表帖子</b></td>
            </tr>
            <tr class="tr3">
                <th width="20%"><b>板块</b></th>
                <th>
                    <c:choose>
                        <c:when test="${not empty boards}">
                            <select style="padding-left:2px;font:14px Tahoma" class="input" name="bid">
                                <c:forEach var="b" items="${boards}">
                                    <option value="${b.id}" <c:if test="${b.id == selectedBoardId}">selected</c:if>>
                                        <c:if test="${not empty b.parentName}">${b.parentName} - </c:if>${b.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </c:when>
                        <c:otherwise>
                            <span class="gray">暂无可用板块，请稍后再试。</span>
                        </c:otherwise>
                    </c:choose>
                </th>
            </tr>
            <tr class="tr3">
                <th width="20%"><b>标题</b></th>
                <th><input style="padding-left:2px;font:14px Tahoma" class="input" tabindex="1" size="60" name="title" type="text" maxlength="100"></th>
            </tr>
            <tr class="tr3">
                <th valign="top"><div><b>内容</b></div></th>
                <th colSpan="2">
                    <div><span><textarea style="width:500px" tabindex="2" rows="20" cols="90" name="content" maxlength="1000"></textarea></span></div>
                    (不能大于:<font color="blue">1000</font>字)
                </th>
            </tr>
            </tbody>
        </table>
        <div style="text-align:center;margin:15px 0;">
            <input class="btn" tabindex="3" value="提 交" type="submit">
            <input class="btn" tabindex="4" value="重 置" type="reset">
        </div>
    </form>
</div>
<%-- 引入统一页脚 --%>
<%@ include file="/WEB-INF/views/_inc/footer.jsp" %>
</body>
</html>
