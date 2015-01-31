<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=5;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%
    if(!checkAuth(ud2,authHa,302))
    {
        response.sendRedirect("authIndex.jsp?code=302");
    }
%>
<%@ include file="leftMenu5.jsp"%>
<%


    String backurl = request.getParameter("backurl");
    int amount = Integer.parseInt(request.getParameter("amount"));
    int via = Integer.parseInt(request.getParameter("v"));
    int acctId = 0;
    String reason = "";
    int bunitId = 0;
    if (via==BillPay.SALARY_CASH) {
        acctId = Integer.parseInt(request.getParameter("acctId"));
        Tradeaccount ta = (Tradeaccount) TradeaccountMgr.getInstance().find(acctId);
        bunitId = ta.getBunitId();
        reason = "現金";
    }
    else if (via==BillPay.SALARY_WIRE) {
        acctId = Integer.parseInt(request.getParameter("acctId"));
        BankAccount ba = (BankAccount) BankAccountMgr.getInstance().find(acctId);
        bunitId = ba.getBunitId();
        reason = "匯款";
    }
    else {
       %><script>alert("目前不支援此種支付方式");</script><%
       return;
    }

    String[] targets = request.getParameterValues("target");
    StringBuffer sb = new StringBuffer();
    for (int i=0; i<targets.length; i++) {
        if (sb.length()>0) sb.append(",");
        sb.append(targets[i]);
    }

    EzCountingService ezsvc = EzCountingService.getInstance();
    int tran_id = 0;
    boolean commit = false;

    try{	
        tran_id = Manager.startTransaction();

        ArrayList<MembrInfoBillRecord> salaries = 
            MembrInfoBillRecordMgr.getInstance().retrieveList("ticketId in (" + sb.toString() + 
            ") and billType=" + Bill.TYPE_SALARY + " and privLevel>=" + ud2.getUserRole(), "");
       
        ArrayList<MembrInfoBillRecord> full_paid = new ArrayList<MembrInfoBillRecord>();
        BillPay bpay = ezsvc.doSalaryBalance(tran_id, amount, ud2, salaries, via, acctId, false, full_paid, bunitId);

        if (bpay!=null) {
            VoucherService vsvc = new VoucherService(tran_id, bunitId);
            vsvc.genVoucherForSalaryPay(bpay, ud2.getId(), reason);
        }

        commit = true;
        Manager.commit(tran_id);

    }
    catch (Exception e) {
        ezsvc.sendWarningException(e, "in salary pay exception");
        throw e;
    }
    finally {
        if (!commit)
            try { Manager.rollback(tran_id); } catch (Exception e2) {}  
    }
    
%>

<body>
<br>
<b>&nbsp;&nbsp;&nbsp;支付薪資</b>
 <table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  

<blockquote>

付款成功！
<br>
<br>
<a href="<%=request.getParameter("backurl")%>">回上一頁</a>
|
<a href="salary_payinfo.jsp">付款記錄</a>


</blockquote>
<br>
<br>
<br>
<%@ include file="bottom.jsp"%>	
</body>
