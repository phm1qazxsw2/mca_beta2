<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>

<%
String salaryTypeName=request.getParameter("salaryTypeName");
String salaryTypeFullName=request.getParameter("salaryTypeFullName");
//int salaryTypeContinueActive=Integer.parseInt(request.getParameter("salaryTypeContinueActive")); 	
//int salaryTypeContinue=Integer.parseInt(request.getParameter("salaryTypeContinue"));
//int salaryTypeVerufyNeed=Integer.parseInt(request.getParameter("salaryTypeVerufyNeed"));
int salaryTypeFixNumber=Integer.parseInt(request.getParameter("salaryTypeFixNumber"));
int type=Integer.parseInt(request.getParameter("type"));
String ps=request.getParameter("ps");


SalaryTypeMgr stm=SalaryTypeMgr.getInstance();
SalaryType st=new SalaryType();

st.setSalaryType   	(type);
st.setSalaryTypeName   	(salaryTypeName);
st.setSalaryTypeFullName   	(salaryTypeFullName);
st.setSalaryTypeActive   	(1);
st.setSalaryTypePs   	(ps);
//st.setSalaryTypeContinue   	(salaryTypeContinue);
//st.setSalaryTypeContinueActive(salaryTypeContinueActive);  
//st.setSalaryTypeVerufyNeed(salaryTypeVerufyNeed);
st.setSalaryTypeFixNumber(salaryTypeFixNumber);
stm.createWithIdReturned(st);

if(type==1)
	response.sendRedirect("modifySalary.jsp?m=3");
else if(type==2)
	response.sendRedirect("modifySalary2.jsp?m=3");
else if(type==3) 
	response.sendRedirect("modifySalary3.jsp?m=3"); 
else if(type==5)
	response.sendRedirect("modifySalary4.jsp?m=3");
  	
%>