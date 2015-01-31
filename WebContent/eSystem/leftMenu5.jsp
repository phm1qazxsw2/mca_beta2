<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<!--- start 垂直列左側選單 01 --->
<table bgcolor=#8CAAED width="131" border="0" cellpadding="0" cellspacing="0">

<!--
<tr align=left valign=middle>
<td bgcolor=#696a6e width="131" background=pic/left01.gif class=es02r>
<img src=pic/arrow02.gif border=0 align=absmiddle>
<font color=white>設定&鐘點費</font>
</td>
</tr>


<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<tr align=left valign=middle>
<td width="131" class=es02r>
<img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="listSalaryData.jsp" class=an01>薪資資料設定</a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<tr align=left valign=middle>
<td width="131" class=es02r>
<img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="modifySalary4.jsp" class=an01>鐘點費設定</a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<tr align=left valign=middle>
<td width="131" class=es02r>
<img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="modifySalaryType4Pay.jsp" class=an01>鐘點費發放</a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>


<tr align=left valign=middle>
<td bgcolor=#919193 width="131" height="18" background=pic/left02.gif><img src=pic/dot01.gif border=0 align=absmiddle></td>
</tr>


<%   
    if(AuthAdmin.authPage(ud2,3))
    {    
%>



<tr align=left valign=middle>
<td bgcolor=#696a6e width="131" background=pic/left01.gif class=es02r>
<img src=pic/arrow02.gif border=0 align=absmiddle>
<font color=white>正職員工薪資</font>
</td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<tr align=left valign=middle>
<td width="131" class=es02><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="modifySalary.jsp" class=an01>應領所得</a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<tr align=left valign=middle>
<td width="131" class=es02><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="modifySalary2.jsp" class=an01>代扣 </a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<tr align=left valign=middle>
<td width="131" class=es02><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="modifySalary3.jsp" class=an01>應扣薪資 </a></td>
</tr> 


<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>



<tr align=left valign=middle>
<td bgcolor=#919193 width="131" height="18" background=pic/left02.gif><img src=pic/dot01.gif border=0 align=absmiddle></td>
</tr>

<%
	}
%>

-->

<tr align=left valign=middle>
<td bgcolor=#696a6e width="131" background=pic/left01.gif class=es02r>
<img src=pic/arrow02<%=(leftMenu==1)?"r":""%>.gif border=0 align=absmiddle>
<font color=white>薪  &nbsp;&nbsp;資</font>
</td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02<%=(leftMenu==1)?"r":""%>.gif><img src="pic/h02<%=(leftMenu==1)?"r":""%>.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<%
    if(checkAuth(ud2,authHa,300)){
%>
<tr align=left valign=middle>
<td width="131" class=es02r>
<img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="salaryoverview.jsp" class=an01>總覽</a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<%
}

    if(checkAuth(ud2,authHa,300)){
%>

<tr align=left valign=middle>
<td width="131" class=es02r>
<img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="searchsalaryrecord.jsp" class=an01>查詢與支付</a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>
<%
    }    

    if(checkAuth(ud2,authHa,302)){
%>
<tr align=left valign=middle>
<td width="131" class=es02r>
<img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="salary_payinfo.jsp" class=an01>付款記錄</a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<%
    }

    if(checkAuth(ud2,authHa,303)){
%>

<tr align=left valign=middle>
<td width="131" class=es02r>
<img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="salaryrecord_chart.jsp" class=an01>報表中心</a></td>
</tr>


<%
    }
%>
<!--
<%
    if(AuthAdmin.authPage(ud2,3))
    {
%>
<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<tr align=left valign=middle>
<td width="131" class=es02><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="addSalaryByPerson.jsp" class=an01>個人編輯</a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<tr align=left valign=middle>
<td width="131" class=es02><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="autoSalary.jsp" class=an01>自動產生</a></td>
</tr>

<%
    }
%>
-->

<tr align=left valign=middle>
<td bgcolor=#919193 width="131" height="18" background=pic/left02.gif><img src=pic/dot01.gif border=0 align=absmiddle></td>
</tr>

<!--
<%
    if(AuthAdmin.authPage(ud2,3))
    {
%>

<tr align=left valign=middle>
<td bgcolor=#696a6e width="131" background=pic/left01.gif class=es02r>
<img src=pic/arrow02.gif border=0 align=absmiddle>
<font color=white>支付薪資</font></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<tr align=left valign=middle>
<td width="131" class=es02r>
<img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="listSalaryOut.jsp" class=an01>薪資轉帳</a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>


<tr align=left valign=middle>
<td width="131" class=es02r><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="salaryFaceByFace.jsp" class=an01>櫃臺發放</a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>


<tr align=left valign=middle>
<td bgcolor=#919193 width="131" height="18" background=pic/left02.gif><img src=pic/dot01.gif border=0 align=absmiddle></td>
</tr>

<%
	}
%>
-->

</table>
<!--- end 垂直列左側選單 01 --->


</td>
<td height=430>