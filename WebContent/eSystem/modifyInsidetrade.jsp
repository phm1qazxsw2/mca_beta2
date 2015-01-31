<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=2;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%
    if(!checkAuth(ud2,authHa,402))
    {
        response.sendRedirect("authIndex.jsp?code=402");
    }
%>
<%@ include file="leftMenu2.jsp"%>
<% 
int inId=0;

String orderS=request.getParameter("inId");
 
JsfPay jp=JsfPay.getInstance();
if(orderS !=null)
{
	inId =Integer.parseInt(orderS);
} 

InsidetradeMgr im=InsidetradeMgr.getInstance();

Insidetrade in=(Insidetrade)im.findX(inId, _ws.getBunitSpace("bunitId"));	

if(in==null)
{
	out.println("沒有此筆資料");
	return;
}

java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/dd"); 
java.text.SimpleDateFormat df2 = new java.text.SimpleDateFormat("yyyy/MM/dd HH:MM"); 

UserMgr ux=UserMgr.getInstance(); 
TradeaccountMgr tmx2=TradeaccountMgr.getInstance();
	BankAccountMgr bam2=BankAccountMgr.getInstance();

User uc=(User)ux.find(in.getInsidetradeUserId()); 
%> 
<br>
<br>

<div class=es02>
&nbsp;&nbsp;&nbsp;<img src="pic/insidetradex.png" border=0>&nbsp;<b>內部交易明細</b>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:history.go(-1);"><img src="pic/last2.png" border=0 width=12>&nbsp;回上一頁</a>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table> 	
<blockquote>


<table width="" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#ffffff align=left valign=middle>
		<td bgcolor=#f0f0f0 class=es02>交易日期</td>
		<td bgcolor=#ffffff class=es02><%=df.format(in.getInsidetradeDate())%></td>
	</tr>
	<tr>
		<td bgcolor=#f0f0f0 class=es02>交易人</td>
		<td  bgcolor=#ffffff class=es02><%=uc.getUserFullname()%></td>
	</tr>
	<tr>
		<td bgcolor=#f0f0f0 class=es02>交易方式</td>
		<td  bgcolor=#ffffff class=es02>
		<%
			switch(in.getInsidetradeWay())
			{
				case 1:
					out.println("現金"); 
					break;
				case 2:
					out.println("支票");
					break;
				case 3:
					out.println("匯款");
					break;
				case 4:
					out.println("其他");
					break;	
			}
		
		
		%></td>
	</tr>

	<tr>
		<td bgcolor=#f0f0f0 class=es02>金額</td>
		<tD  bgcolor=#ffffff class=es02><%=in.getInsidetradeNumber()%></td>
	</tr>
	<tr>
		<td bgcolor=#f0f0f0 class=es02>轉出戶頭</td>
		<td  bgcolor=#ffffff class=es02>  
			 <img src="pic/outtrade.png" border=0>
		<%=(in.getInsidetradeFromType()==1)?"個人零用金帳戶-":"銀行帳戶-"%>
	  	<% 
				if(in.getInsidetradeFromType()==1)	
				{
					Tradeaccount  td=(Tradeaccount)tmx2.find(in.getInsidetradeFromId()); 
					out.println(td.getTradeaccountName());

				}else if(in.getInsidetradeFromType()==2){
					
					BankAccount ba=(BankAccount)bam2.find(in.getInsidetradeFromId()); 
					out.println(ba.getBankAccountName());
				}		
	  	%>
		</td>
	</tr>
	<tr>
		<td bgcolor=#f0f0f0 class=es02>轉入戶頭</td>
		<td  bgcolor=#ffffff class=es02>  
			 <img src="pic/intrade.png" border=0>
		<%=(in.getInsidetradeToType()==1)?"個人零用金帳戶-":"銀行帳戶-"%>
	  	<% 
				if(in.getInsidetradeToType()==1)	
				{
					Tradeaccount  td=(Tradeaccount)tmx2.find(in.getInsidetradeToId()); 
					out.println(td.getTradeaccountName());

				}else if(in.getInsidetradeToType()==2){
					
					BankAccount ba=(BankAccount)bam2.find(in.getInsidetradeToId()); 
					out.println(ba.getBankAccountName());
				}		
	  	%>
		</td>
	</tr> 
	
	
	<tr>
		<td bgcolor=#f0f0f0 class=es02>對帳狀態</tD>
		 
			<%
			int checkLog=in.getInsidetradeCheckLog();
  			
  			switch(checkLog)
  			{
  				case 0:
  					out.println("<tD  bgcolor=#ffffff class=es02>尚未對帳");	
  					break;
  				case 1:
  					out.println("<tD  bgcolor=red class=es02><font color=white>警示</font>");	
  					break;					
  				case 90:
  					out.println("<tD  bgcolor=#ffffff class=es02>OK");	
  					break;						
  			}
 		%>
		
		</tD>
	</tr> 
	<%
		if(checkLog>=90) 
		{ 
	%>	
	<tr class=es02>
		<td>確認人</td>
		<td><%
			User ua=(User)ux.find(in.getInsidetradeCheckUserId());
			out.println(ua.getUserFullname());
		%></td>
	</tr> 
	<tr class=es02>
		<td>對帳時間</td>
		<td><%=df2.format(in.getInsidetradeCheckDate())%></td>
	</tr> 
	<%
		}else{

            if(jp.isAuthorAccount(ud2,in.getInsidetradeToType(),in.getInsidetradeToId()))
            {
	%>	
	
    <tr class=es02>
		<td colspan=2 align=middle>
            			<a href="comfirmInsidetrade.jsp?itId=<%=in.getId()%>&inVstatus=1" onClick="return confirm('對帳狀態將改為-OK')"><%=(checkLog==1)?"改為確認":"確認"%></a>	

            <%
                    if(checkLog !=1){
            %> 
            |
			<a href="comfirmInsidetrade.jsp?itId=<%=in.getId()%>&inVstatus=1" onClick="return confirm('對帳狀態將改為-緊示')">警示</a>	
            <%
            }
            %>
        </td>
	</tr>        

<%  
            }
        }
   %>
        </table>
	</td>
	</tr>
	</table> 
	
	<br>
	<!-- 注解掉因為這頁可能從零用金賬戶來，回到內部轉帳列表很怪，干脆用瀏覽器back
    <div align=left>&nbsp;&nbsp;<a href="listInsidetrade.jsp"><img src="pic/littleInside.jpg" border=0>回 內部轉帳列表</a></div>-->

</blockquote>


<%@ include file="bottom.jsp"%>	
