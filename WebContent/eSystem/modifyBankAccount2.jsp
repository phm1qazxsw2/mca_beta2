<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*,phm.accounting.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>

<%
request.setCharacterEncoding("UTF-8");
String accountName=request.getParameter("accountName");
String accountId=request.getParameter("accountId");


String accountNumber=request.getParameter("accountNumber");
String accountNumberName=request.getParameter("accountNumberName");
String ps=request.getParameter("ps");

String bankAccount2client=request.getParameter("bankAccount2client"); 
String bankAccountPayDate=request.getParameter("bankAccountPayDate");

String bankIdS=request.getParameter("backId");

int bankAccountATMActive=Integer.parseInt(request.getParameter("bankAccountATMActive"));

int backId=Integer.parseInt(bankIdS);


String bankActiveS=request.getParameter("bankActive");
int bankActive=Integer.parseInt(bankActiveS);

String bankAccountWebAddress=request.getParameter("bankAccountWebAddress");
String bankAccountWeb1=request.getParameter("bankAccountWeb1");
String bankAccountWeb2=request.getParameter("bankAccountWeb2");
String bankAccountWeb3=request.getParameter("bankAccountWeb3");
  
String bankAccountRealName=request.getParameter("bankAccountRealName");
String bankAccountBranchName=request.getParameter("bankAccountBranchName");

   
   
BankAccountMgr bam=BankAccountMgr.getInstance();

BankAccount ba=(BankAccount)bam.findX(backId, _ws2.getBunitSpace("bunitId"));
String oldname = ba.getBankAccountName();
ba.setBankAccountName   	(accountName);
ba.setBankAccountId   	(accountId);
ba.setBankAccountAccount   	(accountNumber);
ba.setBankAccountAccountName(accountNumberName);
ba.setBankAccountLogUseId   	(ud2.getId());
ba.setBankAccountLogDate   	(new Date());
ba.setBankAccountLogPs   	(ps);
ba.setBankAccountActive(bankActive); 
ba.setBankAccount2client(bankAccount2client);
ba.setBankAccountPayDate (bankAccountPayDate);

ba.setBankAccountWebAddress (bankAccountWebAddress);
ba.setBankAccountWeb1   	(bankAccountWeb1);
ba.setBankAccountWeb2   	(bankAccountWeb2);
ba.setBankAccountWeb3  (bankAccountWeb3);  
ba.setBankAccountATMActive(bankAccountATMActive);

ba.setBankAccountRealName (bankAccountRealName);
ba.setBankAccountBranchName(bankAccountBranchName);                                             
                                             
bam.save(ba);

// ## 2009/2/17 - by peter, 科目用設定的(看上面)，不用程式產生的
VoucherService vsvc = new VoucherService(0, _ws2.getSessionBunitId());
Acode oa = vsvc.getCashAcode(2, ba.getId());
if (!oldname.equals(accountName)) {
    Acode a = vsvc.modifyAcode(oa.getId(), accountName);
}

response.sendRedirect("modifyBankAccountDetail.jsp?bankId="+backId+"&m=1");


%>
