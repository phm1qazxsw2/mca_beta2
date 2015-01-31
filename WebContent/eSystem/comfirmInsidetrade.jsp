<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">


<%
	int itId= Integer.parseInt(request.getParameter("itId"));
	int inVstatus= Integer.parseInt(request.getParameter("inVstatus"));
	
	String vstatus=request.getParameter("vstatus");
	String showType=request.getParameter("showType");
	String orderId=request.getParameter("orderId");



	InsidetradeMgr im=InsidetradeMgr.getInstance();
	Insidetrade in=(Insidetrade)im.find(itId);
	  
	JsfPay jp=JsfPay.getInstance();  
    User ud2 = WebSecurity.getInstance(pageContext).getCurrentUser();
	if(jp.isAuthorAccount(ud2,in.getInsidetradeToType(),in.getInsidetradeToId()))
	{ 	
		in.setInsidetradeCheckLog(inVstatus); 
		in.setInsidetradeCheckUserId(ud2.getId()); 
		in.setInsidetradeCheckDate(new Date());		

		im.save(in); 
		
		if(vstatus!=null) 
		{ 
			response.sendRedirect("listInsidetrade.jsp?vstatus="+vstatus+"&showType="+showType+"&orderId="+orderId);
		}else{
			response.sendRedirect("listInsidetrade.jsp");
		}	
	} else{ 
		
		out.println("沒有修改權限");
		return;
	}
%>