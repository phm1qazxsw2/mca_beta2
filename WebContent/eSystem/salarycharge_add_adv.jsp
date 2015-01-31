<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    if(!checkAuth(ud2,authHa,301))
    {
        response.sendRedirect("authIndex.jsp?code=301");
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
    ArrayList<BillItem> bitems = BillItemMgr.getInstance().retrieveList("billId=" + record.getBillId()+ 
        " and status=1","");
    Iterator<BillItem> iter2 = bitems.iterator();

    Membr membr = (Membr) MembrMgr.getInstance().find("id=" + sid);
    String thisurl = "salarycharge_add_adv.jsp?" + request.getQueryString();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
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
<div class=es02>
&nbsp;&nbsp;<b>新增薪資項目 : <%=record.getName()%> for <%=membr.getName()%></b>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<div class=es02>&nbsp;&nbsp;&nbsp;
<a href="salarybillitem_add.jsp?billId=<%=record.getBillId()%>&backurl=<%=java.net.URLEncoder.encode(thisurl)%>"><img src="pic/add.gif" border=0 width=12>&nbsp;建立新的薪資項目</a>
</div>
<center>
<br> 
<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
    	<td width=40% nowrap>薪資項目</td>
        <td nowrap>類型</td>
        <td nowrap>日期</td>
        <td nowrap>單價</td>
        <td>x</td>
        <td nowrap>數量</td>
        <td>=</td>
        <td nowrap>&nbsp;&nbsp;&nbsp;小計&nbsp;&nbsp;&nbsp;</td>
        <td></td>
    </tr>
<%    
    while (iter2.hasNext())
    {
        BillItem bi = iter2.next();
        if (m.get(new Integer(bi.getId()))==null) {
        %>
    <form name="f<%=bi.getId()%>" action="salarycharge_add_adv2.jsp" onsubmit="return check(this);">
    <input type=hidden name="bid" value="<%=bi.getId()%>">
    <input type=hidden name="brid" value="<%=brid%>">
    <input type=hidden name="sid" value="<%=sid%>">
    <tr bgcolor=white class=es02 valign=center height=30>
        <td nowrap><%=bi.getName()%></td>
        <td nowrap>
            <%
                switch(bi.getSmallItemId()){
                    case BillItem.SALARY_PAY:
                        out.println("+ 應付");                            
                        break;
                    case BillItem.SALARY_DEDUCT1:
                        out.println("- 代扣");
                        break;
                    case BillItem.SALARY_DEDUCT2:
                        out.println("- 應扣");
                        break;
                    default:
                        out.println(bi.getSmallItemId());        
                }
            %>
        </td>
        <td><input type=text size=7 name="feeTime" value="<%=sdf.format(new Date())%>"></td>
        <td>
            <input type=text name="unit" size=3 onblur="calc_subtotal(this.form)">
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

<br>
<br>
</blockquote>


</body>
