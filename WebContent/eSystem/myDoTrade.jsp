<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,java.io.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=2;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu2.jsp"%>
<SCRIPT LANGUAGE="JavaScript">
<!-- Modified By:  Steve Robison, Jr. (stevejr@ce.net) -->

<!-- This script and many more are available free online at -->
<!-- The JavaScript Source!! http://javascript.internet.com -->

<!-- Begin
var checkflag = "false";
function check(field) {
if (checkflag == "false") {
for (i = 0; i < field.length; i++) {
field[i].checked = true;}
checkflag = "true";
return "Uncheck All"; }
else {
for (i = 0; i < field.length; i++) {
field[i].checked = false; }
checkflag = "false";
return "Check All"; }
}
//  End -->
</script>

<%
    if(!AuthAdmin.authPage(ud2,4))
    {
        response.sendRedirect("authIndex.jsp?page=9&info=1");
    }

	String userIdS=request.getParameter("userId");

	int userId= ud2.getId();
	if(userIdS!=null)
 
	userId =Integer.parseInt(userIdS);

	JsfPay jp=JsfPay.getInstance();
	UserMgr um=UserMgr.getInstance(); 
	
	
	User ud3=null;
	
	if(userId !=999)
		ud3=(User)um.find(userId); 
	
	JsfAdmin ja=JsfAdmin.getInstance();
	User[] u2=ja.getAccountUsers(_ws.getBunitSpace("userBunitAccounting"));

	DecimalFormat mnf = new DecimalFormat("###,###,##0");
%>
 
<br>
<blockquote>
 
	<table border=0>
		<tr class=es02>
			<td>
			<b><%=(ud3 !=null)?ud3.getUserFullname():"全部"%>的匯款單</b>
			</td>
 
			<td width=30></td>
			<td>其他使用者的匯款單:</td>
			<td width=100>
 
				<form name="XX"> 
					 
					<select name="checkUser" onChange="javascript:goReload(this.form.checkUser.value)">
					<option value="999" <%=(userId==999)?"selected":""%>>全部</option> 
					<%
						for(int i=0;i<u2.length;i++)	
						{
					%>
							<option value="<%=u2[i].getId()%>" <%=(userId==u2[i].getId())?"selected":""%>><%=u2[i].getUserFullname()%></option> 
					<%		
						}
					%>	
					</select>	
			</form>
			</td>
		</tr>
	</table>
 
	
 
	<script>
		function goReload(userId)
		{
			window.location='myDoTrade.jsp?userId='+userId;
		}
	</script> 
	

<%

	DoTrade[] dt=jp.getDoTradeByUser(userId);
	if(dt==null)
	{
%>
	<br>
	<blockquote>		
		沒有匯款的交易
	</blockquote>
<%	
		return;
	}
 
	
	java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/dd"); 

%>
 
<br>
<form action="makeDotradePDF.jsp"
   method="get" target="_blank">

	<table width="85%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#f0f0f0 class=es02>

			<td><input type="checkbox" onClick="this.value=check(this.form.outPrint)"><br><font color=blue>全選</font></td>
			<td>單號</tD>
			<td>類別</tD>
			<tD>入帳日期</td>
			<tD>傳票名稱</td>
			<td>匯款帳戶</td>
			<td>匯出帳戶</td>
			<td>金額</td>
			<tD>登入人</tD>
			<tD>狀態</tD>
		</tr>
	<%
			TradeaccountMgr tmx2=TradeaccountMgr.getInstance();
			BankAccountMgr bam2=BankAccountMgr.getInstance();

 	 	 	int payTotal=0;


			CostpayMgr cpm=CostpayMgr.getInstance();
			CostbookMgr cbm=CostbookMgr.getInstance();
			ClientAccountMgr cam=ClientAccountMgr.getInstance();
 
			
			
			for(int i=0;i<dt.length;i++)
			{
				Costpay cp=(Costpay)cpm.find(dt[i].getDoTradeCostpayId());
				
				
				int xId=0;
				String tradeType="";	
				String tradeTitle="";
				if(cp.getCostpayCostbookId()!=0)
				{
					tradeType="雜費支出";
					
					xId=cp.getCostpayCostbookId();
					Costbook cb=(Costbook)cbm.find(xId);
					tradeTitle="<a href='modifyCostbook.jsp?cid="+cb.getId()+"&showType=3'>"+cb.getCostbookName()+"</a>";
				}
				
				ClientAccount ca=(ClientAccount)cam.find(dt[i].getDoTradeClientAccountId());
		%>
		<tr bgcolor=#ffffff class=es02>

			<td>
				<input type="checkbox" name="outPrint" value="<%=dt[i].getId()%>" <%=(dt[i].getDoTradeStatus()==0)?"checked":""%>>
			</td> 
			<td>
				<%=dt[i].getId()%>
			</td>
			
			<td>
				<%=tradeType%>
			</td>
			<tD>
				<%=df.format(dt[i].getDoTradedDate())%>
			</tD>
			<tD><%=tradeTitle%></td>
			
			<td><font color=blue><a href="modifyClientAccount.jsp?caId=<%=ca.getId()%>"><%=ca.getClientAccountBankOwner()%></a></font></td>
			<td>
			<%=(cp.getCostpayAccountType()==1)?"個人零用金帳戶":"銀行帳戶"%>-
		  	<% 
					if(cp.getCostpayAccountType()==1)	
					{
						Tradeaccount  td=(Tradeaccount)tmx2.find(cp.getCostpayAccountId()); 
						out.println(td.getTradeaccountName());

					}else if(cp.getCostpayAccountType()==2){
						
						BankAccount ba=(BankAccount)bam2.find(cp.getCostpayAccountId()); 
						out.println(ba.getBankAccountName());
					}		
		  	%>

			</td>
			<tD align=right><%=mnf.format(cp.getCostpayCostNumber())%></tD>
 
			<td>
				<%
				User u=(User)um.find(dt[i].getDoTradeUserId()); 
				out.println(u.getUserFullname());
				%>
			</td>
			<td>
				<%=(dt[i].getDoTradeStatus()==0)?"<font color=blue>尚未處理</font>":"已處理"%>
				(<a href="modifyDotradeStatus.jsp?dtId=<%=dt[i].getId()%>&status=<%=(dt[i].getDoTradeStatus()==0)?"1":"0"%>" onClick="return(confirm('狀態將修改為<%=(dt[i].getDoTradeStatus()==0)?"已處理":"尚未處理"%>'))">修改</a>)
			</td>
		</tr>
	<%
		}
	%>
	<tr>
 
		<td colspan=8 align=center>
		<input type="submit" value="匯出匯款單">
		</tD>
	</tr>
	</table>
 
		 
	</tD>
	</tr>
	</table>
			
	</form>		
	</blockquote>
		