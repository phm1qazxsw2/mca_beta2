<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="justHeader.jsp"%>
<%
    request.setCharacterEncoding("UTF-8");
	String clientAccountBankOwner=request.getParameter("clientAccountBankOwner");
	String clientAccountBankName=request.getParameter("clientAccountBankName");
	String clientAccountBankNum=request.getParameter("clientAccountBankNum");
	String clientAccountBankBranchName=request.getParameter("clientAccountBankBranchName");
	String clientAccountAccountNum=request.getParameter("clientAccountAccountNum");
	String clientAccountAccountName=request.getParameter("clientAccountAccountName");
	String clientAccountBankIdPs=request.getParameter("clientAccountBankIdPs");
    int costtradeId=Integer.parseInt(request.getParameter("costtradeId"));
    

	ClientAccount ca=new ClientAccount();
    ca.setClientAccountBankOwner   	(clientAccountBankOwner);
    ca.setClientAccountBankName   	(clientAccountBankName);
    ca.setClientAccountBankBranchName   	(clientAccountBankBranchName);
    ca.setClientAccountBankNum   	(clientAccountBankNum);
    ca.setClientAccountAccountNum   	(clientAccountAccountNum);
    ca.setClientAccountAccountName   	(clientAccountAccountName);
    ca.setClientAccountBankIdPs(clientAccountBankIdPs);
    ca.setClientAccountActive(1);   
    ca.setClientAccountCosttrade(costtradeId);
    ca.setBunitId(_ws2.getSessionBunitId());

    ClientAccountMgr cam=ClientAccountMgr.getInstance();
    cam.createWithIdReturned(ca);

    String backurl=request.getParameter("backurl");

    if(backurl !=null && backurl.length()>0)
   	    response.sendRedirect(backurl);    
    else
    	response.sendRedirect("listClientAccount.jsp");    
%>