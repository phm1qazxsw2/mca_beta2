<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=11;
    int leftMenu=2;
%>
<%@ include file="topMenu.jsp"%>
<%
if(!checkAuth(ud2,authHa,402))
{
    response.sendRedirect("authIndex.jsp?code=402");
}
%>
<%@ include file="leftMenu11.jsp"%>

<%  

String m=request.getParameter("m");

if(m !=null)	
{
%>
	<script>
		alert('內部轉帳完成!');
	</script>

<%
}

DecimalFormat mnf = new DecimalFormat("###,###,##0"); 

int orderId=0;

String orderS=request.getParameter("orderId");
String vsatusS=request.getParameter("vstatus");
String showTypeS=request.getParameter("showType");
 
int vstatus=999;
int showType =0;

if(showTypeS !=null) 
	showType =Integer.parseInt(showTypeS);

if(vsatusS !=null) 
	vstatus =Integer.parseInt(vsatusS);

if(orderS !=null)
	orderId =Integer.parseInt(orderS);

JsfPay jp=JsfPay.getInstance();
Insidetrade[] in=jp.getInsidetradeByVstatus(vstatus,orderId,_ws.getBunitSpace("bunitId")); 
String backurlstr = java.net.URLEncoder.encode("listInsidetrade.jsp?" + request.getQueryString());
java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/dd"); 
%>

<br>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/insidetradex.png" border=0>&nbsp;內部轉帳紀錄</b>
</div>
<blockquote>
<form action="listInsidetrade.jsp"> 
	&nbsp;&nbsp;&nbsp;對帳確認狀態: 
	<select name="vstatus" size=1>
		<option value=999 <%=(vstatus==999)?"selected":""%>>全部</option>
		<option value=0 <%=(vstatus==0)?"selected":""%>>尚未對帳</option>
		<option value=1 <%=(vstatus==1)?"selected":""%>>警示</option>
		<option value=90 <%=(vstatus==90)?"selected":""%>>已確認</option>
	</select>  
	<input type=hidden name="orderId" value="<%=orderId%>">
	<input type=hidden name="showType" value="<%=showType%>"> 
	<!--
	<input id="loginButton" type="image" src="https://a248.e.akamai.net/sec.yimg.com/i/us/ypn/ms/adapp_1_7_0_0_101/images/login-btn-zh.gif"/>
	-->
	<input type=submit value="搜尋">
</form> 
</blockquote>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<center>
<%
if(in==null)
{ 
	out.println("沒有資料");
	return;
}  

	if(showType==0)
	{
%>	
	顯示最後15筆 | <a href="listInsidetrade.jsp?showType=1&vstatus=<%=vstatus%>&orderId=<%=orderId%>">顯示最後30筆</a> | <a href="listInsidetrade.jsp?showType=2&vstatus=<%=vstatus%>&orderId=<%=orderId%>">顯示全部資料</a>
<%
	}else if(showType==1){
%> 
	<a href="listInsidetrade.jsp?showType=0&vstatus=<%=vstatus%>&orderId=<%=orderId%>">顯示最後15筆</a> | 顯示最後30筆 | <a href="listInsidetrade.jsp?showType=2&vstatus=<%=vstatus%>&orderId=<%=orderId%>">顯示全部資料</a>
<%
	} else if(showType==2)
 { 
%>
	<a href="listInsidetrade.jsp?showType=0&vstatus=<%=vstatus%>&orderId=<%=orderId%>">顯示最後15筆</a> |<a href="listInsidetrade.jsp?showType=1&vstatus=<%=vstatus%>&orderId=<%=orderId%>">顯示最後30筆</a> | 顯示全部資料
<%
	}
%>
 

<div align=left>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;共計:<font color=blue><%=in.length%></font>筆
</div>
<table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#ffffff align=left valign=middle>
		<td bgcolor=#f0f0f0 class=es02>
				<%	if(orderId==0)
{ %>
							<a href="listInsidetrade.jsp?orderId=1">交易日期<img src="images/Upicon2.gif" border=0></a>
				<%	}else{  %>
							<a href="listInsidetrade.jsp?orderId=0">交易日期<img src="images/Downicon2.gif" border=0></a>
				<%	}  %>
		</td>

		
  		<td bgcolor=#f0f0f0 class=es02 width=120>
  		<%	if(orderId==4){ %>				
				<a href="listInsidetrade.jsp?orderId=5">轉出戶頭<img src="images/Upicon2.gif" border=0></a> 
  		<%	}else{  %>				
  				<a href="listInsidetrade.jsp?orderId=4">轉出戶頭<img src="images/Downicon2.gif" border=0></a>
		<%	}
   %> 
		</td>
 		<td bgcolor=#f0f0f0 class=es02  width=120>
		<%	if(orderId==6){ %>				
	 		<a href="listInsidetrade.jsp?orderId=7">轉入戶頭<img src="images/Upicon2.gif" border=0></a>
	 	<% 	}else{  %>
	 		<a href="listInsidetrade.jsp?orderId=6">轉入戶頭<img src="images/Downicon2.gif" border=0></a>
	 	<% 
 } %>
	 	 		
 		
 	 	</td>
		<td bgcolor=#f0f0f0 class=es02 width=58>
			金額</tD>
		<td bgcolor=#f0f0f0 class=es02 nowrap>
				<%	if(orderId==2){ %>		
						<a href="listInsidetrade.jsp?orderId=3">交易人<img src="images/Upicon2.gif" border=0></a>
				<%	}else{  %>		
						<a href="listInsidetrade.jsp?orderId=2">交易人<img src="images/Downicon2.gif" border=0></a>
				<%	}  %>
		</td>
		<td bgcolor=#f0f0f0 class=es02 align=middle>註記</td>	
		<td bgcolor=#f0f0f0 class=es02 align=middle>
		<%	if(orderId==8){ %>				
			<a href="listInsidetrade.jsp?orderId=9">確認狀態<img src="images/Upicon2.gif" border=0></a>
		<%  }else{  %>
			<a href="listInsidetrade.jsp?orderId=8">確認狀態<img src="images/Downicon2.gif" border=0></a>
		<% 	} %>
		</td>
 		<td bgcolor=#f0f0f0 class=es02 width=30>
 		</td>
 	</tr>		
 	
 <% 
  
   	UserMgr ux=UserMgr.getInstance();
  	DecimalFormat mnfinside = new DecimalFormat("###,###,##0");
	UserMgr uminside=UserMgr.getInstance();     
 
	TradeaccountMgr tmx2=TradeaccountMgr.getInstance();
	BankAccountMgr bam2=BankAccountMgr.getInstance();

    
	int rowStart=0;
	if(showType==0)	
	{
		if(in.length>=15)

		{
			rowStart=in.length-15;
		} 
	}else if(showType==1){
		if(in.length>=30)
		{
			rowStart=in.length-30;
		}
	}
  

 	for(int i=0;in!=null&&i<in.length;i++)
 	{
 	
 		if(i<rowStart)
		{ 
			continue;	
 		}
 	 	User uc=(User)ux.find(in[i].getInsidetradeUserId()); 
%> 
 		<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>

		<td class=es02><%=df.format(in[i].getInsidetradeDate())%></td>
  		<td class=es02>
		<img src="pic/outtrade.png" border=0> <%=(in[i].getInsidetradeFromType()==1)?"個人零用金帳戶-<br>":(in[i].getInsidetradeFromType()==2)?"銀行帳戶-<br>":"支票(應收票據)"%>
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
 			<img src="pic/intrade.png" border=0> <%=(in[i].getInsidetradeToType()==1)?"個人零用金帳戶-<br>":(in[i].getInsidetradeToType()==2)?"銀行帳戶-<br>":"支票(應付票據)"%>
	  	<% 
				if(in[i].getInsidetradeToType()==1)	
				{
					Tradeaccount  td=(Tradeaccount)tmx2.find(in[i].getInsidetradeToId()); 
                    if (td!=null)
    					out.println(td.getTradeaccountName());

				}else if(in[i].getInsidetradeToType()==2){
					
					BankAccount ba=(BankAccount)bam2.find(in[i].getInsidetradeToId()); 
                    if (ba!=null)
    					out.println(ba.getBankAccountName());
				}		
	  	%>
 		 
 		</td>
		<td class=es02 align=right><%=mnf.format(in[i].getInsidetradeNumber())%></tD> 
		<td class=es02><%=uc.getUserFullname()%></td>
		<td class=es02 align=left>
			<%=(in[i].getInsidetradeUserPs()!=null && in[i].getInsidetradeUserPs().length()>0)?in[i].getInsidetradeUserPs():""%>		
		</tD>
		
		<% 
			int checkLog=in[i].getInsidetradeCheckLog();
  			switch(checkLog)
  			{
  				case 0:
  					out.println("<td class=es02><font color=blue>尚未確認</font>");	
  					break;
  				case 1:
  					out.println("<td class=es02 bgcolor=red><font color=white>警示</font><br>");	
  					User ux2=(User)uminside.find(in[i].getInsidetradeCheckUserId());
  					if(ux2 !=null)
  						out.println("<font color=white>"+ux2.getUserFullname()+"-"+df.format(in[i].getInsidetradeCheckDate())+"</font>");		
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
			<a href="comfirmInsidetrade.jsp?itId=<%=in[i].getId()%>&inVstatus=90&vstatus=<%=vstatus%>&showType=<%=showType%>&orderId=<%=orderId%>" onClick="return confirm('對帳狀態將改為-OK')"><%=(checkLog==1)?"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=white>改為確認</font>":"確認"%></a>	
            <%
                    if(checkLog !=1){
            %>        
    
                |
			<a href="comfirmInsidetrade.jsp?itId=<%=in[i].getId()%>&inVstatus=1&vstatus=<%=vstatus%>&showType=<%=showType%>&orderId=<%=orderId%>" onClick="return confirm('對帳狀態將改為-緊示')">警示</a>	
		<%	
                    }		
	 	 	 	} 
			}	
		%>

		</td>
 		<td class=es02>
            <a href="modifyInsidetrade.jsp?inId=<%=in[i].getId()%>">詳細資料</a>
        <% if (ud2.getId()==in[i].getInsidetradeUserId()&&checkLog==0) { %>
            | <a href="insidetrade_delete.jsp?id=<%=in[i].getId()%>&backurl=<%=backurlstr%>" onclick="if (confirm('確定刪除此筆內部交易？')) {return true;} else {return false;}">刪除</a> 					
        <% } %>
        </td>
 	</tr>		
  
<%
}
%> 
</table> 
	
	</td>
	</tr>
	</table>
</center> 

<br>
<br>
<%@ include file="bottom.jsp"%>