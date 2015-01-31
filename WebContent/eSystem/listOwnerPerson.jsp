<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=10;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu10.jsp"%>
<%
	String otIdS=request.getParameter("otId");
	
	if(otIdS==null)
	{
		out.println("沒有帳戶資料");
		return;
	}

	int otid=Integer.parseInt(otIdS);
	
	OwnerMgr om=OwnerMgr.getInstance();
	Owner ow=(Owner)om.find(otid);

	if(ow==null)
	{
		out.println("沒有帳戶資料");
		return;
	}

	JsfPay jp=JsfPay.getInstance();
	
	Ownertrade[] ot=jp.getPersonOwnertrade(ow);

	if(ot==null)
	{
		out.println("沒有交易資料");
		return;
	}
	
	
	UserMgr um=UserMgr.getInstance();
	
	java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/dd"); 
	DecimalFormat mnf = new DecimalFormat("###,###,##0");

%>
 
 
<br>
<br>
<b>&nbsp;&nbsp;&nbsp;股東權益變更 -<%=ow.getOwnerName()%> 交易明細</b> 
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<blockquote>

<table width="" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 align=left valign=middle>
		<td>入帳日期</td><td>交易帳戶</td><td width=50>提取</td><td width=50>挹注</td><td>登入人</td><td>審核</td><td></td>
	</tr>
	<%
 
		int allTotal=0;
		for(int i=0;i<ot.length;i++)
		{
 
			if(ot[i].getOwnertradeInOut()==1)
				allTotal-=ot[i].getOwnertradeNumber();
			
			if(ot[i].getOwnertradeInOut()==0)	
				allTotal+=ot[i].getOwnertradeNumber();		
	%>
	<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
		<td class=es02> 
			<%=df.format(ot[i].getOwnertradeAccountDate())%>			
		</td>
		<td class=es02>
		<%=(ot[i].getOwnertradeAccountType()==1)?"個人零用金帳戶-":"銀行帳戶-"%>
		<%
				if(ot[i].getOwnertradeAccountType()==1)	
				{
 
					TradeaccountMgr tmx2=TradeaccountMgr.getInstance();
					Tradeaccount  td=(Tradeaccount)tmx2.find(ot[i].getOwnertradeAccountId()); 
                    if (td!=null)
    					out.println(td.getTradeaccountName());
                    else
                        out.println("**零用金帳戶已被刪除");

				}else if(ot[i].getOwnertradeAccountType()==2){
					BankAccountMgr bam2=BankAccountMgr.getInstance();
					BankAccount ba=(BankAccount)bam2.find(ot[i].getOwnertradeAccountId()); 
                    if (ba!=null)
    					out.println(ba.getBankAccountName());
                    else
                        out.println("**銀行帳戶已被刪除");
				}		
		%>
		</td>
		<td class=es02 align=right><%=(ot[i].getOwnertradeInOut()==1)?mnf.format(ot[i].getOwnertradeNumber()):""%></td>
		<td class=es02 align=right><%=(ot[i].getOwnertradeInOut()==0)?mnf.format(ot[i].getOwnertradeNumber()):""%></td>
		
		<td class=es02>
		<%
		User u2=(User)um.find(ot[i].getOwnertradeLogId());
		out.println(u2.getUserFullname());
		%>	
		</td>
		<td class=es02>
		<%	
			switch(ot[i].getOwnertradeCheckLog()){
				case 0:
					out.println("尚未審核");
					break;
			}
		%>
		</td>
		<td class=es02>
			<a href="detailOwnertrade.jsp?otId=<%=ot[i].getId()%>">詳細資料</a> 
		</td>
	</tr>
	<%
		}
	%>
	<tr class=es02>
		<td colspan=2>交易金額小計</tD>
 
		<td></td>
		<tD align=right><b><%=mnf.format(allTotal)%></b></td>
		<td></td> 
	
	</table>
 
	
	</td>
	</tr>
	</table>
        <br>
<br>
    <div class=es02><a href="javascript:history.go(-1);">回上一頁</a></div>

</blockquote>
<%@ include file="bottom.jsp"%>
