<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
 	request.setCharacterEncoding("UTF-8");
 	
 	int teacherId=Integer.parseInt(request.getParameter("teacherId"));
	String teacherBank1=request.getParameter("teacherBank1");  
	String teacherAccountNumber1=request.getParameter("teacherAccountNumber1"); 
	String teacherBank2=request.getParameter("teacherBank2");  
	String teacherAccountNumber2=request.getParameter("teacherAccountNumber2"); 
	String teacherAccountName1=request.getParameter("teacherAccountName1"); 
	String teacherAccountName2=request.getParameter("teacherAccountName2");
	int bankDefault=0;
    try { bankDefault=Integer.parseInt(request.getParameter("bankDefault")); } catch (Exception e) {}
	String teacherPs=request.getParameter("teacherPs"); 

	int payWay=Integer.parseInt(request.getParameter("payWay")); 
	int teacherParttime=0;
    try { teacherParttime=Integer.parseInt(request.getParameter("teacherParttime")); } catch (Exception e) {}

	String teacherBankName1=request.getParameter("teacherBankName1"); 
	String teacherBankName2=request.getParameter("teacherBankName2");


		
	TeacherMgr tm=TeacherMgr.getInstance();
	Teacher tea=(Teacher)tm.find(teacherId);
	
	tea.setTeacherBank1   	(teacherBank1);
	tea.setTeacherAccountNumber1   	(teacherAccountNumber1);
	tea.setTeacherBank2   	(teacherBank2);
	tea.setTeacherAccountNumber2   	(teacherAccountNumber2);
	tea.setTeacherPs   	(teacherPs);
	tea.setTeacherAccountDefaut(bankDefault);
	tea.setTeacherAccountName1(teacherAccountName1);
	tea.setTeacherAccountName2(teacherAccountName2);
	tea.setTeacherPs   	(teacherPs);
	tea.setTeacherAccountPayWay(payWay);
	tea.setTeacherParttime(teacherParttime);
    tea.setTeacherBankName1(teacherBankName1);
	tea.setTeacherBankName2(teacherBankName2);

	tm.save(tea);
    response.sendRedirect("modifyTeacherAccount.jsp?teacherId=" + teacherId);
%>


