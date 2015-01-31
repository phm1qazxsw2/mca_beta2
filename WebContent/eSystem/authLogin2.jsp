<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>

<%
	request.setCharacterEncoding("UTF-8");
 	int codeType=Integer.parseInt(request.getParameter("codeType"));
	String code=request.getParameter("code");
	
	AuthSystem as=new AuthSystem();
	as.setAuthSystemCode(code); 
	as.setAuthSystemType(codeType);
	
	JsfAuth ja=JsfAuth.getInstance();
	
	if(ja.setAuthSystemData(as))
	{
%>		
<%@ include file="jumpTopNotLogin.jsp"%>
<blockquote>
<b><<<必亨得意算財務系統-授權中心>>></b>
	
	<br>
	<blockquote>

		<font color=blue>新增完成!!</a>
		
		<br>
		<br>
		<a href="authLogin.jsp">繼續登入</a>
	<blockquote>
		
<%
	}
%>	