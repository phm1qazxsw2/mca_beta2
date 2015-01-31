<%@ page language="java" contentType="text/html;charset=UTF-8"%><%   
	DecimalFormat mnfinside = new DecimalFormat("###,###,##0");

	UserMgr uminside=UserMgr.getInstance();
	
    Insidetrade[] in=jp.getInsidetradeByBeforedate(beforeDate, _ws.getBunitSpace("bunitId")); 
	if(in !=null)
	{
%>
<div class=es02>
<b><img src="pic/insidetradex.png" border=0 width=16>&nbsp;內部轉帳</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;更動概況: <a href="#" onClick="showForm('insideDiv');return false"><%=in.length%> 筆</a></div>

<div id=insideDiv style="display:none" class=es02>
<table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#ffffff align=left valign=middle>
		<td bgcolor=#f0f0f0 class=es02 align=middle>
			交易日期 
		</td>
		<td bgcolor=#f0f0f0 class=es02 align=middle>
			交易人
		</td>
  		<td bgcolor=#f0f0f0 class=es02 align=middle>
			轉出帳戶
		</td>
 		<td bgcolor=#f0f0f0 class=es02 align=middle>
			轉入帳戶
 	 	</td>
		<td bgcolor=#f0f0f0 class=es02 width=50>
			金額
		</tD>
		<td bgcolor=#f0f0f0 class=es02 align=middle>
			註記 
		</tD>
		
		<td bgcolor=#f0f0f0 class=es02 align=middle>
			覆核狀態
		</td>
 		<td bgcolor=#f0f0f0 class=es02>
 		</td>
 	</tr>		
 	
 <% 
  
   	UserMgr ux=UserMgr.getInstance();
	TradeaccountMgr tmx2=TradeaccountMgr.getInstance();
	BankAccountMgr bam2=BankAccountMgr.getInstance();

	SimpleDateFormat df=new SimpleDateFormat("yyyy/MM/dd");
   
 	for(int i=0;i<in.length;i++)
 	{
 	 	User uc=(User)ux.find(in[i].getInsidetradeUserId()); 
%> 
 		<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>

		<td class=es02><%=df.format(in[i].getInsidetradeDate())%></td>
		<td class=es02><%=uc.getUserFullname()%></td>
 
		
  		<td class=es02>
		<img src="pic/outtrade.png" border=0><%=(in[i].getInsidetradeFromType()==1)?"個人零用金帳戶-<br>":"銀行帳戶-<br>"%>
	  	<% 
				if(in[i].getInsidetradeFromType()==1)	
				{
					Tradeaccount  td=(Tradeaccount)tmx2.find(in[i].getInsidetradeFromId()); 
					out.println(td.getTradeaccountName());

				}else if(in[i].getInsidetradeFromType()==2){
					
					BankAccount ba=(BankAccount)bam2.find(in[i].getInsidetradeFromId()); 
					out.println(ba.getBankAccountName());
				}		
	  	%>

  		</td>
 		<td class=es02>
 			<img src="pic/intrade.png" border=0><%=(in[i].getInsidetradeToType()==1)?"個人零用金帳戶-<br>":"銀行帳戶-<br>"%>
	  	<% 
				if(in[i].getInsidetradeToType()==1)	
				{
					Tradeaccount  td=(Tradeaccount)tmx2.find(in[i].getInsidetradeToId()); 
					out.println(td.getTradeaccountName());

				}else if(in[i].getInsidetradeToType()==2){
					
					BankAccount ba=(BankAccount)bam2.find(in[i].getInsidetradeToId()); 
					out.println(ba.getBankAccountName());
				}		
	  	%>
 		 
 		</td>
		<td class=es02 align=right><%=mnfinside.format(in[i].getInsidetradeNumber())%></tD>
 
		<td class=es02 align=left>
			<%=(in[i].getInsidetradeUserPs()!=null && in[i].getInsidetradeUserPs().length()>0)?in[i].getInsidetradeUserPs():""%>		
		</tD>
		<%
 
			int checkLog=in[i].getInsidetradeCheckLog();
  			switch(checkLog)
  			{
  				case 0:
  					out.println("<td class=es02><font color=blue>尚未</font>");	
  					break;
  				case 1:
  					out.println("<td class=es02 bgcolor=red><font color=white>警示<br>");	
  					User ux2=(User)uminside.find(in[i].getInsidetradeCheckUserId());
  					if(ux2 !=null)
  						out.println(ux2.getUserFullname()+"-"+df.format(in[i].getInsidetradeCheckDate())+"</font>");		
  					break;					
  				case 90:
  					out.println("<td class=es02>OK<br>");	
  					User ux3=(User)uminside.find(in[i].getInsidetradeCheckUserId());
  					
  					if(ux3 !=null)
  						out.println(ux3.getUserFullname()+"-"+df.format(in[i].getInsidetradeCheckDate()));		
  					break;		
  				default:
  					out.println(checkLog);	
  			}
		
			if(checkLog <90)	
			{
				if(jp.isAuthorAccount(ud2,in[i].getInsidetradeToType(),in[i].getInsidetradeToId()))
				{ 
		%>
 
 
			<br> 
			<a href="comfirmInsidetrade.jsp?itId=<%=in[i].getId()%>&inVstatus=90" onClick="return confirm('對帳狀態將改為-OK')"><%=(checkLog==1)?"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=white>改為確認</font>":"確認"%></a>	
            <%
                    if(checkLog !=1){
            %> 
            |
			<a href="comfirmInsidetrade.jsp?itId=<%=in[i].getId()%>&inVstatus=1" onClick="return confirm('對帳狀態將改為-緊示')">警示</a>	
		<%	
                    }		
	 	 	 	} 
			}	
		%>

		</td>
 		<td class=es02>
 					<a href="modifyInsidetrade.jsp?inId=<%=in[i].getId()%>">詳細資料</a> 					
 		</td>
 	</tr>		
<%
}
%> 
</table> 
	
	</td>
	</tr>
	</table> 
    </div>
	<br>

<%
	}
%>