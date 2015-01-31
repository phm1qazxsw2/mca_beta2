<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>

<%
	
	int cmId=Integer.parseInt(request.getParameter("cmId"));

	
	ClosemonthMgr cmm=ClosemonthMgr.getInstance();
	Closemonth cm =(Closemonth)cmm.find(cmId);
    String salaryPs=request.getParameter("salaryPs");
 
    cm.setClosemonthSalaryUserId   	(ud2.getId());
	cm.setClosemonthSalaryPs   	(salaryPs);
	
		
    JsfPay jp=JsfPay.getInstance();
     
    jp.runCloseSalary(cm);
  
 	cm =(Closemonth)cmm.find(cmId);
  	jp.changeClosemonthStatus(cm);
 	
 	response.sendRedirect("modifyClose.jsp?cmId="+cmId+"&type=2");
	

%>