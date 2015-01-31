<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,phm.accounting.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="justHeader.jsp"%>
<%
String tradename=request.getParameter("tradename");
int active=Integer.parseInt(request.getParameter("active"));
int ctId=Integer.parseInt(request.getParameter("ctId"));
int tradeAccountOrder=Integer.parseInt(request.getParameter("tradeAccountOrder"));


int authId=Integer.parseInt(request.getParameter("authId"));

TradeaccountMgr cm=TradeaccountMgr.getInstance();

Tradeaccount ct=(Tradeaccount)cm.find(ctId);

ct.setTradeaccountUserId(authId);
String oldname = ct.getTradeaccountName();
ct.setTradeaccountName(tradename);
ct.setTradeaccountActive(active); 
ct.setTradeAccountOrder(tradeAccountOrder);

cm.save(ct);

// ## 2009/2/17 - by peter, 科目用設定的(看上面)，不用程式產生的
VoucherService vsvc = new VoucherService(0, _ws2.getSessionBunitId());
Acode oa = vsvc.getCashAcode(1, ct.getId());
if (!oldname.equals(tradename)) {
    Acode a = vsvc.modifyAcode(oa.getId(), tradename);
}

response.sendRedirect("listTradeaccount.jsp");
%>