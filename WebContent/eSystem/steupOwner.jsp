<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=11;
    int leftMenu=3;
%>
<%@ include file="topMenu.jsp"%>
<%
    if(!checkAuth(ud2,authHa,403))
    {
        response.sendRedirect("authIndex.jsp?code=403");
    }
%>
<%@ include file="leftMenu11.jsp"%>
<br>
<br>
<div class=es02>
<b>&nbsp;&nbsp;<img src="pic/add.gif" border=0>&nbsp;新增股東</b>
</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<blockquote>
<form action="addOnwer.jsp" method="post">
	
	<table width="" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">
	
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#ffffff align=left valign=middle>
			<td bgcolor=#f0f0f0 class=es02>股東名稱:</tD>
			<td class=es02><input type=text name="ownerName" size=20></td>
		</tr>
		<tr bgcolor=#ffffff align=left valign=middle>
			<td bgcolor=#f0f0f0 class=es02>備註:</tD>
			<td class=es02><textarea rows=2 cols=30 name="ps"></textarea>
 		</td>
	 	</tr>
	 	<tr>
	 		<td colspan=2 align=center>
	 		<input type=submit value="新增" onClick="return(confirm('確認新增?'))">
	 	</tD>
		</tr>
	</table>	
	</tD>
	</tr>
	</table>
</form>
</blockquote>





<%
	JsfPay jp=JsfPay.getInstance();
	
	Owner[] ow=jp.getAllOwner(_ws.getBunitSpace("bunitId"));
	
%>
	<div align=left class=es02><b>&nbsp;&nbsp;&nbsp;<img src="pic/fix.gif" border=0>股東列表</b>共計 :<font color=blue><%=(ow==null)?"0":ow.length%></font>筆 </div>


<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<% 
	if(ow==null)
 
	{ 
		out.println("尚未設定");	 
		return;
	} 
%>
<br>

<blockquote>
<table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">


<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 align=left valign=middle class=es02>
		<td>名稱</td> <td>狀態</td><td>備註</tD><td></tD>
	</tr>
	<%
		for(int i=0;i<ow.length;i++) 
		{ 
	%> 
		<form action="modifyOwner.jsp" method="post">
		<tr bgcolor=#ffffff align=left valign=middle class=es02>

			<td><input type=text name="ownerName" value="<%=ow[i].getOwnerName()%>"></td>
	 		<td>
	 			<input type=radio name="status" value=1 <%=(ow[i].getOwnerStatus()==1)?"checked":""%>>使用中 
	 			<input type=radio name="status" value=0 <%=(ow[i].getOwnerStatus()==0)?"checked":""%>>停用	
	 		</td>
	 		<td>
	 			<textarea name="ps" rows=2 cols=25><%=ow[i].getOwnerPs()%></textarea> 
	 		</tD>
	 		<td>
	 			<input type=hidden name="ownerId" value="<%=ow[i].getId()%>">
	 			<input type=submit value="修改"  onClick="return(confirm('確認修改?'))">
	 		</tD>
		</tr> 
		</form>
	<%
		}
	%>
	</table>
	</td>
	</tR>
	</table>		
</blockquote>
<%@ include file="bottom.jsp"%>