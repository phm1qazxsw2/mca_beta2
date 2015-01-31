<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=8;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu8.jsp"%>
<%
	JsfAdmin ja=JsfAdmin.getInstance();
	int meId=Integer.parseInt(request.getParameter("meid"));
	int active=Integer.parseInt(request.getParameter("active"));

	
	MessageMgr mm=MessageMgr.getInstance();
	Message  me=(Message)mm.find(meId);	
	me.setMessageActive(1); 
	mm.save(me); 
	
	response.sendRedirect("listMessage.jsp?active="+active);
%>
 
 
