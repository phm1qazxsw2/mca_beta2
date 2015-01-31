<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    int cid = -1, sid = -1;
    try { cid = Integer.parseInt(request.getParameter("cid")); } catch (Exception e) {}
    try { sid = Integer.parseInt(request.getParameter("sid")); } catch (Exception e) {}
    int did = Integer.parseInt(request.getParameter("did")); 

    int type = Integer.parseInt(request.getParameter("type"));
    int damount = 0-Integer.parseInt(request.getParameter("damount"));
    String note = request.getParameter("reason");
    int copystatus = 0;
    try { copystatus = Integer.parseInt(request.getParameter("copystatus")); } catch (Exception e) {}

    EzCountingService ezsvc = EzCountingService.getInstance();
    int tran_id = 0;
    boolean commit = false;
    try { 
        tran_id = Manager.startTransaction();

        ChargeItemMembr ci = new ChargeItemMembrMgr(tran_id).find("charge.chargeItemId=" + cid + " and charge.membrId=" + sid);    
        DiscountMgr dmgr = new DiscountMgr(tran_id);
        ArrayList<Discount> discounts = dmgr.retrieveList("chargeItemId=" + cid + " and membrId=" + sid, "");
        int dnum = 0;
        for (int i=0; i<discounts.size(); i++)
            dnum += discounts.get(i).getAmount();

        Discount d = dmgr.find("id=" + did);

        int orgDiscount = d.getAmount();
        d.setType(type);
        d.setAmount(damount);
        d.setNote(note);
        d.setUserId(ud2.getId());
        d.setCopy(copystatus);
        dmgr.save(d);
        int diff = orgDiscount - damount;
        Date nextFreezeDay = ezsvc.getFreezeNextDay(_ws2.getBunitSpace("bunitId"));
        ezsvc.updateCharge(tran_id, d.getChargeItemId(), d.getMembrId(), diff, nextFreezeDay);
        // ## 改了Receivable有可能和Received不同調
        ArrayList<BillPay> affected_pays = ezsvc.fixupReceivableReceived(tran_id, ci.getBillRecordId(), sid); 

        //if ((dnum - orgDiscount + damount)>ci.getMyAmount())
        //    throw new Exception("y");

        // ##
        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
        jsf.DiscountType dtype = (jsf.DiscountType) ObjectService.find("jsf.DiscountType", "id=" + type);
        vsvc.updateChargeItemMembr(ci, ud2.getId(), ci.getChargeName()+"折扣(修)-" + dtype.getDiscountTypeName());

        if (affected_pays.size()>0)
            vsvc.genVoucherForBillPays(affected_pays, ud2.getId(), "折扣(修)-" + dtype.getDiscountTypeName());

        Manager.commit(tran_id);
        commit = true;
        response.sendRedirect("billdiscount_list.jsp?cid=" + cid + "&sid=" + sid);
    }
    catch (Exception e) {
        if (!commit)
            try { Manager.rollback(tran_id); } catch (Exception ee) {}
        if (e.getMessage()!=null&&e.getMessage().equals("x")) {
      %><script>alert("收費金額小於0");history.go(-1);</script><%
        } else if (e.getMessage()!=null&&e.getMessage().equals("y")) {
      %><script>alert("折扣的金額超過收費項目");history.go(-1);</script><%
        } else {
            e.printStackTrace();
            if (e.getMessage()!=null) {
      %><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>');history.go(-1);</script><%
            }
        }
    }    
%>
