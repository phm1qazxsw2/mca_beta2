<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    if(!checkAuth(ud2,authHa,301))
    {
        response.sendRedirect("authIndex.jsp?code=301");
    }
    String param = request.getParameter("param");
    String[] tokens = param.split("#");
    int brid = Integer.parseInt(tokens[0]);
    int cid = Integer.parseInt(tokens[2]);

    ArrayList<TagMembrTeacher> teachers = TagMembrTeacherMgr.getInstance().
        retrieveListX("teacherStatus in (1,2)","", _ws2.getBunitSpace("membr.bunitId")); // 1:試用, 2：在職

    ChargeMgr cmgr = ChargeMgr.getInstance();
%>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<center>
<script>
function check_all(c) {
    var target = document.f2.target;
    if (typeof target!='undefined') {
        if (typeof target.length=='undefined')
            target.checked = c.checked;
        else {
            for (var i=0; i<target.length; i++) {
                target[i].checked = c.checked;
            }
        }
    }
}
</script>

<center>
<br>
<form name="f2" action="salary_chooser_detail2.jsp">
<input type=hidden name="param" value=<%=param%>>

<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
    <tr>
        <td colspan=6>
  &nbsp;&nbsp;&nbsp;<center><input type=submit value='加入'></center>
        </td>
    </tr>
    <tr>
        <td colspan=6 bgcolor=ffffff class=es02>
        尚未加入本薪資項目名單: <input type=checkbox name="checkall" onclick="check_all(this)"> 全選
        </td>
    </tr>
<%
    int j = 0;
    int k=0;
    Iterator<TagMembrTeacher> iter = teachers.iterator();
    MembrBillRecordMgr mbrmgr = MembrBillRecordMgr.getInstance();
    while (iter.hasNext()) 
    {
        TagMembrTeacher s = iter.next();
        if (cmgr.numOfRows("chargeItemId=" + cid + " and membrId=" + s.getMembrId())>0)
            continue;          
        if ((j%6)==0)
        {
            k++;
            if((k%2)==1)
                out.println("<tr bgcolor=#f2f2f2 class=es02>");
            else
                out.println("<tr bgcolor=#ffffff class=es02>");    
        }
        out.println("<td width='16%' nowrap>");
        if (mbrmgr.numOfRows("billRecordId=" + brid + " and membrId=" + s.getMembrId() + " and printDate>0")>0)
            out.println("<img src='images/lockno.gif' width=15 height=15 align=top>");
        else if (mbrmgr.numOfRows("billRecordId=" + brid + " and membrId=" + s.getMembrId() + 
            " and paidStatus="+MembrBillRecord.STATUS_FULLY_PAID)>0)
            out.println("<img src='images/lockfinish.gif' width=15 height=15 align=top>");
        else
            out.println("<input type=checkbox name='target' value='" + s.getMembrId() + "'>");
        out.println(s.getMembrName() + "</td>");
        if ((j%6)==5)
            out.println("</tr>");
        j++;
    }
%>
        </table>
    </td>
    </tr>
    </table>   
    <br>   
<%
    if (j==0)
        out.println("<b>所有老師皆已加入</b>");
 %>
 
</form>

</centeR>

