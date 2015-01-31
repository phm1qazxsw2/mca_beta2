<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>

<%
    request.setCharacterEncoding("UTF-8");
	
int paySystemNoticeEmailTo=Integer.parseInt(request.getParameter("paySystemNoticeEmailTo")); 
	int paySystemNoticeEmailType=Integer.parseInt(request.getParameter("paySystemNoticeEmailType")); 
	String paySystemNoticeEmailText=request.getParameter("paySystemNoticeEmailText");
	int paySystemNoticeMessageTo=Integer.parseInt(request.getParameter("paySystemNoticeMessageTo")); 
	String paySystemNoticeMessageTest=request.getParameter("paySystemNoticeMessageTest");
	String paySystemNoticeEmailTitle=request.getParameter("paySystemNoticeEmailTitle");


	PaySystemMgr pma=PaySystemMgr.getInstance();
	PaySystem ps=(PaySystem)pma.find(1);

	ps.setPaySystemNoticeEmailTo   	(paySystemNoticeEmailTo);

	ps.setPaySystemNoticeEmailType   	(paySystemNoticeEmailType);
	ps.setPaySystemNoticeEmailText   	(paySystemNoticeEmailText.trim());
	ps.setPaySystemNoticeMessageTo   	(paySystemNoticeMessageTo);
	ps.setPaySystemNoticeMessageTest(paySystemNoticeMessageTest.trim());  
	ps.setPaySystemNoticeEmailTitle(paySystemNoticeEmailTitle.trim());

	pma.save(ps);

	
    int frompage=Integer.parseInt(request.getParameter("frompage")); 

    if(frompage==0)
    	response.sendRedirect("modifyPaySystemNotice.jsp?m=y");
    else
    	response.sendRedirect("email_bill_notice.jsp?pagex=1&m=y");    
%>

