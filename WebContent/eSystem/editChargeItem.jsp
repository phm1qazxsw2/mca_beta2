<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=1;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu1.jsp"%>
<%
    String backurl = "editChargeItem.jsp?" + request.getQueryString();
%>
<%@ include file="editChargeItemContent.jsp"%>
<%
    _ws.setBookmark(ud2, "整批編輯-" + bcitem.getName() + "-" + bcitem.getBillRecordName() + conn_str);
%>
<%@ include file="bottom.jsp"%>	