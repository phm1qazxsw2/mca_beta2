<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*,java.net.*,java.util.*" contentType="text/html;charset=UTF-8"%>
<%
    PaySystem2 _p = PaySystem2Mgr.getInstance().find("id=1");
%>
<head>
    <title>快速編輯-<%=(_p.getCustomerType()==0)?"學號":"客戶"%>帳單</title>
</head>
<link href=ft02.css rel=stylesheet type=text/css> 
<%
    int frameWidth=170;
%>

<link rel="stylesheet" href="style.css" type="text/css">
<frameset cols="<%=frameWidth%>,*" frameborder="NO" border="0" framespacing="0">
  <frame src="ticketMenu.jsp?frameWidth=<%=frameWidth%>&<%=request.getQueryString()%>" name="leftFrame" scrolling="AUTO" resize>
  <frame src="studentFrameStart.jsp" name="mainFrame">
</frameset>