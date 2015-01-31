<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=8;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu8.jsp"%>
<%
 JsfAdmin ja=JsfAdmin.getInstance();
 int meId=Integer.parseInt(request.getParameter("meId"));
%>  

<br>
&nbsp;&nbsp;&nbsp;<a href="listMessage.jsp"><<回收件匣<img src="pic/message.png" border=0 alt="收件匣"></a> 

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<blockquote>
<%@ include file="messagecontent3.jsp"%>


</blockquote>
<%@ include file="bottom.jsp"%>


