<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM");
%>

<%@ include file="schedule_month.jsp"%>
<script src="js/formcheck.js"></script>
<script>
function checkMonth(s, f, data)
{
    updateMonthGrid(s.options[s.selectedIndex].value, 'monthgrid', f, data);
}

function doCheck(f)
{
    var s = f.month;
    var m = s.options[s.selectedIndex].value;
    if (m.length==0) {
        alert("沒有選擇入帳月份");
        s.focus();
        return false;
    }
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

    if (confirm("確定以下設定:\n班表月份: " + m))
        return true;
    return false;
}

</script>
<body>
<div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="pic/add.gif" border=0>&nbsp;新增班表</font></div>

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
            <form name="f1" action="schedule_add2.jsp" method="post" onsubmit="return doCheck(this);">
    
            <table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
            <tr align=left valign=top>
            <td bgcolor="#e9e3de">
                <table width="100%" border=0 cellpadding=4 cellspacing=1>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                    班表月份 
                    </td>
                    <td>
                           <select name="month" onchange="checkMonth(this);">
                            <option value="">-- 請選擇月份 ---</option>
                            <%
                                Calendar cal = Calendar.getInstance();
                                for (long i=0; i<12; i++) {
                                    Date d2 = cal.getTime();
                                    String v = sdf.format(d2);
                                    out.println("<option value='" + v + "'>" + 
                                        sdf.format(d2) + "</option>");
                                    cal.add(Calendar.MONTH, 1);
                                }
                            %>
                            </select>

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
                        <input type=submit value="產生班表">
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


