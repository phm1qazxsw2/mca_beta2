<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=2;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu2.jsp"%>

<%
		JsfPay jp=JsfPay.getInstance();
		SalaryAdmin sa=SalaryAdmin.getInstance();
		BankAccount[] ba=sa.getAllBankAccount(_ws.getBunitSpace("bunitId"));

		//SalarybankAuth[] sa1=jp.getSalarybankAuthByUserId(ud2); 

		int totalTrade=ba.length;
	
		
		Costpay[] cp=jp.getAccountType2Costpay();
 
		
		if(cp==null)
  		{
  			out.println("沒有資料");
  			return;
  		}
 		
		Hashtable incomeHa=new Hashtable();
		Hashtable costHa=new Hashtable();
		
		for(int i=0;i<cp.length;i++)
		{
			if(cp[i].getCostpayNumberInOut()==1)
			{
				if(costHa.get(String.valueOf(cp[i].getCostpayAccountId()))==null)
				{
					costHa.put(String.valueOf(cp[i].getCostpayAccountId()),String.valueOf(cp[i].getCostpayCostNumber()));
					
				}else{
					
					String oldCost=(String)costHa.get(String.valueOf(cp[i].getCostpayAccountId())); 
					
					int nowTotal=cp[i].getCostpayCostNumber()+Integer.parseInt(oldCost);
					
					costHa.put(String.valueOf(cp[i].getCostpayAccountId()),String.valueOf(nowTotal));
				}
			}else{
				if(incomeHa.get(String.valueOf(cp[i].getCostpayAccountId()))==null)
				{
					incomeHa.put(String.valueOf(cp[i].getCostpayAccountId()),String.valueOf(cp[i].getCostpayIncomeNumber()));
					
				}else{
					
					String oldCost=(String)incomeHa.get(String.valueOf(cp[i].getCostpayAccountId()));
					int nowTotal=cp[i].getCostpayIncomeNumber()+Integer.parseInt(oldCost);
					
					incomeHa.put(String.valueOf(cp[i].getCostpayAccountId()),String.valueOf(nowTotal));
				}
			
			}
		}


%>
<br>
<br>
<blockquote>
<h3>銀行帳戶 - 帳戶現狀</h3>
<a href="showCostpay.jsp">個人零用金 - 帳戶現狀</a>
<table width="" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">


<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#ffffff align=left valign=middle>
		<td bgcolor=#f0f0f0 class=es02>帳戶名稱</tD><td bgcolor=#f0f0f0 class=es02  width=50>收入</td><td bgcolor=#f0f0f0 class=es02 width=50>支出</td><td bgcolor=#f0f0f0 class=es02 width=50>餘額</td>
<td bgcolor=#f0f0f0 class=es02></tD> 
	</tr>

	<% 
		int costTotal=0;
		int  incomeTotal=0;
		for(int j=0;j<ba.length;j++)
		{
	%>
		<tr bgcolor=#ffffff align=left valign=middle>
				<td class=es02>
					<%=ba[j].getBankAccountName()%>
				</td>
				<td class=es02 align=right>
				<%
					int income=0; 
					
					if(incomeHa.get(String.valueOf(ba[j].getId()))==null)
					{
						income=0;
						//out.println(income);
					}else{
						String incomeS=(String)incomeHa.get(String.valueOf(ba[j].getId()));
						
						income=Integer.parseInt(incomeS);
					}
						
					out.println(income); 
					incomeTotal +=income;
				%>
				</tD>
				<td class=es02 align=right>
				<%
					int cost=0; 
					if(costHa.get(String.valueOf(ba[j].getId()))==null)
					{
						cost=0;
						//out.println(income);
					}else{
						String costS=(String)costHa.get(String.valueOf(ba[j].getId()));
						
						cost=Integer.parseInt(costS);
					}
						
					out.println(cost); 
					costTotal += cost;
				%>
				</td>
				<td class=es02  align=right>
					<%=income-cost%>	
				</tD>				
				<td class=es02>
					<a href="showCostpayDetailBank2.jsp?baid=<%=ba[j].getId()%>">詳細資料</a>
 
 				</td>
			</tr>
		
	<%
		}
	%> 
	
	<tr>
		<td></td>
		<tD align=right><%=incomeTotal%></td> 
		<tD align=right><%=costTotal%></td> 
		<tD align=right><b><%=incomeTotal-costTotal%></b></td>  
		<td></td>
	</tr>
	</table>
	
	</td>
	</tr>
	</table>

</blockquote>
<%@ include file="bottom.jsp"%>