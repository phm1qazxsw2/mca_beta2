<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=2;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%
    if(!checkAuth(ud2,authHa,203))
    {
        response.sendRedirect("authIndex.jsp?code=203");
    }
%>
<%@ include file="leftMenu2-new.jsp"%>

<%

    JsfAdmin ja=JsfAdmin.getInstance();
    Costtrade[] ct=ja.getActiveCosttrade();

    int ctId=0;
    String ctS=request.getParameter("ctId");
    
    if(ctS !=null)
        ctId=Integer.parseInt(ctS);

    String backurl=request.getParameter("backurl");

%>
<br>
<div class=es02>
<b>&nbsp;&nbsp;<img src="pic/add.gif" border=0>&nbsp;新增匯款交易帳號</b>
</div>
<br>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<blockquote>

<form action="addClientAccount2.jsp" method="post">
	<table width="60%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
		<td>廠商名稱</td>
		<td colspan=3 bgcolor=#ffffff>
            <select name="costtradeId">
                <option value="0" <%=(ctId==0)?"selected":""%>>未設定</option>
<%
            for(int i=0;ct !=null && i<ct.length;i++){
%>
                <option value="<%=ct[i].getId()%>" <%=(ctId==ct[i].getId())?"selected":""%>><%=ct[i].getCosttradeName()%></option>
<%
            }
%>
            </select>

	</tR>        
	<tr bgcolor=#f0f0f0 class=es02>
		<td>帳戶名稱</td>
		<td colspan=3 bgcolor=#ffffff><input type=text size=20 name="clientAccountBankOwner"></td>
	</tR>
	<tr bgcolor=#f0f0f0 class=es02>
		<td>銀行名稱</td>
		<td  bgcolor=#ffffff>
			<input type=text size=10 name="clientAccountBankName">
			代號<input type=text size=5 name="clientAccountBankNum">
		</td>
		<td>分行名稱</td>
		<td bgcolor=#ffffff><input type=text size=10 name="clientAccountBankBranchName"></td>
	</tR>
	<tr bgcolor=#f0f0f0 class=es02>
		<td>帳號</td>
		<td colspan=3 bgcolor=#ffffff><input type=text size=20 name="clientAccountAccountNum"></td>
	</tR>
	<tr bgcolor=#f0f0f0 class=es02>
		<td>戶名</td>
		<td colspan=3 bgcolor=#ffffff><input type=text size=20 name="clientAccountAccountName"></td>
	</tR>	
	<tr bgcolor=#f0f0f0 class=es02>
		<td>備註</td>
		<td colspan=3 bgcolor=#ffffff>
			<textarea name="clientAccountBankIdPs" rows=3 cols=30>
</textarea> 
		</td>
	</tR>	
	<tr>
		<td colspan=4 align=center>
            <input type=hidden name="backurl" value="<%=(backurl!=null &&backurl.length()>0)?backurl:"listClientAccount.jsp"%>">
			<input type="submit" value="新增" onClick="return(confirm('確認新增?'))">
		</td>
	</tr>
	</table>
	
	</td>
	</tR>
	</table>
</form>
</blockquote>

<%@ include file="bottom.jsp"%>