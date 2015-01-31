<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<% if (pZ2.getPagetype()==7) { %>
    <%@ include file="mca_leftMenu1.jsp"%><%    
   }
   else { // ####### add by peter 2009/3/10 
%>
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
<a href="billoverview.jsp" class=an01>帳單總覽</a></td>
</tr>
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
<td width="131" class=es02r><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="billrecord_chart.jsp" class=an01>報表中心</a></td>
</tr>



<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>


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

<tr align=left valign=middle>
<td bgcolor=#919193 width="131" height="18" background=pic/left02.gif><img src=pic/dot01.gif border=0 align=absmiddle></td>
</tr>


<% if (pZ2.getWorkflow()==PaySystem2.WORKFLOW_NEIL) { %>
<tr align=left valign=middle>
<td bgcolor=#696a6e width="131" background=pic/left01.gif class=es02r>
<img src=pic/arrow02<%=(leftMenu==4)?"r":""%>.gif border=0 align=absmiddle><font color=white>派遣管理</font></td>
</tr>



<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>
<tr align=left valign=middle>
<td width="131" class=es02r><img src=pic/arrow01.gif border=0 align=absmiddle>
<!--<a href="outsourcing_overview.jsp" class=an01>派遣記錄</a>-->
<a href="outsourcing2.jsp" class=an01>帳單管理</a>
</td>
</tr>


<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<!--
<tr align=left valign=middle>
<td width="131" class=es02r><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="outsourcing_query.jsp" class=an01>查　　詢</a></td>
</tr>


<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>
-->
<tr align=left valign=middle>
<td bgcolor=#919193 width="131" height="18" background=pic/left02.gif><img src=pic/dot01.gif border=0 align=absmiddle></td>
</tr>
<% }  %>



<%
    }
    
    if(checkAuth(ud2,authHa,105))
    {
%>
<tr align=left valign=middle>
<td bgcolor=#696a6e width="131" background=pic/left01.gif class=es02r>
<img src=pic/arrow02<%=(leftMenu==3)?"r":""%>.gif border=0 align=absmiddle><font color=white>相關設定</font></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02<%=(leftMenu==3)?"r":""%>.gif><img src="pic/h02<%=(leftMenu==3)?"r":""%>.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<!--
<tr align=left valign=middle>
<td width="131" class=es02><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="listStuIncomeItem.jsp" class=an01>收入統計項目</a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>
-->

<tr align=left valign=middle>
<td width="131" class=es02><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="listDiscountType.jsp" class=an01>管理折扣項目 </a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<tr align=left valign=middle>
<td width="131" class=es02><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="list_item_alias.jsp" class=an01>管理收費統稱 </a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

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

<% } // 對應最開始的 // if (pZ2.getPagetype()) .. %>