<%@ page language="java"  import="web.*,jsf.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<link rel="stylesheet" href="style.css" type="text/css"> 
<br>
<br> 
<b>&nbsp;&nbsp;<img src="pic/add.gif" border=0>新增班級</b>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<blockquote>
<form action="addClass2.jsp" method=post>
<table width="320" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td class=es02 class=es02 bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>

	
	<tr bgcolor=#ffffff align=left valign=middle>

	<td bgcolor=#f0f0f0 class=es02>班級名稱</td>
	<td class=es02><input type=text name=className></td>
	</tr>
	
	<tr bgcolor=#ffffff align=left valign=middle>
	<td bgcolor=#f0f0f0 class=es02>班級英文名稱</td>
	<td class=es02><input type=text name=classEName></td>
	</tr> 
	
	<tr bgcolor=#ffffff align=left valign=middle>
		<td bgcolor=#f0f0f0 class=es02>滿額數</td>
		<td class=es02><input type=text name=allPeople value="10" size=4></td>
	</tr>

	<tr>
		<td colspan=2><center>
	<input type=submit value="增加班級">
	
		</center>
		</td>
	</tr>
</table> 

</td>
	</tr>
</table>
</form>	

</blockquote>
