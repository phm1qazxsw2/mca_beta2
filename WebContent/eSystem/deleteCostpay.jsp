<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=2;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu2.jsp"%>

<%

int cpid=Integer.parseInt(request.getParameter("cpid"));

CostpayMgr cpm=CostpayMgr.getInstance();
Costpay oldCostpay=(Costpay)cpm.find(cpid);

CostbookMgr cbmgr = CostbookMgr.getInstance();
int costbookid = oldCostpay.getCostpayCostbookId();
Costbook cb = (Costbook) cbmgr.find(costbookid);

JsfPay ja=JsfPay.getInstance();
ja.removeCostpay(cb, oldCostpay); 

response.sendRedirect("modifyCostbook.jsp?cid="+costbookid+"&showType=2");


%>