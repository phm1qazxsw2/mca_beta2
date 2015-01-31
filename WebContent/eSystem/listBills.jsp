<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<script>
function modifyName(id, oldname)
{
    var newname = "";
    while (newname.length==0) {
        newname = prompt("請輸入新的類型代號", oldname);
        if (newname==null)
            return;
    }
    location.href = "listBills2.jsp?id=" + id + "&n=" + encodeURI(newname) + 
        "&backurl=listBills.jsp";
    //openwindow_phm2('listBills.jsp', '修改', 400,400,'modifywin');
}

function modifyPrettyName(id, oldname)
{
    var newname = "";
    while (newname.length==0) {
        newname = prompt("請輸入新的單據名稱", oldname);
        if (newname==null)
            return;
    }
    location.href = "listBills2.jsp?id=" + id + "&pn=" + encodeURI(newname) +
        "&backurl=listBills.jsp";
}
</script>

<div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>帳單類型列表：</b></div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<center>

<%
    ArrayList<Bill> bills = BillMgr.getInstance().
        retrieveListX("status=1 and billType=" + Bill.TYPE_BILLING, "", _ws2.getBunitSpace("bill.bunitId"));
%>
	
<table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02 valign=top>
    	<td valign=middle>內部作業名稱</td>
        <td valign=middle>實際帳單抬頭</td>
        <td valign=middle>逾期未繳金額是<br>
            否倂入新帳單</td>

        <td valign=middle>上次開單月份</td>
        <td  valign=middle width=100></td>
    </tr>
<%
    BillRecordMgr brmgr = BillRecordMgr.getInstance();
    Iterator<Bill> iter = bills.iterator();
    while (iter.hasNext())
    {
        Bill b = iter.next();
        ArrayList<BillRecord> brecords = brmgr.retrieveList("billId="+b.getId(), "order by id desc limit 1");
        String str = "";
        if (brecords.size()>0) {
            BillRecord br = brecords.get(0);
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy年MM月");
            str = sdf.format(br.getMonth()) + "," + br.getName();
        }
%>
<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>

		<td class=es02 nowrap><img src="pic/bill8.png" border=0>&nbsp;<%=b.getName()%>(<a href="javascript:modifyName(<%=b.getId()%>,'<%=phm.util.TextUtil.escapeJSString(b.getName())%>');">修改</a>)</td>
        <td valign=bottom nowrap class=es02><%=(b.getPrettyName()!=null)?b.getPrettyName():""%>(<a href="javascript:modifyPrettyName(<%=b.getId()%>,'<%=phm.util.TextUtil.escapeJSString(b.getPrettyName())%>');">修改</a>)</td>
        <td valign=bottom class=es02 align=center><%=(b.getBalanceWay()==1)?"是":"否"%></td>
        <td valign=bottom class=es02><%=str%></td>
        <td align=middle nowrap class=es02><a href="addBillRecord.jsp?billId=<%=b.getId()%>"><img src="pic/13.png" border=0>&nbsp;
新增帳單</a>&nbsp;&nbsp;&nbsp;</td>
    </tr>
<%
}
%>
    <tr bgcolor=ffffff class=es02 valign=top>
        <td colspan=5>
            <a href="addBill.jsp"><img src="pic/12.png" border=0>&nbsp;設定新的帳單類型</a>
        </td>
    </tr>
</table>
</td></tr></table> 
</center>
