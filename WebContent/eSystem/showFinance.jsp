<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,jsi.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=10;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu10.jsp"%>
<br>
<br>
 
<b>&nbsp;&nbsp;&nbsp;財務報表-損益統計</b>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<blockquote> 
<%
    if(!AuthAdmin.authPage(ud2,3))
    {
        response.sendRedirect("authIndex.jsp?info=1&page=8");
    }  

	JsfTool jt=JsfTool.getInstance();
	JsfPay jp=JsfPay.getInstance();
	
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM");
	SimpleDateFormat sdf2=new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat sdf3=new SimpleDateFormat("yyyy-MM-dd HH:mm");

	DecimalFormat mnf = new DecimalFormat("###,###,##0");

//	Date runDate=sdf.parse(syear+"-"+smonth);

	Closemonth[] cm=jp.getAllFinishClosemonthDesc();
	  
	if(cm ==null)
	{ 
		out.println("沒有結算資料,需要先做結算才能制作損益統計!");	 
		return;
	}  
%> 

<table width="" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>

		<tr bgcolor=#f0f0f0 class=es02>
 
			<td>月份</tD> 
			<td width=98>學費</td>
			<td width=98>雜費收入</tD> 
			<td width=98>薪資</td>
			<td width=98>雜費支出</td>
			<td width=98>本期損益</tD> 
			<tD width=98></tD>
		</tr>
<% 
	int[][] totalX=new int[cm.length][5]; 
	
	String[] monthString=new String[cm.length]; 
	
	Utility u=Utility.getInstance();
	
	for(int i=0;i<cm.length;i++) 
	{   
		 totalX [i][0]=cm[i].getClosemonthFeesNum()+cm[i].getClosemonthFeesNotNum();
		 totalX [i][1]=cm[i].getClosemonthIncomeNum()+cm[i].getClosemonthIncomeNotNum(); 
		 totalX [i][2]=cm[i].getClosemonthSalaryNum()+cm[i].getClosemonthSalaryNotNum(); 
		 totalX [i][3]=cm[i].getClosemonthCostNum()+cm[i].getClosemonthCostNotNum();
		 totalX [i][4]=totalX [i][0]+totalX [i][1]-totalX [i][2]-totalX [i][3]; 
		 
		 monthString[i]=sdf.format(cm[i].getClosemonthMonth());  
		  
		 String syear=String.valueOf(cm[i].getClosemonthMonth().getYear()+1900);
		 String smonth="";  
		 if(cm[i].getClosemonthMonth().getMonth()<=8)
		 	smonth="0"+String.valueOf((cm[i].getClosemonthMonth().getMonth()+1));
		 else
		 	smonth=String.valueOf(cm[i].getClosemonthMonth().getMonth()+1);
		 	
		
		SimpleDateFormat sdfX2=new SimpleDateFormat("yyyy/MM/01"); 
		String  startS=sdfX2.format(cm[i].getClosemonthMonth()); 
		String endString=u.getLastDateInMonth(cm[i].getClosemonthMonth());
 	
%>
	<tr bgcolor=#ffffff class=es02>
			<td><%=monthString[i]%></tD>
			<td align=right><a href=listFeeNumber.jsp?year=<%=syear%>&month=<%=smonth%>&status=0&classesId=999&level=999><font class=es02><%=mnf.format(totalX [i][0])%></a></td>
			<td align=right><a href="listCostbook.jsp?type=0&trader=0&vstatus=99&attachstatus=0&logId=0&startDate=<%=startS%>&endDate=<%=endString%>"><font class=es02><%=mnf.format(totalX [i][1])%></font></a></tD>
			<td align=right><a href="salarySearch.jsp?year=<%=syear%>&month=<%=smonth%>&poId=999&classId=999"><font class=es02><%=mnf.format(totalX [i][2])%></font></a></td>
			<td align=right><a href="listCostbook.jsp?type=1&trader=0&vstatus=99&attachstatus=0&logId=0&startDate=<%=startS%>&endDate=<%=endString%>"><font class=es02><%=mnf.format(totalX [i][3])%></font></a></td>
			<td align=right><%=mnf.format(totalX [i][4])%></tD>
			<td align=right>
				<a href="displayFinance.jsp?year=<%=syear%>&month=<%=smonth%>" target="_blank">詳細報表</a> 
				
			</td>
		</tr>

<%
	}
%>
</table> 
	</tD>
	</tr>
	</table>
	


<%

/*
	String feeInt[]={"532000","322000","3000320"};         
	String salaryInt[]={"2000","32323","546456"};  
	String feeString[]={"aaa","bbb","ccc"};  	       

*/
%>
<br>
<%// include file="henrybar2.jsp"%>



<%

/*
%>

  
<br>
<b>資產負債表</b>
<table> 
	<tr>
		<td>資產</td>
		<td>=</td>
		<td>負債</td> 
		<td>+</tD>
  		<td>業主權益</td>
   	<tr>
	<tr>
  		<tD>
 	學費收入:

		<table>
  
			<tr>
			 <td>月份</td><tD>現金</td><td>應收金額</td><td>合計</td>
			</tr>	
			<tr>
				<tD>
					<%=sdf.format(runDate)%>				
				</td>
				<td>
					<%=cm[0].getClosemonthFeesNum()%>  
				</td>
 
				
				<td>		
					<a href="showCloseFee.jsp?year=<%=syear%>&month=<%=smonth%>&type=0"><%=cm[0].getClosemonthFeesNotNum()%></a>
				</td> 
				<td>
					<a href="listFeeNumber.jsp?year=<%=syear%>&month=<%=smonth%>"><%=cm[0].getClosemonthFeesNum()+cm[0].getClosemonthFeesNotNum()%>  
				</tD>
			</tr>

<%
  
	int oldCase=0;
	int oldShould=0;
	int paySum =0;  
	 
                
                  	
	if(cm.length>1)
	{
		for(int i=1;i<cm.length;i++)	
		{
 	 
			oldCase +=cm[i].getClosemonthFeesNum();
		 	oldShould +=cm[i].getClosemonthFeesNotNum();
			
			Date cmMonth=cm[i].getClosemonthMonth ();
%>
			<tr>
				<td><%=sdf.format(cm[i].getClosemonthMonth())%></td>
				<tD><%=cm[i].getClosemonthFeesNum()%></td>
				<td><a href="showCloseFee.jsp?year=<%=cmMonth.getYear()+1900%>&month=<%=cmMonth.getMonth()+1%>&type=0"><%=cm[i].getClosemonthFeesNotNum()%></a></td>
				<td><a href="listFeeNumber.jsp?year=<%=cmMonth.getYear()+1900%>&month=<%=cmMonth.getMonth()+1%>"><%=cm[i].getClosemonthFeesNum()+cm[i].getClosemonthFeesNotNum()%></td>	

			</tr>		 
	<%			
		} 
		
		paySum=jp.closefeeBeforeMonth(runDate);	
	} 
%>
	<tr>
		<td>前期已繳</td>
		<td><a href="showCloseFee.jsp?year=<%=syear%>&month=<%=smonth%>&type=1"><%=paySum%></a></td>
		<td></td>
	</tr>
 
	<tr> 
		<td>累計結餘</td>
		<%
			int closeX1=cm[0].getClosemonthFeesNum()+oldCase+paySum;
			int closeX2=cm[0].getClosemonthFeesNotNum()+oldShould-paySum;
		%>
		<tD><%=closeX1%></tD>
		<tD><%=closeX2%></td>
	</tr>	
	<tr> 
		<td>合計</td>
 
		<td colspan=2><%=closeX1+closeX2%></tD>
	</tr>
</table> 

	</td>
	<td>
 = 
	</td>
	
	<tD></td>
	<tD>+</tD>	
	<tD>	
	<% 
  
		int getFeetotal=0;
		int getSalaryTotal=0; 
		int salarytotalCash=0; 
		int salarytotalNotCash=0;  
		
		int incomeCash=0;
		int incomeShould=0;
		int costCash=0;
		int costShould=0;  
		
		int costtotalCash=0;  
		int costtotalNotCash=0;
		if(cm!=null)
		{ 
			for(int i=0;i<cm.length;i++)
			{ 
			incomeCash+=cm[i].getClosemonthIncomeNum();
			incomeShould+=cm[i].getClosemonthIncomeNotNum();
			costCash+=cm[i].getClosemonthCostNum();
			costShould+=cm[i].getClosemonthCostNotNum();
	
			
				getFeetotal+=cm[i].getClosemonthFeesNum()+cm[i].getClosemonthFeesNotNum();
 
				getSalaryTotal += cm[i].getClosemonthSalaryNum() + cm[i].getClosemonthSalaryNotNum ();
			
				if(i!=0)
				{ 
					salarytotalCash+=cm[i].getClosemonthSalaryNum(); 
					salarytotalNotCash += cm[i].getClosemonthSalaryNotNum(); 
				
					costtotalCash+=cm[i].getClosemonthCostNum();
					costtotalNotCash+=cm[i].getClosemonthCostNotNum();				
				}	
			}
		}	
	
%>
		學費收入:<%=getFeetotal%>	
	</td>
</tr>	
	<tr>
		<td>
	薪資支出:	
	<%
		int preSalaryPay=jp.closesalaryBeforeMonth(runDate);
	%>
	<table>
		<tr>
			<td>月份</td>
			<tD>現金支付</td>
		</tr>
 
		<tr>
			<tD><%=sdf.format(cm[0].getClosemonthMonth())%></tD>	
			<td><%=cm[0].getClosemonthSalaryNum()%></td>
		</tr>
 
 
		<tr>
			<td>前期現金合計</td>
			<tD><%=salarytotalCash%></td>
		 </tr> 
		<tr>
			<td>前期累計已付</td>
			<tD><%=preSalaryPay%></td>
 
		 </tr> 
		 <tr>
		   	<td>累計合計</tD>
			<%
				int salaryTotalCash=cm[0].getClosemonthSalaryNum()+salarytotalCash+preSalaryPay;
			%>

			<tD><%=salaryTotalCash%></tD>
		</tr> 
 	</table>

		</td>
		<td>=</td>
		<td> 
			薪資應付: 
			<table>
				<tr>
					<td>
						<%=sdf.format(cm[0].getClosemonthMonth())%>
					</td>
					<td>
						<a href="showCloseSalary.jsp?year=<%=runDate.getYear()+1900%>&month=<%=runDate.getMonth()+1%>&type=0"><%=cm[0].getClosemonthSalaryNotNum()%></a>
					</td>
				</tr>
				<tr>
					<td>前期應付</td>		 
					<td>
					<a href="showCloseSalary.jsp?year=<%=runDate.getYear()+1900%>&month=<%=runDate.getMonth()+1%>&type=3"><%=salarytotalNotCash%>
</a>
					</tD>
				</tr>
				<tr>
					<td>前期累計已付</td>		 
					<td>
					<a href="showCloseSalary.jsp?year=<%=runDate.getYear()+1900%>&month=<%=runDate.getMonth()+1%>&type=1"><%=preSalaryPay%></a>
					</tD>
				</tr> 
				<%
					int allSalaryNotCash=cm[0].getClosemonthSalaryNotNum()+salarytotalNotCash-preSalaryPay;
					
				%>
				<tr>
					<td>累計合計</td>		 
					<td><%=allSalaryNotCash%></tD>
				</tr>
			</table>
		
		</td> 
		<td>+</tD>
  		<td> 
		薪資支出:<%=getSalaryTotal%>
  		</td>
	</tr>
	  		
   	<tr>
		<tr>
		<td>
		雜費收入

	<table>
  
			<tr>
			 <td>月份</td><tD>現金</td><td>應收金額</td><td>合計</td>
			</tr>	
			<tr>
				<tD>
					<%=sdf.format(runDate)%>				
				</td>
				<td>
					<%=cm[0].getClosemonthIncomeNum()%>  
				</td>
 
				
				<td>		
					<a href="showCloseFee.jsp?year=<%=syear%>&month=<%=smonth%>&type=0"><%=cm[0].getClosemonthIncomeNotNum()%></a>
				</td> 
				<td>
					<a href="listFeeNumber.jsp?year=<%=syear%>&month=<%=smonth%>"><%=cm[0].getClosemonthIncomeNum()+cm[0].getClosemonthIncomeNotNum()%>  
				</tD>
			</tr>

<%
  
	int oldIncomeCase=0;
	int oldIncomeShould=0;
	int incomeSum =0; 
	
	if(cm.length>1)
	{
		for(int i=1;i<cm.length;i++)	
		{
			oldIncomeCase +=cm[i].getClosemonthIncomeNum();
		 	oldIncomeShould +=cm[i].getClosemonthIncomeNotNum();
			
			Date cmMonth=cm[i].getClosemonthMonth ();
%>
			<tr>
				<td><%=sdf.format(cm[i].getClosemonthMonth())%></td>
				<tD><%=cm[i].getClosemonthIncomeNum()%></td>
				<td><a href="showCloseFee.jsp?year=<%=cmMonth.getYear()+1900%>&month=<%=cmMonth.getMonth()+1%>&type=0"><%=cm[i].getClosemonthIncomeNotNum()%></a></td>
				<td><a href="listFeeNumber.jsp?year=<%=cmMonth.getYear()+1900%>&month=<%=cmMonth.getMonth()+1%>"><%=cm[i].getClosemonthIncomeNum()+cm[i].getClosemonthIncomeNotNum()%></td>	

			</tr>		 
	<%			
		} 
		
		incomeSum=jp.closeincomeBeforeMonth(runDate);	
	} 
%>
 
  
	<tr>
		<td>前期已繳</td>
		<td><a href="showCloseFee.jsp?year=<%=syear%>&month=<%=smonth%>&type=1"><%=incomeSum%></a></td>
		<td></td>
	</tr>
 
	<tr> 
		<td>累計結餘</td>
		<%
			int closeIncomeX1=cm[0].getClosemonthIncomeNum()+oldIncomeCase+incomeSum;
			int closeIncomeX2=cm[0].getClosemonthIncomeNotNum()+oldIncomeShould-incomeSum;
		%>
		<tD><%=closeIncomeX1%></tD>
		<tD><%=closeIncomeX2%></td>
	</tr>	
	<tr> 
		<td>合計</td>
 
		<td colspan=2><%=closeIncomeX1+closeIncomeX2%></tD>
	</tr>
</table> 


		</td>
		<td>=</td>
		<td></td> 
		<td>+</tD>
  		<td> 
  			雜費收入: <%=incomeCash+incomeShould%>
  		</td>
   	<tr>

	<tr>
		<td>
	雜費支出:	
	<table>
		<tr>
			<td>月份</td>
			<tD>現金支付</td>
		</tr>
 
		<tr>
			<tD><%=sdf.format(cm[0].getClosemonthMonth())%></tD>	
			<td><%=cm[0].getClosemonthCostNum()%></td>
		</tr>
 
 
		<tr>
			<td>前期現金合計</td>
			<tD><%=costtotalCash%></td>
		 </tr> 
		<tr>
			<td>前期累計已付</td> 
			<%
			int preCostPay=jp.closecostBeforeMonth(runDate);
			%> 
			<tD><%=preCostPay%></td>
		 </tr> 
		 <tr>
		   	<td>累計合計</tD>
			<%
				int costTotalCash=cm[0].getClosemonthCostNum()+costtotalCash+preCostPay; 

			%>

			<tD><%=costTotalCash%></tD>
		</tr> 
 	</table>

		</td>
		<td>=</td>
		<td> 
			雜費應付: 
			<table>
				<tr>
					<td>
						<%=sdf.format(cm[0].getClosemonthMonth())%>
					</td>
					<td>
						<a href="showCloseSalary.jsp?year=<%=runDate.getYear()+1900%>&month=<%=runDate.getMonth()+1%>&type=0"><%=cm[0].getClosemonthCostNotNum()%></a>
					</td>
				</tr>
				<tr>
					<td>前期應付</td>		 
					<td>
					<a href="showCloseSalary.jsp?year=<%=runDate.getYear()+1900%>&month=<%=runDate.getMonth()+1%>&type=3"><%=costtotalNotCash%>
</a>
					</tD>
				</tr>
				<tr>
					<td>前期累計已付</td>		 
					<td>
					<a href="showCloseSalary.jsp?year=<%=runDate.getYear()+1900%>&month=<%=runDate.getMonth()+1%>&type=1"><%=preCostPay%></a>
					</tD>
				</tr> 
				<%
					int allCostNotCash=cm[0].getClosemonthCostNotNum()+costtotalNotCash-preCostPay;
					
				%>
				<tr>
					<td>累計合計</td>		 
					<td><%=allCostNotCash%></tD>
				</tr>
			</table>
		
		</td> 
		<td>+</tD>
  		<td> 
		薪資支出:
		<%=costCash+costShould%>
  		</td>
	</tr>
	<tr>  
	<%
		int ownerTotal=jp.getOwnertradeBeforeRundate(sdfX3.parse(endString)) ;
	%>
		
		<td>股東權益變更: <%=ownerTotal%></td>
		<td>=</td>
		<td></td> 
		<td>+</tD>
  		<td><%=ownerTotal%></td>
   	<tr>




</table>


<BR>
<b>學生收費統計</b>
	<a href="studentFeebyMonth.jsp?month=<%=smonth%>&year=<%=syear%>">至 <%=syear%>-<%=smonth%>學費統計</a> 
	
<br>
<b>現金調節</b>
 
<table>
 
	<tr>
		<td></tD><td>結帳點</td><td>存入</td><td>支出</td>
	</tr> 
	<tr>
		<td>預收學費</tD>
		<tD>
 
		<%
			if(cm[0].getClosemonthFeestatus()==90)
  			{
  		%>
 			<%=sdf3.format(cm[0].getClosemonthFeeDate())%>之前		
		<%
			}
		%>
		</td>
		<tD>
  
		<%
		Costpay[] cp2=jp.getFeeticketByAfterFeecoloseDate(cm[0]);
		int caseAllModifiedAfter=0; 
		if(cp2!=null)
		{ 
			caseAllModifiedAfter=jp.totalCostpayFeenumber(cp2);
		} 
		int caseModifiedAfter=caseAllModifiedAfter-closeX1;
		%>
 
		<a href="showPreFee.jsp?cmId=<%=cm[0].getId()%>&type=3"><%=caseModifiedAfter%></a>	
		</td>
	</tr>
	
	
	<tr>
		<td>結帳點之後學費</tD>
		<tD>
 
		<%
			if(cm[0].getClosemonthFeestatus()==90)
  			{
  		%>
 			<%=sdf3.format(cm[0].getClosemonthFeeDate())%>之後	
		<%
			}
		%>
		</td>
		<tD>
  
		<%
 
		
		Costpay[] cp=jp.getFeeticketByBeforeFeecoloseDate(cm[0]);
		int caseModified=0; 
		if(cp!=null)
		{ 
			caseModified=jp.totalCostpayFeenumber(cp);
		}
		%>
 
		<a href="showCashmodifyFee.jsp?cmId=<%=cm[0].getId()%>&type=1"><%=caseModified%></a>	
		</td>
	</tr>
	<tr>
		<td>預支薪資</tD>
		<tD>
 
		<%
			if(cm[0].getClosemonthSalarystatus()==90)
  			{
  		%>
 			<%=sdf3.format(cm[0].getClosemonthSalaryDate())%>之前		
		<%
			}
		%>
		</td> 
		<td></td>
		<tD>
  
		<%
		cp2=jp.getCostpayByAfterSalarycoloseDate(cm[0]);
		int cashAllModifiedAfterSalary=0; 
		if(cp2!=null)
		{ 
			cashAllModifiedAfterSalary=jp.totalCostpayFeenumberCost(cp2);
		}
 
		int caseModifiedAfterSalary=cashAllModifiedAfterSalary-salaryTotalCash;
		%>
 
		<a href="showPreSalary.jsp?cmId=<%=cm[0].getId()%>&type=3"><%=caseModifiedAfterSalary%></a>	
		</td>
	</tr>
	
	
	
	<tr>
		<td>結帳點之後薪資支出</tD> 
		
		<tD>
 
		<%
			if(cm[0].getClosemonthSalarystatus()==90)
  			{
  		%>
 			<%=sdf3.format(cm[0].getClosemonthSalaryDate())%>之後
		<%
			}
		%>
		</td>
		<td></tD>
	
		<tD>
  
		<%
		
		cp=jp.getSalaryticketByBeforeFeecoloseDate(cm[0]);
		int caseSalaryModified=0; 
		if(cp!=null)
		{ 
			caseSalaryModified=jp.totalCostpayFeenumberCost(cp);
		}
		%>
 
		<a href="showCashmodifyFee.jsp?cmId=<%=cm[0].getId()%>&type=2"><%=caseSalaryModified%></a>	
		</td>
	</tr> 
	
	<tr>
		<td>預收雜費收入</tD>
		<tD>
 
		<%
			if(cm[0].getClosemonthIncomestatus()==90)
  			{
  		%>
 			<%=sdf3.format(cm[0].getClosemonthIncomeDate())%>之前		
		<%
			}
		%>
		</td>
		<tD>
  
		<%
		Costpay[] cp3=jp.getCostpayByAfterIncomecoloseDate(cm[0]);
		int caseAllModifiedAfterIncome=0; 
		if(cp3!=null)
		{ 
			caseAllModifiedAfterIncome=jp.totalCostpayFeenumber(cp3);
		}
 
		int caseModifiedAfterIncome=caseAllModifiedAfterIncome-closeIncomeX1;
		%>
 
		<a href="showPreincome.jsp?cmId=<%=cm[0].getId()%>&type=0"><%=caseModifiedAfterIncome%></a>	
		</td>
	</tr>
		
	<tr>
		<td>結帳點之後雜費收入</tD>
		<tD>
 
		<%
			if(cm[0].getClosemonthIncomestatus()==90)
  			{
  		%>
 			<%=sdf3.format(cm[0].getClosemonthIncomeDate())%>之後		
		<%
			}
		%>
		</td>
		<tD>
  
		<%
		
		cp=jp.getCostpayByBeforeIncomecoloseDate(cm[0]);
		int caseIncomeModified=0; 
		if(cp!=null)
		{ 
			caseIncomeModified=jp.totalCostpayFeenumber(cp);
		}
		%>
 
		<a href="showCashmodifyFee.jsp?cmId=<%=cm[0].getId()%>&type=3"><%=caseIncomeModified%></a>	
		</td>
	</tr>
	<tr>
		<td>預支雜費支出</tD>
		<tD>
 
		<%
			if(cm[0].getClosemonthCoststatus()==90)
  			{
  		%>
 			<%=sdf3.format(cm[0].getClosemonthCostDate())%>之前		
		<%
			}
		%>
		</td>
 
		<td></td>
		<tD>
  
		<%
		cp2=jp.getCostpayByAfterCostcloseDate(cm[0]);
		int cashAllModifiedAfterCost=0; 
		if(cp2!=null)
		{ 
			cashAllModifiedAfterCost=jp.totalCostpayFeenumberCost(cp2);
		}
 
		int caseModifiedAfterCost=cashAllModifiedAfterCost-costTotalCash;
		%>
 
		<a href="showPreincome.jsp?cmId=<%=cm[0].getId()%>&type=1"><%=caseModifiedAfterCost%></a>	
		</td>
	</tr>
	
	<tr>
		<td>結帳點之後雜費支出</tD>
		<tD>
		<%
			if(cm[0].getClosemonthCoststatus()==90)
  			{
  		%>
 			<%=sdf3.format(cm[0].getClosemonthCostDate())%>之後
		<%
			}
		%>
		</td> 
		<tD></td>
		<tD>
  
		<%
		cp=jp.getCostpayByBeforeCostcoloseDate(cm[0]);
		int caseCostModified=0; 
		if(cp!=null)
		{ 
			caseCostModified=jp.totalCostpayFeenumberCost(cp);
		}
		%>
		<a href="showCashmodifyFee.jsp?cmId=<%=cm[0].getId()%>&type=4"><%=caseCostModified%></a>	
		</td>
	</tr>
	<tr>
		<td>股東權益變更</tD>
		<tD>
 			<%=sdf.format(runDate)%>-31 之後
 		</td>
 		<td>
 			<%
 				int afterOwner=jp.getOwnertradeAfterRundate(runDate); 
 			%> 
 			<a href="listOwnertrade.jsp"><%=afterOwner%></a>
		</td>
		<tD>
  
		</td>
	</tr>
			


</table>
<%
	int finalFee=caseModifiedAfter+closeX1+caseModified ;
	int finalSalary=caseModifiedAfterSalary+caseSalaryModified+salaryTotalCash ;
	int finalIncome=closeIncomeX1+caseModifiedAfterIncome+caseIncomeModified ;
	int finalCost=costTotalCash+caseModifiedAfterCost+caseCostModified ; 
	int finalOwner= afterOwner+ownerTotal;
%>

學費現金: <%=finalFee%><br>
薪資現金:<%=finalSalary%><br>
雜費收入現金: <%=finalIncome%> <br>
雜費支出現金: <%=finalCost%><br> 
股東權益現金: <%=finalOwner%><br>
 

現金合計:<%=finalFee+finalIncome-finalSalary-finalCost+finalOwner%>
        	
</blockquote>  

<% 
*/
%>

<%@ include file="bottom.jsp"%>