<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>

<%

int soId=Integer.parseInt(request.getParameter("soId"));

SalaryOutMgr som=SalaryOutMgr.getInstance();

SalaryOut so=(SalaryOut)som.find(soId);

SalaryAdmin sdmin=SalaryAdmin.getInstance();
SalaryBank[] sn=sdmin.getAllSalaryBankByBankNum(so.getSalaryOutBanknumber());


out.println(sn.length);
//out.println(so.getSalaryOutBanknumber());
%>