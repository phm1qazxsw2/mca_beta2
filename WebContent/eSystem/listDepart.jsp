﻿<%@ page language="java"  import="web.*,jsf.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=7;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%
    if(!AuthAdmin.authPage(ud2,4))
    {
        response.sendRedirect("authIndex.jsp?info=1&page=1");
    }
%>
<%@ include file="leftMenu7.jsp"%>
<%

    
	JsfAdmin ja=JsfAdmin.getInstance();
	
	Depart[] ra=ja.getAllDepart();
	
%>

<br>

<b>&nbsp;&nbsp;&nbsp;<img src="pic/add.gif" border=0>新增部門</b>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<blockquote>

<form action=addDepart2.jsp method=post>

部門名稱:<input type=text name="dName" size=20>

<input type=submit value="新增">

</form>
</blockquote>

<br>
<br>

<b>&nbsp;&nbsp;&nbsp;<img src="pic/fix.gif" border=0>部門列表</b>
<br>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<%	
	
	
	if(ra==null)
	{
		out.println("<br><blockquote>尚無資料</blockquote>"); 
%>
		<%@ include file="bottom.jsp"%>	
<%
		return;
	}
%> 

<blockquote>
<table width="50%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#f0f0f0 class=es02>
			<td>
				名稱
			</td>
			<td> 
				狀態
			</td>
			<td>
			</td>
		</tr>
	

<%	
	for(int i=0;i<ra.length;i++)
	{
%> 
<form action="modifyDepart.jsp" method="post">

<tr bgcolor=ffffff border=0>
		<td>
		<input type=text name="departName" value="<%=ra[i].getDepartName()%>">
		</td>
		<td>
			<input type=radio name="departActive" value=1 <%=(ra[i].getDepartActive()==1)?"checked":""%>>使用中
			<input type=radio name="departActive" value=0 <%=(ra[i].getDepartActive()==0)?"checked":""%>>停用

		</td>
		<td> 
			<input type=hidden name="rId" value="<%=ra[i].getId()%>">
			<input type=submit value="修改" onClick="return(confirm('確認修改?'))">
			
		</td>		
	</tr>
	</form>
<%		
	}
%>
</table>
</td></tr></table>

</blockquote>
<%@ include file="bottom.jsp"%>	