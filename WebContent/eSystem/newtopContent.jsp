<%@ page language="java" contentType="text/html;charset=UTF-8"%>

<link rel="stylesheet" href="css/dhtmlwindow.css" type="text/css" />



<table bgcolor=#ff0000 background=pic/bg01.gif width="100%" height="9" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td><img src=pic/bg01.gif border=0></td>
</tr>
</table>


<!--- start 水平列書籤式按鈕 01 --->
<table bgcolor=#696A6E width="100%" height="24" border="0" cellpadding="0" cellspacing="0">
<tr align=center valign=middle>

<td><img src=pic/dot01.gif width=30 height=24 border=0></td>

<td class=es02 nowrap><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="billoverview.jsp" class=an01>
<font color=ffffff><b>首 頁</b></font></a>&nbsp;&nbsp;&nbsp;
</td>

<td><img src=pic/vline01.gif vspace=0 hspace=8 border=0></td>



<td class=es02 nowrap>&nbsp;<img src="img/dot.png" border=0>
<a href="billoverview.jsp" class=an01>
<font color=ffffff><b>會員系統</b></font></a>
</td>

<td><img src=pic/vline01.gif vspace=0 hspace=8 border=0></td>

<td class=es02 nowrap><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="billoverview.jsp" class=an01>
<font color=ffffff><b>帳單編輯</b></font></a>
</td>


<td><img src=pic/vline01.gif vspace=0 hspace=8 border=0></td>
<td class=es02 nowrap><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="incomeIndex.jsp" class=an01><font color=white><b>繳費收據</b></font></a></td>


<td><img src=pic/vline01.gif vspace=0 hspace=8 border=0></td>

<td class=es02 nowrap><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="salaryoverview.jsp" class=an01><font color=white><b>銷帳作業</b></font></a></td>

<td><img src=pic/vline01.gif vspace=0 hspace=8 border=0></td>




<td class=es02 nowrap><img src=pic/arrow01.gif border=0 align=absmiddle>

<a href="freportIndex.jsp" class=an01><font color=white><b>報表統計</b></font></a></td>
<td><img src=pic/vline01.gif vspace=0 hspace=8 border=0></td>


<td class=es02 nowrap><img src=pic/arrow01.gif border=0 align=absmiddle>

<%
    if(AuthAdmin.authPage(ud2,4))
    {   
%>
<a href="logoutRedirect.jsp" class=an01><font color=white><b>登　出</b></font></a>
<%
    }else{
%>
<a href="logout.jsp" class=an01><font color=white><b>登　出</b></font></a>
<%
    }
%>
</td>

<td width="100%"><img src=pic/dot01.gif width=80 height=24 border=0></td>
</tr>
</table>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td width="131">
<br>
