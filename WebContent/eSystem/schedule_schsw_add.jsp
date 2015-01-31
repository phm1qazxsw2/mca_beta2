<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM");
    Date d1 = sdf.parse(request.getParameter("d1"));
    Date d2 = sdf.parse(request.getParameter("d2"));
    Calendar c = Calendar.getInstance();
    c.setTime(d2);
    c.add(Calendar.DATE, 1);
    Date nextEndDay = c.getTime();

    // 找出有在這段時間內的 schdefs
    ArrayList<SchDef> schs = SchDefMgr.getInstance().retrieveList(
      "startDate<'" + sdf.format(nextEndDay) + "' and endDate>='" + sdf.format(d1) + "'", "");
    if (schs.size()==0) {
    %><script>alert("尚未設定班表 無法調班");history.go(-1);</script><%
    }

    Date month = sdf2.parse(sdf2.format(d2));
    try { month = sdf.parse(request.getParameter("month")); } catch (Exception e) {}
%>
<div class=es02>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b><img src="pic/addchangeschedule.png" border=0>&nbsp;換班</b>
</div>

<script>
    var _id1 = null;
    var _id2 = null;
    function setup_target_1(id, name)
    {
        document.getElementById("target1").innerHTML = name;
        _id1 = id;
    }
    function setup_target_2(id, name)
    {
        document.getElementById("target2").innerHTML = name;
        _id2 = id;
    }
    function get_month()
    {
        var s = document.f1.month;
        return s.options[s.selectedIndex].value;
    }

    function get_target_1() { return _id1; };
    function get_target_2() { return _id2; };

    parent.setup_target_1 = setup_target_1;
    parent.setup_target_2 = setup_target_2;
    parent.get_target_1 = get_target_1;
    parent.get_target_2 = get_target_2;
    parent.get_month = get_month;
</script>
<form name="f1">
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<center>
<table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02 valign=top>
        <td width=40% valign=center align=middle>班表月份</td>
        <td width=60% align=middle>
            <select name=month><%
                c.setTime(month);
                c.add(Calendar.MONTH, -3);
                for (int i=0; i<9; i++) {                    
                    Date d = c.getTime();
                  %><option value="<%=sdf.format(d)%>" <%=(d.compareTo(month)==0)?"selected":""%>><%=sdf2.format(d)%>
            <%      c.add(Calendar.MONTH, 1);
                }
            %>
            </select>
        </td>
    </tr>
	<tr bgcolor=#f0f0f0 class=es02 valign=top>
        <td width=40% align=middle>換班來源</td>
        <td width=60% align=middle><span id="target1"></span>　<a href="javascript:parent.openFinder(1);">請選擇</a></td>
    </tr>
    
	<tr bgcolor=#f0f0f0 class=es02 valign=top>
        <td width=40% align=middle>換班對象</td>
        <td width=60% align=middle><span id="target2"></span>　<a href="javascript:parent.openFinder(2);">請選擇</a></td>
    </tr>

	<tr bgcolor=#f0f0f0 class=es02 valign=top>
        <td colspan=2 align=middle>
            <span id="target2"></span>　<input type=button value="勾選換班時段" onClick="javascript:parent.openPicker();return false">
        </td>
    </tr>

</TABLE>
</td>
</tr>
</table>
</center>
</form>