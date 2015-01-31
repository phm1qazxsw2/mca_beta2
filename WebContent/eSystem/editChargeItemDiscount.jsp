<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=1;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu1.jsp"%>
<%
    String backurl = "editChargeItemDiscount.jsp?" + request.getQueryString();
%>
<%@ include file="editChargeItemDiscountContent.jsp"%>
<%
    _ws.setBookmark(ud2, "整批折扣-" + bcitem.getName() + "-" + bcitem.getBillRecordName());
%>
<%@ include file="bottom.jsp"%>	