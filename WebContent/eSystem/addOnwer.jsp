<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%@ include file="justHeader.jsp"%>
<%
String ownerName=request.getParameter("ownerName");
String ps=request.getParameter("ps");

Owner ow=new Owner();
ow.setOwnerName   	(ownerName);
ow.setOwnerPs   	(ps);
ow.setOwnerStatus (1);
ow.setBunitId(_ws2.getSessionBunitId());
OwnerMgr om=OwnerMgr.getInstance();

om.createWithIdReturned(ow);

response.sendRedirect("steupOwner.jsp");  
%>