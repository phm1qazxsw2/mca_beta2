<%@ page language="java" contentType="text/html;charset=UTF-8"%><%  

	DecimalFormat mnfcostPay = new DecimalFormat("###,###,##0");

	Costpay[] cp=jp.getCostpayByBeforedate(beforeDate, _ws.getBunitSpace("bunitId")); 
	
	if(cp==null)
  	{
  		
  			
  	}else{

	SimpleDateFormat sdfDate=new SimpleDateFormat("yyyy/MM/dd");
 
	SimpleDateFormat sdf2=new SimpleDateFormat("yyyy/MM");

	BankAccountMgr bam2=BankAccountMgr.getInstance();

	TradeaccountMgr tam=TradeaccountMgr.getInstance();	 
	//Tradeaccount tradeA=(Tradeaccount)tam.find(tradeId);
 
	FeeticketMgr fm=FeeticketMgr.getInstance();

    CostbookMgr cm1=CostbookMgr.getInstance(); 
	StudentMgr stuM=StudentMgr.getInstance(); 
	InsidetradeMgr in1=InsidetradeMgr.getInstance(); 
	OwnertradeMgr ownM=OwnertradeMgr.getInstance();
  	OwnerMgr owM=OwnerMgr.getInstance();
	SalaryBankMgr sbm=SalaryBankMgr.getInstance();
	StudentAccountMgr samm=StudentAccountMgr.getInstance();		
  %>
  
<div class=es02><img src="pic/bank.png" border=0 width=16>&nbsp;<b>現金帳戶</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;更動概況: <a href="#" onClick="showForm('costpayDiv');return false"><%=cp.length%> 筆</a>
</div>

<div id=costpayDiv style="display:none" class=es02>

<table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
<table width="100%" border=0 cellpadding=4 cellspacing=1>
<tr bgcolor=#ffffff align=left valign=middle>
		<td bgcolor=#f0f0f0 class=es02>序號</td>
		<td bgcolor=#f0f0f0 class=es02>入帳日期</tD>
		<td bgcolor=#f0f0f0 class=es02>交易明細</td>
		<td bgcolor=#f0f0f0 class=es02>交易帳戶</tD>		
		<td bgcolor=#f0f0f0 class=es02 width=50>支出</tD>
		<td bgcolor=#f0f0f0 class=es02 width=50>存入</tD>
		<td bgcolor=#f0f0f0 class=es02 width=50>小計</td>	
		<td bgcolor=#f0f0f0 class=es02></td>
	</tr>
	<%
		int total=0; 
		int incomeTotal=0;
		int costTotal=0;
        String _backurl = request.getRequestURI() + "?" + request.getQueryString();
        CostpayDescription cpd = new CostpayDescription();
        Map<Integer, Tradeaccount> tradeaccountMap = new SortingMap(
            tam.retrieveX("", "", _ws.getBunitSpace("bunitId"))).doSortSingleton("getId");
        Map<Integer, BankAccount> bankaccountMap = new SortingMap(
            bam2.retrieveX("", "", _ws.getBunitSpace("bunitId"))).doSortSingleton("getId");
		for(int i=0;i<cp.length;i++)
		{                  
            String[] outTitle=jp.showCostpayTitle(cp[i],ud2, cpd, _backurl);

	%>
	  <tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
		<td class=es02><%=cp[i].getId()%></td>
		<td class=es02><%=sdfDate.format(cp[i].getCostpayDate())%></tD>
		<td class=es02> 
		    <%=outTitle[0]%>
		</td> 
		<td class=es02> 
				<%=(cp[i].getCostpayAccountType()==1)?"零用金帳戶-":"銀行帳戶-"%>
	  			<% 
					if(cp[i].getCostpayAccountType()==1)	
					{
						Tradeaccount td = tradeaccountMap.get(cp[i].getCostpayAccountId()); 
						out.println((td==null)?"":td.getTradeaccountName());
	
					}else if(cp[i].getCostpayAccountType()==2){
						
						BankAccount ba = bankaccountMap.get(cp[i].getCostpayAccountId()); 
						out.println((ba==null)?"":ba.getBankAccountName());
					}	
                    
				%>
		</tD>		
		
		<td class=es02 align=right><%=(cp[i].getCostpayCostNumber()!=0)?mnfcostPay.format(cp[i].getCostpayCostNumber()):""%></tD>
		<td class=es02 align=right><%=(cp[i].getCostpayIncomeNumber()!=0)?mnfcostPay.format(cp[i].getCostpayIncomeNumber()):""%></tD>
		<td class=es02 align=right><%
				int nowtotal=cp[i].getCostpayIncomeNumber()-cp[i].getCostpayCostNumber();
				
				total+=nowtotal ;
 
				incomeTotal +=cp[i].getCostpayIncomeNumber();
				costTotal +=cp[i].getCostpayCostNumber();
				out.println(mnfcostPay.format(total));
			%></td>	
		<td class=es02 nowrap>
            <%=outTitle[1]%>		
		</td>
	</tr>
		
	<%
		}
	%>
	<tr class=es02>
		<td colspan=4 align=middle>小  計</td> 
		
		<td align=right><%=mnfcostPay.format(costTotal)%></td>	
		<td align=right><%=mnfcostPay.format(incomeTotal)%></td>
		<td align=right><b><%=mnfcostPay.format(total)%></b></td>
 		<td></td>
 	</tr> 
 </table>
	</td>
	</tr>
	</table>
    </div>
 
  <br>

<%
	}
%>
