<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    int billId = Integer.parseInt(request.getParameter("billId"));
    EzCountingService ezsvc = EzCountingService.getInstance();	
    Bill b = BillMgr.getInstance().find("id="+billId);
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM");
    ArrayList<BillRecord> brecords = BillRecordMgr.getInstance().
        retrieveList("billId=" + b.getId(), "order by month desc");

    // figure out months that already has this billrecords
    Map<String, String> mm = new HashMap<String, String>();
    Map<Date, Vector<BillRecord>> m = new SortingMap(brecords).doSort("getMonth");
    Set keys = m.keySet();
    Iterator<Date> iterx = keys.iterator();
    while (iterx.hasNext()) {
        Date tmp = iterx.next();
        mm.put(sdf.format(tmp), "");
    }
%>
<script>
function IsNumeric(sText)
{
    var ValidChars = "0123456789.";
    var IsNumber=true;
    var Char; 
    if (sText.length==0)
        return false;
    var i = 0;
    if (sText.length>0 && sText.charAt(0)=='-')
        i = 1;
    for (; i < sText.length && IsNumber == true; i++) 
    { 
        Char = sText.charAt(i); 
        if (ValidChars.indexOf(Char) == -1) 
        {
            IsNumber = false;
        }
    }
    return IsNumber;
}

function doCheck(f)
{
    var s = f.month;
    var m = s.options[s.selectedIndex].value;
    if (f.record.value.length==0) {
        alert("薪資記錄名稱不可空白");
        f.record.focus();
        return false;
    }

    if (confirm("確定以下設定:\n薪資月份: " + m))
        return true;
    return false;
}

var user_change_name = false;
function makeName()
{
    if (user_change_name==true)
        return;
    var f = document.f1;
    var s = f.month;
    if (s.options[s.selectedIndex].value=="-") {
        alert('該月份已經設過薪資，請選擇另一個月份');
        return;
    }
    var m = s.options[s.selectedIndex].value;
    f.record.value = m + ' <%=b.getName()%>';
    autoName = f.record.value;
}

function checkUserChangeName()
{
    var f = document.f1;
    if (f.record.value!=autoName)
        user_change_name = true;
}

</script>
<body onload="makeName()">
<div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="pic/add.gif" border=0>&nbsp;新增薪資-<font color=blue><%=b.getName()%></font>
&nbsp;&nbsp;&nbsp;&nbsp;
<a href="#" onClick="history.go(-1)"><img src="pic/last.gif" border=0 width=12>&nbsp;回上一頁</a>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<br>
<table width="100%" border=0 cellpadding=0 cellspacing=0>
	<tr bgcolor=#ffffff align=left valign=middle> 
        <td valign=top width=30 align=middle>
        </td>            
        <td valign=top width=120 align=middle>
            <img src="pic/sbill1.gif" border=0>
        </td>
        <td>

<form name="f1" action="salaryrecord_add2.jsp" method="post" onsubmit="return doCheck(this);">
<input type=hidden name="billId" value="<%=billId%>">

 <table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
            <tr align=left valign=top>
            <td bgcolor="#e9e3de">
                <table width="100%" border=0 cellpadding=4 cellspacing=1>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                        薪資月份
                    </td>
                    <td>
                        <select name="month" onchange="makeName()">
                        <option value="">-- 請選擇月份 ---</option>
                        <%
                            //Date d = new Date(new Date().getTime()+((long)10)*((long)86400000));
                            //Date d = new Date();
                            Calendar c = Calendar.getInstance();
                            c.add(Calendar.MONTH, -5);
                            for (int i=0; i<12; i++) {
                                Date d2 = c.getTime();
                                boolean done = (mm.get(sdf.format(d2))!=null);
                                String v = (done)?"-": sdf.format(d2);
                                out.println("<option value='" + v + "'>" + 
                                    sdf.format(d2) + ((done)?" 已開過":"") + "</option>");
                                c.add(Calendar.MONTH, 1);
                            }
                        %>
                        </select>
                </tr>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                        作業名稱:
                    </td>
                    <td>
                        <input type=text name="record" onblur="checkUserChangeName();">
                    </td>
                </tr>
                <%
                if (brecords.size()>0) { %>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                    複製前期薪資:
                    </td>
                    <td>
                        <select name="copyfrom">
                            <option value="0">---不複製,新產生---</option>
                        <%
                            Iterator<BillRecord> iter = brecords.iterator();
                            while (iter.hasNext()) {
                                BillRecord br = iter.next();
                                out.println("    <option value=" + br.getId() + ">" + br.getName() + "</option>");
                            }
                        %>
                        </select>
                    </td>
                </tr>
                <%}%>
                <tr>
                    <td colspan=2 align=middle>
                    <input type=submit value="產生薪資記錄"> &nbsp; <input type=button value="回上一頁" onclick="history.go(-1)"> 
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
