<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=9;
    int leftMenu=1;
%>
<%@ include file="topMenuAdvanced.jsp"%>
<%@ include file="leftMenu9.jsp"%>
<br>
<br>

<b>資料備份首頁 </b>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<%
	JsfAdmin jatop=JsfAdmin.getInstance();
 
	JsfPay jp=JsfPay.getInstance();
	boolean needBack=true;
	
	Dbbackup[] dbbtop=jatop.getAllDbbackup();

	SimpleDateFormat sdf2=new SimpleDateFormat("yyyy/MM/dd HH:mm");

	if(dbbtop==null)
	{
		out.println("<br><blockquote>沒有資料!</blockquote><br>");
 
%>
		<%@ include file="bottom.jsp"%>
<%		
		return;
	}
%>

<blockquote> 
	
<table width="60%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr>
		<tD bgcolor=#f0f0f0 class=es02 >
		上次備份時間:
		</tD>
		<td bgcolor=#ffffff class=es02 >
		<font color=blue><%=sdf2.format(dbbtop[0].getCreated())%></font></b><br>
		</tD>
	</tr>
	</table>
	</td>
	</tr>
	</table>

</blockquote>

<%@ include file="bottom.jsp"%>