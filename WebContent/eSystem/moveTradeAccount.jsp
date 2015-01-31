<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=2;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%


int ctId=Integer.parseInt(request.getParameter("ctId"));

TradeaccountMgr tm=TradeaccountMgr.getInstance();

Tradeaccount td=""

tm.remove(ctId);
 
response.sendRedirect("listTradeaccount.jsp");


%>