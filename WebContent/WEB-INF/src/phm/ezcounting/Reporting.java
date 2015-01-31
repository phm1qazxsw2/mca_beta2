package phm.ezcounting;

import dbo.*;
import java.util.*;
import java.text.*;
import jsf.*;

public class Reporting
{
    Date _start;
    Date _end;   
    int[] numbers = null;
    ArrayList<MembrInfoBillRecord> bills = null;
    ArrayList<MembrInfoBillRecord> salaries = null;
    ArrayList<Vitem> income = null;
    ArrayList<Vitem> cost = null;

    Map<Integer/*incomesmallitemId*/, Vector<ChargeItemMembr>> feeMap = null;
    Map<Integer/*IncomeSmallItemId*/, Vector<IncomeSmallItem>> incomesmallitemMap = null;
    Map<String/*chargekey*/, Vector<Discount>> discountMap = null;
    Map<Integer/*billType*/, Vector<MembrInfoBillRecord>> salaryMap = null;

    static SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd");
    public Reporting(int bunitId, Date start, Date end)
        throws Exception
    {
        _start = start;
        _end = end;
        numbers = new int[8];
        bills = new ArrayList<MembrInfoBillRecord>();
        salaries = new ArrayList<MembrInfoBillRecord>();
        income = new ArrayList<Vitem>();
        cost = new ArrayList<Vitem>();
        EzCountingService ezsvc = EzCountingService.getInstance();
        Calendar c = Calendar.getInstance();
        c.setTime(end);
        c.add(Calendar.DATE, 1);
        Date endNextDay = c.getTime();
        ezsvc.getMonthlyNumbers(bunitId, numbers, start, endNextDay, bills, salaries, income, cost);


        ArrayList<BillRecordInfo> targetRecords = BillRecordInfoMgr.getInstance().
            retrieveList("month>='" + sdf2.format(start) + "' and month<'" + sdf2.format(endNextDay) + "'" + 
                " and billType="+Bill.TYPE_BILLING, "");
        ArrayList<BillRecordInfo> salaryRecords = BillRecordInfoMgr.getInstance().
            retrieveList("month>='" + sdf2.format(start) + "' and month<'" + sdf2.format(endNextDay) + "'" + 
                " and billType="+Bill.TYPE_SALARY, "");
        
        String brids = new RangeMaker().makeRange(targetRecords, "getId");

        // 找出這批record 所有的 charge, 并放到 feeMap 里
        ArrayList<ChargeItemMembr> all_fees = ChargeItemMembrMgr.getInstance().
            retrieveList("chargeitem.billRecordId in (" + brids + ")", "");
        String chargeIds = new RangeMaker().makeRange(all_fees, "getChargeItemId");
        ArrayList<DiscountInfo> all_discounts = DiscountInfoMgr.getInstance().
            retrieveList("chargeItemId in (" + chargeIds + ")", ""); 
        
        feeMap = new SortingMap(all_fees).doSort("getSmallItemId");
        discountMap = new SortingMap(all_discounts).doSort("getChargeKey");

        Object[] objs = SmallItemMgr.getInstance().retrieve("","");
        Map<Integer/*smallItemId*/, Vector<SmallItem>> smallitemMap = 
            new SortingMap().doSort(objs, new ArrayList<SmallItem>(), "getId");
        objs = IncomeSmallItemMgr.getInstance().retrieve("","");
        
        incomesmallitemMap = new SortingMap().doSort(objs, new ArrayList<IncomeSmallItem>(), "getId");

        salaryMap = new SortingMap(salaries).doSort("getBillType");
    }

    // 雜費收入
    public int getIncomeTotal() {
        return numbers[0];
    }
    // 雜費已收
    public int getIncomeReceived() {
        return numbers[1];
    }      
    // 雜費支出
    public int getSpendingTotal() {
        return numbers[2];
    }
    // 雜費已付
    public int getSpendingPaid() {
        return numbers[3];
    }
    // 學費收入
    public int getRevenueTotal() {
        return numbers[4];
    }
    // 學費已收
    public int getRevenueReceived() {
        return numbers[5];
    }
    // 薪資支出
    public int getSalaryTotal() {
        return numbers[6];
    }
    // 薪資已付
    public int getSalaryPaid() {
        return numbers[7];
    }

    int getChargeAmount(ChargeItemMembr ci, Map<String, Vector<Discount>> discountMap)
    {
        int ret = ci.getMyAmount();
        Vector<Discount> dv = discountMap.get(ci.getChargeKey());
        if (dv!=null) {
            for (int i=0; i<dv.size(); i++) {
                ret -= dv.get(i).getAmount();
            }
        }
        return ret;
    }

    public Map<IncomeSmallItem, Integer> getRevenueDetails()
        throws Exception
    {
        Map<IncomeSmallItem, Integer> ret = new LinkedHashMap<IncomeSmallItem, Integer>();
        Set<Integer> keys = feeMap.keySet();
        Iterator<Integer> keyIter = keys.iterator();
        while (keyIter.hasNext()) {
            int thisChargeAmount = 0;
			Integer incomesmallitemId = keyIter.next();
            IncomeSmallItem isi = incomesmallitemMap.get(incomesmallitemId).get(0);
			Vector<ChargeItemMembr> fees = feeMap.get(incomesmallitemId);
            for (int i=0; i<fees.size(); i++) {
                ChargeItemMembr ci = fees.get(i);
                thisChargeAmount += getChargeAmount(ci, discountMap);
            }
            ret.put(isi, new Integer(thisChargeAmount));
        }
        return ret;
    }

    public Map<String, Integer> getSalaryDetails()
        throws Exception
    {
        Map<String, Integer> ret = new LinkedHashMap<String, Integer>();
        Set<Integer> keys = salaryMap.keySet();
        Iterator<Integer> keyIter = keys.iterator();
        while (keyIter.hasNext()) {
            int n = 0;
            Integer billtype = keyIter.next();
            Vector<MembrInfoBillRecord> salaries = salaryMap.get(billtype);
            for (int i=0; salaries!=null&&i<salaries.size(); i++)
                n += salaries.get(i).getReceivable();
            ret.put(salaries.get(0).getBillName(), new Integer(n));
        }
        return ret;
    }


    public Map<String/*acctcode*/, Vector<Vitem>> getIncomeDetails()
        throws Exception
    {
        return new SortingMap(income).doSort("getAcctCodeTrim");
    }

    public Map<String/*acctcode*/, Vector<Vitem>> getCostDetails()
        throws Exception
    {
        return new SortingMap(cost).doSort("getAcctCodeTrim");
    }
 

}
