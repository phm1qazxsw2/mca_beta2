<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
 	request.setCharacterEncoding("UTF-8");
 	
 	int teacherId=Integer.parseInt(request.getParameter("teacherId"));

	int teacherHealthType=0;
    try { teacherHealthType=Integer.parseInt(request.getParameter("teacherHealthType")); } catch (Exception e) {}

	int teacherHealthMoney=0;
    try { teacherHealthMoney=Integer.parseInt(request.getParameter("teacherHealthMoney")); } catch (Exception e) {}

	int teacherHealthPeople=0;
    try { teacherHealthPeople=Integer.parseInt(request.getParameter("teacherHealthPeople")); } catch (Exception e) {}

	int teacherLaborMoney=0;
    try { teacherLaborMoney=Integer.parseInt(request.getParameter("teacherLaborMoney")); } catch (Exception e) {}

	int teacherRetireMoney=0;
    try { teacherRetireMoney=Integer.parseInt(request.getParameter("teacherRetireMoney")); } catch (Exception e) {}

	int teacherRetirePercent=0;
    try { teacherRetirePercent=Integer.parseInt(request.getParameter("teacherRetirePercent")); } catch (Exception e) {}

	
	TeacherMgr tm=TeacherMgr.getInstance();
	Teacher tea=(Teacher)tm.find(teacherId);
    tea.setTeacherHealthType   	(teacherHealthType);
    tea.setTeacherHealthMoney   	(teacherHealthMoney);
    tea.setTeacherHealthPeople   	(teacherHealthPeople);
    tea.setTeacherLaborMoney   	(teacherLaborMoney);
    tea.setTeacherRetireMoney   	(teacherRetireMoney);
    tea.setTeacherRetirePercent   	(teacherRetirePercent);

	tm.save(tea);
    response.sendRedirect("modifyTeacherFee.jsp?teacherId=" + teacherId);
%>
