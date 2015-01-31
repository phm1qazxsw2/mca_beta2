<%@ page language="java" contentType="text/html;charset=UTF-8"%><% 
	DecimalFormat mnfincome = new DecimalFormat("###,###,##0");

	Costbook[] cbsin=jp.getCostbookByBeforedate(0,beforeDate); 
	SimpleDateFormat sdfDateIncome=new SimpleDateFormat("yyyy-MM-dd");
	
	if(cbsin==null)
	{
	

	}else{
		int type=0;
%>
<b><img src="pic/costIn.png" border=0>  雜費收入更動概況:</b> <br>
<table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>

	<tr bgcolor=#ffffff align=left valign=middle>
		<td bgcolor=#f0f0f0 class=es02>傳票編號</td>
		<td bgcolor=#f0f0f0 class=es02>入帳日期</td>
		<td bgcolor=#f0f0f0 class=es02>傳票抬頭</td>
		<td bgcolor=#f0f0f0 class=es02>登入人</td>
		<td bgcolor=#f0f0f0 class=es02>登入金額</td>
		<td bgcolor=#f0f0f0 class=es02>
			<%
			if(type==1)
				out.println("已付金額");
			else
				out.println("已收金額");
			%>				
		</td> 
		<td bgcolor=#f0f0f0 class=es02>
 		<%
					if(type==1)
						out.println("需付金額");
 
					else
						out.println("未收金額");
					%>
 			</td>	
 		<td bgcolor=#f0f0f0 class=es02>附件</td>		
 		<td bgcolor=#f0f0f0 class=es02>審核狀態</tD>			
		<td bgcolor=#f0f0f0 class=es02></tD> 
	</tr>
	<% 
		UserMgr  umc=UserMgr.getInstance();
		int total1=0;
		int total2=0;
		int total3=0;
		
		BigItemMgr bim=BigItemMgr.getInstance();						
		SmallItemMgr sim=SmallItemMgr.getInstance(); 

		for(int j=0;j<cbsin.length;j++)	
		{ 
	%>
	<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
		
		<td class=es02><%=cbsin[j].getCostbookCostcheckId()%></td>
		<td class=es02><%=sdfDateIncome.format(cbsin[j].getCostbookAccountDate())%></td>
		<td class=es02>
			<%=cbsin[j].getCostbookName()%>
		</td>
		<td class=es02>
		<%
						
						User ux=(User)umc.find(cbsin[j].getCostbookLogId());
						out.println(ux.getUserFullname());
						
		%></td>					
		
		<td  class=es02 align=right><%=mnfincome.format(cbsin[j].getCostbookTotalMoney())%></td>
		<td  class=es02 align=right>
			<%=mnfincome.format(cbsin[j].getCostbookPaiedMoney())%>
		</td> 
		<td  class=es02 align=right>
		<%
			int shouldPay=cbsin[j].getCostbookTotalMoney()-cbsin[j].getCostbookPaiedMoney();
			out.println(mnfincome.format(shouldPay));
		
			total1+=cbsin[j].getCostbookTotalMoney();
			total2+=cbsin[j].getCostbookPaiedMoney();
			
		%>

		</td> 
		<td class=es02>
		<%
			switch(cbsin[j].getCostbookAttachStatus()){
				case 1:
					out.println("<font color=red>未附</font>");
 
					break;
				case 2:	
					out.println("<font color=red>不完整</font>");
					break; 
				case 99:
					out.println("完整");
					break; 				
			}
		
		%>
		</td>
		<td class=es02>
			<%	
				if(cbsin[j].getCostbookVerifyStatus()==0)
				{
 
					
					out.println("尚未審核");		
					
					if(shouldPay!=0)
 
					{ 
						out.println("-尚未結清");					
					}

				}else if(cbsin[j].getCostbookVerifyStatus()==90){

					out.println("OK");
					
					User vu=(User)umc.find(cbsin[j].getCostbookVerifyId());
					out.println("("+vu.getUserFullname()+"-"+sdf.format(cbsin[j].getCostbookVerifyDate())+")");					
				}
			%>
		</tD>

		<td  class=es02>
			<a href="modifyCostbook.jsp?cid=<%=cbsin[j].getId()%>">詳細資料</a>
		</tD> 
	</tr> 
	<%
			Cost[] co=jp.getCostByCBId(cbsin[j]);	
 	 		if(co!=null)
			{	
				for(int k=0;k<co.length;k++) 
				{
	%> 
		<tr bgcolor=ffffff class=es02>
			<tD></td> 
			<tD>	
			<%
			BigItem biX=(BigItem)bim.find(co[k].getCostBigItem());
			out.println(biX.getBigItemName()+"->");	
			
			SmallItem siX=(SmallItem)sim.find(co[k].getCostSmallItem());							
			out.println(siX.getSmallItemName());
			%>
			</td>
			<td  colspan=3> <%=co[k].getCostName()%></tD>
 
			<td align=right colspan=3>
			<%=mnfcost.format(co[k].getCostMoney())%>			
			</td>
 
			<td align=right colspan=2></td>
 		</tR>		
	<% 
				}	
			}
		}
	%>
	<tr>
		<td  colspan=4>合計</td>
		<td align=right><%=mnfincome.format(total1)%></td><td align=right><%=mnfincome.format(total2)%></td><td align=right><%=mnfincome.format(total1-total2)%></td>
 	</tr>
</table>	
	
		</td>
		</tr>
		</table> 
		<br>

<%
	}
%>	
	