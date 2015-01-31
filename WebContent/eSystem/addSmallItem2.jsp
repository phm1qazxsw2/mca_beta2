<%@ page language="java" buffer="32kb" import="web.*,jsf.*" contentType="text/html;charset=UTF-8"%>


<%
 request.setCharacterEncoding("UTF-8");
  
 String itemName=request.getParameter("isiName");	 
 int bID=Integer.parseInt(request.getParameter("bigItemId")); 

 SmallItem si=new SmallItem();
 
 si.setSmallItemName(itemName);   
 si.setSmallItemActive(1); 
 si.setSmallItemBigItemId(bID);

 SmallItemMgr sim=SmallItemMgr.getInstance();
 sim.createWithIdReturned(si);

 String xPage=request.getParameter("xPage"); 

if(xPage!=null)
{  	
	response.sendRedirect("modifyThisBigItem.jsp?bid="+bID+"&m=1");
}else{	
 	response.sendRedirect("ListBigItem.jsp"); 
} 

 %>
 