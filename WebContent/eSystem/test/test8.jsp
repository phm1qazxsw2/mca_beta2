<%@ page language="java" 
    import="com.axiom.mgr.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*"
    contentType="text/html;charset=UTF-8"%>
<%

int tran_id1 = 0;
int tran_id2 = 0;
boolean commit = false;
HashMap<Integer,Bill> ticketType = new HashMap<Integer,Bill>();
// String = month + " " + billname
HashMap<String,BillRecord> billrecords = new HashMap<String,BillRecord>();
// String = CMid + " " + BillRecord name (see above)
HashMap<String,BillItem> billitems = new HashMap<String,BillItem>();
// String = month + " " + BillItem name (see above)
HashMap<String,ChargeItem> chargeitems = new HashMap<String,ChargeItem>();


try {
    tran_id1 = com.axiom.mgr.Manager.startTransaction();
    tran_id2 = dbo.Manager.startTransaction();

    FeeticketMgr ftmgr = new FeeticketMgr(tran_id1);
    ClassesFeeMgr clsfeemgr = new ClassesFeeMgr(tran_id1);
    PayFeeMgr pfmgr = new PayFeeMgr(tran_id1);

    BillMgr bmgr = new BillMgr(tran_id2);
    BillRecordMgr brmgr = new BillRecordMgr(tran_id2);
    BillItemMgr bimgr = new BillItemMgr(tran_id2);
    ChargeItemMgr cimgr = new ChargeItemMgr(tran_id2);
    ChargeMgr cmgr = new ChargeMgr(tran_id2);
    DiscountMgr dmgr = new DiscountMgr(tran_id2);
    MembrBillRecordMgr sbrmgr = new MembrBillRecordMgr(tran_id2);
    BillPayMgr bpmgr = new BillPayMgr(tran_id2);
    BillPaidMgr paidmgr = new BillPaidMgr(tran_id2);
    MembrMgr mmgr = new MembrMgr(tran_id2);

    SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM");

    // 對每一張帳單
    Object[] objs = ftmgr.retrieve("", "");
    for (int i=0; objs!=null&&i<objs.length; i++) {
        Feeticket ft = (Feeticket) objs[i];
        int ticket_type = ft.getFeeticketNewFeenumberCmId();
        Membr membr = mmgr.find("type=" + Membr.TYPE_STUDENT + 
               " and surrogateId=" + ft.getFeeticketStuId());
        Bill bill = null;
        // 如果是新的帳單類型，就產生
        if ((bill=ticketType.get(new Integer(ticket_type)))==null) {
            if (ticket_type>0) {
                // find no bill type, create 1 for it
                ClassesMoney cm = (ClassesMoney) ObjectService.find("jsf.ClassesMoney", "id=" + ticket_type);
                bill = new Bill();
                bill.setName(cm.getClassesMoneyName());
                bill.setPrettyName(cm.getClassesMoneyName());
                bill.setBalanceWay(Bill.MANUAL); // independent
            }
            else {
                // this is monthly bill
                bill = new Bill();
                bill.setName("月費");
                bill.setPrettyName("學雜費繳費單");
                bill.setBalanceWay(Bill.FIFO); // FIFO
            }
            bill.setStatus(1);
            bmgr.create(bill);
            ticketType.put(new Integer(ticket_type), bill);
        }

        // 用每個月份和型別來判定一新的 billrecord
        Date mon = ft.getFeeticketMonth();
        String bn = sdf1.format(mon) + bill.getName();
        BillRecord br = null;
        if ((br=billrecords.get(bn))==null) {
            br = new BillRecord();
            br.setBillId(bill.getId());
            br.setName(bn);
            br.setMonth(mon);
            br.setBillDate(ft.getFeeticketEndPayDate());
            brmgr.create(br);
            billrecords.put(bn, br);
        }        

        Object[] objs2 = clsfeemgr.retrieve("classesFeeFeenumberId=" + ft.getFeeticketFeenumberId(), "");
        for (int j=0; objs2!=null && j<objs2.length; j++)
        {
            ClassesFee cf = (ClassesFee) objs2[j];
            ClassesMoney cm = (ClassesMoney) ObjectService.
                find("jsf.ClassesMoney", "id=" + cf.getClassesFeeCMId());
            String biname = cm.getId() + " " + bill.getName();
            BillItem bi = null;
            if ((bi=billitems.get(biname))==null) {
                bi = new BillItem();
                bi.setBillId(bill.getId());
                bi.setName(cm.getClassesMoneyName());
                bi.setSmallItemId(cm.getClassesMoneyIncomeItem());
                bi.setStatus(1);
                bimgr.create(bi);
                billitems.put(biname, bi);
            }
                
            String ciname = sdf1.format(mon) + biname;
            ChargeItem ci = null;
            if ((ci=chargeitems.get(ciname))==null) {
                ci = new ChargeItem();
                ci.setBillItemId(bi.getId());
                ci.setBillRecordId(br.getId());
                ci.setSmallItemId(bi.getSmallItemId());
                ci.setChargeAmount(cm.getClassesMoneyNumber());
                cimgr.create(ci);
                chargeitems.put(ciname, ci);
            }

            Charge c = new Charge();
            c.setChargeItemId(ci.getId());
            c.setMembrId(membr.getId());
            if (cf.getClassesFeeShouldNumber()!=ci.getChargeAmount())
                c.setAmount(cf.getClassesFeeShouldNumber());
            c.setUserId(cf.getClassesFeeLogId());
            c.setNote(cf.getClassesFeeLogPs());
            cmgr.create(c);

            // handle discount
            Object[] objs3 = CfDiscountMgr.getInstance().retrieve("cfDiscountClassesFeeId=" + cf.getId(),"");
            if (objs3!=null) {
                for (int k=0; k<objs3.length; k++) {
                    CfDiscount d = (CfDiscount) objs3[k];
                    Discount dd = new Discount();
                    dd.setChargeItemId(ci.getId());
                    dd.setMembrId(membr.getId());
                    dd.setUserId(d.getCfDiscountLogId());
                    dd.setAmount(d.getCfDiscountNumber());
                    dd.setType(d.getCfDiscountTypeId());
                    dd.setNote(d.getCfDiscountVPs());
                    dmgr.create(dd);
                }
            }
        }

        MembrBillRecord sbr = new MembrBillRecord();
        sbr.setMembrId(membr.getId());
        sbr.setBillRecordId(br.getId());
        sbr.setTicketId(ft.getFeeticketFeenumberId()+"");
        sbr.setReceivable(ft.getFeeticketSholdMoney()-ft.getFeeticketDiscountMoney());
        sbr.setReceived(ft.getFeeticketPayMoney());
        if (ft.getFeeticketStatus()==91) {
            sbr.setPaidStatus(MembrBillRecord.STATUS_FULLY_PAID);
            // need to import paid information
            Object[] objs5 = pfmgr.retrieve("payFeeFeenumberId=" + sbr.getTicketId(), "");
            for (int k=0; objs5!=null && k<objs5.length; k++) {
                PayFee fee = (PayFee) objs5[k];
                BillPay pay = new BillPay();
                if (fee.getPayFeeSourceCategory()==1 || fee.getPayFeeSourceCategory()==2)
                    pay.setVia(BillPay.VIA_ATM);
                else if (fee.getPayFeeSourceCategory()==3)
                    pay.setVia(BillPay.VIA_STORE);
                else
                    pay.setVia(BillPay.VIA_INPERSON);
                pay.setRecordTime(fee.getPayFeeLogDate());
                pay.setAmount(fee.getPayFeeMoneyNumber());
                pay.setMembrId(sbr.getMembrId());
                pay.setUserId(fee.getPayFeeLogId());
                bpmgr.create(pay);

                BillPaid paid = new BillPaid();
                paid.setBillPayId(pay.getId());
                paid.setTicketId(sbr.getTicketId());
                paid.setRecordTime(pay.getRecordTime());
                paid.setAmount(pay.getAmount());
                paidmgr.create(paid);
            }
        }
        else if (ft.getFeeticketStatus()==1)
             sbr.setPaidStatus(MembrBillRecord.STATUS_NOT_PAID);
        sbrmgr.create(sbr);
    }

    com.axiom.mgr.Manager.commit(tran_id1);
    dbo.Manager.commit(tran_id2);
    commit = true;
}
finally {
    if (!commit) {
        com.axiom.mgr.Manager.rollback(tran_id1);
        try { dbo.Manager.rollback(tran_id2); } catch (Exception ee) {}
    }
}

ticketType = null;
billrecords = null;
billitems = null;
chargeitems = null;
%> 
done!




