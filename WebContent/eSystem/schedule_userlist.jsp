<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    int id = Integer.parseInt(request.getParameter("id"));
    SchDef s = SchDefMgr.getInstance().find("id=" + id);
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");

    int bunit=-1;
    String bunitS=request.getParameter("bunit");        
    if(bunitS !=null)
        bunit=Integer.parseInt(bunitS); 
%>

<div class=es02>
    &nbsp;&nbsp;<img src="pic/tag1.png" border=0>&nbsp;<b>班表人員: <%=s.getName()%></b>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<script>
<%
    Date d = new Date();               
    if (d.compareTo(s.getStartDate())>0) {
        %> var cross_today = true; <%
    } else {
        %> var cross_today = false; <%
    }
%>
function check()
{
<%
    if(s.getAutoRun()==1){
%>
        if (cross_today && !confirm('修改後的起始日會從明天開始生效，今天和之前的班表人員不會改變'))
            return false;
<%
    }
%>
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

<%
    BunitMgr bm=BunitMgr.getInstance();
    ArrayList<Bunit> b=bm.retrieveListX("status ='1' and flag='0'","", _ws2.getBunitSpace("buId"));
%>

<%
    if(b !=null && b.size()>=0){
%>
<blockquote>
<form action="schedule_userlist.jsp" method="post">
    依部門查詢: <select name="bunit" size=1>
                <option value="-1" <%=(bunit==-1)?"selected":""%>>全部部門</option>
    <%          
                for(int j=0;j<b.size();j++){    
                    Bunit bb=b.get(j);
    %>
                    <option value="<%=bb.getId()%>" <%=(bunit==bb.getId())?"selected":""%>><%=bb.getLabel()%></option>
    <%          }   %>
                <option value="0" <%=(bunit==0)?"selected":""%>>未定</option>
            </select>
            <input type=hidden name="id" value=<%=id%>>
            <input type=submit value="查詢">
        </form>
</blockquote>
    <%  }   %>

<center>
<form name="f2" action="schedule_userlist2.jsp" onsubmit="return check();">
<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
    <input type=hidden name=schid value=<%=id%>>
    <tr>
        <td colspan=6 align=middle>
            <input type=submit value='儲存名單'>
            <input type=hidden name="bunit" value="<%=bunit%>">
        </td>
    </tr>
    <tr>
        <td colspan=6 bgcolor=ffffff class=es02>
        班表名單: <input type=checkbox name="checkall" onclick="check_all(this)"> 全選
        </td>
    </tr>
<%
    String query="";

    if(bunit !=-1)
        query="teacherBunitId ='"+bunit+"'";

    Map<Integer, MembrTeacher> teacherMap = new SortingMap(MembrTeacherMgr.getInstance().
        retrieveList(query, "")).doSortSingleton("getMembrId"); // 全部 including 離職
    ArrayList<SchMembr> schs = SchMembrMgr.getInstance().retrieveList("schdefId=" + s.getId(), "");

    int j = 0;
    Iterator<SchMembr> iter = schs.iterator();
    while (teacherMap.size()>0) 
    {
        MembrTeacher t = null;
        boolean checked = false;
        if (iter.hasNext()) {
            SchMembr sm = iter.next();
            Integer n = new Integer(sm.getMembrId());
            t = teacherMap.get(n);
            if(t !=null)
                teacherMap.remove(n);
            else
                continue;                
            checked = true;
        }else {
            Integer n = teacherMap.keySet().iterator().next();
            t = teacherMap.get(n);
            
            if(t !=null)
                teacherMap.remove(n);
            else
                continue;                
            if (t.getStatus()==0)
                continue;
        }
        if ((j%6)==0)
        {
            out.println("<tr bgcolor=#ffffff class=es02>");    
        }

        out.println("<td width='16%' bgcolor="+(checked?"#f2f2f2":"white")+">");
        out.println("<input type=checkbox name='target' value='" + t.getMembrId() + "'"+ ((checked)?" checked":"") +">");
        out.println(t.getName() + "</td>");

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
</form>
</center>
<% 
    String save = request.getParameter("save");
    if (save!=null && save.equals("1")) {
     %><script>
          parent.do_reload = true;
          parent.parent.do_reload = true; // 有可能是在兩層 window 下
     </script><%
    }
%>
