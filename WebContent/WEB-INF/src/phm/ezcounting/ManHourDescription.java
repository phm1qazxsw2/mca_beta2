package phm.ezcounting;

import java.util.*;
import java.text.*;

public class ManHourDescription
{
    private static SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    private ArrayList<ManHour> manhours;
    private Map<Integer, Membr> clientMap;
    private Map<Integer, Membr> executorMap;
    private Map<Integer, FeeDetail> billfdMap;
    private Map<Integer, BillChargeItem> billchargeMap;

    public ManHourDescription(ArrayList<ManHour> manhours)
        throws Exception
    {
        this.manhours = manhours;
        String clientIds = new RangeMaker().makeRange(this.manhours, "getClientMembrId");
        clientMap = new SortingMap(MembrMgr.getInstance().
            retrieveList("id in (" + clientIds + ")", "")).doSortSingleton("getId");
        String executorIds = new RangeMaker().makeRange(this.manhours, "getExecuteMembrId");
        executorMap = new SortingMap(MembrMgr.getInstance().
            retrieveList("id in (" + executorIds + ")", "")).doSortSingleton("getId");
        String billfdIds = new RangeMaker().makeRange(this.manhours, "getBillfdId");
        ArrayList<FeeDetail> billfds = FeeDetailMgr.getInstance().retrieveList("id in (" + billfdIds + ")", "");        
        billfdMap = new SortingMap(billfds).doSortSingleton("getId");
        String chargeitemIds = new RangeMaker().makeRange(billfds, "getChargeItemId");
        ArrayList<BillChargeItem> bcitems = BillChargeItemMgr.getInstance().retrieveList
                ("chargeitem.id in (" + chargeitemIds + ")", "");
        billchargeMap = new SortingMap(bcitems).doSortSingleton("getId");  
    }

    public String getClientLink(ManHour mh)
    {
        String ret = "<a target=_blank href=\"manhour_go_bill.jsp?mhId=" + mh.getId() + "\">" + getClientName(mh) + "</a>";
        return ret;
    }

    public String getClientName(ManHour mh)
    {
        Membr membr = clientMap.get(new Integer(mh.getClientMembrId()));
        return membr.getName();
    }

    public String getSalaryLink(ManHour mh) 
    {
        String ret = "<a target=_blank href=\"manhour_go_salary.jsp?mhId=" + mh.getId() + "\">" + getExecutorName(mh) + "</a>";
        return ret;
    }

    public String getExecutorName(ManHour mh)
    {
        Membr membr = executorMap.get(new Integer(mh.getExecuteMembrId()));
        return membr.getName();
    }

    public int getChargeItemId(ManHour mh)
    {
        FeeDetail fd = billfdMap.get(new Integer(mh.getBillfdId()));
if (fd==null)
    return 0;
        return fd.getChargeItemId();

    }

    public String getChargeName(ManHour mh)
    {
        FeeDetail fd = billfdMap.get(new Integer(mh.getBillfdId()));
if (fd==null)
    return "###";
        BillChargeItem bcitem = billchargeMap.get(new Integer(fd.getChargeItemId()));
        return bcitem.getName();
    }

    public String getMonth(ManHour mh)
    {
        FeeDetail fd = billfdMap.get(new Integer(mh.getBillfdId()));
if (fd==null)
    return "";
        BillChargeItem bcitem = billchargeMap.get(new Integer(fd.getChargeItemId()));
        return sdf.format(bcitem.getMonth());
    }
    
    public int getChargeUnitPrice(ManHour mh)
    {
        FeeDetail fd = billfdMap.get(new Integer(mh.getBillfdId()));
if (fd==null)
    return 0;
        return fd.getUnitPrice();
    }

    public int getChargeNum(ManHour mh)
    {
        FeeDetail fd = billfdMap.get(new Integer(mh.getBillfdId()));
if (fd==null)
    return 0;
        return fd.getNum();
    }

    public int getChargeSubtotal(ManHour mh)
    {
        FeeDetail fd = billfdMap.get(new Integer(mh.getBillfdId()));
if (fd==null)
    return 0;
        return fd.getUnitPrice() * fd.getNum();
    }

    public String getNote(ManHour mh)
    {
        FeeDetail fd = billfdMap.get(new Integer(mh.getBillfdId()));
if (fd==null)
    return "";
        String note = fd.getNote();
        return (note==null)?"":note;
    }
}