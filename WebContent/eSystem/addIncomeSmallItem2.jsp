<%@ page language="java" buffer="32kb" import="web.*,jsf.*" contentType="text/html;charset=UTF-8"%>


<%
 request.setCharacterEncoding("UTF-8");
  
 String itemName=request.getParameter("isiName");	 
 int bID=Integer.parseInt(request.getParameter("bigItemId")); 
 String directTo=request.getParameter("directTo"); 
 IncomeSmallItem si=new IncomeSmallItem();
 
 si.setIncomeSmallItemName(itemName);   
 si.setIncomeSmallItemActive(1); 
 si.setIncomeSmallItemIncomeBigItemId(bID);

 IncomeSmallItemMgr sim=IncomeSmallItemMgr.getInstance();
 sim.createWithIdReturned(si);

 response.sendRedirect(directTo+"?m=2"); 	

 %>
