<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=5;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu5.jsp"%>

<%

int sbId=Integer.parseInt(request.getParameter("sbId"));

SalaryBankMgr sbm=SalaryBankMgr.getInstance();

sbm.remove(sbId);


String soId=request.getParameter("soId");

response.sendRedirect("modifySalaryOutList.jsp?soId="+soId);


%>

