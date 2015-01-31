<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
request.setCharacterEncoding("UTF-8");
String tradeName=request.getParameter("tradeName");
int userId=Integer.parseInt(request.getParameter("userId"));
int tradeAccountOrder=Integer.parseInt(request.getParameter("tradeAccountOrder"));


TradeaccountMgr cm=TradeaccountMgr.getInstance();

Tradeaccount ct=new Tradeaccount();

ct.setTradeaccountName(tradeName);
ct.setTradeaccountActive(1);
ct.setTradeaccountUserId(userId);
ct.setTradeaccountAuth(1);
ct.setTradeAccountOrder(tradeAccountOrder);
ct.setBunitId(_ws2.getSessionBunitId());
cm.createWithIdReturned(ct);
%>

<br>
<div class=es02>
<b>&nbsp;&nbsp;<img src="pic/add.gif" border=0>&nbsp;新增零用金帳號</b>
</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<blockquote>

    <div class=es02>
        新增成功.
    </div>
</blockquote>
