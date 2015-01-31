<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=7;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%
	
	int costId=Integer.parseInt(request.getParameter("contactId"));
	TcontactMgr cfm=TcontactMgr.getInstance();
	cfm.remove(costId);
%>

資料已刪除!!