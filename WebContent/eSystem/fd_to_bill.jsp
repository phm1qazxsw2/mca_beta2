<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%
    FeeDetail orgfd = FeeDetailMgr.getInstance().find("id=" + request.getParameter("id"));
    ChargeItem ci = ChargeItemMgr.getInstance().find("id=" + orgfd.getChargeItemId());
    response.sendRedirect("bill_detail_express.jsp?rid=" + ci.getBillRecordId() + "&sid=" + orgfd.getMembrId() + "&backurl=1");
%>