<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    if(!checkAuth(ud2,authHa,102))
    {
        response.sendRedirect("authIndex.jsp?code=102");
    }
    int brid = Integer.parseInt(request.getParameter("brid"));
    int sid = Integer.parseInt(request.getParameter("sid"));

    EzCountingService ezsvc = EzCountingService.getInstance();

    // save those billitem that use already has
    ArrayList<ChargeItemMembr> citems = ChargeItemMembrMgr.getInstance().
        retrieveList("chargeitem.billRecordId=" + brid + " and membr.id=" + sid, "");

    Iterator<ChargeItemMembr> iter = citems.iterator();
    Map m = new HashMap();
    for (int i=0; iter.hasNext(); i++) {
        ChargeItemMembr ci = iter.next();
        m.put(new Integer(ci.getBillItemId()), ci);
    }

    BillRecordInfo record = BillRecordInfoMgr.getInstance().findX("billrecord.id="+brid, _ws2.getBunitSpace("bunitId"));

    if (record==null) {
        %><script>alert("資料不存在");history.go(-1)</script><%
        return;
    }

    ArrayList<BillItem> bitems = BillItemMgr.getInstance().retrieveList("billId=" + record.getBillId(),"order by pos asc");
    Iterator<BillItem> iter2 = bitems.iterator();

    Membr membr = (Membr) MembrMgr.getInstance().find("id=" + sid);
    String thisurl = "billcharge_add.jsp?" + request.getQueryString();
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

function check(f)
{
    if (!IsNumeric(f.amount.value)) {
        alert("請輸入正確金額");
        f.amount.focus();
        return false;
    }
    return true;
}
</script>

<body>
&nbsp;&nbsp;<b>新增收費項目 : <%=record.getName()%> for <%=membr.getName()%></b>

<br> 
<div align=right class=es02>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</div>
<center>
<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
    	<td width="10">No.</td>
    	<td width=60%>收費項目</td>
        <td nowrap width=20%>金額</td>
        <td width=20%></td>
    </tr>
<%    
    int row = 1;
    while (iter2.hasNext())
    {
        BillItem bi = iter2.next();
        if (mca.McaService.isSystemCharge(bi.getName())) 
            continue;
        if (bi.getStatus()!=BillItem.STATUS_ACTIVE)
            continue;
        if (m.get(new Integer(bi.getId()))==null) {
            String color = bi.getColor(); 
        %>
    <form action="billcharge_add2.jsp" onsubmit="return check(this);">
    <input type=hidden name="bid" value="<%=bi.getId()%>">
    <input type=hidden name="brid" value="<%=brid%>">
    <input type=hidden name="sid" value="<%=sid%>">
    <tr bgcolor=white class=es02 valign=center height=30>
    	<td width="10" <%=(color!=null&&color.length()>0)?"bgcolor="+color:""%>><%=row++%></td>
        <td><%=bi.getName()%></td>
        <td nowrap>
         <% if (bi.getPitemId()>0) { %>
            <input type=text name="num" value="1" size=1>個共
            <input type=text name="amount" value="<%=bi.getDefaultAmount()%>" size=2>元
         <% } else { %>
            <input type=text name="amount" value="<%=bi.getDefaultAmount()%>" size=8>
         <% } %>
        </td>
        <td nowrap><input type=submit value="新增"></td>
    </tr>
    </form>
<%  
        }
    }
%>
    </table>
    </td></tr>
</table>
 
</center>


<blockquote>
<div class=es02>
<a href="addBillItem.jsp?billId=<%=record.getBillId()%>&backurl=<%=java.net.URLEncoder.encode(thisurl)%>"><img src="pic/add.gif" border=0>&nbsp;建立新的收費項目</a>
</div>
<br>
<br>
</blockquote>


</body>
