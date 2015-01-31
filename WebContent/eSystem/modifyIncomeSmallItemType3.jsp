<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>


<%


String itemName=request.getParameter("sName");
int siId=Integer.parseInt(request.getParameter("siId"));
int sActive=Integer.parseInt(request.getParameter("sActive"));

IncomeSmallItemMgr isiz=IncomeSmallItemMgr.getInstance();


IncomeSmallItem isim=(IncomeSmallItem)isiz.find(siId);
isim.setIncomeSmallItemName   	(itemName);
isim.setIncomeSmallItemActive   	(sActive);
isim.setIncomeSmallItemIncomeBigItemId(3); 

isiz.save(isim);

response.sendRedirect("modifySalary3.jsp?m=2");
%>