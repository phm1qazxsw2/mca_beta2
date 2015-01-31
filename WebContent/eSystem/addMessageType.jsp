<%@ page language="java"  import="web.*,jsf.*,java.util.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="justHeader.jsp"%>
<%
	request.setCharacterEncoding("UTF-8");
 	String placeName=request.getParameter("placeName");

	MessageTypeMgr rm=MessageTypeMgr.getInstance();
	
	MessageType ra=new MessageType();
	ra.setMessageTypeName(placeName);
	ra.setMessageTypeStatus(1);
	ra.setBunitId(_ws2.getSessionBunitId());

	rm.createWithIdReturned(ra);

	response.sendRedirect("modifyMessageType.jsp");
%>