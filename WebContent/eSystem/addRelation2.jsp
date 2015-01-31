<%@ page language="java" buffer="32kb" import="web.*,jsf.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="justHeader.jsp"%>
<%
	request.setCharacterEncoding("UTF-8");
 	String rName=request.getParameter("rName");

	RelationMgr rm=RelationMgr.getInstance();
	
	Relation ra=new Relation();
	ra.setRelationName(rName);
    ra.setBunitId(_ws2.getSessionStudentBunitId());
	
	rm.createWithIdReturned(ra);

	response.sendRedirect("listRelation.jsp");
%>