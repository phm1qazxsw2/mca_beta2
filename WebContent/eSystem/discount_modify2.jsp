<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="justHeader.jsp"%>
<%
    //##v2
    if(!AuthAdmin.authPage(ud2,4))
    {
        response.sendRedirect("authIndex.jsp?info=1&page=1");
    }
    int id = Integer.parseInt(request.getParameter("id"));
    int type = Integer.parseInt(request.getParameter("type"));
    int amount = 0-Integer.parseInt(request.getParameter("amount"));

    EzCountingService ezsvc = EzCountingService.getInstance();
    int tran_id = 0;
    boolean commit = false;
    try { 
        tran_id = Manager.startTransaction();
        DiscountMgr dmgr = new DiscountMgr(tran_id);
        Discount d = dmgr.find("id=" + id);

        String note = request.getParameter("note");
        int diff = d.getAmount() - amount;
        d.setType(type);
        d.setAmount(amount);
        d.setNote(note);
        dmgr.save(d);

        if (diff!=0)  {
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
            vsvc.updateChargeItemMembr(cs, ud2.getId(), cs.getChargeName()+"折扣(修)-" + dtype.getDiscountTypeName());

            if (affected_pays.size()>0)
                vsvc.genVoucherForBillPays(affected_pays, ud2.getId(), "折扣(修)-"+ dtype.getDiscountTypeName());
        }

        Manager.commit(tran_id);
        commit = true;
    }
    catch (Exception e) {
        if (e.getMessage()!=null&&e.getMessage().equals("x")) {
      %><script>alert("收費金額小於0");history.go(-1);</script><%
        } else if (e.getMessage()!=null&&e.getMessage().equals("y")) {
      %><script>alert("折扣的金額超過收費項目");history.go(-1);</script><%
        } else {
            e.printStackTrace();
            if (e.getMessage()!=null) {
              %><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>');history.go(-1);</script><%
                return;
            } else {
              %><script>alert("發生錯誤");history.go(-1);</script><%
                return;
            }
        }
    }
    finally {
        if (!commit)
            try { Manager.rollback(tran_id); } catch (Exception ee) {}
    }
%>
<br>
<br>
<blockquote>
設定成功！
</blockquote>
