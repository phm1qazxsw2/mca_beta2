<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%
    //##v2
    ArrayList<MembrInfoBillRecord> all = MembrInfoBillRecordMgr.getInstance().retrieveList("", "");
    Iterator<MembrInfoBillRecord> iter = all.iterator();
    ChargeItemMembrMgr cismgr = ChargeItemMembrMgr.getInstance();
    DiscountInfoMgr dimgr = DiscountInfoMgr.getInstance();

    MembrBillRecordMgr mbrmgr = MembrBillRecordMgr.getInstance();
    while (iter.hasNext()) {
        int bill_amount = 0;
        int charge_subtotal = 0;
        int discount_subtotal = 0;
        MembrInfoBillRecord sinfo = iter.next();
        bill_amount = sinfo.getReceivable();
        ArrayList<ChargeItemMembr> items = cismgr.retrieveList(
            "charge.membrId=" + sinfo.getMembrId() + " and chargeitem.billRecordId=" + sinfo.getBillRecordId(), "");
        Iterator<ChargeItemMembr> citer = items.iterator();
        while (citer.hasNext()) {
            ChargeItemMembr ci = citer.next();
            ArrayList<DiscountInfo> discounts = dimgr.retrieveList(
                "chargeItemId=" + ci.getChargeItemId() + " and membrId=" + sinfo.getMembrId(), "");
            charge_subtotal += ci.getMyAmount();
            Iterator<DiscountInfo> diter = discounts.iterator();
            while (diter.hasNext()) {
                DiscountInfo di = diter.next();
                discount_subtotal += di.getAmount();
            }
        }
        if (bill_amount != (charge_subtotal - discount_subtotal)) {
            out.println(sinfo.getTicketId() + " " + bill_amount + " != " +
                (charge_subtotal - discount_subtotal) + "(" + charge_subtotal + " - " + discount_subtotal  + ")<br>");
            MembrBillRecord mbr = mbrmgr.find("ticketId='" + sinfo.getTicketId() + "'");
            mbr.setReceivable((charge_subtotal - discount_subtotal));
            mbrmgr.save(mbr);
        }
    }
%>
