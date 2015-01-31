<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,java.io.*,dbo.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=7;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu7.jsp"%>
<%
    if(!AuthAdmin.authPage(ud2,3)) 
    {
        response.sendRedirect("authIndex.jsp?info=1&page=1");
    }   

    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy/MM/dd"); 
  	DecimalFormat mnf = new DecimalFormat("###,###,##0");
    String[] taccts = request.getParameterValues("trade");
    String[] banks = request.getParameterValues("bank");   
%>
<br>
<br>
<blockquote>
<%
    boolean commit = false;
    int tran_id = 0;
    try {           
        tran_id = dbo.Manager.startTransaction();

        Date d = new Date();
        EzCountingService ezsvc = EzCountingService.getInstance();
        boolean change = false;
        for (int i=0; taccts!=null&&i<taccts.length; i++) {
            int amount = Integer.parseInt(request.getParameter("a##" + taccts[i]));
            int diff = ezsvc.adjustCashAccount(tran_id, d, 1, Integer.parseInt(taccts[i]), amount, ud2, _ws.getSessionBunitId());
            Tradeaccount ta = (Tradeaccount) ObjectService.find("jsf.Tradeaccount", "id=" + taccts[i]);
            if (diff!=0) {
                out.println("零用金帳戶 - " + ta.getTradeaccountName() + " 成功調整成 " + mnf.format(amount) + " (from "+mnf.format(amount-diff)+")<br>");
                change = true;
            }
            else 
                out.println("零用金帳戶 - " + ta.getTradeaccountName() + " 前後金額一樣沒有調整<br>");
        }

        for (int i=0; banks!=null&&i<banks.length; i++) {
            int amount = Integer.parseInt(request.getParameter("b##" + banks[i]));
            int diff = ezsvc.adjustCashAccount(tran_id, d, 2, Integer.parseInt(banks[i]), amount, ud2, _ws.getSessionBunitId());
            BankAccount ba = (BankAccount) ObjectService.find("jsf.BankAccount", "id="+ banks[i]);
            if (diff!=0) {
                out.println("銀行帳戶 - " + ba.getBankAccountName() + " 成功調整成 " + mnf.format(amount) + " (from "+mnf.format(amount-diff)+")<br>");
                change = true;
            }
            else 
                out.println("銀行帳戶 - " + ba.getBankAccountName() + " 前後金額一樣沒有調整<br>");

        }

        if (!change) {
            out.println("沒有任何改變，帳戶沒有做任何更動!<br>");
        }

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
%>
</blockquote>
<%@ include file="bottom.jsp"%>