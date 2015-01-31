<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>

<%
	String ctId=request.getParameter("ctId");
	
	TradeaccountMgr tm=TradeaccountMgr.getInstance();
	
	Tradeaccount td=(Tradeaccount)tm.findX(Integer.parseInt(ctId), _ws2.getBunitSpace("bunitId"));

    if (td==null) {
        %><script>alert("資料不存在");history.go(-1)</script><%
        return;
    }

%>

<b><%=td.getTradeaccountName()%> -照片上傳</b>

<br>
<center>
<form action="uploadTradePic2.jsp"  enctype="multipart/form-data" method="post">
<table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">


<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 align=left valign=middle>
		<tD>檔案位置</td>
		<td align=left class=es02  bgcolor=#ffffff><input type=file name="photo1"></td>
	</tr>
	<tr>
		<td colspan=2>
			
			<center>
				<input type="hidden" name="ctId" value="<%=ctId%>">
				<input type=submit value="上傳照片">
			</center>
		</tD>
	<tr  bgcolor=#ffffff class=es02>
		<td colspan=2> p.s 建議照片大小: 寬 150 * 高: 113</tD>
	</tr>
	
	</table>
	
	</tD>
	</tr>
	</table>
</center>