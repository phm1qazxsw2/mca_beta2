<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTopAdvanced.jsp"%>
<%
        request.setCharacterEncoding("UTF-8");
		String rName=request.getParameter("rName");
		int rRelation=Integer.parseInt(request.getParameter("rRelation")); 	
		int studentId=Integer.parseInt(request.getParameter("studentId")); 	
		String rPhone=request.getParameter("rPhone");
		String rPhone2=request.getParameter("rPhone2");
		String rMobile=request.getParameter("rMobile");
		String rPs=request.getParameter("rPs");
		
		ContactMgr rm=ContactMgr.getInstance();
		Contact re=new Contact();
		re.setContactStuId   	(studentId);
		re.setContactName   	(rName);
		re.setContactReleationId   	(rRelation);
		re.setContactPhone1   	(rPhone);
		re.setContactPhone2   	(rPhone2);
		re.setContactMobile   	(rMobile);
		re.setContactPs   	(rPs);
		rm.createWithIdReturned(re);

        response.sendRedirect("studentContact.jsp?studentId="+studentId);
%> 





