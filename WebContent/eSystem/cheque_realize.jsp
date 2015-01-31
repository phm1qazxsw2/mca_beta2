<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%!
    public String getAvailableAccounts(User user, boolean in)
    {
        JsfPay jp=JsfPay.getInstance();
        SalarybankAuth[] bankAuths = jp.getSalarybankAuthByUserId(user); 
        BankAccountMgr bamgr = BankAccountMgr.getInstance();
        if (bankAuths==null) {
            return "沒有任何可以收付款的帳戶";
        }
        StringBuffer sb = new StringBuffer();
        sb.append("<select name='acct'>");
        sb.append("<option value=''>--請選擇一" + ((in)?"存入":"提出") + "帳戶--");
        for (int i=0; bankAuths!=null && i<bankAuths.length; i++) {
            BankAccount bank = (BankAccount) bamgr.find(bankAuths[i].getSalarybankAuthId());
            sb.append("<option value='2,"+bank.getId()+"'>銀行－" + bank.getBankAccountName());
        }
        sb.append("</select>");
        return sb.toString();
    }

    SimpleDateFormat sdf2 = new SimpleDateFormat("MM");
    String getDescription(Cheque ch)
    {
        ArrayList<BillPaidInfo> paids = BillPaidInfoMgr.getInstance().
            retrieveList("billpay.chequeId=" + ch.getId(), "");

        String desc = ch.getTitle();
        if (desc==null)
            desc = "";
        if (paids.size()>0) {
            Iterator<BillPaidInfo> iter = paids.iterator();
            while (iter.hasNext()) {
                BillPaidInfo bp = iter.next();
                if (desc.length()>0) desc += "<br>";
                desc += "　　銷 " + sdf2.format(bp.getBillMonth()) + "月 " + bp.getBillPrettyName() + bp.getPaidAmount();
            }
        }
        return desc;
    }
%>
<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    DecimalFormat mnf = new DecimalFormat("###,###,##0");
    String chequeId = request.getParameter("id");
    Cheque ch = ChequeMgr.getInstance().findX("id=" + chequeId, _ws2.getBunitSpace("bunitId"));

    if (ch==null) {
        %><script>alert("資料不存在");history.go(-1)</script><%
        return;
    }

    boolean in = (ch.getType()==Cheque.TYPE_INCOME_TUITION) || (ch.getType()==Cheque.TYPE_SPENDING_INCOME);
%>

<body>
<div class=es02>
&nbsp;&nbsp;&nbsp;<img src="pic/cheque.png" border=0>&nbsp;<b>兌現支票:-<%=getDescription(ch)%></b>
</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  

<br>
<form action="cheque_realize2.jsp" method=post onsubmit="return check(this);">
<input type=hidden name="chequeId" value="<%=ch.getId()%>">
<center>
<table width="96%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
        <td><%=(in)?"存入":"兌現"%>日期:</td>
        <td bgcolor=#ffffff><input type=text name="payDate" value="<%=sdf.format(new Date())%>" size=7></td>
    </tr>       
	<tr bgcolor=#f0f0f0 class=es02>
        <tD><%=(in)?"存入":"兌現"%>帳戶:</td>
        <tD bgcolor=#ffffff><%=getAvailableAccounts(ud2, in)%></tD>
    </tr>
	<tr bgcolor=#f0f0f0 class=es02>
        <tD><%=(in)?"存入":"兌現"%>金額:</td>
        <% int amount = (in)?ch.getInAmount():ch.getOutAmount(); %>
        <td bgcolor=#ffffff><%=mnf.format(amount)%>
            <input type=hidden name="amount" value="<%=amount%>"></td>
    </tr>
	<tr bgcolor=#f0f0f0 class=es02>
        <tD>備註:</td>
        <td bgcolor=#ffffff>
            <textarea name="ps" cols=40 rows=3></textarea>
        </td>
    </tr>
	<tr class=es02>
        <td colspan=2 align=middle>
            <input type=submit value="<%=(in)?"存入":"提出"%>">
        </td>
    </tr>
    </table>
    </td>
    </tr>
    </table>
</form>

</center>

<script src="js/formcheck.js"></script>
<script>
function check(f)
{
    var a = f.acct;
    if (!checkDate(f.payDate.value, '/')) {
        alert("請輸入正確日期");
        return false;
    }
    if (typeof a=='undefined') {
        alert("沒有可收付的銀行帳戶");
        return false;
    }
    if (a.selectedIndex==0) {
        alert("請選擇一帳戶<%=(in)?"存入":"提出"%>");
        return false;
    }

    return true;
}
</script>

</body>


