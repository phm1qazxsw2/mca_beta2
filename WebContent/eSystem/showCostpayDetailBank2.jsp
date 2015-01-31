<%@ page language="java" buffer="32kb" 
import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=10;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu10.jsp"%>
<br>
<br>
<%  
    request.setCharacterEncoding("UTF-8");
	String bankTypeS=request.getParameter("bankType");
	
	int bankType=1;
	if(bankTypeS!=null)
		bankType=Integer.parseInt(bankTypeS);	 
	
	DecimalFormat mnf = new DecimalFormat("###,###,##0");

    String baidS=request.getParameter("baid");

    int tradeId=1;
    if(baidS !=null)
        tradeId=Integer.parseInt(baidS);
	
	String showTypeS=request.getParameter("showType");
	
	JsfAdmin ja=JsfAdmin.getInstance(); 
	
	if(bankType==2) 
	{ 
		if(ud2.getUserRole()>2 && !ja.isAuthBank(tradeId,ud2.getId()))
		{	
%>
			<br>	
			<br>
			<blockquote>	
				<div class=es02>權限不足!	</div>
			</blockquote>			
	
			<%@ include file="bottom.jsp"%>
<%		
				return;
		}	
	}	
	int showType=0;
	if(showTypeS !=null) 
		 showType=Integer.parseInt(showTypeS);
	
	JsfPay jp=JsfPay.getInstance(); 
	
	int type=99; 
	int tradeType =99;
	String  typeS=request.getParameter("type");
	String  tradeTypeS=request.getParameter("tradeType");

	Date nowDate=new Date();
	
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
	String  endDate = sdf.format(nowDate);;
	String  endDateS = request.getParameter("endDate");
	
	if(typeS!=null)
	{
		type=Integer.parseInt(typeS); 
		tradeType=Integer.parseInt(tradeTypeS);
 		endDate =endDateS;
 	}
	Date runBeforeDate=sdf.parse(endDate); 

    IncomeCost ic = jp.getIncomeCost(bankType, tradeId, type, tradeType, runBeforeDate);
System.out.println("## income=" + ic.getIncome() + " cost=" + ic.getCost());
    String query = jp.getCostpayQueryString(bankType, tradeId, type, tradeType, null, runBeforeDate);
System.out.println("## 1");
    ArrayList<Costpay2> items = Costpay2Mgr.getInstance().retrieveList(query, "order by id desc");
System.out.println("## 2 " + items.size());
	
	Costpay[] cp=jp.getCostpayByBaId(bankType,tradeId,type,tradeType,runBeforeDate);
	if(cp==null)
	{
		out.println("沒有交易資料");
		return;
	}
	SimpleDateFormat sdf2=new SimpleDateFormat("yyyy/MM");
 
	TradeaccountMgr tam=TradeaccountMgr.getInstance(); 
	BankAccountMgr bam2=BankAccountMgr.getInstance();
	
	if(bankType==2)
	{ 
		BankAccount  banNow=(BankAccount)bam2.find(tradeId);
%> 
	<b>&nbsp;&nbsp;<img src="pic/bank.png" border=0><%=banNow.getBankAccountName()%>-交易查詢</b>	
<%	
	}else{ 
		
		Tradeaccount tradeA=(Tradeaccount)tam.find(tradeId);
 
%>
	<b>&nbsp;&nbsp;&nbsp;<img src="pic/people.png" border=0><%=tradeA.getTradeaccountName()%>-交易明細</b>	
<%
	}
%>					

	<blockquote>
	<form action="showCostpayDetailBank2.jsp" method="get"> 
	
	<table width="60%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#ffffff class=es02>
		 	<td nowrap>形式</tD>
		 	<td bgcolor=#ffffff>
			<select size=1 name="type">
				<option value="99" <%=(type==99)?"selected":""%>>全部</option>
				<option value="1" <%=(type==1)?"selected":""%>>支出</option>
				<option value="0" <%=(type==0)?"selected":""%>>收入</option>
			</select>
		 	</td>
		 	<td nowrap>
		 		交易類別
		 	</tD>
		 	<td bgcolor=#ffffff>
			 	<select size=1 name="tradeType">
					<option value="99" <%=(tradeType==99)?"selected":""%>>全部</option>
					<option value="1" <%=(tradeType==1)?"selected":""%>>學費交易</option>
					<option value="2" <%=(tradeType==2)?"selected":""%>>薪資交易</option>
					<option value="3" <%=(tradeType==3)?"selected":""%>>雜費交易</option>
					<option value="4" <%=(tradeType==4)?"selected":""%>>內部轉帳</option>

				</select>
		 	</tD>
		 	<tD nowrap>交易日期至</tD> 
			<td bgcolor=#ffffff>
				<input type=text name="endDate" value="<%=endDate%>" size=7>
			</td>
		 	<td bgcolor=#ffffff>
		 		<input type=hidden name="baid" value="<%=tradeId%>">
                <input type=hidden name="bankType" value=<%=bankType%>>
 		 		<input type=submit value="搜尋">
		 	</tD>
		</tR>
	</table> 	
		</tD>
		</tr>
		</table>
	
	</form> 
	</blockquote>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>	
<BR>	
<center>
<%
	if(cp ==null)
	{
		out.println("沒有資料"); 
		return;
	}
	if(showType==0)  
	{
%>	
	顯示最後15筆 | <a href="showCostpayDetailBank2.jsp?bankType=<%=bankType%>&baid=<%=tradeId%>&showType=1&type=<%=type%>&tradeType=<%=tradeType%>&endDate=<%=endDate%>">顯示最後30筆</a> | <a href="showCostpayDetailBank2.jsp?bankType=<%=bankType%>&baid=<%=tradeId%>&showType=2&type=<%=type%>&tradeType=<%=tradeType%>&endDate=<%=endDate%>">顯示全部資料</a>
<%
	}else if(showType==1){
%> 
	<a href="showCostpayDetailBank2.jsp?bankType=<%=bankType%>&baid=<%=tradeId%>&showType=0&type=<%=type%>&tradeType=<%=tradeType%>&endDate=<%=endDate%>">顯示最後15筆</a> | 顯示最後30筆 | <a href="showCostpayDetailBank2.jsp?bankType=<%=bankType%>&baid=<%=tradeId%>&showType=2&type=<%=type%>&tradeType=<%=tradeType%>&endDate=<%=endDate%>">顯示全部資料</a>
<%
	} else if(showType==2) { 
%>
	<a href="showCostpayDetailBank2.jsp?bankType=<%=bankType%>&baid=<%=tradeId%>&showType=0&type=<%=type%>&tradeType=<%=tradeType%>&endDate=<%=endDate%>">顯示最後15筆</a> |<a href="showCostpayDetailBank2.jsp?bankType=<%=bankType%>&baid=<%=tradeId%>&showType=1&type=<%=type%>&tradeType=<%=tradeType%>&endDate=<%=endDate%>">顯示最後30筆</a> | 顯示全部資料
<%
	}
%> 
<br>
<div align=left>合計: <font color=blue><%=cp.length%></font>筆</div> 

<table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>
<tr bgcolor=#ffffff align=left valign=middle>
		<td bgcolor=#f0f0f0 class=es02>序號</td>
		<td bgcolor=#f0f0f0 class=es02>入帳日期</tD>
		<td bgcolor=#f0f0f0 class=es02 width=200>交易明細</td>
		<td bgcolor=#f0f0f0 class=es02 width=50>支出</tD>
		<td bgcolor=#f0f0f0 class=es02 width=50>存入</tD>
		<td bgcolor=#f0f0f0 class=es02 width=50>小計</td>	
		<td bgcolor=#f0f0f0 class=es02 colspan=2>註記</td>	
		<td bgcolor=#f0f0f0 class=es02></td>
	</tr>
	<%
 
		int total=0; 
		int incomeTotal=0;
		int costTotal=0; 
	
		int rowStart=0;
		if(showType==0)	
		{
			if(cp.length>=15)
			{
				rowStart=cp.length-15;
			} 
		}else if(showType==1){
			if(cp.length>=30)
			{
				rowStart=cp.length-30;
			}
		}
			
        CostpayDescription cpd = new CostpayDescription();
		for(int i=0;i<cp.length;i++)
		{ 		
	 	 	 	int nowtotal=cp[i].getCostpayIncomeNumber()-cp[i].getCostpayCostNumber();
				total+=nowtotal ;
				incomeTotal +=cp[i].getCostpayIncomeNumber();
				costTotal +=cp[i].getCostpayCostNumber();

				String[] outTitle=jp.showCostpayTitle(cp[i],ud2,cpd,null);
 
				
			if(i>=rowStart) 
			{ 
	%>
	 <tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
		<td class=es02><%=cp[i].getId()%></td>
		<td class=es02><%=sdf.format(cp[i].getCostpayDate())%></tD>
		<td class=es02 width=200> 
			<%=outTitle[0]%>
			<%
			if(cp[i].getCostpayPayway()!=1)
			{  
				switch(cp[i].getCostpayPayway())
				{ 
					case 2:	
						out.println("<br><font color=red>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;交易方式: 支票</font>");			
						break;
					case 3:	
						out.println("<br><font color=red>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;交易方式: 匯款</font>");			
						break;
					case 4:	
						out.println("<br><font color=red>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;交易方式: 其他</font>");			
						break;	
				}
			} 
 
		%>

		</td>
		<td class=es02 align=right><%=(cp[i].getCostpayCostNumber()==0)?"":mnf.format(cp[i].getCostpayCostNumber())%></tD>
		<td class=es02 align=right><%=(cp[i].getCostpayIncomeNumber()==0)?"":mnf.format(cp[i].getCostpayIncomeNumber())%></tD>
		<td class=es02 align=right><%
				out.println(mnf.format(total));
			%></td>	
		<td class=es02 align=left colspan=2>
			<%=(cp[i].getCostpayLogPs()!=null && cp[i].getCostpayLogPs().length()>0)?cp[i].getCostpayLogPs():""%>

                    <a href="javascript:openwindow_phm('modifyCostpayPs.jsp?cpId=<%=cp[i].getId()%>','編輯註解',300,200,true);"><img src="images/lockyes.gif" border=0 width=15 alt="編輯註記"></a>
		</tD>			
		<td class=es02>
		<%=outTitle[1]%>
		</td>
	</tr>
		
	<%
		} 
	 } 
	%>
 
	
	<tr class=es02> 
		<td colspan=3 align=middle><b>小 計</b></td>
		<td align=right><%=mnf.format(costTotal)%></td>	
		<td align=right><%=mnf.format(incomeTotal)%></td>
		<td align=right><b><%=mnf.format(total)%></b></td>
 		<td>
			</td>
 			</tr> 
 			</table>
	</td>
	</tr>
	</table>
 </center>  
  <br>
  <br>
 <%@ include file="bottom.jsp"%>
