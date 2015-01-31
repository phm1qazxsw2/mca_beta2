<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<!--- start 垂直列左側選單 01 --->
<table bgcolor=#8CAAED width="131" border="0" cellpadding="0" cellspacing="0">


<tr align=left valign=middle>
<td bgcolor=#696a6e width="131" background=pic/left01.gif class=es02r>
<img src=pic/arrow02<%=(leftMenu==1)?"r":""%>.gif border=0 align=absmiddle>
<font color=white><%=(pZ2.getCustomerType()==0)?"教職員":"員工"%>管理</font>
</td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02<%=(leftMenu==1)?"r":""%>.gif><img src="pic/h02<%=(leftMenu==1)?"r":""%>.gif" height=1 border=0 alt=""></td></tr></table></td></tr>
<%
    if(checkAuth(ud2,authHa,701)){
%>

<tr align=left valign=middle>
<td width="131" class=es02><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="addTeacher.jsp" class=an01>新增<%=(pZ2.getCustomerType()==0)?"教職員":"員工"%></a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<%  }

    if(checkAuth(ud2,authHa,700)){
%>

<tr align=left valign=middle>
<td width="131" class=es02><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="listTeacher.jsp" class=an01>在職<%=(pZ2.getCustomerType()==0)?"教職員":"員工"%></a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<tr align=left valign=middle>
<td width="131" class=es02><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="listLeaveTeacher.jsp" class=an01>非在職<%=(pZ2.getCustomerType()==0)?"教職員":"員工"%></a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<%
    }

    if(pZ2.getEventAuto()==1){

        if(checkAuth(ud2,authHa,702)){

%>
<tr align=left valign=middle>
<td bgcolor=#919193 width="131" height="18" background=pic/left02.gif><img src=pic/dot01.gif border=0 align=absmiddle></td>
</tr>

<script>
function sch_qa(r)
{
    window.open('http://218.32.77.178/smsserver/qa/show_topic.jsp?r='+r,'問與答','width=500,height=400,scrollbars=yes,resizable=yes');
}
</script>

<tr align=left valign=middle>
<td bgcolor=#696a6e width="131" background=pic/left01.gif class=es02r nowrap>
<img src=pic/arrow02<%=(leftMenu==3)?"r":""%>.gif border=0 align=absmiddle><font color=white>班表管理　<a href="javascript:sch_qa(2)" class=an03>Q&A</a></font></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02<%=(leftMenu==3)?"r":""%>.gif><img src="pic/h02<%=(leftMenu==3)?"r":""%>.gif" height=1 border=0 alt=""></td></tr></table></td></tr>
<tr align=left valign=middle>
<td width="131" class=es02r><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="schedule.jsp" class=an01>班表總覽</a></td>
</tr>
</tr>


<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>
<tr align=left valign=middle>
<td width="131" class=es02r><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="schedule_switch.jsp" class=an01>換班請假</a></td>
</tr>


<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>
<tr align=left valign=middle>
<td width="131" class=es02r><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="schedule_daily.jsp" class=an01>考勤日報表</a></td>
</tr>


<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>
<tr align=left valign=middle>
<td width="131" class=es02r><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="schedule_event2.jsp" class=an01>缺勤統計</a></td>
</tr>


<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>
<tr align=left valign=middle>
<td width="131" class=es02r><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="schedule_schdef_info.jsp" class=an01>出勤統計</a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<tr align=left valign=middle>
<td bgcolor=#919193 width="131" height="18" background=pic/left02.gif><img src=pic/dot01.gif border=0 align=absmiddle></td>
</tr>

<tr align=left valign=middle>
<td bgcolor=#696a6e width="131" background=pic/left01.gif class=es02r>
<img src=pic/arrow02<%=(leftMenu==4)?"r":""%>.gif border=0 align=absmiddle><font color=white>考勤相關設定</font></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02<%=(leftMenu==4)?"r":""%>.gif><img src="pic/h02<%=(leftMenu==4)?"r":""%>.gif" height=1 border=0 alt=""></td></tr></table></td></tr>


<tr align=left valign=middle>
<td width="131" class=es02r><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="listOvertime.jsp" class=an01>補休設定</a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>


<tr align=left valign=middle>
<td width="131" class=es02r><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="listYearHoliday.jsp" class=an01>年假設定</a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<tr align=left valign=middle>
<td width="131" class=es02r><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="holiday.jsp" class=an01>假期設定</a></td>
</tr>

<!--
<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<tr align=left valign=middle>
<td width="131" class=es02r><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="entryGroup.jsp" class=an01>刷卡資料補登</a></td>
</tr>
</tr>
-->

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<tr align=left valign=middle>
<td width="131" class=es02r><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="listCardNumber.jsp" class=an01>刷卡資料查詢</a></td>
</tr>
</tr>
<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<tr align=left valign=middle>
<td width="131" class=es02r><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="exportCardData.jsp" class=an01>衛星程式補登</a></td>
</tr>
</tr>
<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<%
        }
    }
%>
<tr align=left valign=middle>
<td bgcolor=#919193 width="131" height="18" background=pic/left02.gif><img src=pic/dot01.gif border=0 align=absmiddle></td>
</tr>
</table>
<!--- end 垂直列左側選單 01 --->


</td>
<td height=430>