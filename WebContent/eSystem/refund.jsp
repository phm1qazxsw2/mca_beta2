<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,java.io.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    if(!checkAuth(ud2,authHa,103))
    {
        response.sendRedirect("authIndex.jsp?code=103");
    }
    
    int sid = Integer.parseInt(request.getParameter("sid"));

    // 帳戶餘額
    Membr membr = MembrMgr.getInstance().find("id=" + sid);
    EzCountingService ezsvc = EzCountingService.getInstance();
    BillPayMgr bpmgr = BillPayMgr.getInstance();
    int remain = (int) ezsvc.getMembrRemain(sid);

    DecimalFormat mnf = new DecimalFormat("##,####,##0");
    DecimalFormat mnf2 = new DecimalFormat("########0");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月");
    User ud4 = WebSecurity.getInstance(pageContext).getCurrentUser();
    JsfPay jp=JsfPay.getInstance(); 
    Tradeaccount[] tradeA=jp.getActiveTradeaccount(ud4.getId());
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

var remain = <%=remain%>;
function check(f)
{
    if (!IsNumeric(f.refund.value)) {
        alert("請輸入數字");
        return false;
    }
    var v = eval(f.refund.value);
    if (v>remain) {
        alert("輸入的金額不可大於餘額");
        return false;
    }
    return true;
}

</script>
<body>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=membr.getName()%>-臨櫃退費</b>
</div>

<blockquote>

<%
    if (tradeA==null) {
        out.println("<br><br> 您還沒有設定現金帳戶，不能辦理退款");
        return;
    }
%>
<br>
<form name=f1 action="refund2.jsp" method="post" onsubmit="return check(this);"> 
<input type=hidden name="sid" value="<%=sid%>">
退費金額 <input type=text name="refund" value="<%=remain%>" size=7>
<br>
<br>
退費零用金帳戶: (款項從此帳戶扣除) <br>
<select name=acctInfo>
<%
for (int i=0; i<tradeA.length; i++)
    out.println("<option value='1#"+tradeA[i].getId()+"'>" + tradeA[i].getTradeaccountName()+"</option>");


SalarybankAuth[] bankAuths = jp.getSalarybankAuthByUserId(ud2); 
BankAccountMgr bamgr = BankAccountMgr.getInstance();
for (int i=0; bankAuths!=null && i<bankAuths.length; i++) {
    BankAccount bank = (BankAccount) bamgr.find(bankAuths[i].getSalarybankAuthId());
    if (bank.getBankAccountName().indexOf("USD$")<0)
        out.println("<option value='2#"+bank.getId()+"'>" + bank.getBankAccountName()+"</option>");
}
%>
</select>
<br>
<br>
<br>
<input type=submit value="退費">
</form>

</blockquote>

</body>