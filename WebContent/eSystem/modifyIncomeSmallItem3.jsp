<%@ page language="java"  import="web.*,jsf.*" contentType="text/html;charset=UTF-8"%>

<%
 request.setCharacterEncoding("UTF-8");
 String itemName=request.getParameter("isiName"); 
 int sid=Integer.parseInt(request.getParameter("sid"));
 int smallActive=Integer.parseInt(request.getParameter("isiActive"));
String directTo=request.getParameter("directTo"); 
 JsfAdmin ad=JsfAdmin.getInstance();
 IncomeSmallItem si=ad.getIncomeSmallItemById(sid);
 si.setIncomeSmallItemName(itemName);
 si.setIncomeSmallItemActive(smallActive);
 IncomeSmallItemMgr sim=IncomeSmallItemMgr.getInstance();
 
 sim.save(si);

 response.sendRedirect(directTo+"?m=1");	
%>
