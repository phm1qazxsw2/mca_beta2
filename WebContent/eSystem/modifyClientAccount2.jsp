<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=2;
    int leftMenu=3;
%>
<%@ include file="topMenu.jsp"%>
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
	int clientAccountActive=Integer.parseInt(request.getParameter("clientAccountActive"));
	int caId=Integer.parseInt(request.getParameter("caId"));
	
	ClientAccountMgr cam=ClientAccountMgr.getInstance();
	ClientAccount ca=(ClientAccount)cam.find(caId);

    ca.setClientAccountBankOwner   	(clientAccountBankOwner);
    ca.setClientAccountBankName   	(clientAccountBankName);
    ca.setClientAccountBankBranchName   	(clientAccountBankBranchName);
    ca.setClientAccountBankNum   	(clientAccountBankNum);
    ca.setClientAccountAccountNum   	(clientAccountAccountNum);
    ca.setClientAccountAccountName   	(clientAccountAccountName);
    ca.setClientAccountBankIdPs(clientAccountBankIdPs);
    ca.setClientAccountActive(clientAccountActive);   
    ca.setClientAccountCosttrade(costtradeId);
	cam.save(ca);	

    String backurl=request.getParameter("backurl");

    if(backurl !=null && backurl.length()>0 && !backurl.equals("null") && !backurl.equals("NULL"))
    	response.sendRedirect(backurl);
    else            
    	response.sendRedirect("listClientAccount.jsp");    
%>