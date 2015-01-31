<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css"> 
<head>
<link rel="stylesheet" href="style.css" type="text/css">
 
<%
 PaySystemMgr pmx2=PaySystemMgr.getInstance();
 PaySystem pd2=(PaySystem)pmx2.find(1);


%>
<SCRIPT LANGUAGE="JavaScript">

<!-- This script and many more are available free online at -->
<!-- The JavaScript Source!! http://javascript.internet.com -->
<!-- Original:  nprakaz@rediffmail.com -->
<!-- Web Site:  http://www20.brinkster.com/mahathmaonline -->

<!-- Begin
function addbookmark()
{
bookmarkurl="http://www.phm.com.tw"
bookmarktitle=" 必亨得意算財務系統"
if (document.all)
window.external.AddFavorite(bookmarkurl,bookmarktitle)
}
//  End -->
</script>

</head>

<script type="text/javascript" src="openWindow.js"></script>

<br>
<br>
<font color=red>認證失敗!!
 </font>
<table width="60%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#ffffff align=left valign=middle>
		<td bgcolor=#f0f0f0 class=es02>授權使用機構</td>
		<td class=es02>
		
		<%=pd2.getPaySystemCompanyName()%>
		
		<b></b></td>
	
	</tr>
	
	<tr bgcolor=#ffffff align=left valign=middle>
		<td class=es02 colspan=2 align=middle> 
			<a href="#" onClick="javascript:openwindow60();return false">更新授權碼</a> |   
		使用手冊 | 服務資訊
		
</td>
	</tr>
	
	

	</table>
	
</td></tr></table>	

