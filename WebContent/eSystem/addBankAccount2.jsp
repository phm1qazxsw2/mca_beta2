<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
request.setCharacterEncoding("UTF-8");

    if(!checkAuth(ud2,authHa,403))
    {
        response.sendRedirect("authIndex.jsp?code=403");
    }

String accountName=request.getParameter("accountName");

String accountId = request.getParameter("accountId").trim();
int bankAccountATMActive=Integer.parseInt(request.getParameter("bankAccountATMActive"));
String accountNumber=request.getParameter("accountNumber");
String accountNumberName=request.getParameter("accountNumberName");
String ps=request.getParameter("ps");

String bankAccount2client=request.getParameter("bankAccount2client");
String bankAccountPayDate=request.getParameter("bankAccountPayDate");

String bankAccountRealName=request.getParameter("bankAccountRealName");
String bankAccountBranchName=request.getParameter("bankAccountBranchName");


BankAccount ba=new BankAccount();
ba.setBankAccountName   	(accountName);
ba.setBankAccountId   	(accountId);
ba.setBankAccountAccount   	(accountNumber);
ba.setBankAccountAccountName(accountNumberName);
ba.setBankAccountLogUseId   	(ud2.getId());
ba.setBankAccountLogDate   	(new Date());
ba.setBankAccountLogPs   	(ps);
ba.setBankAccountActive(1); 
ba.setBankAccount2client(bankAccount2client);
ba.setBankAccountPayDate (bankAccountPayDate);  
ba.setBankAccountATMActive(bankAccountATMActive);

ba.setBankAccountRealName (bankAccountRealName);
ba.setBankAccountBranchName(bankAccountBranchName);                                             
ba.setBunitId(_ws2.getSessionBunitId());


BankAccountMgr bam=BankAccountMgr.getInstance();

int bankId=bam.createWithIdReturned(ba);


if(ud2.getUserRole()>1){

	SalarybankAuthMgr sam=SalarybankAuthMgr.getInstance();	
    SalarybankAuth sa=new SalarybankAuth();	
    sa.setSalarybankAuthId   	(bankId);
    sa.setSalarybankAuthUserID   	(ud2.getId());
    sa.setSalarybankAuthActive   	(1);
    sa.setSalarybankLoginId(ud2.getId());
    sam.createWithIdReturned(sa);
}
%>
<br>
<div class=es02>
<b>&nbsp;&nbsp;<img src="pic/add.gif" border=0>&nbsp;新增銀行帳戶</b>
</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<br>

<blockquote>
    <div class=es02>    
        新增成功.
    </div>
</blockquote>
