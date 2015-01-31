<%@ page language="java"  import="web.*,jsf.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="justHeader.jsp"%>
<%
	request.setCharacterEncoding("UTF-8");
 	String rName=request.getParameter("dName");

	LeaveReasonMgr rm=LeaveReasonMgr.getInstance();
	
	LeaveReason ra=new LeaveReason();
	ra.setLeaveReasonName(rName);
	ra.setLeaveReasonActive(1);
    ra.setBunitId(_ws2.getSessionStudentBunitId());
	
	rm.createWithIdReturned(ra);

	response.sendRedirect("listLeaveReason.jsp");
%>