<%@ page language="java" buffer="32kb"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,phm.accounting.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=7;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%> 
<%@ include file="leftMenu7.jsp"%>

<%


int ctId=Integer.parseInt(request.getParameter("ctId"));

JsfPay jp=JsfPay.getInstance();

TradeaccountMgr tm=TradeaccountMgr.getInstance();

Costpay[] cp=jp.getAccountType1CostpayByTradeId(ctId);

if(cp==null) 
{ 
    // ## 2009/2/19 - by peter
    VoucherService vsvc = new VoucherService(0, _ws.getSessionBunitId());
    Acode oa = vsvc.getCashAcode(1, ctId);
    vsvc.disableAcode(oa.getId());

	tm.remove(ctId);
	response.sendRedirect("listTradeaccount.jsp");
}else{

	out.println("<BR><BR><blockquote><img src=\"pic/warning.gif\" border=0>目前已登入交易資料,不得刪除!!</blockquote>");
}

%>

<%@ include file="bottom.jsp"%>