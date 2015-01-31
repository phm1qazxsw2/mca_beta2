<%@ page language="java"  import="web.*,jsf.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%> 

<%
	request.setCharacterEncoding("UTF-8");
 	String rName=request.getParameter("dName");

	LevelMgr rm=LevelMgr.getInstance();
	
	Level ra=new Level();
	ra.setLevelName(rName);
	
	rm.createWithIdReturned(ra);

	response.sendRedirect("listLevel.jsp");
%>