<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM");
    int mid = Integer.parseInt(request.getParameter("mid"));
    int schId = Integer.parseInt(request.getParameter("schId"));
    SchDefMembr s = SchDefMembrMgr.getInstance().find("membrId=" + mid + " and schdefId=" + schId);
    boolean changed = !s.getMyDays().equals(s.getDays());
%>

<%@ include file="schedule_month.jsp"%>

<body>
<div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="pic/add.gif" border=0>&nbsp;個人班表 <%=sdf.format(s.getMonth())%> <%=s.getMembrName()%>
</font>
</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<br>
<table width="100%" border=0 cellpadding=0 cellspacing=0>
	<tr bgcolor=#ffffff align=left valign=middle> 
        <td valign=top width=30 align=middle>
        </td>            
        <td valign=top width=120 align=middle>
            <img src="img/abill.gif" border=0>
        </td>
        <td>
            <form name="f1" action="schedule_membr2.jsp" method="post">
    
            <table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
            <tr align=left valign=top>
            <td bgcolor="#e9e3de">
                <table width="100%" border=0 cellpadding=4 cellspacing=1>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                    班表月份 
                    </td>
                    <td>
                        <input type=text name="month" value="<%=sdf.format(s.getMonth())%>" disabled>
                    </td>
                </tr>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                    班表名稱: 
                    </td>
                    <td>
                        <input type=text name="name" disabled>
                 </td>
                </tr>
                <tr>
                    <td colspan=2 align=middle>    
                        <input type=hidden name="mid" value="<%=mid%>">
                        <input type=hidden name="schId" value="<%=schId%>">
                        <input type=submit value="儲存班表">
                    </td>
                </tr>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                        時段
                    </td>
                    <td nowrap>
                        <input type=text name="startHr" value="0800" size=3 disabled>
                        - 
                        <input type=text name="endHr" value="1700" size=3 disabled>
                        &nbsp;&nbsp;&nbsp;&nbsp;休息時間
                        <input type=text name="offMin" value="0" size=1 disabled>
                        分鐘
                    </td>
                </tr>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                        上班日期
                    </td>
                    <td nowrap>
                        <div id="monthgrid"></div>
                    <% if (changed) { %>
                        &nbsp;<a href="javascript:restoreOrg();">使用原班表日期</a>　　　　
                        <a href="javascript:restoreDays();">回復特別設定的日期</a>
                    <% }
                       else {
                           
                       }%>
                    </td>
                </tr>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                        說明
                    </td>
                    <td nowrap>
                        <textarea name="note" rows=4 cols=35></textarea>                        
                    </td>
                </tr>
            </table>
            </td>
            </tr>
            </table>
            </form>

        </td>
    </tr>
</table>

</body>

<script>
    var mon = '<%=sdf.format(s.getMonth())%>';
    document.f1.name.value = '<%=phm.util.TextUtil.escapeJSString(s.getName())%>';
    document.f1.startHr.value = '<%=s.getStartHr()%>';
    document.f1.endHr.value = '<%=s.getEndHr()%>';
    document.f1.buffer.value = <%=s.getBuffer()%>;
    document.f1.note.value = '<%=phm.util.TextUtil.escapeJSString(s.getMyNote())%>';
    updateMonthGrid(mon, 'monthgrid', document.f1, '<%=s.getMyDays()%>');  
    
    function restoreOrg() {
        updateMonthGrid(mon, 'monthgrid', document.f1, '<%=s.getDays()%>');
    }
    function restoreDays() {
        updateMonthGrid(mon, 'monthgrid', document.f1, '<%=s.getMyDays()%>');
    }

</script>

