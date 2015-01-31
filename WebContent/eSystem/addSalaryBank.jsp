<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>

<%
 	String sanumberid[]=request.getParameterValues("sanumberid");
 	
 	if(sanumberid==null || sanumberid.length==0)
 	{
 %>
 		尚未選擇匯款項目!! <br><br>
 <%
 		return;
 	}
 	
 	int soId=Integer.parseInt(request.getParameter("soId"));
 	
 	SalaryOutMgr som=SalaryOutMgr.getInstance();
	SalaryOut so=(SalaryOut)som.find(soId);
	
	Date runDate=so.getSalaryOutMonth();
	
	SalaryAdmin sa=SalaryAdmin.getInstance();

	BankAccountMgr bam=BankAccountMgr.getInstance();
	BankAccount ba=(BankAccount)bam.find(so.getSalaryOutBankAccountId());

	SalaryBankMgr sbm=SalaryBankMgr.getInstance();

	for(int i=0;i<sanumberid.length;i++)
	{
		int stNumber=Integer.parseInt(sanumberid[i]);
		SalaryTicket st=sa.getSalaryTicketBySanumber(stNumber);
	
		SalaryBank sb=new SalaryBank();
		sb.setSalaryBankMonth   	(so.getSalaryOutMonth());
		sb.setSalaryBankTeacherId   	(st.getSalaryTicketTeacherId());
		sb.setSalaryBankSanumber   	(stNumber);
		sb.setSalaryBankMoney   	(0);
		sb.setSalaryBankBankNumberId   	(so.getSalaryOutBanknumber());
		sb.setSalaryBankStatus   	(0);
		
		//sb.setSalaryBankPrintDate   	(Date salaryBankPrintDate);
		//sb.setSalaryBankPayDate   	(Date salaryBankPayDate);
		//sb.setSalaryBankPayBankAccount   	(int salaryBankPayBankAccount);
		//sb.setSalaryBankPayId   	(int salaryBankPayId);
		//sb.setSalaryBankPayAcount   	(String salaryBankPayAcount);
		//sb.setSalaryBankToId   	(int salaryBankToId);
		//sb.setSalaryBankToAccount   	(St
		
		sbm.createWithIdReturned(sb);		
 	}	
 	
 	response.sendRedirect("modifySalaryOutList.jsp?soId="+soId);
 %>
 