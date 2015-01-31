<%@ page language="java"  import="phm.ezcounting.*,phm.accounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%><%@ include file="../justHeader.jsp"%><%
    Date d = new Date();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    try { d = sdf.parse(request.getParameter("d")); } catch (Exception e) {}
    out.print(new VoucherService(0, _ws2.getSessionBunitId()).getSerialNo("M-", d));
%>