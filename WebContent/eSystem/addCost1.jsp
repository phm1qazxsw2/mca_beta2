﻿<%@ page language="java"  import="web.*,jsf.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=7;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%

JsfAdmin ja=JsfAdmin.getInstance();

BigItem[] bi=ja.getAllActiveBigItem();

if(bi==null)
{
	out.println("尚未設定主項目!!");
	return;
}
%>

<h3>支出登入</h3>


  主項目:
  <form action=addCost2.jsp method=post>
  
  <%
  	for(int i=0;i<bi.length;i++)
  	{
  %>
  	<input type=radio name=bigItem value=<%=bi[i].getId()%>><%=bi[i].getBigItemName()%> <br>  
  <%
  	}
  %>	
  <br>
  <input type=submit value="下一步">
  </form>
  
  <br>
  
 <br>
 <a href="ListBigItem.jsp" target="_blank">管理雜費支出項目 </a>

