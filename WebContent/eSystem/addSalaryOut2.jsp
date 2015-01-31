<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>

<%
request.setCharacterEncoding("UTF-8");
String year=request.getParameter("year");
String month=request.getParameter("month");
int bankAccountId=Integer.parseInt(request.getParameter("bankAccountId"));
String ps=request.getParameter("ps");


SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM");
Date runDate=sdf.parse(year+"-"+month);

SalaryAdmin sa=SalaryAdmin.getInstance();

String bankNumber=sa.generateBanknumber(runDate);

SalaryOut so=new SalaryOut();

so.setSalaryOutMonth   	(runDate);
so.setSalaryOutBanknumber   	(Integer.parseInt(bankNumber));
so.setSalaryOutBankAccountId   	(bankAccountId);
so.setSalaryOutStatus   	(90);
so.setSalaryOutPs(ps);   


SalaryOutMgr som=SalaryOutMgr.getInstance();
som.createWithIdReturned(so);
response.sendRedirect("listSalaryOut.jsp?year="+year+"&month="+month);


%>