<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
	request.setCharacterEncoding("UTF-8");
 	String rName=request.getParameter("dName");

	DepartMgr rm=DepartMgr.getInstance();
	
	Depart ra=new Depart();
	ra.setDepartName(rName);
	
	rm.createWithIdReturned(ra);

	response.sendRedirect("listDepart.jsp");
	
%>	