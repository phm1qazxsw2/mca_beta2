<%@ page language="java" buffer="32kb" import="web.*,jsf.*" contentType="text/html;charset=UTF-8"%>

<%
 request.setCharacterEncoding("UTF-8");
 String itemName=request.getParameter("newBigItemName"); 

 IncomeBigItem bi=new IncomeBigItem();
 bi.setIncomeBigItemName(itemName.trim());
 bi.setIncomeBigItemActive(1);
 
 IncomeBigItemMgr bim=IncomeBigItemMgr.getInstance();
 bim.createWithIdReturned(bi);

 response.sendRedirect("ListIncomeBigItem.jsp");	
 %>
