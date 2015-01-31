<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,java.io.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%@ include file="jumpTop.jsp"%>
<%!
    int getFdAmount(ArrayList<FeeDetail> fds)
    {
        int ret = 0;
        if (fds==null)
            return 0;
        for (int i=0; i<fds.size(); i++) {
            FeeDetail fd = fds.get(i);
            ret += fd.getUnitPrice()*fd.getNum();
        }
        return ret;
    }

    int getChargeTotal(ArrayList<ChargeItemMembr> charges)
    {
        int ret = 0;
        if (charges==null)
            return 0;
        for (int i=0; i<charges.size(); i++) {
            ChargeItemMembr ci = charges.get(i);
            ret += ci.getMyAmount();
        }
        return ret;
    }
%>
<%
    int brId = Integer.parseInt(request.getParameter("brId"));
    if (brId<13) {
      %><script>alert("此功能只適用於2008-12月以後的資料");history.go(-1);</script><%
        return;
    }
    ArrayList<ChargeItem> chargeitems = ChargeItemMgr.getInstance().retrieveList("billRecordId=" + brId, "");
    String chargeitemIds = new RangeMaker().makeRange(chargeitems, "getId");
    ArrayList<FeeDetail> fds = FeeDetailMgr.getInstance().retrieveList("chargeItemId in (" + chargeitemIds + ")", "");
    String manhourIds = new RangeMaker().makeRange(fds, "getManhourId");
    
    String q = "id in (" + manhourIds + ")";
    
    boolean commit = false;
    int tran_id = 0;
    try {        
        tran_id = dbo.Manager.startTransaction();
        ArrayList<ManHour> manhours = new ManHourMgr(tran_id).retrieveList(q, "");

        // 從這以下的 fd 和 charges 有包括帳單和薪資的部分可是只有和 manhour 有關的

        ArrayList<FeeDetail> mh_fds = new FeeDetailMgr(tran_id).retrieveList("manhourId in (" + manhourIds + ")", "");
        Map<String, ArrayList<FeeDetail>> mh_feedetailMap = new SortingMap(mh_fds).doSortA("getChargeKey");

        chargeitemIds = new RangeMaker().makeRange(mh_fds, "getChargeItemId");
        ArrayList<ChargeItemMembr> mh_charges = new ChargeItemMembrMgr(tran_id).
            retrieveList("chargeItemId in (" + chargeitemIds + ")", "");

        // 找出 feedetail 和 charge 不 match 的記錄
        ArrayList<String> needfix = new ArrayList<String>();
        for (int i=0; i<mh_charges.size(); i++) {
            ChargeItemMembr ci = mh_charges.get(i);
            ArrayList<FeeDetail> myfds = mh_feedetailMap.get(ci.getMembrId()+"#"+ci.getChargeItemId());
            if (ci.getMyAmount()!=getFdAmount(myfds)) {
                out.println("<br>##1## " + ci.getTicketId());
                needfix.add(ci.getTicketId());
            }
        }

        // 找出 ticket 和 charge 不 match 的記錄
        String ticketIds = new RangeMaker().makeRange(mh_charges, "getTicketIdAsString");
        ArrayList<MembrInfoBillRecord> mbrs = new MembrInfoBillRecordMgr(tran_id).retrieveList("ticketId in (" + ticketIds + ")","");
        ArrayList<ChargeItemMembr> bill_charges = new ChargeItemMembrMgr(tran_id).
            retrieveList("ticketId in (" + ticketIds + ")", "");
        Map<String, ArrayList<ChargeItemMembr>> billchargeMap = new SortingMap(bill_charges).doSortA("getTicketId");

        for (int i=0; i<mbrs.size(); i++) {
            MembrInfoBillRecord mbr = mbrs.get(i);
            ArrayList<ChargeItemMembr> billcharges = billchargeMap.get(mbr.getTicketId());
            if (mbr.getReceivable()!=getChargeTotal(billcharges)) {
                out.println("<br>##2## " + mbr.getTicketId());
                needfix.add(mbr.getTicketId());
            }
        }

        // 重新計算 membrbillrecord
        MembrBillRecordMgr mbrmgr = new MembrBillRecordMgr(tran_id);
        ChargeMgr cmgr = new ChargeMgr(tran_id);
        for (int i=0; i<needfix.size(); i++) {
            MembrBillRecord mbr = mbrmgr.find("ticketId='" + needfix.get(i) + "'");
            ArrayList<ChargeItemMembr> mycharges = billchargeMap.get(mbr.getTicketId());
            int total = 0;
            for (int j=0; j<mycharges.size(); j++) {
                ChargeItemMembr ci = mycharges.get(j);
                ArrayList<FeeDetail> myfds = mh_feedetailMap.get(ci.getMembrId()+"#"+ci.getChargeItemId());
                if (myfds==null) { // 這個不是 manhour 來的 charge
                    total += ci.getMyAmount();
                }
                else {
                    int charge_total = getFdAmount(myfds);
                    if (ci.getMyAmount()!=charge_total) {
                        if (mbr.getPaidStatus()!=MembrBillRecord.STATUS_NOT_PAID)
                            throw new Exception("已付款不可修改");
                        Charge cc = cmgr.find("membrId=" + ci.getMembrId() + " and chargeItemId=" + ci.getChargeItemId());
                        cc.setAmount(charge_total);
                        cmgr.save(cc);
                    }
                    total += charge_total;
                }
            }
            if (total!=mbr.getReceivable()) {
                if (mbr.getPaidStatus()!=MembrBillRecord.STATUS_NOT_PAID)
                    throw new Exception("已付款不可修改");
                mbr.setReceivable(total);
                mbrmgr.save(mbr);
            }
        }

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    catch (Exception e) {
        e.printStackTrace();
        if (e.getMessage()!=null) { 
      %><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>'); history.go(-1);</script><%
        } else { 
      %><script>alert("錯誤發生，設定沒有寫入");history.go(-1);</script><%
            e.printStackTrace();
        }
        return;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
%>
done!