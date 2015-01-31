<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,java.io.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=11;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%
    if(!checkAuth(ud2,authHa,400))
    {
        response.sendRedirect("authIndex.jsp?code=400");
    }
%>
<%@ include file="leftMenu11.jsp"%>

<%
 	JsfPay jp=JsfPay.getInstance();

	Tradeaccount[] tradeA2=jp.getActiveTradeaccount(ud2.getId());

	if(tradeA2!=null)
	{ 
%>  
	<br>
	<br>
	<%@ include file="userselfTradeAccountPic.jsp"%>
<%
	}else{
%>
        <br>
        <div class=es02>
        <b>&nbsp;&nbsp;<img src="pic/casex.png" border=0>&nbsp;我的零用金帳戶:</b>
        </div>
        <table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>				
<%	
		out.println("<br><blockquote><div class=es02>沒有可用的個人零用金帳戶</div></blockquote>");
	} 
	
%>
<br>
<%@ include file="bottom.jsp"%>