<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%
    FeeDetail sfd = FeeDetailMgr.getInstance().find("id=" + request.getParameter("id"));
    ChargeItem ci = ChargeItemMgr.getInstance().find("id=" + sfd.getChargeItemId());
    response.sendRedirect("salary_detail_express.jsp?rid=" + ci.getBillRecordId() + "&sid=" + sfd.getMembrId() + "&backurl=1");
%>