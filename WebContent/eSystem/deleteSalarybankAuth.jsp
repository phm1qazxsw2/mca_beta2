<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=5;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>

<%

int baId=Integer.parseInt(request.getParameter("baId"));

int baAuth=Integer.parseInt(request.getParameter("baAuth"));
SalarybankAuthMgr sam=SalarybankAuthMgr.getInstance();

sam.remove(baAuth);

response.sendRedirect("addSalarybankAuth.jsp?baId="+baId);
%>