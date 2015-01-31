<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,java.io.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%!
    public String isCheck(int rid1, int rid2)
    {
        if (rid1==-1)
            return "checked";
        else {
            if (rid1==rid2)
                return "checked";
        }
        return "";
    }
%>
<%
    if (pd2.getPagetype()==7) {
        response.sendRedirect("mca_otc_pay.jsp?" + request.getQueryString());
        return;
    }

    //##v2
    if(!checkAuth(ud2,authHa,103))
    {
        response.sendRedirect("authIndex.jsp?code=103");
    }
    
    int sid = Integer.parseInt(request.getParameter("sid"));
    boolean input = true;
    try { input = !request.getParameter("input").equals("no"); } catch (Exception e) {}
    int rid = -1;
    try { rid=Integer.parseInt(request.getParameter("rid")); } catch (Exception e) {}
    Membr membr = MembrMgr.getInstance().findX("id="+sid, _ws2.getStudentBunitSpace("bunitId"));

    if (membr==null) {
        %><script>alert("資料不存在");history.go(-1)</script><%
        return;
    }

    MembrInfoBillRecordMgr simgr = MembrInfoBillRecordMgr.getInstance();
    ArrayList<MembrInfoBillRecord> bills = simgr.retrieveListX("membrId=" + sid + 
        " and paidStatus in (0,1) and billType=" + Bill.TYPE_BILLING, "order by billRecordId asc", 
        _ws2.getAcrossBillBunitSpace("bill.bunitId"));
        // 要能付 cover 單位的帳單

    // 帳戶餘額
    EzCountingService ezsvc = EzCountingService.getInstance();
    BillPayMgr bpmgr = BillPayMgr.getInstance();
    int remain = (int) ezsvc.getMembrRemain(sid);

    DecimalFormat mnf = new DecimalFormat("##,####,##0");
    DecimalFormat mnf2 = new DecimalFormat("########0");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月");
    SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy/MM/dd");
    User ud4 = WebSecurity.getInstance(pageContext).getCurrentUser();
    JsfPay jp=JsfPay.getInstance(); 
    Tradeaccount[] tradeA=jp.getActiveTradeaccount(ud4.getId());
    SalarybankAuth[] bankAuths = jp.getSalarybankAuthByUserId(ud2); 
    BankAccountMgr bamgr = BankAccountMgr.getInstance();

%>
<script type="text/javascript" src="js/check.js"></script>
<script type="text/javascript" src="js/string.js"></script>
<script type="text/javascript" src="js/dateformat.js"></script>
<script type="text/javascript" src="js/formcheck.js"></script>
<script>
function calc_sum_aux()
{
    var r = document.f1.rid;
    if (typeof r == 'undefined')
        return 0;
    if (typeof r.length=='undefined') {
        if (r.checked) {
            return amount[r.value];
        }
    }
    else {
        var sum = 0;
        for (var i=0; i<r.length; i++) {
            if (r[i].checked)
                sum += amount[r[i].value];
        }
        return sum;
    }
    return 0;
}

function paywayChanged(s)
{
    var acct_text = document.getElementById("acct_text");
    var acct_info = document.getElementById("acct_info");
    if (s.selectedIndex==0) { // 現金
        acct_info.innerHTML = "零用金帳戶";
        acct.innerHTML = acct_text.innerHTML; 
    }
    else if (s.selectedIndex==1) {
        acct_info.innerHTML = "支票資料";
        acct.innerHTML = acct_cheque.innerHTML;
    }
    else if (s.selectedIndex==2 || s.selectedIndex==3) {
        acct_info.innerHTML = "銀行帳戶";
        acct.innerHTML = acct_bank.innerHTML;
    }
}

function calc_sum()
{
    var d = document.getElementById("sum");
    var sum = calc_sum_aux();
    d.innerHTML =  sum + "元";

    d = document.getElementById("payfield");
    var p = document.getElementById("payway");
    var sms = document.getElementById("sms");
    var sms_text = document.getElementById("sms_text");
    var acct_text = document.getElementById("acct_text");
    var acct_info = document.getElementById("acct_info");
    var subm = document.getElementById("submit");
    var acct = document.getElementById("acct");
    if (sum==0) {
        d.innerHTML = "";
        subm.innerHTML = "";
    }
    else if (remain>0 || <%=!input%>) {
        d.innerHTML = "0<input type=hidden name=payMoney value=0>";
        p.innerHTML = "帳戶餘額沖款<input type=hidden name=paywayX value=0>";
        __oldtext = sms.innerHTML;
        sms.innerHTML = "不發送簡訊";
        subm.innerHTML = "<img src='pic/feeIn.png' border=0><input type='submit' name='submitbutton' value='沖帳'>";
        var b = document.f1.submitbutton;
        b.value = "沖帳";
        acct.innerHTML = "無";
    }
    else {
        d.innerHTML = "<input type=text name=payMoney size=10 value='"+(sum-remain)+"'>";
        p.innerHTML = "<select size=1 name='paywayX' onchange='paywayChanged(this)'><option value=1 selectd>現金</option><option value=2>支票</option> <option value=3>匯款</option><option value=4>信用卡</option></select>";

        sms.innerHTML = sms_text.innerHTML;
        subm.innerHTML = "<img src='pic/feeIn.png' border=0><input type='submit' name='submitbutton' value='繳款'>";
        var b = document.f1.submitbutton;
        b.value = "繳款";
        acct_info.innerHTML = "零用金帳戶";
        acct.innerHTML = acct_text.innerHTML;
    }
}
var amount = new Array;
var remain = <%=remain%>;

function checkForm(f)
{
    if (!isDate(f.recordTime.value, "yyyy/MM/dd")) {
        alert("請輸入正確的入帳日期");
        f.recordTime.focus();
        return false;
    }
    if (typeof f.issueBank!='undefined' && trim(f.issueBank.value).length==0) {
        alert("請輸入支票發出銀行");
        f.issueBank.focus();
        return false;
    }
    if (typeof f.chequeId!='undefined') {
        if (f.chequeId.value.length==0) {
            alert("請輸入支票號碼");
            f.chequeId.focus();
            return false;
        }
    }
    if (typeof f.cashDate!='undefined') {
        if (!isDate(f.cashDate.value,"yyyy/MM/dd")) {
            alert("請輸入正確的支票日期");
            f.cashDate.focus();
            return false;
        }
    }
    
    return true;
}
</script>

<body onload="calc_sum()">
<br>
<div class=es02><b>&nbsp;&nbsp;&nbsp;&nbsp;<%=membr.getName()%>-臨櫃繳款</b>

<%
    if (tradeA==null) {
%>
        <blockquote>
        <br> 
            <div class=es02>您還沒有設定現金帳戶，不能收款.</div>
        </blockquote>
<%
        return;
    }

%>
<form name=f1 action="otc_pay_all2.jsp" method="post" onsubmit="return checkForm(this)"> 
<input type=hidden name="sid" value="<%=sid%>">
<center>
<table width="450" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

    <table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#ffffff align=left valign=middle class=es02>
        <td width=150 align=middle valign=middle bgcolor=#f0f0f0>
            繳款帳單
        </td>
        <td colspan=3>
        <%
        Iterator<MembrInfoBillRecord> iter = bills.iterator();
        while (iter.hasNext()) {
            MembrInfoBillRecord sinfo = iter.next();
        %>
            <input type=checkbox name='rid' value='<%=sinfo.getBillRecordId()%>' <%=isCheck(rid,sinfo.getBillRecordId())%> onclick='calc_sum()'>
            <%=sdf.format(sinfo.getBillMonth())%> <%=sinfo.getBillPrettyName()%> 
            (餘額<%=mnf2.format(sinfo.getReceivable()-sinfo.getReceived())%> 元)<br>
            <script>amount[<%=sinfo.getBillRecordId()%>]=<%=sinfo.getReceivable()-sinfo.getReceived()%>;</script>
        <%  }
        %>
        </td>
    </tr>
	<tr bgcolor=#ffffff align=left valign=middle>
        <td width=200 rowspan=3 colspan=2 align=middle valign=middle>
            <div id="payPic">
            <%
                String filePath2 = request.getRealPath("./")+"accountAlbum/"+tradeA[0].getId();
                File FileDic2 = new File(filePath2);
                File files2[]=FileDic2.listFiles();
            
                File xF2=null; 
                
                if(files2 !=null)
                { 
                    for(int j2=0;j2<files2.length;j2++)
                    { 
                        if(!files2[j2].isHidden())
                            xF2 =files2[j2] ;
                    } 
                }
                
                if(xF2 !=null && xF2.exists())
                {			
            %>
                    <img src="accountAlbum/<%=tradeA[0].getId()%>/<%=xF2.getName()%>" width=150 border=0>
            <%	
                }else{
            %>
                    <img src="pic/nocontent.gif" border=0>
            <%
                }
            %>
            </div>
        </td>
		<td bgcolor=#f0f0f0 class=es02 width=100>應繳金額</td>
		<td class=es02 width=120>
            <div id="sum"></div>
        </td>
	</tr>
	<tr bgcolor=#ffffff align=left valign=middle>        
		<td bgcolor=#f0f0f0 class=es02 height="40">帳戶餘額</td>
		<tD class=es02>
		    <%=remain%>
        </td>
	</tr>
	<tr bgcolor=#ffffff align=left valign=middle>        
		<td bgcolor=#f0f0f0 class=es02 height="40">本次收款</td>
		<td class=es02>
		    <div id="payfield"></a>
        </td>
	</tr>

    <tr bgcolor=#f0f0f0 align=left valign=middle>
		<td class=es02 nowrap rowspan=2>
          <div id="acct_info">零用金帳戶</div>
        </td>
		<td bgcolor=ffffff width=150 class=es02 rowspan=2> 
          <div id="acct">
          </div>
		</td>
		<td class=es02 nowrap>付款方式</td>
		<td  bgcolor=ffffff class=es02> 
            <div id="payway"></div>
		</td>
	</tr>	
    <tr bgcolor=#f0f0f0 align=left valign=middle>
		<td class=es02 nowrap>入帳日期</td>
		<td  bgcolor=ffffff class=es02> 
            <input type=text name='recordTime' value='<%=sdf2.format(new Date())%>' size=7>
		</td>
    </tr>

    <tr bgcolor=#f0f0f0 class=es02> 
	    <td nowrap>
                簡訊發送狀態<br>                
        </td>
		<td bgcolor=#ffffff class=es02 width=150>
            <div id="sms">
            </div>
	    </td>
	    <td colspan=2 class=es02 bgcolor=ffffff>
            <center>
            <div id="submit">
            </div>
            </center>
        </td>
    </tr>

    <tr bgcolor=#f0f0f0 class=es02> 
	    <td nowrap>
                附註<br>                
        </td>
	    <td colspan=3 class=es02 bgcolor=ffffff>
            <textarea name="note" rows=3 cols=30></textarea>
        </td>
    </tr>
    
    </table>
</td>
</tr>
</table>

</center>
</form>

<div id="acct_text" style="visibility:hidden">
    <select name="tradeAccount" size=1  onChange="showPicFrom('1',this.form.tradeAccount.value,'payPic')">
    <% 
        for(int i=0;i<tradeA.length;i++)
        {
            if(tradeA !=null){ 
    %>  <option value="<%=tradeA[i].getId()%>"><%=tradeA[i].getTradeaccountName()%></option><%
            }
        }
    %>
    </select>
    <input type=hidden name="bankType" value="1"> 
</div>

<div id="acct_bank" style="visibility:hidden">
    <select name="bankAccount" size=1  onChange="showPicFrom('2',this.form.bankAccount.value,'payPic')">
    <% 
        for (int i=0; bankAuths!=null && i<bankAuths.length; i++) {
            BankAccount bank = (BankAccount) bamgr.find(bankAuths[i].getSalarybankAuthId());

            if(bank != null){
    %>  <option value="<%=bank.getId()%>"><%=bank.getBankAccountName()%></option><%
            }
        }
    %>
    </select>
    <input type=hidden name="bankType" value="2"> 
</div>

<div id="acct_cheque" style="visibility:hidden">
    發票銀行:<br>
    <input type=text name="issueBank" value="" size=7><br>
    支票號碼:<br>
    <input type=text name="chequeId" size=7><br>
    兌現日期:<br>
    <input type=text name="cashDate" value="<%=sdf2.format(new Date())%>" size=7>
    <input type=hidden name="bankType" value="3"> 
</div>


<div id="sms_text" style="visibility:hidden">
    <table border=0 class=es02>
      <tr class=es02>
        <td valign=middle>    
        <%
        PaySystem ps = (PaySystem) ObjectService.find("jsf.PaySystem","id=1");
        if(ps.getPaySystemMessageActive()==1) 
        {
        %>  
            <img src="pic/yes2.gif"  border=0 alt='發送'><br>
        <%
        }else{
        %>
            <img src="pic/no2.gif" border=0 alt="停用">
        <%
        }
        %>   
        </td>
        <td valign=middle>
        <%
        if(ps.getPaySystemMessageActive()==1) 
        {
                JsfAdmin js=JsfAdmin.getInstance();
                int studentId = membr.getSurrogateId();
                Student stu = (Student) ObjectService.find("jsf.Student", "id="+studentId);

                if(stu !=null){
        %>
               <%=js.getStudentMoblieList(ps,stu)%>
        <%
                }
        }else if(ps.getPaySystemMessageActive()==0){
        %>
               停用中 
        <%
        }else{
        %>
                系統尚未開啟
        <%
        }
        %>
        </tD>
        <td>
        </td>    
      </tr>
    </table>
</div>
</body>