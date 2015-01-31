<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=2;
    int leftMenu=3;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu2.jsp"%>

<br> 
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;廠商匯款帳戶</b>

</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<br>
<div class=es02>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="addClientAccount.jsp"><img src="pic/add.gif" border=0 width=15>&nbsp;<font color=blue>新增匯款交易帳號</font></a>
</div>
<br>
<center>

<% 
		JsfAdmin ja=JsfAdmin.getInstance();
		
        ClientAccount[] ca=ja.getAllClientAccount(_ws.getBunitSpace("bunitId")); 
		if(ca==null) 
		{ 
%> 
		<blockquote>
			目前沒有匯款交易帳號.
		</blockquote> 
		
		<%@ include file="bottom.jsp"%>	
<%		
			return;			
		} 

        CosttradeMgr cmm=CosttradeMgr.getInstance();
%>
	<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#f0f0f0 class=es02>
            <td>廠商名稱</td>
            <td align=middle>帳戶名稱</td>
            <td align=middle>銀行名稱-分行名稱</td> 
            <td align=middle>銀行代號 - 帳號</td>
            <td align=middle>戶名</td> 
            <td align=middle>狀態</td>
            <td></td>
 		</tr>
		 
<%		
		for(int i=0;i<ca.length;i++)
		{

            Costtrade co=(Costtrade)cmm.find(ca[i].getClientAccountCosttrade()); 
%>
		<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>

			
            <td class=es02><%=(co!=null)?co.getCosttradeName():""%></td>            
            <td class=es02><%=ca[i].getClientAccountBankOwner()%></td>
			<td class=es02><%=ca[i].getClientAccountBankName()%>-<%=ca[i].getClientAccountBankBranchName()%></td> 
			<tD class=es02>
<%=(ca[i].getClientAccountBankNum()==null || ca[i].getClientAccountBankNum().length()<=0)?"未設定":ca[i].getClientAccountBankNum()%>-

<%=(ca[i].getClientAccountAccountNum()==null || ca[i].getClientAccountAccountNum().length()<=0)?"未設定":ca[i].getClientAccountAccountNum()%>
            </tD>
			
            <td class=es02><%=ca[i].getClientAccountAccountName()%></td>
			<td class=es02>
				<%=(ca[i].getClientAccountActive()==1)?"使用中":"停用"%>
			</td>
  			<td class=es02>
  				<a href="modifyClientAccount.jsp?caId=<%=ca[i].getId()%>"><img src="pic/fix.gif" border=0>詳細資料</a>	
  			</td>
 		</tr>

<%
		}
%>
	</table> 
	
	</td>
	</tr>
	</table>
  	

</center>
<br>
<br>

<%@ include file="bottom.jsp"%>	