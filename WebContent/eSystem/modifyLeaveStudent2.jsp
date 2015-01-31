<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>

<%
	request.setCharacterEncoding("UTF-8");
 	String ps=request.getParameter("ps");
	int lrId=Integer.parseInt(request.getParameter("lrId"));
	int leaveStudentId=Integer.parseInt(request.getParameter("leaveStudentId"));
	int studentId=Integer.parseInt(request.getParameter("studentId"));
	
	LeaveStudentMgr lsm=LeaveStudentMgr.getInstance();
	LeaveStudent lsX=(LeaveStudent)lsm.find(leaveStudentId);

	lsX.setLeaveStudentReasonId(lrId);
	lsX.setLeaveStudentPs(ps);
	
	lsm.save(lsX);
	
	response.sendRedirect("modifyLeaveStudent.jsp?studentId="+studentId);
%>