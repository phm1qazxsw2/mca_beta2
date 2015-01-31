<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTopAdvanced.jsp"%>

<%
	
	int contactId=Integer.parseInt(request.getParameter("contactId"));
	ContactMgr cfm=ContactMgr.getInstance();

    Contact re=(Contact)cfm.find(contactId);
	cfm.remove(contactId);

    response.sendRedirect("studentContact.jsp?studentId="+re.getContactStuId());
%>
