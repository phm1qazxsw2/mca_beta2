<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>


<%
	int bankId=Integer.parseInt(request.getParameter("bankId"));
	
	SalaryBankMgr sbm=SalaryBankMgr.getInstance();
	
	SalaryBank sb=(SalaryBank)sbm.find(bankId);

	int soNumber=sb.getSalaryBankBankNumberId();
	
	//SalaryOutMgr som=SalaryOutMgr.getInstance();
	//SalaryOut so=(SalaryOut)som.find(soId);

	SalaryAdmin sa=SalaryAdmin.getInstance();
	SalaryOut so=sa.getAllSalaryOutByNumber(soNumber);

	BankAccountMgr bam=BankAccountMgr.getInstance();
	BankAccount ba=(BankAccount)bam.find(so.getSalaryOutBankAccountId());  
	
	int ticketId=sb.getSalaryBankSanumber();
   	SalaryTicket st=sa.getSalaryTicketBySanumber (ticketId );
   
   
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM");
%> 

<div align=left><b>&nbsp;&nbsp;&nbsp;匯款單資訊</b></div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<br>
<blockquote>
	<table width="85%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
	<td>狀態</td><td bgcolor=ffffff colspan=3>
	<%
		int status=so.getSalaryOutStatus();
		
		switch(status){
			case 90:
				out.println("可編輯名單");
				break;
			case 1:
				out.println("匯出名單作業中");
				break;
			case 2:
				out.println("匯出作業完成");
				break;
			}
	%>
	
	</td>
</tr>
<tr bgcolor=#f0f0f0 class=es02>
	<td>流水號</td><td bgcolor=ffffff><%=so.getSalaryOutBanknumber()%></td><tD>月份</td><td bgcolor=ffffff><%=sdf.format(so.getSalaryOutMonth())%></td>
</tr>
<tr bgcolor=#f0f0f0 class=es02>
	<td colspan=4><b>匯款銀行資訊</b></td>
</tr>
<tr bgcolor=#f0f0f0 class=es02>
<td>名稱</td><td bgcolor=ffffff><%=ba.getBankAccountName()%></td><td> 銀行代碼</td><td  bgcolor=ffffff><%=ba.getBankAccountId()%></td></tr>
<tr bgcolor=#f0f0f0 class=es02>
<td>帳戶號碼</td><td bgcolor=ffffff><%=ba.getBankAccountAccount()%></td><td>戶名</td><td bgcolor=ffffff><%=ba.getBankAccountAccountName()%></td>
</tr> 
<table>
</td>
</tr>
</table>