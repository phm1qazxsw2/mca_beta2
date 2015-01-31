<%@ page language="java" 
    import="com.axiom.mgr.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*"
    contentType="text/html;charset=UTF-8"%>
<%

int tran_id1 = 0;
int tran_id2 = 0;
boolean commit = false;

// String = month + " " + bill.prettyName
HashMap<String,BillRecord> billrecords = new HashMap<String,BillRecord>();
// String = salaryTypeName
HashMap<String,BillItem> billitems = new HashMap<String,BillItem>();
// String = month + " " + BillItem name (see above)
HashMap<String,ChargeItem> chargeitems = new HashMap<String,ChargeItem>();

try {
    tran_id1 = com.axiom.mgr.Manager.startTransaction();
    tran_id2 = dbo.Manager.startTransaction();

    SalaryFeeMgr sfmgr = SalaryFeeMgr.getInstance();
    SalaryTypeMgr tpmgr = SalaryTypeMgr.getInstance();
    SalaryBankMgr sbmgr = SalaryBankMgr.getInstance();
    BillPayMgr bpmgr = new BillPayMgr(tran_id2);
    BillPaidMgr paidmgr = new BillPaidMgr(tran_id2);
    MembrBillRecordMgr sbrmgr = new MembrBillRecordMgr(tran_id2);
    BillRecordMgr brmgr = new BillRecordMgr(tran_id2);
    BillItemMgr bimgr = new BillItemMgr(tran_id2);
    ChargeItemMgr cimgr = new ChargeItemMgr(tran_id2);
    ChargeMgr cmgr = new ChargeMgr(tran_id2);
    MembrMgr mmgr = new MembrMgr(tran_id2);

    BillMgr bmgr = new BillMgr(tran_id2);
    Bill[] b = new Bill[2];
    b[0] = new Bill();
    b[0].setName("正職薪資");
    b[0].setPrettyName("員工薪資");
    b[0].setStatus(Bill.STATUS_ACTIVE);
    b[0].setBillType(Bill.TYPE_SALARY);
    b[0].setPrivLevel(Bill.PRIV_OFFICER);
    bmgr.create(b[0]);

    b[1] = new Bill();
    b[1].setName("兼職薪資");
    b[1].setPrettyName("才藝課鐘點費");
    b[1].setStatus(Bill.STATUS_ACTIVE);
    b[1].setBillType(Bill.TYPE_SALARY);
    b[1].setPrivLevel(Bill.PRIV_MANAGER);
    bmgr.create(b[1]);

    SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM");
    SalaryTicketMgr stmgr = new SalaryTicketMgr(tran_id1);
    Object[] objs = stmgr.retrieve("", "");
    for (int i=0; objs!=null && i<objs.length; i++) {
        SalaryTicket s = (SalaryTicket) objs[i];
        Membr membr = mmgr.find("type=" + Membr.TYPE_TEACHER + 
               " and surrogateId=" + s.getSalaryTicketTeacherId());
        Date mon = s.getSalaryTicketMonth();
        // 用每個月份和型別來判定一新的 billrecord
        int parttime = s.getSalaryTicketTeacherParttime();
        Bill bill = (parttime==0)?b[0]:b[1];
        String bn = sdf1.format(mon) + " " + bill.getName();
        BillRecord br = null;
        if ((br=billrecords.get(bn))==null) {
            br = new BillRecord();
            br.setBillId(bill.getId());
            br.setName(bn);
            br.setMonth(mon);
            br.setBillDate(mon);
            brmgr.create(br);
            billrecords.put(bn, br);
        }

        String ticketId = s.getSalaryTicketSanumberId() + "";
        Object[] objs2 = sfmgr.retrieve("salaryFeeSanumberId=" + ticketId, "");
        for (int j=0; objs2!=null && j<objs2.length; j++) {
            SalaryFee sf = (SalaryFee) objs2[j];
            SalaryType stype = (SalaryType) ObjectService.find("jsf.SalaryType", "id=" + sf.getSalaryFeeTypeId());
            String biname = parttime + " " + stype.getSalaryTypeName();
            BillItem bi = null;
            if ((bi=billitems.get(biname))==null) {
                bi = new BillItem();
                bi.setBillId(bill.getId());
                bi.setName(stype.getSalaryTypeName());
                int tp = stype.getSalaryType();
                if (stype.getSalaryType()>3)
                    tp = 1;
                bi.setSmallItemId(tp);
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
                ci.setChargeAmount(0);
                cimgr.create(ci);
                chargeitems.put(ciname, ci);
            }

            Charge c = new Charge();
            c.setChargeItemId(ci.getId());
            c.setMembrId(membr.getId());
            int amount = sf.getSalaryFeeNumber();
            if (amount!=0) {
                if (stype.getSalaryType()==2 || stype.getSalaryType()==3)
                    amount = 0 - amount;
                c.setAmount(amount);
                c.setUserId(sf.getSalaryFeeLogId());
                c.setNote(sf.getSalaryFeeLogPs());
                cmgr.create(c);
            }
        }

        MembrBillRecord sbr = new MembrBillRecord();
        sbr.setMembrId(membr.getId());
        sbr.setBillRecordId(br.getId());
        sbr.setTicketId(ticketId);
        sbr.setReceivable(s.getSalaryTicketTotalMoney());
        sbr.setReceived(s.getSalaryTicketPayMoney());

        if (s.getSalaryTicketTotalMoney()==s.getSalaryTicketPayMoney())
            sbr.setPaidStatus(MembrBillRecord.STATUS_FULLY_PAID);
        else if (s.getSalaryTicketPayMoney()==0)
            sbr.setPaidStatus(MembrBillRecord.STATUS_NOT_PAID);
        else if (s.getSalaryTicketTotalMoney()>s.getSalaryTicketPayMoney())
            sbr.setPaidStatus(MembrBillRecord.STATUS_PARTLY_PAID);
        
        // need to import paid information, could be more than 1
        Object[] objs3 = sbmgr.retrieve("salaryBankSanumber=" + sbr.getTicketId(), "");
        for (int j=0; objs3!=null && j<objs3.length; j++) {
            SalaryBank sbank = (SalaryBank) objs3[j];
            BillPay pay = new BillPay();
            pay.setRecordTime(sbank.getSalaryBankPayDate());
            pay.setAmount(sbank.getSalaryBankMoney());
            pay.setMembrId(sbr.getMembrId());
            pay.setUserId(sbank.getSalaryBankLogId());
            pay.setAccountId(sbank.getSalaryBankPayAccountId());
            if (sbank.getSalaryBankPayWay()==1)
                pay.setVia(BillPay.SALARY_CASH);
            else if (sbank.getSalaryBankPayWay()==1)
                pay.setVia(BillPay.SALARY_CHECK);
            else if (sbank.getSalaryBankPayWay()==3)
                pay.setVia(BillPay.SALARY_WIRE);
            bpmgr.create(pay);

            BillPaid paid = new BillPaid();
            paid.setBillPayId(pay.getId());
            paid.setTicketId(sbr.getTicketId());
            paid.setRecordTime(pay.getRecordTime());
            paid.setAmount(pay.getAmount());
            paidmgr.create(paid);
        }
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

%> 
done!




