<%@ page language="java" buffer="32kb" import="web.*,jsf.*" contentType="text/html;charset=UTF-8"%>



<%
 request.setCharacterEncoding("UTF-8");
 
 String itemName=request.getParameter("biName"); 
 int itemId=Integer.parseInt(request.getParameter("id"));
 int itemActive=Integer.parseInt(request.getParameter("iActive"));
 
 BigItemMgr bim=BigItemMgr.getInstance(); 
 BigItem bi=(BigItem)bim.find(itemId);
 
 bi.setBigItemName(itemName);    
 bi.setBigItemActive(itemActive);
 
 bim.save(bi);

response.sendRedirect("ListBigItem.jsp");
 %>
 
