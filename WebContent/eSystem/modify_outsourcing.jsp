<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    int teacherId = Integer.parseInt(request.getParameter("teacherId"));
    MembrMgr mmgr = MembrMgr.getInstance();
    Membr membr = mmgr.find("type=2 and surrogateId=" + teacherId);
    MembrUserData u2 = MembrUserDataMgr.getInstance().find("membrId=" + membr.getId());
	TeacherMgr tm=TeacherMgr.getInstance();
	Teacher tea=(Teacher)tm.find(teacherId); 
%>

<table width="100%" height="" border="0" cellpadding="8" cellspacing="0">
<tr align=left valign=top>
<td class=es02>

<%=(pd2.getCustomerType()==0)?"老師":"員工"%>:<font color=blue><b><%=tea.getTeacherFirstName()%><%=tea.getTeacherLastName()%></b></font><br><br>
<a href="modifyTeacher.jsp?teacherId=<%=tea.getId()%>">基本資料</a>
 | 
<a href="modifyTeacherWork.jsp?teacherId=<%=tea.getId()%>">工作設定</a>
 | 
<a href="modifyTeacherFee.jsp?teacherId=<%=tea.getId()%>">勞健保設定</a> |
<a href="modifyTeacherAccount.jsp?teacherId=<%=tea.getId()%>">帳務資料</a> 
<% if (pd2.getWorkflow()==PaySystem2.WORKFLOW_NEIL) { %>
| <a href="modifyTeacherUser.jsp?teacherId=<%=tea.getId()%>">登入設定</a>
| 派遣對象
<% } %>
<% if (pd2.getCardread()!=0) { %>
| <a href="modifyTeacherCard.jsp?teacherId=<%=tea.getId()%>">感應卡設定</a>
<%  }   %>
</td>
</tr>
</table>
<script>
    top.nowpage=6;
</script>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<% if (u2==null) { %>
<blockquote>
尚未<a href="modifyTeacherUser.jsp?teacherId=<%=teacherId%>">設定登入資料</a>，不可設定派遣對象
</blockquote>
<% 
     return;
   } 
%>

<center>
<script type="text/javascript" src="js/string.js"></script>
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script>
function selectCopyFrom(membrId)
{
    var url = "outsourcing_gettarget.jsp?id="+membrId + "&r="+(new Date()).getTime();
    var req = new XMLHttpRequest();
    if (req) 
    {
        req.onreadystatechange = function() 
        {
            if (req.readyState == 4 && req.status == 200) 
            {
                setTargetIds(trim(req.responseText));
            }
        }
    };
    req.open('GET', url);
    req.send(null);
}

function setTargetIds(input)
{
    var tokens = input.split(",");
    var a = new Array;
    if (typeof document.f2.target.length=='undefined') {
        document.f2.target.checked = false;
        a[document.f2.target.value] = document.f2.target;
    }
    else {
        for (var i=0; i<document.f2.target.length; i++) {
            document.f2.target[i].checked = false;
            a[document.f2.target[i].value] = document.f2.target[i];
        }
    }
    for (var i=0; i<tokens.length; i++) {
        if (tokens[i].length>0)
            a[tokens[i]].checked = true;
    }
}

function check()
{
    if (typeof document.f2.target=='undefined') {
        if (!confirm("確定清空?"))
            return false;
    }
    if (typeof document.f2.target.length=='undefined') {
     if (!document.f2.target.checked) {
            if (!confirm("確定清空?"))
                return false;
        }
    }
    else {
        for (var i=0; i<document.f2.target.length; i++) {
            if (document.f2.target[i].checked)
                return true;
        }
        if (!confirm("確定清空?"))
            return false;
    }
    return true;
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
<form name="f2" action="modify_outsourcing2.jsp" onsubmit="return check();">
<input type=hidden name="teacherId" value="<%=teacherId%>">
<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
    <tr>
        <td colspan=6>
  &nbsp;&nbsp;&nbsp;<center><input type=submit value='設定'></center>
        </td>
    </tr>
    <tr>
        <td colspan=6 bgcolor=ffffff class=es02>
        派遣對象: <input type=checkbox name="checkall" onclick="check_all(this)"> 全選
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <a href="javascript:openwindow_phm2('outsourcing_copytarget.jsp','複製派遣對象',500,600,'copylistwin');">複製其他人的設定</a>
        </td>
    </tr>
<%
    Map<Integer, MembrStudent> membrstudentMap = new SortingMap(MembrStudentMgr.getInstance().
        retrieveList("", "")).doSortSingleton("getMembrId"); // 全部 including 離職
    ArrayList<MembrMembr> targets = MembrMembrMgr.getInstance().retrieveList("m1Id=" + membr.getId(), "");

    int j = 0;
    Iterator<MembrMembr> iter = targets.iterator();
    while (membrstudentMap.size()>0) 
    {
        MembrStudent s = null;
        boolean checked = false;
        if (iter.hasNext()) {
            MembrMembr mm = iter.next();
            Integer n = new Integer(mm.getM2Id());
            s = membrstudentMap.get(n);
            membrstudentMap.remove(n);
            checked = true;
        }
        else {
            Integer n = membrstudentMap.keySet().iterator().next();
            s = membrstudentMap.get(n);
            membrstudentMap.remove(n);
            int status = s.getStatus();
            if (status!=3 && status!=4)
                continue;
        }

        if ((j%4)==0)
        {
            out.println("<tr bgcolor=#ffffff class=es02>");    
        }
        out.println("<td width='16%' bgcolor="+(checked?"#f2f2f2":"white")+" nowrap>");
        out.println("<input type=checkbox name='target' value='" + s.getMembrId() + "'"+ ((checked)?" checked":"") +">");
        out.println(s.getName() + "</td>");
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
 
</form>

</centeR>

