<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,java.io.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=11;
    int leftMenu=3;
%>
<%@ include file="topMenu.jsp"%>
<%
    if(!checkAuth(ud2,authHa,403)) 
    {
        response.sendRedirect("authIndex.jsp?code=403");
    } 
%>
<%@ include file="leftMenu2-new.jsp"%>
<%
  

    SalaryAdmin sa=SalaryAdmin.getInstance();

    BankAccount[] ba=sa.getAllBankAccount(_ws.getBunitSpace("bunitId")); 
%>
<script>
	function goAlert()
	{
		window.location.reload();
	}

</script>

<br>

<div class=es02>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/bank.png" border=0>&nbsp;銀行帳戶管理</b> 
</div>
<br> 
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<div class=es02>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:openwindow_phm('addBankAccount.jsp','新增銀行帳戶',500,550,true);"><img src="pic/add.gif" width=15 border=0>&nbsp;新增銀行帳戶</a> 
</div>
<center>
<%
if(ba==null)
{
	out.println("<br>沒有資料");
%>
<%@ include file="bottom.jsp"%>	
<%	
	return;
}
%> 

<script> 
	function showAccount(divName,accountName,web1,web2,web3)
	{ 
		var s="<font color=blue>"+accountName+"</font><br><blockquote>欄位一:"+web1+"<br>"+"欄位二:"+web2+"<br>"+"欄位三:"+web3+"</blockquote>";
		
		document.getElementById(divName).innerHTML=s; 
	}
</script>
<br>
<table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>

<tr bgcolor=#f0f0f0 align=left valign=middle class=es02> 
	<td>識別照片</td><td>銀行名稱</td><td>狀態</td><td>銀行代號</td><td>帳號</td><td>薪資企業代碼</td><td>薪資匯款日期</td><td>備註</td>
	<td colspan=3></td>
</tr>

<%
for(int i=0;i<ba.length;i++)
{
%>
<tr bgcolor=#ffffff align=left valign=middle  class=es02> 
<tD>  
	<%
		  	String filePath2 =application.getRealPath("/")+"eSystem/bankAlbum/"+ba[i].getId();
		  	
		 	File FileDic2 = new File(filePath2);
			File files2[]=FileDic2.listFiles();

			File xF2=null; 
		
			if(files2 !=null)
			{ 
				for(int j2=0;j2<files2.length;j2++)
				{ 
					if(!files2[j2].isHidden())
 						xF2 =files2[j2] ;
				} 
			}
		
			if(xF2 !=null && xF2.exists())
			{
		%> 
			<img src="bankAlbum/<%=ba[i].getId()%>/<%=xF2.getName()%>" width=150 border=0>
			<br>
			<a href="deleteBankAlbum.jsp?ctId=<%=ba[i].getId()%>" onClick="javascript:return(confirm('確認刪除此照片?'))"><img src="pic/delete.gif" border=0>刪除此照片</a>
		
		<%
			} else{ 
		%> 
				[尚未上傳]<br> 
				<a href="#" onClick="javascript:openwindow72('<%=ba[i].getId()%>');return false;">上傳</a><br>
		<%	
			}
		%>

	
</tD>
<td>
	<%=ba[i].getBankAccountName()%> <br>
	<a href="<%=ba[i].getBankAccountWebAddress()%>" onMouseOver="javascript:showAccount('showWeb','<%=ba[i].getBankAccountName()%>','<%=ba[i].getBankAccountWeb1()%>','<%=ba[i].getBankAccountWeb2()%>','<%=ba[i].getBankAccountWeb3()%>')" target="_blank">[網銀]</a>
		
</td>
<td><%=(ba[i].getBankAccountActive()==1)?"使用中":"停用"%></td>
<td><%=ba[i].getBankAccountId()%></td>
<td><%=ba[i].getBankAccountAccount()%></td> 
<td><%=ba[i].getBankAccount2client()%></td>
<td><%=ba[i].getBankAccountPayDate()%></td>

<td><%=ba[i].getBankAccountLogPs()%></td> 

 
<td colspan=3>
<a href="#" onClick="javascript:openwindow551('<%=ba[i].getId()%>');return false"><img src="pic/fix.gif" border=0>修改基本資料</a><br>
<a href="show_costpay_detail.jsp?bankType=2&baid=<%=ba[i].getId()%>"><img src="pic/trade.png" border=0>交易紀錄</a><br>
<a href="addSalarybankAuth.jsp?baId=<%=ba[i].getId()%>"><img src="pic/user.gif" border=0>使用權限</a>

</td>

</tr>

<%
}
%>
</table>

</td></tr></table> 
<br>
<div id="showWeb"  class=es02 align=left></div>
</center>

<%@ include file="bottom.jsp"%>