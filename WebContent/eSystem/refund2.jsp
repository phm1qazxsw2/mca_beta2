<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,java.io.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    if(!checkAuth(ud2,authHa,103))
    {
        response.sendRedirect("authIndex.jsp?code=103");
    }
    
    int sid = Integer.parseInt(request.getParameter("sid"));
    int amount = Integer.parseInt(request.getParameter("refund"));
    String acctInfo = request.getParameter("acctInfo");
    String[] tokens = acctInfo.split("#");
    int acctType = Integer.parseInt(tokens[0]);
    int acctId = Integer.parseInt(tokens[1]);

    Tradeaccount tacct = (Tradeaccount) ObjectService.find("jsf.Tradeaccount", "id=" + acctId);
    EzCountingService ezsvc = EzCountingService.getInstance();
    boolean commit = false;
    int tran_id = 0;
    try {           
        tran_id = dbo.Manager.startTransaction();
        Membr membr = new MembrMgr(tran_id).find("id=" + sid);
        ArrayList<BillPay> affected = new ArrayList<BillPay>();
        ezsvc.refundMembr(tran_id, membr, amount, acctType, acctId, ud2, affected, _ws2.getSessionBunitId());
        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
        vsvc.genVoucherForBillPays(affected, ud2.getId(), "學費退款");
        dbo.Manager.commit(tran_id);
        commit = true;
    }
    catch (Exception e) {
        if (e.getMessage()!=null) {
         %><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>'); history.go(-1);</script><%
        } else {
            e.printStackTrace();
        }
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
    
%>
<blockquote>
退款成功！
</blockquote>
