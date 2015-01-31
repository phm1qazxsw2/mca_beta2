<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>

<%
    request.setCharacterEncoding("UTF-8");
	String paySystemEmailServer=request.getParameter("paySystemEmailServer");
	String paySystemEmailSender=request.getParameter("paySystemEmailSender");
	String paySystemEmailSenderAddress=request.getParameter("paySystemEmailSenderAddress");
	String paySystemEmailCode=request.getParameter("paySystemEmailCode");

	PaySystemMgr pma=PaySystemMgr.getInstance();
	PaySystem ps=(PaySystem)pma.find(1);
	ps.setPaySystemEmailServer   	(paySystemEmailServer.trim());
	ps.setPaySystemEmailSender   	(paySystemEmailSender.trim());
	ps.setPaySystemEmailSenderAddress   	(paySystemEmailSenderAddress.trim());
    if (paySystemEmailCode!=null)
    	ps.setPaySystemEmailCode   	(paySystemEmailCode.trim());

	pma.save(ps);
	
	
	response.sendRedirect("steupEmail.jsp?m=1");
%>	