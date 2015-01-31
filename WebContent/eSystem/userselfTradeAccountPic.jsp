<%@ page language="java" contentType="text/html;charset=UTF-8"%><%
 
		DecimalFormat mnftrade = new DecimalFormat("###,###,##0");

		Tradeaccount[] tradeA=jp.getActiveTradeaccount(ud2.getId());

		if(tradeA!=null)
 
		{ 
%> 
&nbsp;&nbsp;&nbsp;<img src="pic/casex.png" border=0>&nbsp;<b>我的零用金帳戶:</b> 

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<%
		}

		Costpay[] cpta=jp.getAccountType1Costpay();
 
		if(cpta!=null)
  		{
 		
 		Hashtable allTrade=jp.getTradeAcccountNum(cpta);		
%> 

<blockquote>
 
<table width="400" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
<table width="100%" border=0 cellpadding=4 cellspacing=1>
	
	<%
 
		int[] payTotal={0,0,0};
		if(tradeA!=null) 
		{	
			for(int p=0;p<tradeA.length;p++)
			{
 
				int[] allNum=jp.getSingleTradeANum (allTrade,tradeA[p].getId()); 
 
				payTotal[0]+=allNum[0];
				payTotal[1]+=allNum[1];	
				payTotal[2]+=allNum[2];	
	%> 
 
		<tr bgcolor=#ffffff align=left valign=middle> 
					<td bgcolor=#ffffff class=es02 width=152>
					<% 
					
						String filePath2 = request.getRealPath("./")+"accountAlbum/"+tradeA[p].getId();
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
			<img src="accountAlbum/<%=tradeA[p].getId()%>/<%=xF2.getName()%>" width=150 border=0>
<%
						}else{
							out.println("[尚未上傳]<br>");
%>							 
							<a href="#" onClick="javascript:openwindow72a('<%=tradeA[p].getId()%>');return false">上傳</a>

<%						
						}
						
%>
					</td>
					<td bgcolor=#ffffff class=es02 valign=middle width="248">
						
						<table width="248" height="" border="0" cellpadding="0" cellspacing="0">
						<tr align=left valign=top>
						<td bgcolor="#e9e3de">
						<table width="100%" border=0 cellpadding=4 cellspacing=1>

						<tr bgcolor=#f0f0f0 align=left valign=middle>
							<td align=middle bgcolor=#e9e3de class=es02 colspan=2>
								<a href="show_costpay_detail.jsp?bankType=1&baid=<%=tradeA[p].getId()%>"><font color=blue><%=tradeA[p].getTradeaccountName()%></font></a>
							</td>	
						</tr>
						<tr align=left bgcolor=#f0f0f0 class=es02>
							<td>
								存入						
							</td>	
							<td  bgcolor=#ffffff class=es02 align=right> 
								<%=mnftrade.format(allNum[0])%>
							</td>
						</tr>		
						
						<tr align=left bgcolor=#f0f0f0 class=es02>
							<td>
								支出					
							</td>	
							<td  bgcolor=#ffffff class=es02  align=right> 
								<%=mnftrade.format(allNum[1])%>
							</td>
						</tr>		
						<tr align=left bgcolor=#f0f0f0 class=es02>
							<td>
								餘額
							</td>	
							<td  bgcolor=#ffffff class=es02  align=right> 
								<a href="show_costpay_detail.jsp?bankType=1&baid=<%=tradeA[p].getId()%>"><%=mnftrade.format(allNum[2])%></a>
							</td>
						</tr>		
						</table>
 
						
						</td>
						</tr>
						</table>
			</td>
		</tr>
	
	<%
			}	
		}
	%>		
	<tr>
		<td align=right colspan=2>
		存入總額: <%=mnftrade.format(payTotal[0])%> 支出總額: <%=mnftrade.format(payTotal[1])%>
		
		合計:<b><%=mnftrade.format(payTotal[2])%></b>
		</td>
	</tr>
	
	</table>
			</td>
	</tr>
	</table>

</blockquote>
<%
	}
else{
	
		out.println("目前沒有交易紀錄");
	} 
	
%>
 
<br>
