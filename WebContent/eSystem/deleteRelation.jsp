<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="justHeader.jsp"%>
<%
	RelationMgr rm=RelationMgr.getInstance();
	int rId=Integer.parseInt(request.getParameter("rId")); 
	
	Relation ra=(Relation)rm.find(rId);
	String rName=request.getParameter("rName");
	ra.setRelationName(rName);	
	rm.save(ra);

	response.sendRedirect("listRelation.jsp");
%>