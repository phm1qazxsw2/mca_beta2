<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=5;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%
    //##v2
//    User ud2 = WebSecurity.getInstance(pageContext).getCurrentUser();
    if(!checkAuth(ud2,authHa,102))
    {
        response.sendRedirect("authIndex.jsp?code=102");
    }
    int cid = Integer.parseInt(request.getParameter("cid"));
    String[] target = request.getParameterValues("target");
    
    int tran_id = 0;
    boolean commit = false;
    try { 
        tran_id = Manager.startTransaction();
        ChargeItemMembrMgr csmgr = new ChargeItemMembrMgr(tran_id);
        EzCountingService ezsvc = EzCountingService.getInstance();
        VoucherService vsvc = new VoucherService(tran_id, _ws.getSessionBunitId());

        Date nextFreezeDay = ezsvc.getFreezeNextDay(_ws.getBunitSpace("bunitId"));
        for (int i=0; target!=null && i<target.length; i++)
        {
            ChargeItemMembr cs = csmgr.find("chargeItemId=" + cid + " and membr.id=" + target[i]);
            try {
                ezsvc.deleteCharge(tran_id, cs, ud2, true, nextFreezeDay);
                vsvc.updateChargeItemMembr(cs, ud2.getId(), cs.getChargeName()+"(刪)");
            }
            catch (Exception e) {
                if (e.getMessage()!=null&&e.getMessage().equals("z")) {
                    MembrInfoBillRecord bill = new MembrInfoBillRecordMgr(tran_id).find("billRecordId=" + cs.getBillRecordId()
                        + " and membrId=" + cs.getMembrId());
                    vsvc.genVoucherForBill(bill, ud2.getId(), "刪除" + bill.getTicketId());
                    MembrBillRecordMgr sbrmgr = new MembrBillRecordMgr(tran_id);
                    sbrmgr.executeSQL("delete from membrbillrecord where ticketId='" + bill.getTicketId() + "'");
                }
                else
                    throw e;
            }   
        }

        Manager.commit(tran_id);
        commit = true;
    }
    catch (Exception e) {
        if (!commit)
            try { Manager.rollback(tran_id); } catch (Exception ee) {}
        if (e.getMessage()!=null&&e.getMessage().equals("z")) {
      %><script>alert("至少要有一項收費項目");history.go(-1);</script><%
        } else {
            e.printStackTrace();
            if (e.getMessage()!=null) {
      %><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>');history.go(-1);</script><%
            }
        }
        return;
    }    

%>
<script>
    alert("刪除成功！");
    location.href = '<%=request.getParameter("backurl")%>';
</script>
