<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=2;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu2.jsp"%>
<%

int otId=Integer.parseInt(request.getParameter("otId"));
OwnertradeMgr om=OwnertradeMgr.getInstance();
Ownertrade ot=(Ownertrade)om.findX(otId, _ws.getBunitSpace("bunitId"));

if(ot==null)
{
	out.println("沒有資料");
	return;	
}

java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/dd"); 

OwnerMgr om2=OwnerMgr.getInstance();
UserMgr um=UserMgr.getInstance();

DecimalFormat mnf = new DecimalFormat("###,###,##0");

%>  

<br>
<br>

<div class=es02>
<b>&nbsp;&nbsp;&nbsp;股東提取/挹注 交易明細</b>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href="javascript:history.go(-1);"><img src="pic/last.gif" border=0>&nbsp;回上一頁</a>
</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<blockquote> 

<table width="" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>
<tr bgcolor=#f0f0f0 class=es02 align=left valign=middle>
	<td>入帳日期</td>
	<td bgcolor=#ffffff class=es02><%=df.format(ot.getOwnertradeAccountDate())%></td>
</tr>
<tr bgcolor=#f0f0f0 class=es02 align=left valign=middle>
	<td>形式</td>
	<td bgcolor=#ffffff class=es02><%=(ot.getOwnertradeInOut()==1)?"提取":"挹注"%></td>
</tr>
<tr bgcolor=#f0f0f0 class=es02 align=left valign=middle>
	<td>股東名稱</td>
	<td bgcolor=#ffffff class=es02>
			<%
			Owner ow=(Owner)om2.find(ot.getOwnertradeOwnerId());
			
			out.println(ow.getOwnerName());
		%>

	
	</td>
</tr>
<tr bgcolor=#f0f0f0 class=es02 align=left valign=middle>
	<td>交易帳戶</td>
	<td bgcolor=#ffffff class=es02>
			<%=(ot.getOwnertradeAccountType()==1)?"個人零用金帳戶-":"銀行帳戶-"%>
		<%
				if(ot.getOwnertradeAccountType()==1)	
				{
 
					TradeaccountMgr tmx2=TradeaccountMgr.getInstance();
					Tradeaccount  td=(Tradeaccount)tmx2.find(ot.getOwnertradeAccountId()); 
					out.println(td.getTradeaccountName());

				}else if(ot.getOwnertradeAccountType()==2){
					BankAccountMgr bam2=BankAccountMgr.getInstance();
					BankAccount ba=(BankAccount)bam2.find(ot.getOwnertradeAccountId()); 
					out.println(ba.getBankAccountName());
				}		
		%>

	
	</td>
</tr>

<tr bgcolor=#f0f0f0 class=es02 align=left valign=middle>
	<td>金額</td>
	<td bgcolor=#ffffff class=es02><%=mnf.format(ot.getOwnertradeNumber())%></td>
</tr>
 

	<tr bgcolor=#f0f0f0 class=es02 align=left valign=middle>
		<td>交易方式</td>
		<td bgcolor=#ffffff class=es02>
		<%  
			int way=ot.getOwnertradeWay ();
			
			switch(way) { 
				case 1:
					out.println("現金");		
					break;	
				case 2:
					out.println("支票");		
					break;
				case 3:
					out.println("匯款");		
					break;
				case 4:
					out.println("其他");		
					break;
			} 

		%>
		
		
		</td>
	</tr>
	
<tr bgcolor=#f0f0f0 class=es02 align=left valign=middle>
	<td>登入人</td>
	<td bgcolor=#ffffff class=es02>
		<%
		User u2=(User)um.find(ot.getOwnertradeLogId());
		out.println(u2.getUserFullname());
		%>	
	</td>
</tr>
<tr bgcolor=#f0f0f0 class=es02 align=left valign=middle>
	<td>登入註記</td>
	<td bgcolor=#ffffff class=es02>
	<%=ot.getOwnertradeLogPs()%></td>
</tr>
</table> 

</td>
</tr>
</table>
<br>
<br>

</blockquote>
<%@ include file="bottom.jsp"%>