<%@ page language="java" buffer="32kb" import="web.*,jsf.*" contentType="text/html;charset=UTF-8"%>



<%
 request.setCharacterEncoding("UTF-8");
 
 String itemName=request.getParameter("biName"); 
 int itemId=Integer.parseInt(request.getParameter("id"));
 int itemActive=Integer.parseInt(request.getParameter("iActive"));
 
 IncomeBigItem bi=new IncomeBigItem();
 bi.setId(itemId);
 bi.setIncomeBigItemName(itemName);    
 bi.setIncomeBigItemActive(itemActive);

 IncomeBigItemMgr bim=IncomeBigItemMgr.getInstance(); 
 bim.save(bi);

 response.sendRedirect("ListIncomeBigItem.jsp");	
%>


 
 
