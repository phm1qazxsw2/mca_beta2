<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%!
    static SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    public String getAvailableAccounts(User user)
    {
        JsfPay jp=JsfPay.getInstance();
    	Tradeaccount[] tradeAccts = jp.getActiveTradeaccount(user.getId());
        SalarybankAuth[] bankAuths = jp.getSalarybankAuthByUserId(user); 
        BankAccountMgr bamgr = BankAccountMgr.getInstance();
        if (tradeAccts==null && bankAuths==null) {
            return "沒有任何可以收付款的帳戶";
        }
        StringBuffer sb = new StringBuffer();
        sb.append("<select name='acct' onchange=\"check_cheque(this)\">");
        sb.append("<option value=''>--請選擇一付款帳戶--");
        for (int i=0; tradeAccts!=null && i<tradeAccts.length; i++) {
            if(tradeAccts[i] !=null){
                sb.append("<option value='1,"+tradeAccts[i].getId()+"'>現金－" + tradeAccts[i].getTradeaccountName());
            }
        }
        for (int i=0; bankAuths!=null && i<bankAuths.length; i++) {
            BankAccount bank = (BankAccount) bamgr.find(bankAuths[i].getSalarybankAuthId());
            if(bank !=null)            
                sb.append("<option value='2,"+bank.getId()+"'>匯款－" + bank.getBankAccountName());
        }
        // 2009/3/9 by peter, 大家應該都可用支票收付，跟看不看得到支票內容無關
        //if(user.getUserRole()<=3){
            sb.append("<option value='3'>支票");
        //}
        sb.append("</select>");

        sb.append("<span id=\"chequeinfo\" style=\"visibility:hidden\">");
        sb.append("    支票號碼:");
        sb.append("    <input type=text name=\"chequeId\" value=\"\" size=7>");
        sb.append("    兌現日期:");
        sb.append("    <input type=text name=\"cashDate\" value=\""+sdf.format(new Date())+"\" size=7>");
        sb.append("    <input type=hidden name=\"bankType\" value=\"3\">");
        sb.append("</span>");

        return sb.toString();
    }

    ArrayList<Vitem> getMergedVitems(String vids)
        throws Exception
    {
        VitemMgr vimgr = VitemMgr.getInstance();
        VoucherMgr vchrmgr = VoucherMgr.getInstance();

        String[] tokens = vids.split(",");
        ArrayList<Vitem> ret = new ArrayList<Vitem>();
        for (int i=0; i<tokens.length; i++) {
            if (tokens[i].charAt(0)=='I')
                ret.add(vimgr.find("id=" + tokens[i].substring(1)));
            else {
                Voucher v = vchrmgr.find("id=" + tokens[i].substring(1));
                ArrayList<Vitem> tmp = vimgr.retrieveList("voucherId=" + v.getId(), "");
                for (int j=0; j<tmp.size(); j++)
                    ret.add(tmp.get(j));
            }
        }
        for (int i=0; i<ret.size()-1; i++) {
            if (ret.get(i).getType()!=ret.get(i+1).getType())
                throw new Exception("收付款不可同時包含收支");
        }
        return ret;
    }
%>
<%
try {

    if(!checkAuth(ud2,authHa,202)){
        response.sendRedirect("authIndex.jsp?code=202");
    }

    DecimalFormat mnf = new DecimalFormat("###,###,##0");
    String vids = request.getParameter("vid");

    ArrayList<Vitem> vitems = null;
    if (request.getParameter("m")!=null&&request.getParameter("m").equals("1"))
        vitems = getMergedVitems(vids);
    else
        vitems = VitemMgr.getInstance().retrieveList("id in (" + vids + ")", "");

    Iterator<Vitem> iter = vitems.iterator();
    int type = vitems.get(0).getType();
    String name;
    if (type==Vitem.TYPE_SPENDING || type==Vitem.TYPE_COST_OF_GOODS)
        name = "付款";
    else 
        name = "收款";
    int unpaid_amount = 0;
%>

<body>
<form name=f1 action="spending_pay2.jsp" method=post onsubmit="return check(this);">
<div class=es02>
&nbsp;&nbsp;&nbsp;<img src="pic/costticket.png" border=0>&nbsp;<b>傳票明細:</b>
</div>

<center>
<table width="96%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
	
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
		<td align=middle nowrap width=50>編號</td>
        <td align=middle>日期</td>
        <td align=middle>明細</td>
        <td align=middle nowrap width=70>帳面金額</td>
        <td align=middle nowrap width=70>已付金額</td>
        <td align=middle nowrap width=70>未付金額</td>
	</tr>
<%
    int totalbook=0;
    int totalpay=0;

    Date d = null;
    while (iter.hasNext()) {
        Vitem vi = iter.next();
        totalbook+=vi.getTotal();
        totalpay+=vi.getRealized();
        unpaid_amount += (vi.getTotal()-vi.getRealized());
        d = vi.getRecordTime();
%>
    <input type=hidden name="vid" value="<%=vi.getId()%>">
    <tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
        <td class=es02>I<%=vi.getId()%></td>
        <td class=es02><%=sdf.format(vi.getRecordTime())%></td>	
        <td class=es02 width=60%><%=vi.getTitle()%></td>	
        <td class=es02 align=right><%=mnf.format(vi.getTotal())%></td>  
        <td class=es02 align=right><%=mnf.format(vi.getRealized())%></td>  
        <td class=es02 align=right><%=mnf.format(vi.getTotal()-vi.getRealized())%></td>  
    </tr>	
<%
    }
%>
    <tr class=es02>
        <td colspan=2 align=middle>
            <%=(type==1)?"小計:":"小計:"%>
        </td>
        <td align=right>
            <%=mnf.format(totalbook)%>
        </td>
        <%  if((unpaid_amount)!=0){ %>
            <td bgcolor=#4A7DBD align=right class=es02 valign=bottom>

        <%  }else{  %>
            <td bgcolor=#F77510 align=right class=es02 valign=bottom>
        <%  }   %>
        <font color=white><%=mnf.format(totalpay)%></font></td>
        <td align=right>
            <b><%=mnf.format(unpaid_amount)%></b>
        </tD>
    </tr>
    </table> 
</td>
</tr>
</table>
</center>
<br>

<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>

<div class=es02>&nbsp;&nbsp;&nbsp;<img src="pic/costSpend.png" border=0>&nbsp;<b>雜費<%=name%>:</b></div>
<center>
<table width="96%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
        <td><%=name%>日期:</td>
        <td bgcolor=#ffffff><input type=text name="payDate" value="<%=sdf.format(d)%>" size=7>
        &nbsp;&nbsp;&nbsp;<a href="#" onclick="displayCalendar(document.f1.payDate,'yyyy/mm/dd',this);return false"><img src="pic/blog4.gif" border=0></a>        
        </td>
    </tr>       
	<tr bgcolor=#f0f0f0 class=es02>
        <tD><%=name%>帳戶:</td>
        <tD bgcolor=#ffffff><%=getAvailableAccounts(ud2)%></tD>
    </tr>
	<tr bgcolor=#f0f0f0 class=es02>
        <tD><%=name%>金額:</td>
        <td bgcolor=#ffffff><input type=text name="amount" value="<%=unpaid_amount%>" size=5></td>
    </tr>
	<tr bgcolor=#f0f0f0 class=es02>
        <tD>備註:</td>
        <td bgcolor=#ffffff>
            <textarea name="ps" cols=40 rows=3></textarea>
        </td>
    </tr>
	<tr class=es02>
        <td colspan=2 align=middle>
            <input type=hidden name="type" value="<%=type%>">
            <input type=submit value="<%=name%>">
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
function check_cheque(s)
{
    if (s.options[s.selectedIndex].value==3)
        document.getElementById('chequeinfo').style.visibility= 'visible';
    else 
        document.getElementById('chequeinfo').style.visibility= 'hidden';
}

var unpaid_amount = <%=unpaid_amount%>;
function check(f)
{
    var a = f.acct;
    if (typeof a=='undefined') {
        alert("沒有可收付的帳戶");
        return false;
    }
    if (a.selectedIndex==0) {
        alert("請選擇一帳戶轉出");
        return false;
    }
    var v = f.amount.value;
    if (v>unpaid_amount) {
        alert("金額不可大於未付金額");
        return false;
    }
    if (document.getElementById('chequeinfo').style.visibility=='visible') {
        if (f.chequeId.value.length==0) {
            alert("請輸入支票號碼");
            f.chequeId.focus();
            return false;
        }
    }
    if (typeof f.cashDate!='undefined') {
        if (!checkDate(f.cashDate.value, '/')) {
            alert("請輸入正確的兌現日期的格式");
            f.checkDate.focus();
            return false;
        }
    }
    return true;
}
</script>

</body>

<%
}
catch (Exception e) {
    if (e.getMessage()!=null) {
     %><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>'); parent.location.reload();</script><%
    } else {
        e.printStackTrace();
    }
}
%>
