<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=7;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%
    request.setCharacterEncoding("UTF-8");
	int baId=Integer.parseInt(request.getParameter("baId"));
	int userId=Integer.parseInt(request.getParameter("userId"));		

	SalarybankAuthMgr sam=SalarybankAuthMgr.getInstance();	
	JsfPay jp=JsfPay.getInstance();	
	if(jp.getSalarybankAuthByBankIdUserId(baId,userId))
	{	
        SalarybankAuth sa=new SalarybankAuth();	
        sa.setSalarybankAuthId   	(baId);
        sa.setSalarybankAuthUserID   	(userId);
        sa.setSalarybankAuthActive   	(1);
        sa.setSalarybankLoginId(ud2.getId());
        sam.createWithIdReturned(sa);
    	response.sendRedirect("addSalarybankAuth.jsp?baId="+baId);	
	}
    else{	
    	response.sendRedirect("addSalarybankAuth.jsp?baId="+baId);
	}	
%>