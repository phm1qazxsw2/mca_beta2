<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,java.io.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%@ include file="jumpTop.jsp"%>
<%
    String ticketId = request.getParameter("tid");
    int paidId = Integer.parseInt(request.getParameter("pid"));
    BillPaidInfo bp = BillPaidInfoMgr.getInstance().findX("billPayId=" + paidId + " and billpaid.ticketId='" + 
        ticketId + "'", _ws2.getAcrossBillBunitSpace("bill.bunitId"));
        // 兩個單位都要能退至學生帳戶

    if (bp==null) {
        %><script>alert("資料不存在");history.go(-1)</script><%
        return;
    }

%>
<br>
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

var paidAmount = <%=bp.getPaidAmount()%>;
function dosubmit(f)
{
    if (!IsNumeric(f.refund.value)) {
        alert("請輸入數字");
        f.refund.focus();
        return false;
    }
    var v = eval(f.refund.value);
    if (v>paidAmount) {
        alert("請輸入可轉帳之數值");
        f.refund.focus();
        return false;
    }
    return true;
}
</script>

<blockquote>

把金額轉至個人帳戶，該餘額可用來銷其他帳單或進行實際退款動作.
<br>
<br>
請輸入轉帳金額：<br>
<form action="membrbillrecord_refund2.jsp" onsubmit="return dosubmit(this)">
<input type=hidden name="tid" value="<%=ticketId%>">
<input type=hidden name="pid" value="<%=paidId%>">
<input type=text name="refund" value="<%=bp.getPaidAmount()%>" size=5>
<br>
<br>
<input type=submit value="轉至學生帳戶">
</form>

</blockquote>
