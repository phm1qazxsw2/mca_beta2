<%@ page language="java"  import="web.*,jsf.*" contentType="text/html;charset=UTF-8"%>

<%
	int lrId=Integer.parseInt(request.getParameter("lrId"));
	int active=Integer.parseInt(request.getParameter("active"));

	String dName =request.getParameter("dName");

	LeaveReasonMgr lrm=LeaveReasonMgr.getInstance();
	
	LeaveReason lr=(LeaveReason)lrm.find(lrId);
	lr.setLeaveReasonActive(active);
	lr.setLeaveReasonName (dName);
	lrm.save(lr);
	response.sendRedirect("listLeaveReason.jsp");
%>