<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>


<%

request.setCharacterEncoding("UTF-8");
String itemName=request.getParameter("itemName");


IncomeSmallItemMgr isiz=IncomeSmallItemMgr.getInstance();
IncomeSmallItem isim=new IncomeSmallItem();
isim.setIncomeSmallItemName   	(itemName);
isim.setIncomeSmallItemActive   	(1);
isim.setIncomeSmallItemIncomeBigItemId(2); 

isiz.createWithIdReturned(isim);

response.sendRedirect("modifySalary2.jsp?m=1");
%>