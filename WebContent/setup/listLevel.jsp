<%@ page language="java"  import="web.*,jsf.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
	JsfAdmin ja=JsfAdmin.getInstance();
	
	Level[] ra=ja.getAllLevel();
	
%>
<br>
<br>
<blockquote>
<form action=addLevel2.jsp method=post>

<img src="pic/add.gif" border=0>新增年級:<input type=text name="dName" size=20>
<input type=submit value="新增" onClick="return(confirm('確認新增?'))">
</form>
</blockquote>
<br>

<b>&nbsp;&nbsp;&nbsp;<img src="pic/fix.gif" border=0>年級列表</b>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<%	
	
	
	if(ra==null)
	{
		out.println("尚無資料");
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
	<td> 狀態
	</td>
	<td>
	</td>
	</tr>
	

<%	
	for(int i=0;i<ra.length;i++)
	{
%> 

<form action="modifyLevel.jsp" method="post">

	<tr bgcolor=#ffffff class=es02>
		<td>
		<input type="text" name="levelName" value="<%=ra[i].getLevelName()%>">
		</td>
		<td> 
			 <input type=radio name="levelActive" value=1 <%=(ra[i].getLevelActive()==1)?"checked":""%>>使用中
			<input type=radio name="levelActive" value=0 <%=(ra[i].getLevelActive()==0)?"checked":""%>>停用

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
<!--- end 表單01 --->



<!--- end 主內容 --->

