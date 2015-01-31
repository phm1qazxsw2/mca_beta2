<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<script src="js/cookie.js"></script>
<%
request.setCharacterEncoding("UTF-8");
String tradeName=request.getParameter("tradeName");

CosttradeMgr cm=CosttradeMgr.getInstance();
Costtrade ct=new Costtrade();
ct.setCosttradeName(tradeName);
ct.setCosttradeActive(1);
ct.setBunitId(_ws2.getSessionBunitId());
int ctId=cm.createWithIdReturned(ct);

CostbigitemMgr cbm=CostbigitemMgr.getInstance();
Costbigitem cb=new Costbigitem();
cb.setCosttradeId(ctId);
cb.setBigitemId(0);
int id = cbm.createWithIdReturned(cb);

String p=request.getParameter("p"); 

if (p==null) 
{
 response.sendRedirect("listCosttrade.jsp");
} else {	
  %>新增完成!!<script>parent.setCostTradeId(<%=ctId%>, '<%=phm.util.TextUtil.escapeJSString(tradeName)%>');parent.costtradewin.hide();</script><%
}
%>

