package mca;

import phm.accounting.*;
import phm.ezcounting.*;
import literalstore.*;
import java.util.*;
import java.text.*;
import phm.util.*;
import jsf.*;
import com.axiom.util.*;
import beans.jdbc.*;


public class McaInterest2
{
    int tran_id;
    Map<Integer, Bunit> bunitMap = null;
    Map<String, ArrayList<BillPaidInfo>> paidsMap = null;
    Map<String, McaDeferred> deferredMap = null;
    Map<Integer, McaFeeRecord> mcafeerecordMap = null;
    Map<Integer, McaFee> feeMap = null;
    Map<String, ArrayList<ChargeItemMembr>> chargeitemMap = null;
    Map<String, ArrayList<Discount>> discountMap = null;
    static SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    static SimpleDateFormat sdf2 = new SimpleDateFormat("MM/dd");
    Map<Integer, Date> freezedayMap = null;
    Map<Integer, ChargeItem> latefeeitemMap = null;
    Map<Integer, ChargeItem> interestitemMap = null;

    EzCountingService ezsvc = null;
    ChargeItemMembrMgr cimmgr = null;    
    ChargeMgr cmgr = null;
    MembrBillRecordMgr sbrmgr = null;

    public McaInterest2(int tran_id)
        throws Exception
    {
        this.tran_id = tran_id;
    }

    int getDays(Date d1, Date d2) 
        throws Exception
    {
        return (int)((d2.getTime() - d1.getTime())/(86400*1000));
    }

    static long grace_range = 5 * 86400 * 1000; // 5 天
    static double daily = (0.01/30);
    public void calcLatefeeInterest(MembrInfoBillRecord bill, Date d, User user)
        throws Exception
    {
        ArrayList<Delta> deltas = fixDeltas(bill);
        int amount = 0;
        StringBuffer sb = new StringBuffer();
        sb.append(sdf2.format(d));
        sb.append("<table border=1>");
        sb.append("<tr><th>Date</th><th>Plan</th><th>Paid</th><th>Balance</th><th>Intr.base</th><th>days</th><th>Intr.("+sdf2.format(d)+")</th></tr>");
        double intr_total = 0;
        for (int i=0; i<deltas.size(); i++) {
            Delta dt = deltas.get(i);
            sb.append("<tr align=right><td>"+sdf2.format(dt.date)+"</td><td>&nbsp;");
            if (dt.amount>0)
                sb.append(dt.amount);
            sb.append("</td><td>&nbsp;");
            if (dt.amount<0)
                sb.append(0-dt.amount);
            sb.append("</td><td>");
            amount += dt.amount;
            sb.append(amount);
            sb.append("</td><td>&nbsp;");
            if (amount>0)
                sb.append(amount);
            sb.append("</td><td>&nbsp;");
            int days = 0;
            if (amount>0) {
                days = getDays(dt.date, d);
                if (days>0) {
                    if (i<deltas.size()-1) {
                        Delta next = deltas.get(i+1);
                        int tmp = getDays(dt.date, next.date);
                        days = Math.min(days, tmp);
                    }
                    if (days<6)
                        days = 0;
                }
                if (days>0) {
                    sb.append(days);
                }
            }
            sb.append("</td><td>&nbsp;");
            if (days>0 && amount>0) {
                double intr = amount * days * daily;
                intr_total+= intr;
                sb.append((int)Math.rint(intr));
            }
            sb.append("</td></tr>");
        }
        sb.append("</table>");

        if (intr_total>0) {
            makeLateFee(bill, user);
            makeInterest(bill, (int)Math.rint(intr_total), sb.toString(), user);

            if (bill.getPaidStatus()==MembrBillRecord.STATUS_FULLY_PAID) {
                sbrmgr.executeSQL("update membrbillrecord set paidStatus=" + MembrBillRecord.STATUS_PARTLY_PAID + 
                    " where ticketId='" + bill.getTicketId() + "'");
            }
        }
        else {
            int deduct = deleteLateFee(bill, user);
            deduct += deleteInterest(bill, user);
            
            ArrayList<BillPaidInfo> paids = paidsMap.get(bill.getTicketId());
            int paidamount = 0;
            for (int i=0; paids!=null && i<paids.size(); i++)
                paidamount += paids.get(i).getPaidAmount();

            int total = bill.getReceivable() - deduct;
            if (total==paidamount) {
                if (bill.getPaidStatus()!=MembrBillRecord.STATUS_FULLY_PAID)
                    sbrmgr.executeSQL("update membrbillrecord set paidStatus=" + MembrBillRecord.STATUS_FULLY_PAID + 
                    " where ticketId='" + bill.getTicketId() + "'");
            }
            else if (total>paidamount) {
                if (paidamount>0 && bill.getPaidStatus()!=MembrBillRecord.STATUS_PARTLY_PAID)
                    sbrmgr.executeSQL("update membrbillrecord set paidStatus=" + MembrBillRecord.STATUS_PARTLY_PAID + 
                    " where ticketId='" + bill.getTicketId() + "'");
                else if (paidamount==0 && bill.getPaidStatus()!=MembrBillRecord.STATUS_NOT_PAID)
                    sbrmgr.executeSQL("update membrbillrecord set paidStatus=" + MembrBillRecord.STATUS_NOT_PAID + 
                    " where ticketId='" + bill.getTicketId() + "'");
            }
            else {// total<paidamount
				BillPaidInfo bp = paids.get(paids.size()-1);
				int diff = paidamount - total;
				if (bp.getPaidAmount()<=diff)
					throw new Exception("刪除利息後繳費大于帳單金額 total=" + total + " paid=" + paidamount + " ticket#:" + bill.getTicketId());
				new BillPaidMgr(tran_id).executeSQL("update billpaid set amount=amount-" + diff + " where billPayId=" + bp.getBillPayId() +
					   " and ticketId='" + bp.getTicketId() + "'");
				new BillPayMgr(tran_id).executeSQL("update billpay set remain=remain+" + diff + " where id=" + bp.getBillPayId());
			}
        }
    }

    public int deleteLateFee(MembrInfoBillRecord bill, User user)
        throws Exception
    {
        ArrayList<ChargeItemMembr> citems = chargeitemMap.get(bill.getTicketId());
        ChargeItemMembr ci = null;
        for (int i=0; citems!=null && i<citems.size(); i++) {
            if (citems.get(i).getChargeName_().equals(McaService.BILL_ITEMS[23])) { // ## Latefee
                ci = citems.get(i);
                break;
            }
        }

        if (ci!=null) {
            sbrmgr.executeSQL("update membrbillrecord set printDate=0, forcemodify=" + new Date().getTime() + 
                " where ticketId='" + bill.getTicketId() + "'");
            Date nextFreezeDay = freezedayMap.get(bill.getBunitId());
            ezsvc.deleteCharge(tran_id, ci, user, nextFreezeDay);
            return ci.getMyAmount();
        }
        return 0;
    }

    public int deleteInterest(MembrInfoBillRecord bill, User user)
        throws Exception
    {
        ArrayList<ChargeItemMembr> citems = chargeitemMap.get(bill.getTicketId());
        ChargeItemMembr ci = null;
        for (int i=0; citems!=null && i<citems.size(); i++) {
            if (citems.get(i).getChargeName_().equals(McaService.BILL_ITEMS[24])) { // ## Interest
                ci = citems.get(i);
                break;
            }
        }

        if (ci!=null) {
            sbrmgr.executeSQL("update membrbillrecord set printDate=0, forcemodify=" + new Date().getTime() + 
                " where ticketId='" + bill.getTicketId() + "'");
            Date nextFreezeDay = freezedayMap.get(bill.getBunitId());
            ezsvc.deleteCharge(tran_id, ci, user, nextFreezeDay);
            return ci.getMyAmount();
        }
        return 0;
    }

    public void makeLateFee(MembrInfoBillRecord bill, User user)
        throws Exception
    {
        ArrayList<ChargeItemMembr> citems = chargeitemMap.get(bill.getTicketId());
        for (int i=0; citems!=null && i<citems.size(); i++) {
            if (citems.get(i).getChargeName_().equals(McaService.BILL_ITEMS[11])) // Latefee
                return;
            if (citems.get(i).getChargeName_().equals(McaService.BILL_ITEMS[23])) // ## Latefee
                return;
        }
        
        sbrmgr.executeSQL("update membrbillrecord set printDate=0, forcemodify=" + new Date().getTime() + 
                " where ticketId='" + bill.getTicketId() + "'");
        Date nextFreezeDay = freezedayMap.get(bill.getBunitId());
        ChargeItem lf = latefeeitemMap.get(bill.getBillRecordId());
        McaFeeRecord mr = mcafeerecordMap.get(bill.getBillRecordId());
        McaFee fee = feeMap.get(mr.getFeeId());
        Charge c = ezsvc.addChargeMembr(tran_id, lf, bill.getMembrId(), mr, user.getId(), nextFreezeDay);
        ChargeItemMembr ci = cimmgr.find("chargeItemId=" + lf.getId() + " and charge.membrId=" + bill.getMembrId());
        ezsvc.setChargeItemMembrAmount(tran_id, ci, fee.getLateFee() , user.getId(), nextFreezeDay);
    }

    // makeInterest(bill, intr_total, sb, user);
    public void makeInterest(MembrInfoBillRecord bill, int interest, String table, User user)
        throws Exception
    {
        ChargeItemMembr ci = null;
        ArrayList<ChargeItemMembr> citems = chargeitemMap.get(bill.getTicketId());
        for (int i=0; citems!=null && i<citems.size(); i++) {
            if (citems.get(i).getChargeName_().equals(McaService.BILL_ITEMS[24])) { // ## Interest
                ci = citems.get(i);
                break;
            }
        }

        Date nextFreezeDay = freezedayMap.get(bill.getBunitId());
        ChargeItem ic = interestitemMap.get(bill.getBillRecordId());
        McaFeeRecord mr = mcafeerecordMap.get(bill.getBillRecordId());
        McaFee fee = feeMap.get(mr.getFeeId());
        
        Charge c = null;
        if (ci==null) {
            c = ezsvc.addChargeMembr(tran_id, ic, bill.getMembrId(), mr, user.getId(), nextFreezeDay);
            ci = cimmgr.find("chargeItemId=" + ic.getId() + " and charge.membrId=" + bill.getMembrId());
        }
        else {
            c = cmgr.find("chargeItemId=" + ci.getChargeItemId() + " and membrId=" + ci.getMembrId());
        }

        c.setNote(table);
        cmgr.save(c);

        if (ci.getMyAmount()!=interest) {
            sbrmgr.executeSQL("update membrbillrecord set printDate=0, forcemodify=" + new Date().getTime() + 
                " where ticketId='" + bill.getTicketId() + "'");
            ezsvc.setChargeItemMembrAmount(tran_id, ci, interest , user.getId(), nextFreezeDay);
        }
    }

    // 這個要和 mcaService 的 getBaseAmount 同步
    // 不包含 interest1, latefee2, interest2 (但有 latefee1) 的金額  
    public int getBaseWithoutLatefee(MembrInfoBillRecord bill) 
        throws Exception
    {
        ArrayList<ChargeItemMembr> citems = chargeitemMap.get(bill.getTicketId());;
        return new McaService(tran_id).getBaseWithoutLatefee(citems, discountMap);
        /*
        ArrayList<ChargeItemMembr> citems = chargeitemMap.get(bill.getTicketId());
        int deduct = 0;
        for (int i=0; citems!=null && i<citems.size(); i++) {
            if (citems.get(i).getChargeName_().equals(McaService.BILL_ITEMS[11])) // Latefee
                deduct += citems.get(i).getMyAmount();
            if (citems.get(i).getChargeName_().equals(McaService.BILL_ITEMS[22])) // Interest
                deduct += citems.get(i).getMyAmount();
            if (citems.get(i).getChargeName_().equals(McaService.BILL_ITEMS[23])) // ## Latefee
                deduct += citems.get(i).getMyAmount();
            if (citems.get(i).getChargeName_().equals(McaService.BILL_ITEMS[24])) // ## Interest
                deduct += citems.get(i).getMyAmount();
        }
        return bill.getReceivable() - deduct;
        */
    }

    public int getLateFee(MembrInfoBillRecord bill) 
        throws Exception
    {
        ArrayList<ChargeItemMembr> citems = chargeitemMap.get(bill.getTicketId());
        for (int i=0; citems!=null && i<citems.size(); i++) {
            if (citems.get(i).getChargeName_().equals(McaService.BILL_ITEMS[11])) { // LateFee

                return citems.get(i).getMyAmount();
            }
        }
        return 0;
    }

    public int getInterest(MembrInfoBillRecord bill) 
        throws Exception
    {
        ArrayList<ChargeItemMembr> citems = chargeitemMap.get(bill.getTicketId());
        for (int i=0; citems!=null && i<citems.size(); i++) {
            if (citems.get(i).getChargeName_().equals(McaService.BILL_ITEMS[22])) { // Interest

                return citems.get(i).getMyAmount();
            }
        }
        return 0;
    }

    public int getInterest2(MembrInfoBillRecord bill) 
        throws Exception
    {
        ArrayList<ChargeItemMembr> citems = chargeitemMap.get(bill.getTicketId());
        for (int i=0; citems!=null && i<citems.size(); i++) {
            if (citems.get(i).getChargeName_().equals(McaService.BILL_ITEMS[24])) { // ## Interest

                return citems.get(i).getMyAmount();
            }
        }
        return 0;
    }

    public ArrayList<Delta> fixDeltas(MembrInfoBillRecord bill)
        throws Exception
    {
        McaDeferred deferred = deferredMap.get(bill.getTicketId());
        ArrayList<Delta> list = new ArrayList<Delta>();
        int base = getBaseWithoutLatefee(bill); // 不包含 latefee1, interest1, latefee2, interest2 的金額

        if (deferred==null || deferred.getType()==0) {
            list.add(new Delta(0, base, bill.getMyBillDate()));
        }
        else {
            // 這里 duplicate McaService 的 breaking fees 要注意同步問題
            int latefee = getLateFee(bill);
            int interest = getInterest(bill);
            int interest2 = getInterest2(bill);
            int onetime = bill.getReceivable() - (base + latefee + interest + interest2);

            Calendar c = Calendar.getInstance();
            if (deferred.getType()==McaDeferred.TYPE_STANDARD) {
                int a = base/4;
                c.setTime(bill.getMyBillDate());
                list.add(new Delta(0, (a*2 + latefee + onetime), c.getTime()));
                c.add(Calendar.MONTH, 1);
                list.add(new Delta(0, a, c.getTime()));
                c.add(Calendar.MONTH, 1);
                list.add(new Delta(0, a, c.getTime()));
            }
            else { // MONTHLY
                int[] series = new int[5];
                McaService.getInterestAmount((base+latefee), series);
                c.setTime(bill.getMyBillDate());
                for (int i=0; i<series.length; i++) {
                    int amt = series[i];
                    if (i==0)
                        amt += onetime;
                    list.add(new Delta(0, amt, c.getTime()));
                    c.add(Calendar.MONTH, 1);
                }
            }
        }

        ArrayList<BillPaidInfo> paids = paidsMap.get(bill.getTicketId());
        for (int i=0; paids!=null && i<paids.size(); i++) {
            BillPaidInfo p = paids.get(i);
            list.add(new Delta(1, (0-p.getPaidAmount()), p.getPaidTime()));
        }

        Collections.sort(list);
        return list;
    }

    public void setup(MembrInfoBillRecord bill)
        throws Exception
    {
        ArrayList<MembrInfoBillRecord> bills = new ArrayList<MembrInfoBillRecord>();
        bills.add(bill);
        setup(bills);
    }

    public void setup(ArrayList<MembrInfoBillRecord> bills)
        throws Exception
    {
        String ticketIds = new RangeMaker().makeRange(bills, "getTicketIdAsString");        
        ArrayList<BillPaidInfo> paids = new BillPaidInfoMgr(tran_id).retrieveList("billpaid.ticketId in (" + ticketIds + ") and billpaid.amount>0", "");
        paidsMap = new SortingMap(paids).doSortA("getTicketId");

        ArrayList<ChargeItemMembr> citems = new ChargeItemMembrMgr(tran_id).retrieveList("ticketId in (" + ticketIds + ")", "");
        chargeitemMap = new SortingMap(citems).doSortA("getTicketId");

        ArrayList<Discount> discounts = new DiscountMgr(tran_id).retrieveList("","");
        discountMap = new SortingMap(discounts).doSortA("getChargeKey");
    
        ArrayList<McaDeferred> deferreds = new McaDeferredMgr(tran_id).retrieveList("ticketId in (" + ticketIds + ")", "");
        deferredMap = new SortingMap(deferreds).doSortSingleton("getTicketId");

        String billrecordIds = new RangeMaker().makeRange(bills, "getBillRecordId");
        ArrayList<McaFeeRecord> mrs = new McaFeeRecordMgr(tran_id).retrieveList("billRecordId in (" + billrecordIds + ")", "");
        mcafeerecordMap = new SortingMap(mrs).doSortSingleton("getId");

        String feeIds = new RangeMaker().makeRange(mrs, "getFeeId");
        ArrayList<McaFee> fees = new McaFeeMgr(tran_id).retrieveList("id in (" + feeIds + ")", "");
        feeMap = new SortingMap(fees).doSortSingleton("getId");

        ArrayList<Bunit> bunits = new BunitMgr(tran_id).retrieveList("flag=" + Bunit.FLAG_BIZ, "");
        bunitMap = new SortingMap(bunits).doSortSingleton("getId");

        ezsvc = EzCountingService.getInstance();
        BunitHelper bh = new BunitHelper(tran_id);
        freezedayMap = new HashMap<Integer, Date>();
        for (int i=0; i<bunits.size(); i++) {
            Bunit bu = bunits.get(i);
            Date nextFreezeDay = ezsvc.getFreezeNextDay(bh.getSpace("bunitId", bu.getId()));
            freezedayMap.put(bu.getId(), nextFreezeDay);
        }

        latefeeitemMap = new HashMap<Integer, ChargeItem>();
        interestitemMap = new HashMap<Integer, ChargeItem>();
        McaService mcasvc = new McaService(tran_id);
        for (int i=0; i<mrs.size(); i++) {
            McaFeeRecord mr = mrs.get(i);
            McaFee fee = feeMap.get(mr.getFeeId());
            Bunit bu = bunitMap.get(mr.getBunitId());

            ChargeItem ci = mcasvc.getChargeItem(bu.getLabel(), fee, McaService.BILL_ITEMS[23]);
            latefeeitemMap.put(mr.getId(), ci);

            ci = mcasvc.getChargeItem(bu.getLabel(), fee, McaService.BILL_ITEMS[24]);
            interestitemMap.put(mr.getId(), ci);
        }

        cimmgr = new ChargeItemMembrMgr(tran_id);
        cmgr = new ChargeMgr(tran_id);
        sbrmgr = new MembrBillRecordMgr(tran_id);
    }

    public int getAutoGeneratedLateFeeInterest(String ticketId)
    {
        int ret = 0;
        ArrayList<ChargeItemMembr> cims = chargeitemMap.get(ticketId);
        for (int i=0; cims!=null && i<cims.size(); i++) {
            ChargeItemMembr cim = cims.get(i);
            if (cim.getChargeName_().equals(McaService.BILL_ITEMS[23])) {
                ret += cim.getMyAmount();
            }
            else if (cim.getChargeName_().equals(McaService.BILL_ITEMS[24])) {
                ret += cim.getMyAmount();
            }
        }
        return ret;
    }

    public void updateLatefeeInterest(User user)
        throws Exception
    {
        Date today = new Date();
        ArrayList<MembrInfoBillRecord> bills = new MembrInfoBillRecordMgr(tran_id).retrieveList(
            "paidStatus!=2 and billrecord.billDate<'" + sdf.format(today) + "'", "");

        setup(bills);
        ezsvc.setModifyAlert(false);
        
        for (int i=0; i<bills.size(); i++) {
            MembrInfoBillRecord bill = bills.get(i);
            calcLatefeeInterest(bill, today, user);
        }

    }

    public static void main(String[] args)
    {
        boolean commit = false;
        int tran_id1 = 0;
        int tran_id2 = 0;
        try {           
        
        	DbConnectionPool pool = 
        	    new DbConnectionPool(args[0], args[1], args[2], args[3]);
            DbPool.setDbPool(pool);
            dbo.DataSource.setup("datasource");

            tran_id1 = dbo.Manager.startTransaction();
            tran_id2 = com.axiom.mgr.Manager.startTransaction();

            User u = (User) new UserMgr(tran_id2).find(1);

            McaInterest mi = new McaInterest(tran_id1);
            mi.updateLatefeeInterest(u);

            dbo.Manager.commit(tran_id1);
            com.axiom.mgr.Manager.commit(tran_id2);

            commit = true;
        }
        catch (Exception e) {
            e.printStackTrace();
            EzCountingService.getInstance().sendWarningException(e, "MCA UPDATING Interest FAILED!!");
        }
        finally {
            if (!commit) {
                try { 
                    dbo.Manager.rollback(tran_id1); 
                    com.axiom.mgr.Manager.rollback(tran_id2);
                }
                catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }    
    }
}


