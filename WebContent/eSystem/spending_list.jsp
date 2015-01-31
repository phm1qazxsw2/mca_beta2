<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,mca.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=2;
    int leftMenu=1;
%>
<style type="text/css">

.inputcost{
    background: blue;
    border: 2.5px solid #ffffff
}
.inputincome{
    background: red;
    border: 2.5px solid #ffffff
}

</style>
<%@ include file="topMenu.jsp"%>
<%!
    static DecimalFormat mnf = new DecimalFormat("###,###,##0");
    static DecimalFormat mnf2 = new DecimalFormat("###,###.##");
    String[] accts = { "1", "臺幣現金", "3", "臺幣支票", "4", "USD Cash", "5", "USD Check" };
    public String getAvailableAccounts(User user, String cashacct)
    {
        JsfPay jp=JsfPay.getInstance();
    	Tradeaccount[] tradeAccts = jp.getActiveTradeaccount(user.getId());
        SalarybankAuth[] bankAuths = jp.getSalarybankAuthByUserId(user); 
        BankAccountMgr bamgr = BankAccountMgr.getInstance();
        if (tradeAccts==null && bankAuths==null) {
            return "";
        }
        StringBuffer sb = new StringBuffer();
        sb.append("<select name='cashacct' onchange=\"check_cheque(this)\">");
        sb.append("<option value=''>全部帳戶");
        for (int i=0; tradeAccts!=null && i<tradeAccts.length; i++) {
            if(tradeAccts[i] !=null){
                for (int j=0; j<accts.length; j+=2) {
                    String acctinfo = "$" + accts[j] + "$"+tradeAccts[i].getId();
                    sb.append("<option value='"+acctinfo+"'"+((acctinfo.equals(cashacct))?" selected":"")+">" +
                        accts[j+1] + "－" + tradeAccts[i].getTradeaccountName());
                }
            }
        }
        for (int i=0; bankAuths!=null && i<bankAuths.length; i++) {
            BankAccount bank = (BankAccount) bamgr.find(bankAuths[i].getSalarybankAuthId());
            if(bank !=null)            
                sb.append("<option value='$2$"+bank.getId()+"'>匯款－" + bank.getBankAccountName());
        }

        sb.append("</select>");
        return sb.toString();
    }

    private Map<Integer, Tradeaccount> _tradeacctMap = null;
    private Map<Integer, BankAccount> _bankacctMap = null;
    String getAccountName(int type, int id)
        throws Exception
    {
        if (_tradeacctMap==null) {
            Object[] objs = TradeaccountMgr.getInstance().retrieve("", "");
            ArrayList<Tradeaccount> tlist = new ArrayList<Tradeaccount>();
            for (int i=0; objs!=null&&i<objs.length; i++) {
                tlist.add((Tradeaccount)objs[i]);
            }
            _tradeacctMap = new SortingMap(tlist).doSortSingleton("getId");
        }
        if (_bankacctMap==null) {
            Object[] objs = BankAccountMgr.getInstance().retrieve("", "");
            ArrayList<BankAccount> blist = new ArrayList<BankAccount>();
            for (int i=0; objs!=null&&i<objs.length; i++) {
                blist.add((BankAccount)objs[i]);
            }
            _bankacctMap = new SortingMap(blist).doSortSingleton("getId");
        }
        String suffix = "";
        if (type==3) {
            suffix = "(臺支)";
        }
        else if (type==4) {
            suffix = "(美金)";
        }
        else if (type==5) {
            suffix = "(美支)";
        }
        String name = null;
        if (type==1 || type>=3) {
            Tradeaccount ta = _tradeacctMap.get(id);
            name = ta.getTradeaccountName();
        }
        else {
            BankAccount ba = _bankacctMap.get(id);
            name = ba.getBankAccountName();
        }
        if (suffix.length()>0)
            name += suffix;
        return name;
    }

    double getUSD(Vitem vi, Map<Integer, VPaid> paidMap, Map<Integer, Costpay2> costpayMap)
    {
        VPaid vp = paidMap.get(vi.getId());
        Costpay2 cp = costpayMap.get(vp.getCostpayId());
        //if (cp.getCostpayAccountType()>=4) {
        if (cp.getOrgAmount()>0)
            return cp.getOrgAmount();
        //}
        return 0;
    }

    String getCheckInfo(Vitem vi, Map<Integer, VPaid> paidMap, Map<Integer, Costpay2> costpayMap)
    {
        VPaid vp = paidMap.get(vi.getId());
        Costpay2 cp = costpayMap.get(vp.getCostpayId());
        if (cp.getCostpayAccountType()==3 || cp.getCostpayAccountType()==5) {
            return cp.getCheckInfo();
        }
        return "";
    }

%>
<%
    if(!checkAuth(ud2,authHa,200))
    {
        response.sendRedirect("authIndex.jsp?code=200");
    }
%>
<%@ include file="leftMenu2-new.jsp"%>
<%
    Calendar c = Calendar.getInstance();
    c.add(Calendar.DATE, 7);
    Date end = c.getTime();
    try { end = sdf.parse(request.getParameter("end")); } catch (Exception e) {}
    int paidstatus = 0;
    try { paidstatus = Integer.parseInt(request.getParameter("paidstatus")); } catch (Exception e) {}
    c.setTime(end);
    c.add(Calendar.DATE, 1);
    Date nextEndDay = c.getTime();
    c.add(Calendar.DATE, -22);
    Date start = c.getTime();
    int type=-1;
    try { type=Integer.parseInt(request.getParameter("type")); } catch (Exception e) {}
    try { start = sdf.parse(request.getParameter("start")); } catch (Exception e) {}

    int userId=-1;

    //行政的限制
    if(ud2.getUserRole()>=4){
        userId=ud2.getId();
    }else{
        try { userId=Integer.parseInt(request.getParameter("userId")); } catch (Exception e) {}
    }

    boolean do_border = request.getParameter("do_border")!=null && request.getParameter("do_border").equals("1");


    int verifystatus=-1;
    try { verifystatus=Integer.parseInt(request.getParameter("verifystatus")); } catch (Exception e) {}

    int ctId=-1;
    try { ctId=Integer.parseInt(request.getParameter("ctId")); } catch (Exception e) {}

    String receiptNo = request.getParameter("receiptNo");
    if (receiptNo==null)
        receiptNo = "";
    String payerName = request.getParameter("payerName");
    if (payerName==null)
        payerName = "";
    String keyword = request.getParameter("keyword");
    if (keyword==null)
        keyword = "";
    String ac = request.getParameter("ac");
    if (ac==null)
        ac = "";
    String cashacct = request.getParameter("cashacct");
    if (cashacct==null)
        cashacct = "";

    String query = "recordTime<'" + sdf.format(nextEndDay) + 
        "' and recordTime>='" + sdf.format(start) + "' and total>0";

    if (type>=0)
        query += " and type=" + type;

    if(userId !=-1)
        query+=" and userId="+userId;

    if(verifystatus !=-1)
        query+=" and verifystatus="+verifystatus;

    if(ctId !=-1)
        query+=" and costTradeId="+ctId;

    if (receiptNo.length()>0)
        query += " and receiptNo like '%" + receiptNo + "%'";

    if (payerName.length()>0)
        query += " and payerName like '%" + payerName + "%'";    

    if (keyword.length()>0)
        query += " and (title like '%" + keyword + "%' or note like '%" + keyword + "%')";

    if (ac.length()>0)
        query += " and acctCode like '"+ ac +"%'";

    if (cashacct.length()>0)
        query += " and cashAcct = '"+ cashacct +"'";

System.out.println("## 1");
    VitemMgr vimgr = VitemMgr.getInstance();
    ArrayList<Vitem> vitems = vimgr.retrieveListX(query, "order by recordTime asc", _ws.getBunitSpace("bunitId"));
System.out.println("## 2");
    String backurl = "spending_list.jsp?" + request.getQueryString();
    VoucherMgr vchrmgr = VoucherMgr.getInstance();

    // 下面是為了找收據號
    String vitemIds = new RangeMaker().makeRange(vitems, "getId");
    ArrayList<VPaid> paids = VPaidMgr.getInstance().retrieveList("vitemId in (" + vitemIds + ")", "");
System.out.println("## 3");
    String costpayIds = new RangeMaker().makeRange(paids, "getCostpayId");
    Map<Integer, Costpay2> costpayMap = new SortingMap(Costpay2Mgr.getInstance().
        retrieveList("id in (" + costpayIds + ")", "")).doSortSingleton("getId");
    ArrayList<McaReceipt> receipts = McaReceiptMgr.getInstance().retrieveList("costpayId in (" + costpayIds + ")", "");
System.out.println("## 4");
    Map<Integer, VPaid> paidMap = new SortingMap(paids).doSortSingleton("getVitemId");
    Map<Integer, McaReceipt> receiptMap = new SortingMap(receipts).doSortSingleton("getCostpayId");

    /*
        when list vitems, if vitem has voucherId then we need to do special handling
        1. use its voucher contents to draw
        2. later if encounter vitem using the same voucher, ignore it        
    */
    Map<Integer/*voucherId*/, Vector<Vitem>> voucherMap = null;
    Map<Integer/*voucherId*/, Vector<Voucher>> voucherMap2 = null;
    HashMap<Integer/*voucherId*/, String> _done = new HashMap<Integer/*voucherId*/, String>();
    if (vitems.size()>0) {
        String voucherIds = new RangeMaker().makeRange(vitems, "getVoucherId");
System.out.println("## 4.1 vitems=" + vitems.size() + " voucherIds=" + voucherIds);
        if (voucherIds!=null && voucherIds.length()>0 && !voucherIds.equals("0")) {
            ArrayList<Vitem> vchr_items = 
                vimgr.retrieveList("voucherId in (" + voucherIds + ")", "order by recordTime asc");
System.out.println("## 4.2");
            voucherMap = new SortingMap(vchr_items).doSort("getVoucherId");
            ArrayList<Voucher> vouchers = 
                vchrmgr.retrieveList("id in (" + voucherIds + ")", "");
System.out.println("## 4.3");
            voucherMap2 = new SortingMap(vouchers).doSort("getId");
        }
    }
System.out.println("## 5");

    Object[] users = UserMgr.getInstance().retrieve("", "");
    Map<Integer, Vector<User>> userMap = new SortingMap().doSort(users, new ArrayList<User>(), "getId");
System.out.println("## 6");

    SimpleDateFormat sdf2 = new SimpleDateFormat("MM/dd");
    String title = (type==-1)?"收支":(type==0)?"支":"收";
    _ws.setBookmark(ud2, title + "-" + sdf2.format(start) + "-" + sdf2.format(end));


    Costtrade2Mgr ctm=Costtrade2Mgr.getInstance();
    ArrayList<Costtrade2> ct2=ctm.retrieveList("","order by id desc");
System.out.println("## 7");

    Map<Integer, Costtrade2> ctmap = new SortingMap(ct2).doSortSingleton("getId");
%>
<script src="js/formcheck.js"></script>
<script>
function show_print()
{
    window.open('spending_list_print.jsp');
}

function doSubmit(f)
{
    if (!checkDate(f.start.value,'/')) {
        alert("請輸入正確的開始日期");
        f.start.focus();
        return false;
    }
    if (!checkDate(f.end.value,'/')) {
        alert("請輸入正確的結束日期");
        f.end.focus();
        return false;
    }
    return true;
}

function do_pay()
{
    var e = document.f2.id;
    var ret = '';
    if (typeof e=='undefined') {
        alert("沒有選擇項目");
        return false;
    }
    else if (typeof e.length=='undefined') {
        if (e.checked) {
            ret = e.value;
        }
    }
    else {
        for (var i=0; i<e.length; i++) {
            if (e[i].checked) {
                if (ret.length>0) ret += ",";
                    ret += e[i].value;
            }
        }
    }
    if (ret.length==0) {
        alert("沒有選擇項目");
        return false;
    }
    openwindow_phm('spending_pay.jsp?vid=' + encodeURI(ret) + "&m=1",'收付款',500,400,true);
}

function do_merge()
{
    var e = document.f2.id;
    var ret = '';
    if (typeof e=='undefined') {
        alert("沒有選擇項目");
        return false;
    }
    else if (typeof e.length=='undefined') {
        if (e.checked) {
            ret = e.value;
        }
    }
    else {
        for (var i=0; i<e.length; i++) {
            if (e[i].checked) {
                if (ret.length>0) ret += ",";
                    ret += e[i].value;
            }
        }
    }
    if (ret.length==0) {
        alert("沒有選擇項目");
        return false;
    }
    // openwindow_phm('spending_pay.jsp?vid=' + encodeURI(ret),'合倂',500,400,true);
    return true;
}
</script>
<br>

<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>

<form name="f" action="spending_list.jsp" method="get" onsubmit="return doSubmit(this)">
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;雜費收支總覽</b>
<blockquote>
<!-- for 馬禮遜
形式:
<select name="type">
<option value="-1" <%=(type==-1)?"selected":""%>>全部<option value="0" <%=(type==0)?"selected":""%>>支出<option value="1" <%=(type==1)?"selected":""%>>收入<option value="2" <%=(type==2)?"selected":""%>>進貨
</select>
-->
<input type=hidden name="type" value="-1">
<a href="#" onclick="displayCalendar(document.f.start,'yyyy/mm/dd',this);return false">起:</a><input type=text name="start" value="<%=sdf.format(start)%>" size=6>
&nbsp;&nbsp;<a href="#" onclick="displayCalendar(document.f.end,'yyyy/mm/dd',this);return false">至:</a><input type=text name="end" value="<%=sdf.format(end)%>" size=6>
   

<%
    if(ct2 !=null && ct2.size()>0){
%>
        廠商:<select name="ctId" size=1>
                <option value="-1" <%=(ctId==-1)?"selected":""%>>全部</option>
<%        
        for(int j=0;j<ct2.size();j++){

            Costtrade2 ct=ct2.get(j);
%>
            <option value="<%=ct.getId()%>" <%=(ctId==ct.getId())?"selected":""%>><%=(ct.getCosttradeName()!=null && ct.getCosttradeName().length()>4)?ct.getCosttradeName().substring(0,4)+"..":ct.getCosttradeName()%></option>
<%
        }
%>      
        </select>
<%
    }else{
%>
        <input type="hidden" name="ctId" value="-1">
<%  }   %>

<%
    if(ud2.getUserRole()>=4){
%>
    <input type="hidden" name="userId" value="<%=userId%>">

<%
    }else{
%>

&nbsp;登入人:
<select name="userId" size=1>
    <option value="-1" <%=(userId==-1)?"selected":""%>>全部</option>
<%  for(int j=0;users !=null && j<users.length;j++){    
        User u=(User)users[j];
%>
    <option value="<%=u.getId()%>" <%=(userId==u.getId())?"selected":""%>><%=u.getUserFullname()%></option>        
<%  }   %>
</select> 
<%
    }
%>
<br>
Account#:
<input type=text name="ac" value="<%=ac%>" size=6>
Receipt#:
<input type=text name="receiptNo" value="<%=receiptNo%>" size=6>
&nbsp;&nbsp;PayerName:
<input type=text name="payerName" value="<%=payerName%>" size=8>
<br>Keyword:
<input type=text name="keyword" value="<%=keyword%>" size=13>
&nbsp;&nbsp;
<%=getAvailableAccounts(ud2, cashacct)%>
&nbsp;&nbsp;
<input type=submit value="查詢">
&nbsp;&nbsp;
<input type=checkbox name=do_border value="1" <%=(do_border)?"checked":""%>> 加框(適合匯出格式)
</blockquote>
</form>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  
<br>
<%
    if(checkAuth(ud2,authHa,201)){
%>
<div class=es02>
&nbsp;&nbsp;&nbsp;&nbsp;
<!--<a href="spending_add.jsp?type=0"><img src="pic/costAdd.png" border=0>&nbsp;新增支出</a>
|--> <a href="spending_add.jsp?type=1"><img src="pic/incomeAdd.png" border=0>&nbsp;新增收入</a>
<%
    if(ud2.getUserRole()>=4){
%>
    由於權限不足,僅能顯示自己登入的雜費.
<%  }   %>
</div>

<%  }   %>
<%
    if(vitems==null || vitems.size()==0){
%>
        <center>
        <div class=es02>
            <font color=blue>本次搜尋沒有相關資料.</font>
        </div>
        </center>
        
        <%@ include file="bottom.jsp"%>
<%
        return;
    }
%>
<form name="f2" action="spending_merge.jsp" onsubmit="return do_merge();">
<center>
<input type=hidden name="backurl" value="<%=backurl%>">
<div class=es02 align=right>
    本次搜尋合計:<font color=blue><%=vitems.size()%></font> 筆 | 
<a href="javascript:show_print()">&nbsp;可匯出版本</a>
<!-- | <a href="spending_analysis.jsp?type=<%=type%>&start=<%=sdf.format(start)%>&end=<%=sdf.format(end)%>">雜費統計</a>-->
&nbsp;&nbsp;&nbsp;&nbsp;

</div>

<div id="result">
<table width="96%" height="" border="<%=(do_border)?1:0%>" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
	<table width="100%" border=<%=(do_border)?1:0%> cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
		<td align=middle nowrap>編號</td>
		<td align=middle nowrap>日期</td>
        <td align=middle colspan=2 width=120 nowrap>Title</td>
        <td align=middle width=40 colspan=2 nowrap>Account#</td>
        <td align=middle width=40 nowrap>Receipt#</td>
        <td align=middle width=40 nowrap>PayerName</td>
        <td align=middle width=50 nowrap>登入人</td>
        <td align=middle nowrap>Amount</td>
        <td align=middle nowrap>USD</td>
        <td align=middle nowrap>CheckInfo</td>
        <td align=middle nowrap colspan=2>借方</td>
        <td align=middle nowrap>帳戶</td>
        <td align=middle nowrap>備註</td>
        <td align=middle colspan="2" nowrap>
<%
/*
    if(checkAuth(ud2,authHa,201)){
%>
            <input type=submit value="合倂">
<%
        }
    if(checkAuth(ud2,authHa,202)){
%>
    &nbsp; <input type=button value="收付款" onclick="do_pay();">
<%
    }
*/
%>
        </td>
	</tr>
<%
    int costTotal=0;
    int incomeTotal=0;
    int paytotal=0;
    double usdTotal = 0;

    Iterator<Vitem> iter = vitems.iterator();
    while (iter.hasNext()) {
        Vitem vi = iter.next();
        boolean isPacked = false;
        if (vi.getVoucherId()>0) {
            isPacked = true;
            vi = getMergedInfo(vi, voucherMap, voucherMap2, _done, userMap, backurl,ud2,authHa,ctmap);
            if (vi==null) // already done before, skip
                continue;
        }
        if (paidstatus==2 && vi.getPaidstatus()!=Vitem.STATUS_FULLY_PAID)
            continue;
        String identifier = ((isPacked)?"V":"I") + vi.getId();

        if(vi.getType()==Vitem.TYPE_SPENDING){

            costTotal+=vi.getTotal();
            paytotal-=vi.getRealized();
        }else{
            incomeTotal+=vi.getTotal();
            paytotal+=vi.getRealized();            
        }
        if(!isPacked){
%>
<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight<%=(vi.getType()==Vitem.TYPE_SPENDING)?"2":""%>'"  onmouseout="this.className='normal2'" valign=middle>
        <td class=es02  bgcolor=#ffffff valign=top>
        </td>
        <td class=es02 valign=top align=middle><%=sdf2.format(vi.getRecordTime())%></td>
        <td class=es02 valign=top colspan=2>
            <%
                // Vitem.TYPE_SPENDING, Vitem.TYPE_INCOME
                if(vi.getType()==Vitem.TYPE_SPENDING){
            %>
        &nbsp;<font color=blue><%=identifier%></font>
            <%  }else{  %>
        &nbsp;<font color=red><%=identifier%></font>
            <%  }   %>
            &nbsp;<%=vi.getTitle()%>
        </td>
        <td class=es02 valign=top align=middle nowrap>
        <%
            String[] tokens = vi.getAcctcode().split("-");
            if (tokens.length>0)
                out.println(tokens[0]);
        %>
        </td>
        <td class=es02 valign=top align=middle>
        <%
            if (tokens.length>1)
                out.println(tokens[1]);
        %>
        </td>
        <td class=es02 valign=top align=middle>
            <%=vi.getReceiptNo()%>
        <td class=es02 align=left valign=top>
            <%=vi.getPayerName()%>              
        </td>	
        <td class=es02 align=middle valign=top><%=getUserName(vi.getUserId(), userMap)%>
        </td>
        <td align=right class=es02 valign=middle nowrap>
            <%=mnf.format(vi.getRealized())%>
        </td>  
        <td align=right class=es02 valign=middle nowrap>
            <%
                double usd = getUSD(vi, paidMap, costpayMap);
                usdTotal += usd;
                if (usd>0)
                    out.println(mnf2.format(usd));
            %>
        </td>        
        <td class=es02>
            <%
                out.println(getCheckInfo(vi, paidMap, costpayMap));
            %>
        </td>
        <td class=es02 nowrap>
            1101
        </td>
        <td>
            <%
                VPaid vp = paidMap.get(vi.getId());
                Costpay2 cp = costpayMap.get(vp.getCostpayId());
                out.println("$" + cp.getCostpayAccountType() + "$" + cp.getCostpayAccountId());
            %>
        </td>
        <td class=es02>
            <%=getAccountName(cp.getCostpayAccountType(), cp.getCostpayAccountId())%>
        </td>
        <td class=es02>
            <%=vi.getNote()%>
        </td>
        <td class=es02 align=middle valign=top nowrap>

            <a href="spending_voucher.jsp?id=I<%=vi.getId()%>&backurl=<%=java.net.URLEncoder.encode(backurl)%>">詳細資料</a>

        </td>
<!--
        <td valign=top class=es02 align="<%=(vi.getType()==Vitem.TYPE_SPENDING)?"left":"right"%>">
<%
        if(vi.getVerifystatus()==Vitem.VERIFY_NO){
%>
            <input type=checkbox name="id" value="<%=identifier%>" class="<%=(vi.getType()==Vitem.TYPE_SPENDING)?"inputcost":"inputincome"%>">
<%
        }
%>    
        </td>
-->
    </tr>

<%      }else{  %>
        
            <%=vi.getTitle()%>
<%
        }
    }
%>
    <tr class=es02 bgcolor="#f0f0f0">
        <td colspan=9 align=middle><b>本 次 搜 尋 小 計</b></td>
        <td align=right nowrap>
            <b><%
                if(paytotal <0)
                    out.println("-");
                out.println(mnf.format(Math.abs(paytotal)));
            %></b>
        </td>
        <td align=right><%=mnf2.format(usdTotal)%></td>
        <td></td>
        <td colspan=4 align=center>
<%
/*
    if(checkAuth(ud2,authHa,201)){
%>
            <input type=submit value="合倂">
<%
        }
    if(checkAuth(ud2,authHa,202)){
%>
    &nbsp; <input type=button value="收付款" onclick="do_pay();">
<%
    }
*/
%>

        </td>
    </tr>
    </table> 
</td>
</tr>
</table>
</div>
</form>
</center>

<%
    if(checkAuth(ud2,authHa,201)){
%>
<div class=es02>
&nbsp;&nbsp;&nbsp;&nbsp;<!--<a href="spending_add.jsp?type=0"><img src="pic/costAdd.png" border=0>&nbsp;新增支出</a>
|--> <a href="spending_add.jsp?type=1"><img src="pic/incomeAdd.png" border=0>&nbsp;新增收入</a>
</div>
<%  }   %>
<br>

<%@ include file="bottom.jsp"%>

<%!

    static SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    static SimpleDateFormat sdf2 = new SimpleDateFormat("MM/dd");
    public Vitem getMergedInfo(Vitem vi, 
            Map<Integer, Vector<Vitem>> voucherMap,
            Map<Integer, Vector<Voucher>> voucherMap2,
            Map<Integer/*voucherId*/, String> _done, 
            Map<Integer/*userId*/, Vector<User>> userMap, String backurl,User ud2,Hashtable authHa,Map<Integer, Costtrade2> ctmap) throws Exception
    {
        Integer vchrId = new Integer(vi.getVoucherId());
        if (_done.get(vchrId)!=null)
            return null; // already done
        Vector<Vitem> v = voucherMap.get(vchrId);
        Vitem ret = new Vitem();
        StringBuffer sb = new StringBuffer();

        Voucher vr = voucherMap2.get(vchrId).get(0);

        sb.append("<tr bgcolor=#ffffff align=left  onmouseover=\"this.className='highlight");

        if(vi.getType()==Vitem.TYPE_SPENDING){
            sb.append("2");
        }

        sb.append("'\"  onmouseout=\"this.className='normal2'\" valign=middle>");

        String costbook="";
        
        if(vr.getCostbookId() !=null)
            costbook=vr.getCostbookId();

        if(vi.getType()==Vitem.TYPE_SPENDING){

        sb.append("<td rowspan="+v.size()+" class=es02 valign=top bgcolor=ffffff><img src=\"pic/costticket.png\" width=16>&nbsp;<br><font color=blue>"+costbook+"</font></td>");

        }else{

        sb.append("<td rowspan="+v.size()+" class=es02 valign=top bgcolor=ffffff><img src=\"pic/incometicket.png\" width=16>&nbsp;<br><font color=red>"+costbook+"</font></td>");

        }

        StringBuffer sb2=new StringBuffer();
        
        boolean paid = true;
        int total = 0;
        int realized = 0;

        for (int i=0; i<v.size(); i++) {

            if(i==0)
            {
                sb.append("<td class=es02 align=middle>" + sdf2.format(v.get(i).getRecordTime()) + "</td><td class=es02 colspan=2>");

                if(vi.getType()==Vitem.TYPE_SPENDING){
                    sb.append("&nbsp;<font color=blue>I"+v.get(i).getId()+"</font>&nbsp;&nbsp;"+ v.get(i).getTitle());
                }else{
                    sb.append("&nbsp;<font color=blue>I"+v.get(i).getId()+"</font>&nbsp;&nbsp;"+ v.get(i).getTitle());
                }
                sb.append("</td>");

                String costtradeName="";
                if(v.get(i).getCostTradeId()>0){
                    Costtrade2 ctx=ctmap.get(new Integer(v.get(i).getCostTradeId()));
                    if(ctx !=null)
                        costtradeName=(ctx.getCosttradeName()!=null &&ctx.getCosttradeName().length()>4)?ctx.getCosttradeName().substring(0,4)+"..":ctx.getCosttradeName();

                }

                sb.append("<td  class=es02 align=left width=80 nowrap>"+costtradeName+"</td>");
                sb.append("<td  class=es02 align=middle width=80>"+getUserName(v.get(i).getUserId(), userMap)+"</td>");

            }else{

                sb2.append("<tr bgcolor=#ffffff align=left  onmouseover=\"this.className='highlight");
                
                if(vi.getType()==Vitem.TYPE_SPENDING){
                    sb2.append("2");
                }

                sb2.append("'\"  onmouseout=\"this.className='normal2'\" valign=middle>");

                sb2.append("<td class=es02 align=middle>" + sdf2.format(v.get(i).getRecordTime()) + "</td><td class=es02 colspan=2>");

                if(vi.getType()==Vitem.TYPE_SPENDING){
                    sb2.append("&nbsp;<font color=blue>I"+v.get(i).getId()+"</font>&nbsp;&nbsp;"+ v.get(i).getTitle());
                }else{
                    sb2.append("&nbsp;<font color=blue>I"+v.get(i).getId()+"</font>&nbsp;&nbsp;"+ v.get(i).getTitle());
                }
                sb2.append("</td>");

                String costtradeName="";
                if(v.get(i).getCostTradeId()>0){
                    Costtrade2 ctx=ctmap.get(new Integer(v.get(i).getCostTradeId()));
                    if(ctx !=null)
                        costtradeName=(ctx.getCosttradeName()!=null &&ctx.getCosttradeName().length()>4)?ctx.getCosttradeName().substring(0,4)+"..":ctx.getCosttradeName();
                }
                sb2.append("<td  class=es02 align=left width=80 nowrap>"+costtradeName+"</td>");
                sb2.append("<td align=middle width=80 class=es02>"+getUserName(v.get(i).getUserId(), userMap)+"</td></tr>");

            }

            total += v.get(i).getTotal();
            realized += v.get(i).getRealized();

            if (v.get(i).getPaidstatus()!=Vitem.STATUS_FULLY_PAID)
                paid = false;
        }
        if(vi.getType()==Vitem.TYPE_SPENDING){
        
            sb.append("<td class=es02  bgcolor=#ffffff rowspan="+v.size()+" align=right valign=middle>"+mnf.format(total)+"</td>");
            sb.append("<td class=es02  bgcolor=#ffffff rowspan="+v.size()+" align=right></td>");
        }else{
            sb.append("<td class=es02  bgcolor=#ffffff rowspan="+v.size()+" align=right></td>");
            sb.append("<td class=es02  bgcolor=#ffffff rowspan="+v.size()+" align=right valign=middle>"+mnf.format(total)+"</td>");
        }
        if((total-realized)==0)
        {
            sb.append("<td class=es02 rowspan="+v.size()+" align=right bgcolor=#F77510>");
        }else{
            sb.append("<td class=es02 rowspan="+v.size()+" align=right bgcolor=#4A7DBD>");
        }
        sb.append("<font color=white>");

        if(vi.getType()==Vitem.TYPE_SPENDING &&realized >0){
            sb.append("("+mnf.format(realized)+")");
        }else{
            sb.append(mnf.format(realized));
        }

        if(vi.getVerifystatus()==Vitem.VERIFY_NO){  
            
            sb.append("<td bgcolor=ffffff class=es02 align=middle valign=middle nowrap rowspan="+v.size()+">尚未覆核<br>");

            if(checkAuth(ud2,authHa,204)){

            sb.append("<a href=\"voucher_verify.jsp?id=V"+vchrId+"&status="+Vitem.VERIFY_YES+"&backurl="+java.net.URLEncoder.encode(backurl)+"\">OK</a>|<a href=\"voucher_verify.jsp?id=V"+vchrId+"&status="+Vitem.VERIFY_WARN+"&backurl="+java.net.URLEncoder.encode(backurl)+"\">警示</a>");
            }
        }else if(vi.getVerifystatus()==Vitem.VERIFY_YES){

            sb.append("<td class=es02  bgcolor=ffffff  align=middle valign=middle nowrap rowspan="+v.size()+">OK<br>");

            if(checkAuth(ud2,authHa,204)){
                sb.append("<a href=\"voucher_verify.jsp?id=V"+vchrId+"&status="+Vitem.VERIFY_WARN+"&backurl="+java.net.URLEncoder.encode(backurl)+"\">改為警示</a>");
            }

        }else if(vi.getVerifystatus()==Vitem.VERIFY_WARN){

            sb.append("<td class=es02 align=middle valign=middle bgcolor=red nowrap rowspan="+v.size()+"><font color=white>警示</font><br>");

            if(checkAuth(ud2,authHa,204)){
                sb.append("<a href=\"voucher_verify.jsp?id=V"+vchrId+"&status="+Vitem.VERIFY_YES+"&backurl="+java.net.URLEncoder.encode(backurl)+"\"><font  color=white>改為OK</font></a>");
            }

        } 

        sb.append("</td>");
        sb.append("<td class=es02 bgcolor=#ffffff rowspan="+v.size()+" align=middle nowrap><a href=\"spending_voucher.jsp?id=V"+vchrId+"&backurl="+java.net.URLEncoder.encode(backurl)+"\">詳細資料</a></td>");

        /*
        sb.append("<td class=es02 bgcolor=#ffffff rowspan="+v.size());
        if (vi.getType()==Vitem.TYPE_SPENDING)
            sb.append(" align=left");
        else
            sb.append(" align=right");
        sb.append(">");

        if(vi.getVerifystatus()==Vitem.VERIFY_NO){  
            sb.append("<input type=checkbox name=\"id\" value=\"V"+vchrId+"\" class='"+((vi.getType()==Vitem.TYPE_SPENDING)?"inputcost":"inputincome")+"'>");
        }

        sb.append("</td>");
        */
        sb.append("</tr>");

        sb.append(sb2.toString());
        ret.setTitle(sb.toString());
        ret.setId(vchrId);
        ret.setRecordTime(v.get(0).getRecordTime());
        ret.setType(v.get(0).getType());
        ret.setTotal(total);
        ret.setRealized(realized);
        ret.setBunitId(vi.getBunitId());
        if (paid)
            ret.setPaidstatus(Vitem.STATUS_FULLY_PAID);
        _done.put(vchrId, "");
        // Vitem.TYPE_SPENDING, Vitem.TYPE_INCOME
        return ret;
    }

    public String getUserName(int uid, Map<Integer,Vector<User>> userMap)
    {
        Vector<User> vu = userMap.get(new Integer(uid));
        if (vu==null)
            return "###";

        if(vu.get(0).getUserFullname().length()>0)
            return vu.get(0).getUserFullname();
        else
            return vu.get(0).getUserLoginId();
    }
%>

