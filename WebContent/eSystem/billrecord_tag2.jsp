<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<blockquote>
<%
    int brid = Integer.parseInt(request.getParameter("brid"));
    String[] outkeys = request.getParameterValues("out");
    String[] inkeys = request.getParameterValues("in");
    boolean commit = false;
    int tran_id = 0;
    try {            
        tran_id = dbo.Manager.startTransaction();
        EzCountingService ezsvc = EzCountingService.getInstance();
        ChargeItemMembrMgr cimmgr = new ChargeItemMembrMgr(tran_id);
        ChargeItemMgr cimgr = new ChargeItemMgr(tran_id);
        ChargeMgr cmgr = new ChargeMgr(tran_id);
        BillRecord br = new BillRecordMgr(tran_id).find("id=" + brid);
        ArrayList<ChargeItem> citems = cimgr.retrieveList("chargeitem.billRecordId=" + brid, "");
        Map<Integer/*chargeitem.id*/, Vector<ChargeItem>> citemMap = new SortingMap(citems).doSort("getId");
        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
        MembrBillRecordMgr sbrmgr = new MembrBillRecordMgr(tran_id);

        Date nextFreezeDay = ezsvc.getFreezeNextDay(_ws2.getBunitSpace("bunitId"));
        for (int i=0; outkeys!=null&&i<outkeys.length; i++) {
            String key = outkeys[i];
            String[] k = key.split("#");
            ChargeItemMembr ci = cimmgr.find("membr.id=" + k[0] + " and chargeitem.id=" + k[1]);
            try {
                ezsvc.deleteCharge(tran_id, ci, ud2, true, nextFreezeDay);
            } catch (Exception e) {
                if (e.getMessage()!=null&&e.getMessage().equals("z")) {
                    MembrInfoBillRecord bill = new MembrInfoBillRecordMgr(tran_id).find("ticketId='" + ci.getTicketId() + "'");
                    vsvc.genVoucherForBill(bill, ud2.getId(), "刪除" + bill.getTicketId());
                    sbrmgr.executeSQL("delete from membrbillrecord where ticketId='" + bill.getTicketId() + "'");
                }
            }
        }

        ArrayList<Tag> tags = new TagMgr(tran_id).retrieveList("", "");
        Map<Integer/*tagId*/, Vector<Tag>> tagMap = new SortingMap(tags).doSort("getId");
        for (int i=0; inkeys!=null&&i<inkeys.length; i++) {
            String key = inkeys[i];
            String[] k = key.split("#");
            int membrId = Integer.parseInt(k[0]);
            int chargeItemId = Integer.parseInt(k[1]);
            int tagId = Integer.parseInt(k[2]);
            int amount = 0;
            try { amount=Integer.parseInt(request.getParameter(key)); } catch (Exception e) {}
            Tag tag = tagMap.get(new Integer(tagId)).get(0);
            ChargeItem ci = citemMap.get(chargeItemId).get(0);
            Charge c = ezsvc.addChargeMembr(tran_id, ci, membrId, br, ud2.getId(), tag, nextFreezeDay);

            if (amount!=ci.getChargeAmount()) {
                c.setAmount(amount);
                cmgr.save(c);
                ezsvc.updateCharge(tran_id, chargeItemId, membrId, (amount-ci.getChargeAmount()), nextFreezeDay);
            }
            vsvc.updateCharge(c, ud2.getId(), null);
        }
        dbo.Manager.commit(tran_id);
        commit = true;
    }
    catch (Exception e) {
        if (e.getMessage()!=null&&e.getMessage().equals("z")) {
      %><script>alert("至少要有一項收費項目");history.go(-1);</script><%
        } else if (e.getMessage()!=null&&e.getMessage().equals("x")) {
      %><script>alert("薪資金額小於0");history.go(-1);</script><%
        } else {
            e.printStackTrace();
      %><script>alert("錯誤發生，設定沒有寫入");history.go(-1);</script><%
        }
    } 
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
%>
設定成功！
<br>
<br>
<a target=_top href="editBillRecord.jsp?recordId=<%=brid%>">編輯帳單</a>
</blockquote>