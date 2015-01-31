<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*;,phm.accounting.*;,literalstore.*,phm.util.*" contentType="text/html;charset=UTF-8"%>
<%
    boolean commit = false;
    int tran_id = 0;
    try {           
        tran_id = dbo.Manager.startTransaction();
        ArrayList<MembrInfoBillRecord> bills = new MembrInfoBillRecordMgr(tran_id).retrieveList("billrecord.id in (19,20)", "");
        VoucherService vsvc = new VoucherService(tran_id, 19);
        vsvc.genVoucherForBills(bills, 0, "");

        /*
        // ################ 沖帳傳票摘要加人名 ################
        ArrayList<MembrInfoBillRecord> bills = new MembrInfoBillRecordMgr(tran_id).retrieveList("", "");
        VoucherService vsvc = new VoucherService(tran_id, 19);
        vsvc.genVoucherForBills(bills, 0, "");
        
        LiteralStore store = new LiteralStore(tran_id, "literal", null);
        BillPayMgr bmgr = new BillPayMgr(tran_id);
        MembrMgr mmgr = new MembrMgr(tran_id);
        MembrInfoBillRecordMgr mbrmgr = new MembrInfoBillRecordMgr(tran_id);

        ArrayList<VchrItemInfo> items = new VchrItemInfoMgr(tran_id).retrieveList("srcType=" + VchrThread.SRC_TYPE_BILLPAID, "");
        String threadIds = new RangeMaker().makeRange(items, "getThreadId");
        ArrayList<VchrThread> threads = new VchrThreadMgr(tran_id).retrieveList("id in (" + threadIds + ")", "");
        Map<Integer, VchrThread> threadMap = new SortingMap(threads).doSortSingleton("getId");

        VchrInfo vinfo = VchrInfo.getVchrInfo(items, tran_id);
        Map<Integer, VchrHolder> vchrMap = vinfo.getVchrMap();
        Iterator<Integer> iter = vchrMap.keySet().iterator();
        while (iter.hasNext()) {
            VchrHolder vh = vchrMap.get(iter.next());

            VchrThread t = threadMap.get(vh.getThreadId());
            String key = t.getSrcInfo();
            String[] tokens = key.split("#");
            BillPay bpay = bmgr.find("id=" + tokens[0]);
            Membr m = mmgr.find("id=" + bpay.getMembrId());

            if (m!=null) {
                String s = store.restore((long)vh.getNote());
                store.save((long)vh.getNote(), s + "," + m.getName());
                out.println(vh.getSerial() + " | " + s + m.getName() + "<br>");
            }
            else {
                MembrInfoBillRecord bill = mbrmgr.find("ticketId='" + tokens[1] + "'");
                if (bill!=null) {
                    String s = store.restore((long)vh.getNote());
                    store.save((long)vh.getNote(), s + "," + bill.getMembrName());
                    out.println(vh.getSerial() + " # " + s + bill.getMembrName() + "<br>");
                }
            }

            //String s = store.restore((long)vh.getNote());
            //out.println(vh.getSerial() + " | " + s + "<br>");
        }

        //############################################################


        // ################ 繳費傳票摘要加人名 ################
        
        LiteralStore store = new LiteralStore(tran_id, "literal", null);
        BillPayMgr bmgr = new BillPayMgr(tran_id);
        MembrMgr mmgr = new MembrMgr(tran_id);

        ArrayList<VchrItemInfo> items = new VchrItemInfoMgr(tran_id).retrieveList("srcType=" + VchrThread.SRC_TYPE_BILLPAY, "");
        String threadIds = new RangeMaker().makeRange(items, "getThreadId");
        ArrayList<VchrThread> threads = new VchrThreadMgr(tran_id).retrieveList("id in (" + threadIds + ")", "");
        Map<Integer, VchrThread> threadMap = new SortingMap(threads).doSortSingleton("getId");

        VchrInfo vinfo = VchrInfo.getVchrInfo(items, tran_id);
        Map<Integer, VchrHolder> vchrMap = vinfo.getVchrMap();
        Iterator<Integer> iter = vchrMap.keySet().iterator();
        while (iter.hasNext()) {
            VchrHolder vh = vchrMap.get(iter.next());

            VchrThread t = threadMap.get(vh.getThreadId());
            BillPay bpay = bmgr.find("id=" + t.getSrcInfo());
            Membr m = mmgr.find("id=" + bpay.getMembrId());

            if (m!=null) {
                String s = store.restore((long)vh.getNote());
                store.save((long)vh.getNote(), s + "," + m.getName());
                out.println(vh.getSerial() + " | " + s + m.getName() + "<br>");
            }

            //String s = store.restore((long)vh.getNote());
            //out.println(vh.getSerial() + " | " + s + "<br>");
        }
        //############################################################
        */
        /*
        // ################ 帳單傳票摘要加人名 ################
        
        LiteralStore store = new LiteralStore(tran_id, "literal", null);
        MembrInfoBillRecordMgr mbrmgr = new MembrInfoBillRecordMgr(tran_id);

        ArrayList<VchrItemInfo> items = new VchrItemInfoMgr(tran_id).retrieveList("srcType=" + VchrThread.SRC_TYPE_BILL, "");
        String threadIds = new RangeMaker().makeRange(items, "getThreadId");
        ArrayList<VchrThread> threads = new VchrThreadMgr(tran_id).retrieveList("id in (" + threadIds + ")", "");
        Map<Integer, VchrThread> threadMap = new SortingMap(threads).doSortSingleton("getId");

        VchrInfo vinfo = VchrInfo.getVchrInfo(items, tran_id);
        Map<Integer, VchrHolder> vchrMap = vinfo.getVchrMap();
        Iterator<Integer> iter = vchrMap.keySet().iterator();
        while (iter.hasNext()) {
            VchrHolder vh = vchrMap.get(iter.next());

            VchrThread t = threadMap.get(vh.getThreadId());
            MembrInfoBillRecord bill = mbrmgr.find("ticketId='" + t.getSrcInfo() + "'");
            if (bill!=null) {
                String s = store.restore((long)vh.getNote());
                store.save((long)vh.getNote(), s + bill.getMembrName());
                out.println(vh.getSerial() + " | " + s + bill.getMembrName() + "<br>");
            }
            else {
                out.println(vh.getSerial() + " # " + t.getSrcInfo() + "<br>");
            }

            //String s = store.restore((long)vh.getNote());
            //out.println(vh.getSerial() + " | " + s + "<br>");
        }
        */

        /*
        for (int i=0; i<items.size(); i++) {
            out.println("<br>#############<br>");
            out.print(vinfo.getAcodeFullName(items.get(i), 50, true, false));
            out.print(" | ");
            out.print(vinfo.getNote(items.get(i)));
            out.print(" | ");
            out.print(vinfo.getTotalNote(items.get(i)));
        }
        */

        // ##############################################

        /*
        // ################ 設定傳票部門 ################

        ArrayList<VchrHolderType> vchrs = new VchrHolderTypeMgr(tran_id).retrieveList("srcType=" + VchrThread.SRC_TYPE_BILL, "");
        String threadIds = new RangeMaker().makeRange(vchrs, "getThreadId");
        ArrayList<VchrThread> threads = new VchrThreadMgr(tran_id).retrieveList("id in (" + threadIds + ")", "");

        Bunit bu1 = BunitMgr.getInstance().find("label='幼稚園'");
        Bunit bu2 = BunitMgr.getInstance().find("label='國小安親班'");

        //LiteralStore store = new LiteralStore(tran_id, "literal", null);
        int cur_bill_id = 0;
        MembrInfoBillRecordMgr mbrmgr = new MembrInfoBillRecordMgr(tran_id);
        VchrItemMgr vimgr = new VchrItemMgr(tran_id);
        
        for (int i=0; i<threads.size(); i++) {
            VchrThread t = threads.get(i);
            MembrInfoBillRecord bill = mbrmgr.find("ticketId='" + t.getSrcInfo() + "'");
            if (bill==null) {
                out.println(t.getSrcInfo()+" is deleted...");
            }
            else {
                cur_bill_id = bill.getBillId();
                out.println(t.getSrcInfo()+":" + bill.getBillId());
            }
            
            // 設定 vchr_item 的 bunit
            Bunit b = (cur_bill_id==1 || cur_bill_id==2)?bu1:bu2;
            
            // bill 的 vchr_item
            PArrayList<VchrItem> items = new PArrayList(vimgr.retrieveList("threadId=" + t.getId(), ""));

            String all="";
            if (bill!=null) {
                ArrayList<BillPaid> paids = new BillPaidMgr(tran_id).retrieveList("ticketId='" + bill.getTicketId() + "'", "");
                String billpayIds = new RangeMaker().makeRange(paids, "getBillPayId");
                ArrayList<BillPay> pays = BillPayMgr.getInstance().retrieveList("id in (" + billpayIds + ")", "");
                String threadIds1 = new RangeMaker().makeRange(paids, "getThreadId");
                String threadIds2 = new RangeMaker().makeRange(pays, "getThreadId");
                if (!threadIds1.equals("-1"))
                    all += threadIds1;
                if (!threadIds2.equals("-1")) {
                    if (all.length()>0)
                        all += ",";
                    all += threadIds2;
                }
                if (all.length()>0)
                    items.concate(vimgr.retrieveList("threadId in (" + all + ")", ""));
            }
            for (int j=0; j<items.size(); j++) {
                VchrItem vi = items.get(j);
                vi.setBunitId(b.getId());
                vimgr.save(vi);
            }
        }
        // ##############################################


        // ################設定傳票樣本部門################

        // 幼稚園
        ArrayList<BillItem> bitems = new BillItemMgr(tran_id).retrieveList("billId in (1,2)", "");
        // 先改 template
        for (int i=0; i<bitems.size(); i++) {
            BillItem bi = bitems.get(i);
            VchrHolder v = new VchrHolderMgr(tran_id).find("id=" + bi.getTemplateVchrId() + " and type=" + VchrHolder.TYPE_TEMPLATE);
            if (v==null)
                continue;
            ArrayList<VchrItem> items = vimgr.retrieveList("vchrId=" + v.getId(), "");
            for (int j=0; j<items.size(); j++) {
                VchrItem vi = items.get(j);
                vi.setBunitId(bu1.getId());
                vimgr.save(vi);
            }
        }

        // 國小安親班
        bitems = new BillItemMgr(tran_id).retrieveList("billId in (4)", "");
        // 先改 template
        for (int i=0; i<bitems.size(); i++) {
            BillItem bi = bitems.get(i);
            VchrHolder v = new VchrHolderMgr(tran_id).find("id=" + bi.getTemplateVchrId() + " and type=" + VchrHolder.TYPE_TEMPLATE);
            if (v==null)
                continue;
            ArrayList<VchrItem> items = vimgr.retrieveList("vchrId=" + v.getId(), "");
            for (int j=0; j<items.size(); j++) {
                VchrItem vi = items.get(j);
                vi.setBunitId(bu2.getId());
                vimgr.save(vi);
            }
        }
        // ##############################################
        */

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }

    /*
    VoucherService vsvc = new VoucherService(0, 19);
    Acode a = vsvc._get_acode("1141");
    LiteralStore store = new LiteralStore(0, "literal", null);
    int id = (int) LiteralStore.create(store, "應收票據");
    a.setName1(id);
    AcodeMgr.getInstance().save(a);
    */
%>
done!
