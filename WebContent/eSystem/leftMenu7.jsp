<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<!--- start 垂直列左側選單 01 --->
<table bgcolor=#8CAAED width="131" border="0" cellpadding="0" cellspacing="0">

<tr align=left valign=middle>
<td bgcolor=#696a6e width="131" background=pic/left01.gif class=es02r>
<img src=pic/arrow02.gif border=0 align=absmiddle>
<font color=white>帳務系統設定</font>
</td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02<%=(leftMenu==1)?"r":""%>.gif><img src="pic/h02<%=(leftMenu==1)?"r":""%>.gif" height=1 border=0 alt=""></td></tr></table></td></tr>
<tr align=left valign=middle>
<%
    if(ud2.getUserRole()==1)
    {
%>

<td width="131" class=es02><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="modifyPaySystem.jsp" class=an01>繳款資訊設定 </a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>
<tr align=left valign=middle>

<%
    }else if(ud2.getUserRole()>1 && ud2.getUserRole()<=3){
%>
<td width="131" class=es02><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="modifyPaySystemX.jsp" class=an01>繳款資訊設定 </a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>
<tr align=left valign=middle>


<%
    }
%>

<tr align=left valign=middle>
<td bgcolor=#919193 width="131" height="18" background=pic/left02.gif><img src=pic/dot01.gif border=0 align=absmiddle></td>
</tr>
<%
    if(AuthAdmin.authPage(ud2,4))
    {
%>

<tr align=left valign=middle>
<td bgcolor=#696a6e width="131" background=pic/left01.gif class=es02r>
<img src=pic/arrow02.gif border=0 align=absmiddle>
<font color=white>Email 設定</font>
</td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02<%=(leftMenu==4)?"r":""%>.gif><img src="pic/h02<%=(leftMenu==4)?"r":""%>.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<tr align=left valign=middle>
<td width="131" class=es02><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="modifyPaySystemNotice.jsp" class=an01>Email 帳單設定</a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<tr align=left valign=middle>
<td width="131" class=es02><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="modifyEmailSalary.jsp" class=an01>Email 薪資條設定</a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<tr align=left valign=middle>
<td width="131" class=es02><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="steupEmail.jsp" class=an01>Email 系統設定</a></td>
</tr>


<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>


<tr align=left valign=middle>
<td bgcolor=#919193 width="131" height="18" background=pic/left02.gif><img src=pic/dot01.gif border=0 align=absmiddle></td>
</tr>

<%
    }



    if(ud2.getUserRole()!=5)
    {

%>
<tr align=left valign=middle>
<td bgcolor=#696a6e width="131" background=pic/left01.gif class=es02r>
<img src=pic/arrow02.gif border=0 align=absmiddle><font color=white>其他設定</font></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02<%=(leftMenu==2)?"r":""%>.gif><img src="pic/h02<%=(leftMenu==2)?"r":""%>.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<%
    if(AuthAdmin.authPage(ud2,4))
    {
%>

<tr align=left valign=middle>
<td width="131" class=es02><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="bunitIndex.jsp" class=an01>考勤部門設定</a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<%
        if (ud2.getId()==1) {
%>
<tr align=left valign=middle>
<td width="131" class=es02><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="companyindex.jsp" class=an01>單 位 設 定</a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>
<%
        }
%>


<tr align=left valign=middle>
<td width="131" class=es02><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="modifySystem.jsp" class=an01>資料顯示設定</a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>


<tr align=left valign=middle>
<td width="131" class=es02><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="modifyMessageType.jsp" class=an01>訊息項目管理</a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<%
    }
%>


<tr align=left valign=middle>
<td bgcolor=#919193 width="131" height="18" background=pic/left02.gif><img src=pic/dot01.gif border=0 align=absmiddle></td>
</tr>


<%
    }

    /*
    ## 初始化沒產生傳票，根本是錯的, 現階段先 comment 掉，用傳票初始化好了
    if(pZ2.getVersion()==1 && AuthAdmin.authPage(ud2,3))
    {
%>
<tr align=left valign=middle>
<td bgcolor=#696a6e width="131" background=pic/left01.gif class=es02r>
<img src=pic/arrow02.gif border=0 align=absmiddle><font color=white>專業版設定</font></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02<%=(leftMenu==3)?"r":""%>.gif><img src="pic/h02<%=(leftMenu==3)?"r":""%>.gif" height=1 border=0 alt=""></td></tr></table></td></tr>


<tr align=left valign=middle>
<td width="131" class=es02r><img src=pic/arrow01.gif border=0 align=absmiddle>
 <a href="initialAccount.jsp" class=an01>帳戶初始化</a> </td>
</tr>
<tr align=left valign=middle>
<td bgcolor=#919193 width="131" height="18" background=pic/left02.gif><img src=pic/dot01.gif border=0 align=absmiddle></td>
</tr>
<%
    }
    */
%>

<!--
<tr align=left valign=middle>
<td bgcolor=#696a6e width="131" background=pic/left01.gif class=es02r>
<img src=pic/arrow02.gif border=0 align=absmiddle><font color=white>組織管理</font></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<tr align=left valign=middle>
<td width="131" class=es02r><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="listDepart.jsp" class=an01>部門</a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<tr align=left valign=middle>
<td width="131" class=es02r><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="listClass.jsp" class=an01>班級</a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<tr align=left valign=middle>
<td width="131" class=es02r><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="listLevel.jsp" class=an01>年級</a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>


<tr align=left valign=middle>
<td bgcolor=#919193 width="131" height="18" background=pic/left02.gif><img src=pic/dot01.gif border=0 align=absmiddle></td>
</tr>
-->


</table>
<!--- end 垂直列左側選單 01 --->


</td>
<td height=430>