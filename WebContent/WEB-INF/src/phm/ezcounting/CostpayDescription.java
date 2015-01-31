package phm.ezcounting;

import mca.*;
import java.util.*;
import java.text.*;
import jsf.*;

public class CostpayDescription
{
    private Object[] costpays = null;
    private Map<Integer/*billpay.id*/, Vector<BillPayInfo>> billpayMap = null;
    private Map<Integer/*sourceId*/, Vector<BillSource>> sourceMap = null;
    private Map<Integer, Vector<Tradeaccount>> tacctMap = null;
    private Map<Integer, Vector<BankAccount>> bankMap = null;
    private Map<Integer, Vector<VPaidItem>> vitempaidMap = null;
    private Map<Integer, McaExRate> exrateMap = null;

    private static SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");

    public CostpayDescription()
    {
    }

    public CostpayDescription(Object[] costpays)
    {
        this.costpays = costpays;
    }

    public CostpayDescription(ArrayList<Costpay2> costpays)
    {
        this.costpays = (Object[]) costpays.toArray();
    }

    
    public String getMoneyflowDetail(Costpay cp) 
        throws Exception
    {
        preparePayInfo();
        Vector<BillPayInfo> vb = billpayMap.get(new Integer(cp.getCostpayStudentAccountId()));
        if (vb==null)
            return "";
        BillPayInfo b = vb.get(0);

        StringBuffer ret = new StringBuffer();
        if (b.getVia()==BillPay.VIA_ATM) {
            Vector<BillSource> bsv = sourceMap.get(new Integer(b.getBillSourceId()));
            String acctId = "";
            if (bsv!=null) {
                BillSource bs = bsv.get(0);
                try { acctId = bs.getLine().substring(57,71); } catch (Exception e) {} // 2008-12-11 by peter 聯邦的格式不同，以後要考慮，現在先 catch 起來
            }
            ret.append("CD轉入 " + acctId);
        }
        else if (b.getVia()==BillPay.VIA_STORE) {
            ret.append(" 轉帳存入 "+sdf.format(cp.getCostpayDate()) + " + 四工作天");
        }
        return ret.toString();
    }

    public BillPayInfo getPayInfo(Costpay cp)
        throws Exception
    {
        preparePayInfo();
        Vector<BillPayInfo> vb = billpayMap.get(new Integer(cp.getCostpayStudentAccountId()));
        if (vb==null) {
            return null;
        }
        return vb.get(0);
    }

    Map<Integer, ArrayList<VPaid>> vpaidMap = null;
    Map<Integer, Vitem> vitemMap = null;
    public String getReceiptNo(Costpay cp)
        throws Exception
    {
        if (cp.getReceiptNo()!=null&&cp.getReceiptNo().length()>0)
            return cp.getReceiptNo();

        if (vpaidMap==null) {
            StringBuffer sb = new StringBuffer();
            for (int i=0; i<costpays.length; i++) {
                if (sb.length()>0) sb.append(",");
                sb.append(((Costpay)costpays[i]).getId());
            }
            ArrayList<VPaid> paids = new VPaidMgr(0).retrieveList("costpayId in (" + sb.toString() + ")", "");
            vpaidMap = new SortingMap(paids).doSortA("getCostpayId");
            String vitemIds = new RangeMaker().makeRange(paids, "getVitemId");
            ArrayList<Vitem> vims = new VitemMgr(0).retrieveList("id in (" + vitemIds + ")", "");
            vitemMap = new SortingMap(vims).doSortSingleton("getId");
        }
        
        StringBuffer sb = new StringBuffer();
        ArrayList<VPaid> vps = vpaidMap.get(cp.getId());
        for (int i=0; vps!=null && i<vps.size(); i++) {
            Vitem vi = vitemMap.get(vps.get(i).getVitemId());
            if (sb.length()>0)
                sb.append(",");
            sb.append(vi.getReceiptNo());
        }

        return sb.toString();
    }

    public String getReceiptLink(Costpay cp)
        throws Exception
    {
        String receiptNo = getReceiptNo(cp);
        // boolean isBillPay = (cp.getReceiptNo()!=null&&cp.getReceiptNo().length()>0);
        boolean isBillPay = cp.getCostpayFeePayFeeID()==Costpay2.COSPAY_TYPE_TUITION;
        String url = "";
        if (isBillPay) {
            int billpayId = cp.getCostpayStudentAccountId();
            url = "print_mcabill_receipt.jsp?pid=" + billpayId;
            ArrayList<BillPaid> paids = new BillPaidMgr(0).retrieveList("billPayId=" + billpayId, "");
            if (paids.size()>0) {
                url += "&tid=" + paids.get(0).getTicketId();
            }
        }
        else {
            prepareVitemInfo();
            url = "print_mca_receipt.jsp?id=";
            Vector<VPaidItem> vv = this.vitempaidMap.get(new Integer(cp.getId()));
            if (vv!=null && vv.size()>0) {
                url += vv.get(0).getVitemId();
            }
        }
        url += "&r=" + new Date().getTime();
        return url;
    }

    // this is called by show_cost_detail.jsp 所以會有 cache (via ezsvc.getVpaidCostPayDescription())
    public String getVitemDescription(Costpay cp)
        throws Exception
    {
        prepareVitemInfo();
        Vector<VPaidItem> vv = this.vitempaidMap.get(new Integer(cp.getId()));
        if (vv==null)
            return "";
        StringBuffer sb = new StringBuffer();
        for (int i=0; i<vv.size(); i++) {
            if (sb.length()>0) sb.append(",");
            sb.append("I" + vv.get(i).getVitemId() + " " + vv.get(i).getTitle());
        }
        return "-" + sb.toString();   
    }

    private DecimalFormat mnf = new DecimalFormat("###,###.##");
    public String getAmount(Costpay2 cp)
        throws Exception
    {
        boolean USD = (cp.getCostpayAccountType()==Costpay2.ACCOUNT_TYPE_USD_CASH || cp.getCostpayAccountType()==Costpay2.ACCOUNT_TYPE_USD_CHECK)
            || (cp.getCostpayAccountType()==Costpay2.ACCOUNT_TYPE_BANK && cp.getExRateId()>0);
    
        int amount = (cp.getCostpayNumberInOut()==0)?cp.getCostpayIncomeNumber():cp.getCostpayCostNumber();
        String ret = mnf.format(amount);
        if (USD) {
            return ret + "(USD$" + mnf.format(cp.getOrgAmount()) + ")";
        }
        return ret;
    }

    public String getAccountName(Costpay2 cp)
        throws Exception
    {
        prepareAccount();
        if (cp.getCostpayAccountType()==1 || cp.getCostpayAccountType()==4 || cp.getCostpayAccountType()==5) {
            Vector<Tradeaccount> vt = this.tacctMap.get(new Integer(cp.getCostpayAccountId()));
            String acctName = "";
            if (vt!=null) {
                acctName = "-" + vt.get(0).getTradeaccountName();
            }
            if (cp.getCostpayAccountType()==1)
                return "零用金帳戶(臺幣)" + acctName;
            else if (cp.getCostpayAccountType()==4)
                return "零用金帳戶(美金)" + acctName;
            else if (cp.getCostpayAccountType()==5)
                return "零用金帳戶(美支)" + acctName;
        }
        else if (cp.getCostpayAccountType()==2) {
            Vector<BankAccount> vb = this.bankMap.get(new Integer(cp.getCostpayAccountId()));
            String bankName = "";
            if (vb!=null) {
                bankName = "-" + vb.get(0).getBankAccountName();
            }
            return "銀行帳戶" + bankName;
        }
        else if (cp.getCostpayAccountType()==3) {
            return "支票";
        }

        return "####";
    }

    private void prepareAccount()
        throws Exception
    {
        if (this.bankMap==null) {
            Object[] objs = BankAccountMgr.getInstance().retrieve("", "");
            this.bankMap = new SortingMap().doSort(objs, new ArrayList<BankAccount>(), "getId");
            objs = TradeaccountMgr.getInstance().retrieve("", "");
            this.tacctMap = new SortingMap().doSort(objs, new ArrayList<Tradeaccount>(), "getId");
        }
    }

    private void prepareVitemInfo()
        throws Exception
    {
        if (vitempaidMap==null) {
            //## 找出相關的 vpaiditem
            StringBuilder ids = new StringBuilder();
            for (int i=0; costpays!=null&&i<costpays.length; i++)
            {
                Costpay cp = (Costpay) costpays[i];
                if (cp.getCostpayFeePayFeeID()<=Costpay2.COSPAY_TYPE_SPENDING && 
                    cp.getCostpayFeePayFeeID()>=Costpay2.COSPAY_TYPE_COST_OF_GOODS) 
                {
                    if (ids.length()>0) ids.append(",");
                    ids.append(cp.getId());
                }
            }

            if (ids.length()>0) {
                ArrayList<VPaidItem> paiditmes = VPaidItemMgr.getInstance().retrieveList("costpayId in (" + ids + ")", "");
                vitempaidMap = new SortingMap(paiditmes).doSort("getCostpayId");
            }
            if (this.vitempaidMap==null)
                this.vitempaidMap = new HashMap<Integer, Vector<VPaidItem>>();
        }
    }

    private void preparePayInfo()
        throws Exception
    {
        if (this.billpayMap==null) { 
            //## 找出相關的 billpay 和 billsource
            StringBuilder ids = new StringBuilder();
            for (int i=0; costpays!=null&&i<costpays.length; i++)
            {
                Costpay cp = (Costpay) costpays[i];
                if (cp.getCostpayFeePayFeeID()<-9000 && cp.getCostpayStudentAccountId()>0) {
                    if (ids.length()>0) ids.append(",");
                    ids.append(cp.getCostpayStudentAccountId());
                }
            }

            if (ids.length()>0) {
                ArrayList<BillPayInfo> billpays = BillPayInfoMgr.getInstance().
                    retrieveList("billpay.id in (" + ids + ")", "");
                this.billpayMap = new SortingMap(billpays).doSort("getId");
                String sourceIds = new RangeMaker().makeRange(billpays, "getBillSourceId");
                ArrayList<BillSource> sourcelines = BillSourceMgr.getInstance().
                        retrieveList("id in (" + sourceIds + ")", "");
                this.sourceMap = new SortingMap(sourcelines).doSort("getId");
            }
            if (this.billpayMap==null)
                this.billpayMap = new HashMap<Integer/*billpay.id*/, Vector<BillPayInfo>>();
        }
    }
}