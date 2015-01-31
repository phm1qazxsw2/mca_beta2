<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=2;
    int leftMenu=3;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu2.jsp"%>

<%
	int caId=Integer.parseInt(request.getParameter("caId"));
	
	ClientAccountMgr cam=ClientAccountMgr.getInstance();
	ClientAccount ca=(ClientAccount)cam.find(caId);

    JsfAdmin ja=JsfAdmin.getInstance();
    Costtrade[] ct=ja.getActiveCosttrade();
 
    String backurl=request.getParameter("backurl");
%>
<br>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/fix.gif" border=0>修改匯款交易帳號</b>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <a href="listClientAccount.jsp"><img src="pic/last.gif" border=0 width=15>&nbsp;回帳號列表</a>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<blockquote>
<form action="modifyClientAccount2.jsp" method="post">
	<table width="60%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>

	<tr bgcolor=#f0f0f0 class=es02>
		<td>廠商名稱</td>
        <td colspan=3 bgcolor=ffffff>
            <select name="costtradeId">
                <option value="0" <%=(ca.getClientAccountCosttrade()==0)?"selected":""%>>未設定</option>
<%
            for(int i=0;ct !=null && i<ct.length;i++){
%>
                <option value="<%=ct[i].getId()%>" <%=(ca.getClientAccountCosttrade()==ct[i].getId())?"selected":""%>><%=ct[i].getCosttradeName()%></option>
<%
            }
%>

            </select>
        </td>
    </tr>

	<tr bgcolor=#f0f0f0 class=es02>
		<td>帳戶名稱</td>
		<td colspan=3 bgcolor=#ffffff><input type=text size=20 name="clientAccountBankOwner" value="<%=ca.getClientAccountBankOwner()%>"></td>
	</tR>
	
	<tr bgcolor=#f0f0f0 class=es02>
		<td>使用狀態</td>
		<td colspan=3 bgcolor=#ffffff>
			<input type=radio name="clientAccountActive" value=1 <%=(ca.getClientAccountActive()==1)?"checked":""%>>使用中
			<input type=radio name="clientAccountActive" value=0 <%=(ca.getClientAccountActive()==0)?"checked":""%>> 停用
		</td>
	</tR>
	<tr bgcolor=#f0f0f0 class=es02>
		<td>銀行名稱</td>
		<td  bgcolor=#ffffff>
			<input type=text size=10 name="clientAccountBankName"  value="<%=ca.getClientAccountBankName()%>">
			代號<input type=text size=5 name="clientAccountBankNum" value="<%=ca.getClientAccountBankNum()%>">
		</td>
		<td>分行名稱</td>
		<td bgcolor=#ffffff><input type=text size=10 name="clientAccountBankBranchName" value="<%=ca.getClientAccountBankBranchName()%>"></td>
	</tR>
	<tr bgcolor=#f0f0f0 class=es02>
		<td>帳號</td>
		<td colspan=3 bgcolor=#ffffff><input type=text size=20 name="clientAccountAccountNum" value="<%=ca.getClientAccountAccountNum()%>"></td>
	</tR>
	<tr bgcolor=#f0f0f0 class=es02>
		<td>戶名</td>
		<td colspan=3 bgcolor=#ffffff><input type=text size=20 name="clientAccountAccountName" value="<%=ca.getClientAccountAccountName()%>"></td>
	</tR>	
	<tr bgcolor=#f0f0f0 class=es02>
		<td>備註</td>
		<td colspan=3 bgcolor=#ffffff>
			<textarea name="clientAccountBankIdPs" rows=3 cols=30><%=ca.getClientAccountBankIdPs()%></textarea> 
		</td>
	</tR>	
	<tr>
		<td colspan=4 align=center> 
			<input type="hidden" name="caId" value="<%=caId%>">
 			
            <input type="hidden" name="backurl" value="<%=backurl%>">
            <input type="submit" value="修改" onClick="return(confirm('確認修改?'))">
		</td>
	</tr>
	</table>

	
	</td>
	</tR>
	</table>
</form>
</blockquote>

<%@ include file="bottom.jsp"%>