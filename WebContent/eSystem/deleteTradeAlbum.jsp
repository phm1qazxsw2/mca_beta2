<%@ page language="java"  import="jsf.*,jsi.*,java.util.*,java.text.*,web.*" contentType="text/html;charset=UTF-8"%>
<%@page import="java.io.*" %>
<%@page import="java.util.*" %>
<%
	String ctId=request.getParameter("ctId");
	
	String filePath2 = request.getRealPath("./")+"accountAlbum/"+ctId;
	File FileDic2 = new File(filePath2);
	File files2[]=FileDic2.listFiles();
	
	File xF2=null; 
	
	if(files2 !=null)
	{ 
		for(int j2=0;j2<files2.length;j2++)
		{ 
			if(!files2[j2].isHidden())
				files2[j2].delete();
		} 
	}

	response.sendRedirect("listTradeaccount.jsp");
%>

