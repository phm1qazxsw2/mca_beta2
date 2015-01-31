<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    int did = Integer.parseInt(request.getParameter("did")); 

    EzCountingService ezsvc = EzCountingService.getInstance();
    int tran_id = 0;
    boolean commit = false;
    try { 
        tran_id = Manager.startTransaction();

        DiscountMgr dmgr = new DiscountMgr(tran_id);
        Discount d = dmgr.find("id=" + did);

        int diff = d.getAmount();
        Discount[] targets = { d };
        dmgr.remove(targets);
        Date nextFreezeDay = ezsvc.getFreezeNextDay(_ws2.getBunitSpace("bunitId"));
        ezsvc.updateCharge(tran_id, d.getChargeItemId(), d.getMembrId(), diff, nextFreezeDay);
        // ## 改了Receivable有可能和Received不同調
        ChargeItem ci = new ChargeItemMgr(tran_id).find("id=" + d.getChargeItemId());
        ArrayList<BillPay> affected_pays = ezsvc.fixupReceivableReceived(tran_id, ci.getBillRecordId(), d.getMembrId()); 

        // ##
        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
        ChargeItemMembr cs = new ChargeItemMembrMgr(tran_id).find("charge.chargeItemId=" + 
            d.getChargeItemId() + " and charge.membrId=" + d.getMembrId());
        jsf.DiscountType dtype = (jsf.DiscountType) ObjectService.find("jsf.DiscountType", "id=" + d.getType());
        vsvc.updateChargeItemMembr(cs, ud2.getId(), cs.getChargeName()+"折扣(刪)-" + dtype.getDiscountTypeName());

        if (affected_pays.size()>0)
            vsvc.genVoucherForBillPays(affected_pays, ud2.getId(), "折扣(刪)-"+ dtype.getDiscountTypeName());

        Manager.commit(tran_id);
        commit = true;
    }
    catch (Exception e) {
        if (e.getMessage().equals("x")) {
      %>@@收費金額小於0<%
        } else {
            e.printStackTrace();
            if (e.getMessage()!=null) {
              %>@@<%=phm.util.TextUtil.escapeJSString(e.getMessage())%><%
            } else {
              %>@@發生錯誤<%
            }
        }
    }
    finally {
        if (!commit)
            try { Manager.rollback(tran_id); } catch (Exception ee) {}
    }    
%>
