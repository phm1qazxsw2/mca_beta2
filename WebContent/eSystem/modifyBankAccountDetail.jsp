<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>

<%@ include file="jumpTop.jsp"%>

<%

if(!checkAuth(ud2,authHa,403))
{
    response.sendRedirect("authIndex.jsp?code=403");   
}

String bankIdS=request.getParameter("bankId");

if(bankIdS==null)
{
	out.println("沒有選擇銀行帳戶");
 
	return;
}

int backId=Integer.parseInt(bankIdS);
 

String m=request.getParameter("m");

BankAccountMgr bam=BankAccountMgr.getInstance();

BankAccount ba=(BankAccount)bam.findX(backId, _ws2.getBunitSpace("bunitId"));

if (ba==null) {
    %><script>alert("資料不存在");history.go(-1)</script><%
    return;
}

%>
 

<b>&nbsp;&nbsp;&nbsp;<img src="pic/fix.gif" border=0>修改銀行帳戶</b><br> 

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>



<blockquote>

<table width="60%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>
<form action=modifyBankAccount2.jsp method=post>


<tr bgcolor=#ffffff align=left valign=middle>
	<td bgcolor=#f0f0f0 class=es02>內部作業帳戶名稱</td>
	<td><input type=text size=10 name=accountName value="<%=ba.getBankAccountName()%>"></td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
	<td bgcolor=#f0f0f0 class=es02>銀行資訊</td>
	<td>
	名稱<input type=text size=10 name=bankAccountRealName  value="<%=(ba.getBankAccountRealName()!=null)?ba.getBankAccountRealName():""%>">
	代號<input type=text size=5 name=accountId  value="<%=ba.getBankAccountId()%>">
	分行<input type=text size=5 name=bankAccountBranchName  value="<%=(ba.getBankAccountBranchName()!=null)?ba.getBankAccountBranchName():""%>">
	</td>
</tr>

<tr bgcolor=#ffffff align=left valign=middle>
	<td bgcolor=#f0f0f0 class=es02>帳號</td>
	<td><input type=text size=15 name=accountNumber value="<%=ba.getBankAccountAccount()%>"></td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
	<td bgcolor=#f0f0f0 class=es02>戶名</td>
	<td><input type=text size=25 name=accountNumberName value="<%=ba.getBankAccountAccountName()%>"></td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
	<td bgcolor=#f0f0f0 class=es02>開放學費匯款轉入</td>
	<td> 
		<input type=radio name="bankAccountATMActive" value=1 <%=(ba.getBankAccountATMActive()==1)?"checked":""%>>使用 
		<input type=radio name="bankAccountATMActive" value=0 <%=(ba.getBankAccountATMActive()==0)?"checked":""%>>停用  
		
		(說明:是否設定為學費的 指定匯款帳戶 ? ) 

	</td>
</tr>
 
<tr bgcolor=#ffffff align=left valign=middle>
	<td bgcolor=#f0f0f0 class=es02>薪轉企業代碼</td>
	<td><input type=text size=6 name=bankAccount2client value="<%=ba.getBankAccount2client()%>"></td>
</tr>


<tr bgcolor=#ffffff align=left valign=middle>
	<td bgcolor=#f0f0f0 class=es02>薪轉每月匯款日期</td>
	<td><input type=text size=4 name=bankAccountPayDate value="<%=ba.getBankAccountPayDate()%>"></td>
</tr>

<tr bgcolor=#ffffff align=left valign=middle>
	<td bgcolor=#f0f0f0 class=es02>使用狀態</td>
	<td>
		<input type=radio name="bankActive" value=1 <%=(ba.getBankAccountActive()==1)?"checked":""%>>使用中
		<input type=radio name="bankActive" value=0 <%=(ba.getBankAccountActive()==0)?"checked":""%>>停用
	
	</td>
</tr>

<tr bgcolor=#ffffff align=left valign=middle>
	<td bgcolor=#f0f0f0 class=es02>網路銀行網址</td>
	<td><input type=text size=30 name=bankAccountWebAddress value="<%=(ba.getBankAccountWebAddress()!=null)?ba.getBankAccountWebAddress():""%>"></td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
	<td bgcolor=#f0f0f0 class=es02>欄位一</td>
	<td><input type=text size=20 name=bankAccountWeb1 value="<%=(ba.getBankAccountWeb1()!=null)?ba.getBankAccountWeb1():""%>"></td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
	<td bgcolor=#f0f0f0 class=es02>欄位二</td>
	<td><input type=text size=20 name=bankAccountWeb2 value="<%=(ba.getBankAccountWeb2()!=null)?ba.getBankAccountWeb2():""%>"></td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
	<td bgcolor=#f0f0f0 class=es02>欄位三</td>
	<td><input type=text size=20 name=bankAccountWeb3 value="<%=(ba.getBankAccountWeb3()!=null)?ba.getBankAccountWeb3():""%>"></td>
</tr>

<tr bgcolor=#ffffff align=left valign=middle>
	<td bgcolor=#f0f0f0 class=es02>備註</td>
	<td><textarea rows=5 cols=30 name=ps><%=ba.getBankAccountLogPs()%></textarea></td>
</tr>

<tr bgcolor=#ffffff align=left valign=middle><td colspan=2><center>
<input type=hidden name="backId" value="<%=backId%>">
<input type=submit value="修改">
</center></td></tr>
</table>
</td></tr></table>
</form>
</blockquote>

</center>

<%
	if(m !=null)
	{
%>
	<script>
		alert('修改完成!');
	</script>		
<%	
	}
%>
