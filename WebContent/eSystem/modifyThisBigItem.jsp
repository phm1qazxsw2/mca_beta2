<%@ page language="java" import="web.*,jsf.*,java.util.*,java.text.*,java.io.*" contentType="text/html;charset=UTF-8"%>
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
  
  	String bidS=request.getParameter("bid");
	int bid=Integer.parseInt(bidS.trim());
%>	
<head>
<title><%=pd2.getPaySystemCompanyName()%></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta http-equiv="imagetoolbar" content="no">
<link href=ft02.css rel=stylesheet type=text/css>
 
<link rel="stylesheet" href="style.css" type="text/css">
<script type="text/javascript" src="openWindow.js"></script> 
<script>
	
	function goX(bid) 
	{ 
		var wo=window.opener;
		
		wo.getIncomeSmallItem2(bid);	
	} 

</script>

</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onunload="javascript:goX(<%=bid%>)">

<table bgcolor=#ff0000 background=pic/bg01.gif width="100%" height="9" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td class=es02><img src=pic/bg01.gif border=0></td>
</tr>
</table>


<!--- start 水平列書籤式按鈕 01 --->
<table bgcolor=#696A6E width="100%" height="24" border="0" cellpadding="4" cellspacing="0">
<tr align=left valign=middle>
<td class=es02r align=right><%=pd2.getPaySystemCompanyName()%></td>
</tr>
</table>

<br> 
 
<br>


<%
	String m=request.getParameter("m");
	
	if(m !=null)	
	{
%>
	<script>
		alert('修改完成!');
	</script>
<%
	}

	JsfAdmin ad=JsfAdmin.getInstance();

	BigItemMgr  bim=BigItemMgr.getInstance();
	
	BigItem bi=(BigItem)bim.find(bid);
	
	if(bi ==null)
	{
		out.println("沒有資料");
  		return;
 	} 
	
	
	
%>	
	
<b>&nbsp;&nbsp;&nbsp;<%=bi.getBigItemName()%>編輯</b>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<center> 

<table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#f0f0f0 class=es02>				
			<tD>次科目</td>
			<td>狀態</td>
			<td></td>
		</tR>
<%

SmallItem[] si=ad.getAllSmallItemByBID(bi.getId());	

	if(si !=null)
	{
		for(int j=0;j<si.length;j++)
		{
			String isiName=si[j].getSmallItemName();
			int isiActive=si[j].getSmallItemActive();
			
%>
			<tr bgcolor=#ffffff class=es02>
			<td>
			<form action="modifySmallItem3.jsp" method="post">
			<b><%=si[j].getId()%></b> - <input type=text name="isiName" size=15 value="<%=isiName%>">
			</td>
 
			
			<td>
 	
				<input type=radio name="isiActive" value=1 <%=(isiActive==1)?"checked":""%>>運作中
				<input type=radio name="isiActive" value=0 <%=(isiActive==0)?"checked":""%>>取消
				
			</td> 
			<td> 
				<input type=hidden name="sid" value="<%=si[j].getId()%>"> 
				<input type=hidden name="xPage" value="x">
				<input type=submit onClick="return(confirm('確認修改 <%=isiName%>的名稱及狀態?'))" value="修改">
				</form>
			</td>
			</tr>
<%		
		
		}	
	}
%>
	<tr bgcolor=ffffff>
	<td colspan=3>
	<form action="addSmallItem2.jsp" method="post"> 
	<img src="pic/add.gif" border=0>新增次項目:<input type=text name="isiName" value="">
	<input type="hidden" name="bigItemId" value="<%=bi.getId()%>"> 
	<input type=hidden name="xPage" value="x">
	<input type=submit onClick="return(confirm('確認新增<%=bi.getBigItemName()%>的次項目?'))" value="新增">
	</form>
	</td>
 
	</tr>
</table>
	</td>
	</tr>
	</table>

</center>	