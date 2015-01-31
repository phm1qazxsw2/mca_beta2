<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<!--- start 垂直列左側選單 01 --->
<table bgcolor=#8CAAED width="131" border="0" cellpadding="0" cellspacing="0">

<tr align=left valign=middle>
<td bgcolor=#696a6e width="131" background=pic/left01.gif class=es02r>
<img src=pic/arrow02<%=(leftMenu==1)?"r":""%>.gif border=0 align=absmiddle>
<font color=white>帳單設定</font>

</td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02<%=(leftMenu==1)?"r":""%>.gif><img src="pic/h02<%=(leftMenu==1)?"r":""%>.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<tr align=left valign=middle>
<td width="131" class=es02r>
<img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="mca_fee_list.jsp" class=an01>帳單總覽</a></td>
<%
    if(checkAuth(ud2,authHa,101))
    {
%>
    <tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

    <tr align=left valign=middle>
    <td width="131" class=es02r>
    <img src=pic/arrow01.gif border=0 align=absmiddle>
    <a href="searchbillrecord.jsp" class=an01>帳單查詢</a></td>
    </tr>
<%
    }
%>

<tr align=left valign=middle>
<td bgcolor=#919193 width="131" height="18" background=pic/left02.gif><img src=pic/dot01.gif border=0 align=absmiddle></td>
</tr>

<%
    if(checkAuth(ud2,authHa,104))
    {
%>

<tr align=left valign=middle>
<td bgcolor=#696a6e width="131" background=pic/left01.gif class=es02r>
<img src=pic/arrow02<%=(leftMenu==2)?"r":""%>.gif border=0 align=absmiddle><font color=white>帳務管理</font></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02<%=(leftMenu==2)?"r":""%>.gif><img src="pic/h02<%=(leftMenu==2)?"r":""%>.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<tr align=left valign=middle>
<td width="131" class=es02><img src=pic/arrow01.gif border=0 align=absmiddle>
	<a href="query_pay_info.jsp?ago=1" class=an01>收款查詢</a>
</td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

</tr>
<tr align=left valign=middle>
<td width="131" class=es02><img src=pic/arrow01.gif border=0 align=absmiddle>
	<a href="query_overpay.jsp" class=an01>溢繳查詢</a>
</td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

</tr>
<tr align=left valign=middle>
<td width="131" class=es02><img src=pic/arrow01.gif border=0 align=absmiddle>
	<a href="query_unpaid.jsp" class=an01>未繳查詢</a>
</td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

</tr>
<tr align=left valign=middle>
<td width="131" class=es02><img src=pic/arrow01.gif border=0 align=absmiddle>
	<a href="mca_coop.jsp" class=an01>合庫銷帳</a>
</td>
</tr>

    <% if (ud2.getUserRole()<=3) { %>
<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

</tr>
<tr align=left valign=middle>
<td width="131" class=es02><img src=pic/arrow01.gif border=0 align=absmiddle>
	<a href="mca_exrate.jsp" class=an01>匯　　率</a>
</td>
</tr>
    <% } %>

<tr align=left valign=middle>
<td bgcolor=#919193 width="131" height="18" background=pic/left02.gif><img src=pic/dot01.gif border=0 align=absmiddle></td>
</tr>

<%
    }
%>    
</table>
<!--- end 垂直列左側選單 01 --->


</td>
<td height=430>