<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    String which = request.getParameter("which");
%>
<form>
<input type=button value="test" onclick="parent.setTarget<%=which%>()">
</form>