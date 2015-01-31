<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    int billId = Integer.parseInt(request.getParameter("billId"));
    EzCountingService ezsvc = EzCountingService.getInstance();	
    Bill b = BillMgr.getInstance().find("id="+billId);
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM");
    ArrayList<BillRecord> brecords = BillRecordMgr.getInstance().retrieveList("billId=" + b.getId(), "order by month desc");

    // figure out months that already has this billrecords
    Map<String, String> mm = new HashMap<String, String>();
    Map<Date, Vector<BillRecord>> m = new SortingMap(brecords).doSort("getMonth");
    Set keys = m.keySet();
    Iterator<Date> iterx = keys.iterator();
    while (iterx.hasNext()) {
        Date tmp = iterx.next();
        mm.put(sdf.format(tmp), "");
    }
    PaySystem2 p = PaySystem2Mgr.getInstance().find("id=1");
    String paymentLimit = PaymentPrinter.makePrecise(p.getPaySystemLimitDate()+"", 2, false, '0');
%>
<script src="js/formcheck.js"></script>
<script>
function doCheck(f)
{
    var s = f.month;
    var m = s.options[s.selectedIndex].value;
    if (m.length==0) {
        alert("沒有選擇入帳月份");
        s.focus();
        return false;
    }
    if (f.record.value.length==0) {
        alert("開單記錄名稱不可空白");
        f.record.focus();
        return false;
    }
    if (!checkDate(f.billDate.value)) {
        alert("繳費期限格式錯誤");
        f.billDate.focus();
        return false;
    }

    if (confirm("確定以下設定:\n開單月份: " + m + "\n繳費期限: " + f.billDate.value))
        return true;
    return false;
}

var user_change_name = false;
var user_change_date = false;
function makeName()
{
    if (user_change_name==true)
        return;
    var f = document.f1;
    var s = f.month;
    if (s.options[s.selectedIndex].value=="-") {
        alert('該月份已經開過，請選擇另一個月份');
        return;
    }
    var m = s.options[s.selectedIndex].value;
    f.record.value = m + ' <%=b.getName()%>';
    autoName = f.record.value;
}
function makeDate()
{
    if (user_change_date==true)
        return;
    var f = document.f1;
    var s = f.month;
    var m = s.options[s.selectedIndex].value;
    f.billDate.value = m + '-<%=paymentLimit%>';
    autoDate = f.billDate.value;
}


function checkUserChangeName()
{
    var f = document.f1;
    if (f.record.value!=autoName)
        user_change_name = true;
}
function checkUserChangeDate()
{
    var f = document.f1;
    if (f.billDate.value!=autoDate)
        user_change_date = true;
}

</script>
<body onload="makeName();makeDate()">
<div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="pic/add.gif" border=0>&nbsp;新增帳單-<font color=blue><%=b.getName()%></font></div>

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
            <form name="f1" action="addBillRecord2.jsp" method="post" onsubmit="return doCheck(this);">
    
            <table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
            <tr align=left valign=top>
            <td bgcolor="#e9e3de">
                <table width="100%" border=0 cellpadding=4 cellspacing=1>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                    入帳月份 
                    </td>
                    <td>
                        <input type=hidden name="billId" value="<%=billId%>">
                           <select name="month" onchange="makeName();makeDate()">
                            <option value="">-- 請選擇月份 ---</option>
                            <%
                                Calendar cal = Calendar.getInstance();
                                cal.add(Calendar.MONTH, -2);
                                for (long i=0; i<14; i++) {
                                    Date d2 = cal.getTime();
                                    boolean done = (mm.get(sdf.format(d2))!=null);
                                    String v = (done)?"-": sdf.format(d2);
                                    out.println("<option value='" + v + "'>" + 
                                        sdf.format(d2) + ((done)?" 已開過":"") + "</option>");
                                    cal.add(Calendar.MONTH, 1);
                                }
                            %>
                            </select>

                    </td>
                </tr>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                    帳單名稱: 
                    </td>
                    <td>
                        <input type=text name="record" onblur="checkUserChangeName();">
                        <br>例如： "<%=sdf.format(new Date())%> 月帳單"   
                 </td>
                </tr>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                        指定繳費期限: 
                    </td>
                    <td>
                        <input type=text name="billDate" onblur="checkUserChangeDate()" size=12>
                    </td>
                </tr>
            <%  if (brecords.size()>0) { %>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>複製前期帳單</td>
                    <td>
                        <select name="copyfrom">
                            <option value="0">---不複製,新產生---</option>
                        <%
                            Iterator<BillRecord> iter = brecords.iterator();
                            while (iter.hasNext()) {
                                BillRecord br = iter.next();
                                out.println("    <option value=" + br.getId() + ">" + br.getName() + "</option>");
                            }
                        %><br>(包括所有的單據項目和折扣,複製後可繼續修改)
                                        </select>
                    </td>
                </tr>
                <%  }   %>
                <tr>
                    <td colspan=2 align=middle>    
                        <input type=submit value="產生開單記錄"> &nbsp; <input type=button value="回上一頁" onclick="history.go(-1)"> 
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
