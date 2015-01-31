<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">

<%
String ownerName=request.getParameter("ownerName");
String ps=request.getParameter("ps");

int ownId=Integer.parseInt(request.getParameter("ownerId"));
int status=Integer.parseInt(request.getParameter("status"));

OwnerMgr om=OwnerMgr.getInstance();

Owner ow=(Owner)om.find(ownId);
ow.setOwnerName   	(ownerName);
ow.setOwnerPs   	(ps);
ow.setOwnerStatus (status);

om.save(ow);

response.sendRedirect("steupOwner.jsp");  
%>