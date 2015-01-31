<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<!--- start 垂直列左側選單 01 --->
<table bgcolor=#8CAAED width="131" border="0" cellpadding="0" cellspacing="0">
<%
    if(checkAuth(ud2,authHa,600)){
%>

<tr align=left valign=middle>
<td bgcolor=#696a6e width="131" background=pic/left01.gif class=es02r>
<img src=pic/arrow02<%=(leftMenu==2)?"r":""%>.gif border=0 align=absmiddle>
<font color=white>Student</td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02<%=(leftMenu==2)?"r":""%>.gif><img src="pic/h02<%=(leftMenu==2)?"r":""%>.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<tr align=left valign=middle>
<td width="131" class=es02r>
<img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="listStudent.jsp" class=an01>Search</a></td>
</tr>

<!--
<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<tr align=left valign=middle>
<td width="131" class=es02r>
<img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="studentoverview.jsp" class=an01>Grouping</a></td>
</tr>
-->

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<tr align=left valign=middle>
<td width="131" class=es02r>
<img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="mca_family_list.jsp" class=an01>Families</a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<%
    boolean hasNew = Student2Mgr.getInstance().numOfRowsX("studentStatus=1", _wsc.getBunitSpace("bunitId"))>0;
%>

<tr align=left valign=middle>
<td width="131" class=es02r>
<img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="mca_new_student.jsp" class=an01><%=(hasNew)?"<BLINK>":""%>Admissions<%=(hasNew)?"</BLINK>":""%></a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<tr align=left valign=middle>
<td width="131" class=es02r>
<img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="mca_off_school.jsp" class=an01>Off School</a></td>
</tr>

<!--
<tr align=left valign=middle>
<td width="131" class=es02r><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="tagtype_list.jsp" class=an01>類型管理</a></td>
</tr>
-->

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<%
    }
    /*
    if(checkAuth(ud2,authHa,603)){
%>

<tr align=left valign=middle>
<td bgcolor=#919193 width="131" height="18" background=pic/left02.gif><img src=pic/dot01.gif border=0 align=absmiddle></td>
</tr>

<tr align=left valign=middle>
<td bgcolor=#696a6e width="131" background=pic/left01.gif class=es02r>
<img src=pic/arrow02<%=(leftMenu==4)?"r":""%>.gif border=0 align=absmiddle><font color=white>進階功能</font></td>
</tr>
<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02<%=(leftMenu==4)?"r":""%>.gif><img src="pic/h02<%=(leftMenu==4)?"r":""%>.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<tr align=left valign=middle>
<td width="131" class=es02r><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="formIndex.jsp" class=an01>表單中心</a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>


<tr align=left valign=middle>
<td width="131" class=es02r><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="sendGroupMessage.jsp" class=an01>發送簡訊</a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<tr align=left valign=middle>
<td width="131" class=es02r><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="sendGroupEmail.jsp" class=an01>發送Email</a></td>
</tr>


<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<%
    }*/
%>

<tr align=left valign=middle>
<td bgcolor=#919193 width="131" height="18" background=pic/left02.gif><img src=pic/dot01.gif border=0 align=absmiddle></td>
</tr>

<%    
    /*
    if(checkAuth(ud2,authHa,604)){
%>


<tr align=left valign=middle>
<td bgcolor=#696a6e width="131" background=pic/left01.gif class=es02r>
<img src=pic/arrow02<%=(leftMenu==5)?"r":""%>.gif border=0 align=absmiddle><font color=white><%=(pZ2.getCustomerType()==0)?"學生資料選項設定":"相關設定"%></a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02<%=(leftMenu==5)?"r":""%>.gif><img src="pic/h02<%=(leftMenu==5)?"r":""%>.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<tr align=left valign=middle>
<td width="131" class=es02r><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="listDegree.jsp" class=an01>學歷列表</a></td>
</tr>

<%
if(pZ2.getCustomerType()==0){
%>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<tr align=left valign=middle>
<td width="131" class=es02r><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="listRelation.jsp" class=an01>親屬關係</a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<tr align=left valign=middle>
<td width="131" class=es02r><img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="listLeaveReason.jsp" class=an01>離校原因</a></td>
</tr>

<%
    }
%>
<tr align=left valign=middle>
<td bgcolor=#919193 width="131" height="18" background=pic/left02.gif><img src=pic/dot01.gif border=0 align=absmiddle></td>
</tr>

<%
        }*/
%>    

</table>
<!--- end 垂直列左側選單 01 --->



</td>
<td height=430>