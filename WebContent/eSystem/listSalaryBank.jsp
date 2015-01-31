<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=5;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu5.jsp"%>
<%

int stId=Integer.parseInt(request.getParameter("stId"));

SalaryTicketMgr stm=SalaryTicketMgr.getInstance();
SalaryTicket st=(SalaryTicket)stm.find(stId);

SalaryAdmin sa=SalaryAdmin.getInstance();
SalaryBank[] sb=sa.getSalaryBankBySanunmber(st);

if(sb==null)
{
	out.println("沒有付款資料");
	return;
}
 

SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd"); 

TradeaccountMgr tmx2=TradeaccountMgr.getInstance();
BankAccountMgr bam2=BankAccountMgr.getInstance();

TeacherMgr tm=TeacherMgr.getInstance();
Teacher tea=(Teacher)tm.find(st.getSalaryTicketTeacherId());

SimpleDateFormat sdf2=new SimpleDateFormat("yyyy-MM"); 

SimpleDateFormat sdf3=new SimpleDateFormat("yyyy");  
SimpleDateFormat sdf4=new SimpleDateFormat("MM"); 
%>
<div align=right>合計:<font color=blue><%=sb.length%></font>筆</div> 

<blockquote>
<b><%=tea.getTeacherFirstName()%><%=tea.getTeacherLastName()%></b> - <%=sdf2.format(st.getSalaryTicketMonth())%>支付明細
<br>
<br>
<a href="salarySearch.jsp
?poId=999&classId=999&year=<%=sdf3.format(st.getSalaryTicketMonth())%>&month=<%=sdf4.format(st.getSalaryTicketMonth())%>">回交易總表</a>

<table width="" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#ffffff align=left valign=middle>
		<td bgcolor=#f0f0f0 class=es02>付款日期</td>
		<td bgcolor=#f0f0f0 class=es02>付款方式</td>
 
		<td bgcolor=#f0f0f0 class=es02>明細</td>
		<td bgcolor=#f0f0f0 class=es02>金額</tD> 
		<td bgcolor=#f0f0f0 class=es02>付款人</td>
 
		<td bgcolor=#f0f0f0 class=es02>匯入帳戶</tD>
		<td bgcolor=#f0f0f0 class=es02></td>
	</tr>
<%
	for(int i=0;i<sb.length;i++)	
	{
%>
	<tr bgcolor=#ffffff align=left valign=middle>
		<td class=es02><%=sdf.format(sb[i].getSalaryBankPayDate())%></td>
		<td class=es02><%
 
		
		
			int payWay=sb[i].getSalaryBankPayWay()
; 
			
			switch(payWay)
 
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
		<td class=es02>
		<%

			if(sb[i].getSalaryBankPayAccountType()==1)	
			{
 
				out.println("個人零用金帳戶-");
				Tradeaccount  td=(Tradeaccount)tmx2.find(sb[i].getSalaryBankPayAccountId()); 
				out.println(td.getTradeaccountName());
	
			}else if(sb[i].getSalaryBankPayAccountType()==2){
				out.println("銀行帳戶-");
				BankAccount ba=(BankAccount)bam2.find(sb[i].getSalaryBankPayAccountId()); 
				out.println(ba.getBankAccountName());
			}	
			

		%>
		
		</td>
		
		<td class=es02><%=sb[i].getSalaryBankMoney()%></tD>
		<td class=es02>
		<% 
 
			
			UserMgr uma=UserMgr.getInstance();
			
			User u0=(User)uma.find(sb[i].getSalaryBankLogId());
			
			out.println(u0.getUserFullname());
		
		%>
		
		</td> 
		<td class=es02>
		<% 
		
			if(sb[i].
getSalaryBankPayWay()==3)
			{ 
		%>		
			<%=sb[i].getSalaryBankToId()%>
			- 
			<%=sb[i].getSalaryBankToAccount()%>
		
		<%
			}
 
		%>
		</td>
 
		<td class=es02> 
		<% 
			if(sb[i].getSalaryBankPayWay()==3)	
			{
		%>	
			<a href="#" onClick="openwindow56('<%=sb[i].getId()%>')">匯款單明細</a>
		
		<%
			}		
		%>
		
		</td>
		
		
	</tr>
<%
	}
%>
</table>
	
	</td>
	</tr>
	</table>	
	
</blockquote>	
<%@ include file="bottom.jsp"%>	

