<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    ManHour mh = ManHourMgr.getInstance().find("id=" + request.getParameter("mhId"));
    FeeDetail fd = FeeDetailMgr.getInstance().find("id=" + mh.getSalaryfdId());
    ChargeItem ci = ChargeItemMgr.getInstance().find("id=" + fd.getChargeItemId());
    response.sendRedirect("salary_detail_express.jsp?rid=" + ci.getBillRecordId() + "&sid=" + mh.getExecuteMembrId() + "&backurl=1");
%>
