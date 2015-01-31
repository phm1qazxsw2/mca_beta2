<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=5;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu5.jsp"%>
<%
    String backurl = "salarychargeitem_edit.jsp?" + request.getQueryString();
%>
<%@ include file="salarychargeitem_edit_content.jsp"%>
<%@ include file="bottom.jsp"%>	