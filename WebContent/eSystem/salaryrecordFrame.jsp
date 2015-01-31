<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*,java.net.*,java.util.*" contentType="text/html;charset=UTF-8"%>
<head>
    <title>快速編輯-薪資</title>
</head>
<link href=ft02.css rel=stylesheet type=text/css> 
<%
    int frameWidth=180;
%>

<link rel="stylesheet" href="style.css" type="text/css">
<frameset cols="<%=frameWidth%>,*" frameborder="NO" border="0" framespacing="0">
  <frame src="sr_menu.jsp?frameWidth=<%=frameWidth%>&<%=request.getQueryString()%>" name="leftFrame" scrolling="AUTO" resize>
  <frame src="studentFrameStart.jsp" name="mainFrame">
</frameset>