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

    BillRecord record = BillRecordMgr.getInstance().find("id="+brid);
    ArrayList<BillItem> bitems = BillItemMgr.getInstance().retrieveList("billId=" + record.getBillId() + 
        " and status=1","order by pos asc");
    Iterator<BillItem> iter2 = bitems.iterator();

    Membr membr = (Membr) MembrMgr.getInstance().find("id=" + sid);
    String thisurl = "billcharge_add.jsp?" + request.getQueryString();
    String backurl = "";
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");

    boolean outsourcing = (pd2.getWorkflow()==2);
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

function checkDate(d) {
    var tokens = d.split("/");
    if (tokens.length!=3)
        return false;
    for (var i=0; i<tokens.length; i++) {
        if (!IsNumeric(tokens[i])) {
            return false;
        }
    }    
    if (tokens[0].length!=4 || tokens[1].length!=2 || tokens[2].length!=2) {
        return false;
    }
    
    return true;
}


function check(f)
{
<% if (outsourcing) { %>
    var fx = document.fx;
    if (typeof fx.executeMembrId=='undefined' || !IsNumeric(fx.executeMembrId.value) || eval(fx.executeMembrId.value)==0) {
        if (!confirm("確定不選擇派員? (材料費不一定要選)"))
            return false;
    }
    f.payrollMembrId.value = fx.executeMembrId.value;
<% } %>

    if (!checkDate(f.feeTime.value)) {
        alert("請輸入正確的日期");
        f.feeTime.focus();
        return false;
    }

    if (!IsNumeric(f.unit.value)) {
        alert("請輸入正確的金額");
        f.unit.focus();
        return false;
    }

    if (!IsNumeric(f.quant.value)) {
        alert("請輸入正確數量");
        f.quant.focus();
        return false;
    }
    return true;
}

function calc_subtotal(f)
{
    var str = f.unit.value + "*" + f.quant.value;
    var v = eval(str);
    document.getElementById("subtotal_" + f.bid.value).innerHTML = v;
}
</script>

<body>
&nbsp;&nbsp;<b>新增收費項目 : <%=record.getName()%> for <%=membr.getName()%></b>
<center>
<br> 
<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
<% if (outsourcing) { %>
    <tr bgcolor="white">
        <td colspan=9>
        <form name=fx>
            <% 
                String field = "executeMembrId"; 
                String extra = "";
            %>
            <%@ include file="manhour_source_setup.jsp"%>
        </form>
        </td>
    </tr>
<% } %>
    <tr bgcolor=#f0f0f0 class=es02>
    	<td width="10">No.</td>
    	<td width=40% nowrap>收費項目</td>
        <td nowrap>日期</td>
        <td nowrap>單價</td>
        <td>x</td>
        <td nowrap>數量</td>
        <td>=</td>
        <td nowrap>&nbsp;&nbsp;&nbsp;小計&nbsp;&nbsp;&nbsp;</td>
        <td></td>
    </tr>
<%    
    int row = 1;
    while (iter2.hasNext())
    {
        BillItem bi = iter2.next();
        if (m.get(new Integer(bi.getId()))==null) {
            String color = bi.getColor();
        %>
    <form name="f<%=bi.getId()%>" action="billcharge_add_adv2.jsp" onsubmit="return check(this);">
    <input type=hidden name="bid" value="<%=bi.getId()%>">
    <input type=hidden name="brid" value="<%=brid%>">
    <input type=hidden name="sid" value="<%=sid%>">
    <input type=hidden name="payrollMembrId" value="0">
    <tr bgcolor=white class=es02 valign=center height=30>
    	<td width="10" <%=(color!=null&&color.length()>0)?"bgcolor="+color:""%>><%=row++%></td>
        <td nowrap><%=bi.getName()%></td>
        <td><input type=text size=7 name="feeTime" value="<%=sdf.format(new Date())%>"></td>
        <td>
            <input type=text name="unit" value="<%=bi.getDefaultAmount()%>" size=3 onblur="calc_subtotal(this.form)">
        </td>
        <td>x</td>
        <td>
            <input type=text name="quant" value="1" size=2 onblur="calc_subtotal(this.form)">
        </td>
        <td>=</td>
        <td>
            <div id="subtotal_<%=bi.getId()%>"><%=bi.getDefaultAmount()%></div>
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
