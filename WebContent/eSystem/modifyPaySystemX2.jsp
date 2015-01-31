<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file='/WEB-INF/jsp/security.jsp'%>
<%    
    User ud2 = WebSecurity.getInstance(pageContext).getCurrentUser();
    if(!AuthAdmin.authPage(ud2,3))
    {
        response.sendRedirect("authIndex.jsp?info=1&page=1");
    }
    request.setCharacterEncoding("UTF-8");
	String cAddress=request.getParameter("cAddress");
	String cPhone=request.getParameter("cPhone");
	int limitDate=Integer.parseInt(request.getParameter("limitDate")); 

    int paySystemATMActive=Integer.parseInt(request.getParameter("paySystemATMActive")); 
	int paySystemStoreActive=Integer.parseInt(request.getParameter("paySystemStoreActive")); 

	int showlimitDate=Integer.parseInt(request.getParameter("showlimitDate")); 

	int paySystemMessageActive=Integer.parseInt(request.getParameter("paySystemMessageActive")); 
	int paySystemMessageTo=Integer.parseInt(request.getParameter("paySystemMessageTo")); 
	
	String paySystemMessageText=request.getParameter("paySystemMessageText");

	String paySystemReplaceWord=request.getParameter("paySystemReplaceWord");

	int paySystemBirthActive=Integer.parseInt(request.getParameter("paySystemBirthActive")); 
	String paySystemBirthWord=request.getParameter("paySystemBirthWord");

	int paySystemATMAccountId=Integer.parseInt(request.getParameter("paySystemATMAccountId")); 
	int paySystemEmailActive=Integer.parseInt(request.getParameter("paySystemEmailActive")); 
	int paySystemEmailTo=Integer.parseInt(request.getParameter("paySystemEmailTo")); 
 

	String paySystemEmailText=request.getParameter("paySystemEmailText"); 

	
	String paySystemFixATMAccount=request.getParameter("paySystemFixATMAccount").trim(); 
	int paySystemFixATMNum=Integer.parseInt(request.getParameter("paySystemFixATMNum")); 
	
	int paySystemExtendNotpay=Integer.parseInt(request.getParameter("paySystemExtendNotpay")); 

	PaySystemMgr pma=PaySystemMgr.getInstance();
	PaySystem ps=(PaySystem)pma.find(1);
	ps.setPaySystemCompanyAddress   	(cAddress.trim());
	ps.setPaySystemCompanyPhone   	(cPhone);
	ps.setPaySystemLimitDate   	(limitDate);

	ps.setPaySystemBeforeLimitDate(showlimitDate);
 

	
    ps.setPaySystemMessageActive   	(paySystemMessageActive);
    ps.setPaySystemMessageTo   	(paySystemMessageTo);
	ps.setPaySystemMessageText(paySystemMessageText); 
	
	
	ps.setPaySystemATMActive   	(paySystemATMActive);
    ps.setPaySystemStoreActive  (paySystemStoreActive);
    ps.setPaySystemReplaceWord(paySystemReplaceWord);  
	
	ps.setPaySystemBirthActive (paySystemBirthActive);
	ps.setPaySystemBirthWord (paySystemBirthWord);
 
	ps.setPaySystemATMAccountId(paySystemATMAccountId); 
	
	ps.setPaySystemEmailActive   	(paySystemEmailActive);
    ps.setPaySystemEmailTo   	(paySystemEmailTo);
    ps.setPaySystemEmailText(paySystemEmailText);   
	
	ps.setPaySystemFixATMAccount(paySystemFixATMAccount);
	ps.setPaySystemFixATMNum(paySystemFixATMNum);
	
	ps.setPaySystemExtendNotpay(paySystemExtendNotpay);
	pma.save(ps);

	response.sendRedirect("modifyPaySystemX.jsp?m=y");
%>

