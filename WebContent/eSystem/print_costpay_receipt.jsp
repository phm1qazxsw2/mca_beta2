<%@ page language="java"  
    import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,java.io.*,mca.*,phm.util.*" 
    contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%@ include file="justHeader.jsp"%>
<%
    int cpId = Integer.parseInt(request.getParameter("id"));
    Object[] objs = CostpayMgr.getInstance().retrieve("id=" + cpId, "");
    CostpayDescription cpd = new CostpayDescription(objs);
    response.sendRedirect(cpd.getReceiptLink((Costpay)objs[0]));
%>