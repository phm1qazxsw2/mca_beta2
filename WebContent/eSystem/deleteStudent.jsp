<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>

<%
	
	String studentIdS=request.getParameter("studentId");

	int studentId=Integer.parseInt(studentIdS);

	StudentMgr sm=StudentMgr.getInstance();

	Student stu=(Student)sm.find(studentId);
	
	stu.setStudentStatus(98);	

	sm.save(stu);
	response.sendRedirect("listVisit.jsp?d=1");		
%>