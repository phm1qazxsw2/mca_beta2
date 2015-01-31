<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=2;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu2.jsp"%>
<%

String stId=request.getParameter("stId");

String defaultString="";

if(stId !=null)
	defaultString=stId;

JsfPay jp=JsfPay.getInstance();



%>

<br>
<br>
<b>&nbsp;&nbsp;&nbsp;依傳票號碼查詢</b>

<blockquote>

<form action="searchCostbookTradeId.jsp" method="get" name="ax" id="ax">
	
	傳票號碼:<input type=text name="stId" size=10 value="<%=defaultString%>">
	<input type=submit value="查詢">	
</form>

</blockquote>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<%
if(stId !=null)
{
	Costbook cb=jp.getCostbookByCheckid(stId.trim()); 
	

	if(cb==null)
	{
		out.println("<blockquote><b><font color=red>沒有此筆資料</font></b></blockquote>");
	}else{
		response.sendRedirect("modifyCostbook.jsp?cid="+cb.getId());
	}
}
%> 
<script>
	document.ax.stId.focus();
</script>

<%@ include file="bottom.jsp"%>