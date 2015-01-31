<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=7;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%
	
	int costId=Integer.parseInt(request.getParameter("costId"));
	CostMgr cfm=CostMgr.getInstance();
	cfm.remove(costId);
%>

資料已刪除!!