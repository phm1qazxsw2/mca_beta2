<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file='/WEB-INF/jsp/security.jsp'%>
<html>
<%

 User ud2 = WebSecurity.getInstance(pageContext).getCurrentUser();
 PaySystemMgr pmx2=PaySystemMgr.getInstance();
 PaySystem pd2=(PaySystem)pmx2.find(1);
 if(ud2==null)
  {
  %>
  	<%@ include file="noUser.jsp"%>
<% 
  	return;
  } 
	if(ud2.getUserRole()>2) 
	{ 
%> 
		權限不足	
	
<% 
		return;
	}
%>
<head>
<title><%=pd2.getPaySystemCompanyName()%> 財務報表</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta http-equiv="imagetoolbar" content="no">
<link href=ft02.css rel=stylesheet type=text/css>
<script type="text/javascript" src="openWindow.js"></script>
</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<table bgcolor=#ff0000 background=pic/bg01.gif width="100%" height="9" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td class=es02><img src=pic/bg01.gif border=0></td>
</tr>
</table>
<%
String syear=request.getParameter("year");
String smonth=request.getParameter("month");
	
%>

<!--- start 水平列書籤式按鈕 01 --->
<table bgcolor=#696A6E width="100%" height="24" border="0" cellpadding="4" cellspacing="0">
<tr align=left valign=middle>
<td class=es02r align=right><%=syear%>-<%=smonth%> <%=pd2.getPaySystemCompanyName()%> 財務報表</td>
</tr>
</table>
 
<br> 


<!--- end 水平列書籤式按鈕 01 --->