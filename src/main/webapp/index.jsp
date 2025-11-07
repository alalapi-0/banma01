<%-- 指定 JSP 输出的内容类型和字符集，避免中文乱码 --%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- 默认访问根路径时，立即转发到 /home，让 HomeServlet 处理 --%>
<jsp:forward page="/home"/>
