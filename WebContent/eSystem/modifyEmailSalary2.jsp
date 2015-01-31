<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>

<%
    request.setCharacterEncoding("UTF-8");
	
int paySystemNoticeEmailType=Integer.parseInt(request.getParameter("paySystemNoticeEmailType")); 
	String paySystemNoticeEmailTitle=request.getParameter("paySystemNoticeEmailTitle");
	String paySystemNoticeEmailText=request.getParameter("paySystemNoticeEmailText");

    EsystemMgr em=EsystemMgr.getInstance();
    Esystem e=(Esystem)em.find(1);
    
    
    e.setEsystememailTitle(paySystemNoticeEmailTitle);
    e.setEsystemEmailContent(paySystemNoticeEmailText);
    e.setEsystemEmailType(paySystemNoticeEmailType);
    em.save(e);

	response.sendRedirect("modifyEmailSalary.jsp?m=y");
%>

