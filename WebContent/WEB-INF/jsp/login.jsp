<%@ page import="jsf.*" contentType="text/html;charset=UTF-8"%>

<head>
<%
 PaySystemMgr pmx2=PaySystemMgr.getInstance();
 PaySystem pd2=(PaySystem)pmx2.find(1);
 if(pd2 ==null) 
 { 
	out.println("<blockquote>尚未初始化</blockquote>");
	return;
 }
%>
<title><%=pd2.getPaySystemCompanyName()%></title>
<link rel="shortcut icon" href="favicon.ico" />
<link rel="stylesheet" href="css/dhtmlwindow.css" type="text/css" />
<link rel="stylesheet" href="style.css" type="text/css"> 

<SCRIPT LANGUAGE="JavaScript">

<!-- This script and many more are available free online at -->
<!-- The JavaScript Source!! http://javascript.internet.com -->
<!-- Original:  nprakaz@rediffmail.com -->
<!-- Web Site:  http://www20.brinkster.com/mahathmaonline -->

<!-- Begin
function addbookmark()
{
bookmarkurl="http://www.easycounting.cc"
bookmarktitle=" 必亨得意算財務系統"
if (document.all)
window.external.AddFavorite(bookmarkurl,bookmarktitle)
}
//  End -->
</script>

<script>
function sch_qa(r)
{
    window.open('http://218.32.77.178/smsserver/qa/show_topic.jsp?r='+r,'問與答','width=500,height=400,scrollbars=yes,resizable=yes');
}
</script>

</head>
<body background="images/bg.gif">
<% 
try{


    WebSecurity ws = WebSecurity.getInstance(pageContext);
    String destURI = ws.getGotoUri();
    
    /*
    //http://60.251.12.21
    String scheme = request.getScheme();
    String serverName = request.getServerName();
    // 彰化沒法連 secure.easycounting.cc
    if (scheme.equals("http") && serverName.equals("218.32.77.178") && destURI.indexOf("jsfch")<0) {
        %><script>location.href="https://secure.easycounting.cc<%=destURI%>";</script><%
        return;
    }    
    */

    String err = ws.getErrorMessage();
    if (err!=null)
        out.println("<font color=red><b>" + err + "</b></font><p>");
%>
<script type="text/javascript" src="openWindow.js"></script>
<table border="0" cellpadding="0" cellspacing="0">
<tr class=es02>
	<td width=370 height=510 valign=bottom align=left>
            <img src="pic/GT_seal_1all.gif" border=0></a>
            <br>
  
	</td>
	<td valign=middle> 
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
<b><%=pd2.getPaySystemCompanyName()%></b>
<form action='<%=destURI%>' method='POST'>
<input type=hidden name="<%=ws.getDoLoginSubmitName()%>" value="admin">
<img src="pic/userOut.gif" border=0>使用者帳號:
<br>
<input name='<%=ws.getLoginIdElementName()%>'><br>
密碼:
<br>
<input type=password name='<%=ws.getPasswordElementName()%>' value="">
<p>
<input type="submit" value="登入">
</form>
<br>

<%
//    if(pd2.getEventAuto()==1){
%>
    <div class=es02>
    <a href="javascript:openwindow_phm('loginEvent.jsp', '線上考勤系統', 800, 600, false);"><img src="images/rfidx.png" border=0>&nbsp;線上考勤系統</a>
    </div>
<%
//    }
%>
<!--

<font sise=2> <a href="javascript:addbookmark()">加入我的最愛</a> </font>-->


</td> 
<td width=430 valign=bottom align=right>
<!--
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
		<td bgcolor=#f0f0f0 class=es02>版本代號</td>
		<td class=es02>
        <%  if (pd2.getVersion()==0) {  %>
                得意算財務系統 標準版
        <%  }else{  %>
                得意算財務系統 專業版
        <%  }   %>

        </td>
	</tr>  
</table>
</td></tr></table>	
-->
<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
<tr>
    <td>
    <br>
<div class=es02 align=left>系統升級公告:</div>

    <table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>


    </td>
</tr>
<tr>    
    <td>   
        <iframe src ="https://secure.easycounting.cc/internal/eSystem/news.jsp" marginwidth="0" marginheight="0" frameborder="0" allowtransparency="true" width="100%" height="150" class=es02>
          <p>Your browser does not support iframes.</p>
        </iframe>
</td>
</tr>
</table>    


<%
}
catch(Exception e) 
{ 
%>
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
<%
}
%>

</td>
</tr>
<tr>
	<td colspan=3 align=middle class=es02>
        <br>
		Copyright © 2009 必亨商業軟體股份有限公司 PHM  Business Software Corp. All rights reserved. Tel: +886-2-23693566  Fax: +886-2-23693569</td>
</tr>
</table>
</body>