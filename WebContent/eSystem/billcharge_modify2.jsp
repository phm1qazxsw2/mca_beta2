<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    int cid = -1, sid = -1;
    try { cid = Integer.parseInt(request.getParameter("cid")); } catch (Exception e) {}
    try { sid = Integer.parseInt(request.getParameter("sid")); } catch (Exception e) {}
    int pitemNum = 0;
    try { pitemNum = Integer.parseInt(request.getParameter("pitemNum")); } catch (Exception e) {}

    String reason = request.getParameter("reason");
    EzCountingService ezsvc = EzCountingService.getInstance();

    int tran_id = 0;
    boolean commit = false;
    try { 
        Integer amount = Integer.parseInt(request.getParameter("amount"));
        tran_id = Manager.startTransaction();
        ChargeItemMembr cs = new ChargeItemMembrMgr(tran_id).
            findX("chargeItemId=" + cid + " and membr.id=" + sid, _ws2.getAcrossBillBunitSpace("bill.bunitId"));
            // 要能編 cover 單位的帳單
        ChargeMgr cmgr = new ChargeMgr(tran_id);
        Charge c = cmgr.find("chargeItemId=" + cid + " and membrId=" + sid);

        int oldamount = cs.getMyAmount();
        int diff = amount - oldamount;
        c.setAmount((amount==cs.getChargeAmount())?0:amount);
        c.setNote((reason!=null && reason.length()>0)?reason:"");
        c.setUserId(ud2.getId());
        if (pitemNum!=c.getPitemNum())
            c.setPitemNum(pitemNum);
        cmgr.save(c);
        Date nextFreezeDay = ezsvc.getFreezeNextDay(_ws2.getBunitSpace("bunitId"));
        ezsvc.updateCharge(tran_id, c.getChargeItemId(), c.getMembrId(), diff, nextFreezeDay);
        // ## 改了Receivable有可能和Received不同調
        ArrayList<BillPay> affected_pays = ezsvc.fixupReceivableReceived(tran_id, cs.getBillRecordId(), sid);         
        // ##
        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
        vsvc.updateCharge(c, ud2.getId(), cs.getChargeName()+"(修)");

        if (affected_pays.size()>0)
            vsvc.genVoucherForBillPays(affected_pays, ud2.getId(), cs.getChargeName()+"(修)");

        Manager.commit(tran_id);
        commit = true;
        out.println("<blockquote>設定成功</blockquote>");
    }
    catch (Exception e) {
        if (!commit)
            try { Manager.rollback(tran_id); } catch (Exception ee) {}
        if (e.getMessage()!=null&&e.getMessage().equals("x")) {
      %><script>alert("收費金額小於0");history.go(-1);</script><%
        } else if (e.getMessage()!=null) {
      %><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>');history.go(-1);</script><%
        } else {
            e.printStackTrace();
      %><script>alert("錯誤發生，設定沒有寫入");history.go(-1);</script><%
        }
    }    
%>

