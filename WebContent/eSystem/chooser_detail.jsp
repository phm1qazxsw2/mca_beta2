<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    if(!checkAuth(ud2,authHa,102))
    {
        response.sendRedirect("authIndex.jsp?code=102");
    }
    int tid = Integer.parseInt(request.getParameter("tag"));
    String param = request.getParameter("param");
    String[] tokens = param.split("#");
    int billRecordId = Integer.parseInt(tokens[0]);
    int citemId = Integer.parseInt(tokens[2]);

    String tagName = "";
    String q = null;
    if (tid==0) {
        tagName = "未定";
        q = "tag.id is NULL";
    }
    else {
        Tag tag = TagMgr.getInstance().findX("id=" + tid, _ws2.getStudentBunitSpace("bunitId"));
        tagName = tag.getName();
        q = " tagId=" + tid;
    }
    ArrayList<TagMembrStudent> tagstudents = TagMembrStudentMgr.getInstance().
        retrieveListX(q,"order by student.studentName asc", _ws2.getStudentBunitSpace("membr.bunitId"));

    ChargeMgr cmgr = ChargeMgr.getInstance();
%>

<div class=es02>
    &nbsp;&nbsp;<img src="pic/tag1.png" border=0>&nbsp;<b>標籤名稱:<%=tagName%></b>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:history.go(-1);"><img src="pic/last2.png" border=0>&nbsp;回前一頁</a>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<center>
<script>
function check()
{
    if (typeof document.f2.target=='undefined') {
        alert("沒有選則任何項目");
        return false;
    }
    if (typeof document.f2.target.length=='undefined') {
     if (!document.f2.target.checked) {
            alert("沒有選則任何項目");
            return false;
        }
    }
    else {
        for (var i=0; i<document.f2.target.length; i++) {
            if (document.f2.target[i].checked)
                return true;
        }
        alert("沒有選則任何項目");
        return false;
    }
}

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
<blockquote>

<br>
<form name="f2" action="chooser_detail2.jsp" onsubmit="return check();">
<input type=hidden name="param" value=<%=param%>>
<input type=hidden name=tag value=<%=tid%>>

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
        尚未加入本收費項目名單: <input type=checkbox name="checkall" onclick="check_all(this)"> 全選
        </td>
    </tr>
<%
    int j = 0;
    int k=0;
    Iterator<TagMembrStudent> iter = tagstudents.iterator();
    MembrBillRecordMgr mbrmgr = MembrBillRecordMgr.getInstance();
    while (iter.hasNext()) 
    {
        TagMembrStudent s = iter.next();
        if ((j%4)==0)
        {
            k++;
            if((k%2)==1)
                out.println("<tr bgcolor=#f2f2f2 class=es02>");
            else
                out.println("<tr bgcolor=#ffffff class=es02>");    
        }
        out.println("<td width='16%' nowrap>");
        if (cmgr.numOfRows("chargeItemId=" + citemId + " and membrId=" + s.getMembrId())>0) {
            out.println("<img src='images/lockyes3.gif' width=15 height=15 align=top>");        
        }
        else if (mbrmgr.numOfRows("billRecordId=" + billRecordId + " and membrId=" + s.getMembrId() + " and printDate>0")>0)
            out.println("<img src='images/lockno.gif' width=15 height=15 align=top>");
        else if (mbrmgr.numOfRows("billRecordId=" + billRecordId + " and membrId=" + s.getMembrId() + 
            " and paidStatus="+MembrBillRecord.STATUS_FULLY_PAID)>0)
            out.println("<img src='images/lockfinish.gif' width=15 height=15 align=top>");
        else
            out.println("<input type=checkbox name='target' value='" + s.getMembrId() + "'>");
        out.println(s.getMembrName() + "</td>");
        if ((j%4)==3)
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
        out.println("<b>此標籤全部學生皆已加入</b>");
 %>
 
</form>

</centeR>

