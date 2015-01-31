<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM");
    int id = Integer.parseInt(request.getParameter("id"));
    SchDef s = SchDefMgr.getInstance().find("id=" + id); 
%>

<%@ include file="schedule_month.jsp"%>
<script src="js/formcheck.js"></script>
<script>
function doCheck(f)
{
    var s = f.month;
    if (f.name.value.length==0) {
        alert("班表名稱不可空白");
        f.name.focus();
        return false;
    }
    if (f.startHr.value.length!=4 || !IsNumeric(f.startHr.value)) {
        alert("請輸入正確的起始時段");
        f.startHr.focus();
        return false;
    }
    if (f.endHr.value.length!=4 || !IsNumeric(f.endHr.value)) {
        alert("請輸入正確的起始時段");
        f.endHr.focus();
        return false;
    }
    f.month.disabled = false;
    return true;
}

</script>
<body>
<div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="pic/add.gif" border=0>&nbsp;編輯班表
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
            <form name="f1" action="schedule_edit2.jsp" method="post" onsubmit="return doCheck(this);">
    
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
                        <input type=text name="name">
                        <br>例如： 早班
                 </td>
                </tr>
                <tr>
                    <td colspan=2 align=middle>    
                        <input type=hidden name="id" value="<%=id%>">
                        <input type=submit value="儲存班表">
                    </td>
                </tr>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                        時段
                    </td>
                    <td nowrap>
                        <input type=text name="startHr" value="0800" size=3>
                        - 
                        <input type=text name="endHr" value="1700" size=3>
                        &nbsp;&nbsp;&nbsp;&nbsp;休息時間
                        <input type=text name="offMin" value="0" size=1>
                        分鐘
                    </td>
                </tr>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                        上班日期
                    </td>
                    <td nowrap>
                        <div id="monthgrid"></div>                        
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
    document.f1.offMin.value = <%=s.getOffMin()%>;
    updateMonthGrid(mon, 'monthgrid', document.f1, '<%=s.getDays()%>');
</script>

