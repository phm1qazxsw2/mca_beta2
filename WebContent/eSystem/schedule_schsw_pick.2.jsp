<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%!
    Calendar getCalendarOf(Date month)
    {
        Calendar c = Calendar.getInstance();
        c.setTime(month);
        c.set(Calendar.DAY_OF_MONTH, 1);
        return c;
    }
%>
<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
    SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd");
    Date month = sdf.parse(request.getParameter("month"));
    MembrMgr mmgr = MembrMgr.getInstance();
    Membr m1 = mmgr.find("id=" + request.getParameter("id1"));
    Membr m2 = mmgr.find("id=" + request.getParameter("id2"));
    SchInfo info1 = SchInfo.getSchInfo(m1, month);
    SchInfo info2 = SchInfo.getSchInfo(m2, month);
    Vector<SchInfo> vinfos = new Vector<SchInfo>();
    vinfos.add(info1);
    vinfos.add(info2);
    // 找出所有該月的 schdefs
    ArrayList<SchDef> schdefs = SchDefMgr.getInstance().retrieveList("month='" + sdf2.format(month) + "'", "");
%>
<script>
function inColor(divId)
{
    var d = document.getElementById(divId);
    d.style.background = "black";
}
function outColor(divId, i, applied)
{
    var d = document.getElementById(divId);
    if (applied)
        d.style.background = (i==0)?"green":"red";
    else
        d.style.background = "white";
}
</script>
<body>
<div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="pic/add.gif" border=0>&nbsp;換班
</font>
</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<center>
<br>
    <form name="f1" action="schedule_leave_add2.jsp" method="post" onsubmit="return doCheck(this);">    
    <table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
<%
        for (int i=0; i<vinfos.size(); i++) {
            SchInfo info = vinfos.get(i); 
%>
        <tr align=left valign=top>
        <td bgcolor="#e9e3de">
            <table width="100%" border=2 cellpadding=4 cellspacing=1>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td rowspan=<%=schdefs.size()%>>
                        <%=info.getMembrName()%>                        
                    </td>
<%
            Iterator<SchDef> iter = schdefs.iterator();
            int j = 0;
            while (iter.hasNext()) {
                SchDef d = iter.next();
                String color = (i==0)?"green":"red";
                if (j>0) {
              %><tr bgcolor=#ffffff class=es02 align=left valign=middle><%
                }
%>
                    <td>
                        <%=d.getName()%>
                    </td>
<%
                Calendar c = getCalendarOf(month);
                int thisMonth = c.get(Calendar.MONTH);
                while (c.get(Calendar.MONTH)==thisMonth) { 
                    String divId = d.getId()+"_"+c.get(Calendar.DAY_OF_MONTH) + "_" + i;
                    boolean a = (info.isApplied(c.getTime(), d.getId()));
                    %>
                    <td id="<%=divId%>" style="background:<%=a?color:"white"%>" <% if (a) { %> onMouseOver="inColor('<%=divId%>')" onMouseOut="outColor('<%=divId%>', <%=i%>, <%=a%>)" <% } %> >
                       <img src="images/spacer.gif" width=15>
                    </td>
<%              c.add(Calendar.DATE, 1);
                }
%>              </tr>
<%              j ++;
            } %>
            </table>
        </td>
        </tr>
        <tr>
        <td height=30></td>
        </tr>
<%      } %>
    </table>
    </form>
</center>
</body>
