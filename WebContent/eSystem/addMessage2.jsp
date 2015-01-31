<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*,phm.util.*,java.io.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=8;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu8.jsp"%>
<br>
<br>

<blockquote>
<b><<<新增訊息>>></b>
<%@ include file="messageContent2.jsp"%>

<%
	response.sendRedirect("addMessage.jsp?m=1");
%>