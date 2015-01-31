<%@ page language="java" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%><%

    try
    {
		
		String typeS=request.getParameter("x");
		String classIdS=request.getParameter("y"); 
		String groupS=request.getParameter("z");
 

		
		JsfPay jp=JsfPay.getInstance();
		
		String outWord=jp.getMessageList(Integer.parseInt(typeS),Integer.parseInt(classIdS),Integer.parseInt(groupS));
		
		out.println(outWord);

	}catch(Exception ex){
	
		out.println("error");
	}
%>