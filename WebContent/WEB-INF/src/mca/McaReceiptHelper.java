package mca;

import phm.accounting.*;
import phm.ezcounting.*;
import literalstore.*;
import java.util.*;
import java.text.*;
import phm.util.*;
import jsf.*;

public class McaReceiptHelper
{
    McaReceipt mr = null;
    Vitem vi = null;
    Costpay2 cp = null;
    MembrInfoBillRecord bill = null;
    BillPay bpay = null;
    boolean prepay = false;
  	static DecimalFormat mnf = new DecimalFormat("###,###,##0");
  	static DecimalFormat mnf2 = new DecimalFormat("###,###.##");

    public McaReceiptHelper(int tran_id, VPaid vp)
        throws Exception
    {
        vi = new VitemMgr(tran_id).find("id=" + vp.getVitemId());
        cp = new Costpay2Mgr(tran_id).find("id=" + vp.getCostpayId());
        mr = new McaService(tran_id).getReceipt(cp, (vi.getAttachtype()==2), getPayerName());
    }
 
    public McaReceiptHelper(int tran_id, BillPay bpay, String ticketId, boolean prepay)
        throws Exception
    {        
        bill = new MembrInfoBillRecordMgr(tran_id).find("ticketId='" + ticketId + "'");
        cp = new Costpay2Mgr(tran_id).find("costpayFeePayFeeID=" + Costpay2.COSPAY_TYPE_TUITION
            + " and costpayStudentAccountId=" + bpay.getId());
        this.bpay = bpay;
        mr = new McaService(tran_id).getReceipt(cp, false, getPayerName());
        this.prepay = prepay;
    }

    public ArrayList<String> getAcodeList()
    {
        ArrayList<String> ret = new ArrayList<String>();
        if (vi!=null)
            ret.add(vi.getAcctcode());
        else {
            if (prepay)
                ret.add("214101");
            else
                ret.add("116201");
        }
        return ret;
    }

    public ArrayList<String> getDescList()
    {
        ArrayList<String> ret = new ArrayList<String>();
        if (vi!=null)
            ret.add(vi.getTitle());
        else {
            if (bill!=null)
                ret.add(bill.getBillRecordName());
            else
                ret.add("學費繳費");
        }
        if (cp.getCheckInfo()!=null && cp.getCheckInfo().length()>0)
            ret.add("Check:" + cp.getCheckInfo());
        if (this.bpay!=null && this.bpay.getNote()!=null && this.bpay.getNote().length()>0)
            ret.add("Note:" + bpay.getNote());
        return ret;
    }

    public ArrayList<String> getAmountList()
    {
        boolean USD = (cp.getCostpayAccountType()==Costpay2.ACCOUNT_TYPE_USD_CASH || cp.getCostpayAccountType()==Costpay2.ACCOUNT_TYPE_USD_CHECK)
            || (cp.getCostpayAccountType()==Costpay2.ACCOUNT_TYPE_BANK && cp.getExRateId()>0);

        ArrayList<String> ret = new ArrayList<String>();
        if (!USD) {
            int amount = cp.getCostpayIncomeNumber();
            ret.add(mnf.format(amount));
        }
        else {
            ret.add(mnf2.format(cp.getOrgAmount()));
        }
        return ret;
    }

    public Date getPaidDate()
    {
        return cp.getCostpayLogDate();
    }

    public String getPayerName()
        throws Exception
    {
        if (vi!=null)
            return cp.getCostpayLogPs();
        else {
            if (bill!=null)
                return bill.getMembrName();
            else {
                Membr m = new MembrMgr(0).find("id=" + bpay.getMembrId());
                return m.getName();
            }
        }
    }

    public String getReceiver()
        throws Exception
    {
        EzCountingService ezsvc = EzCountingService.getInstance();
        return ezsvc.getUserName(cp.getCostpayLogId());
    }

    public String getCurrency()
    {
        boolean USD = (cp.getCostpayAccountType()==Costpay2.ACCOUNT_TYPE_USD_CASH || cp.getCostpayAccountType()==Costpay2.ACCOUNT_TYPE_USD_CHECK)
            || (cp.getCostpayAccountType()==Costpay2.ACCOUNT_TYPE_BANK && cp.getExRateId()>0);

System.out.println("USD=" + USD + " cp.getCostpayAccountType()=" + cp.getCostpayAccountType() + " cp.getOrgAmount()=" + cp.getOrgAmount());
        if (USD)
            return "US$";
        return "NT$";
    }

    public boolean printDonationCorner()
    {
        boolean USD = (cp.getCostpayAccountType()==Costpay2.ACCOUNT_TYPE_USD_CASH || cp.getCostpayAccountType()==Costpay2.ACCOUNT_TYPE_USD_CHECK)
            || (cp.getCostpayAccountType()==Costpay2.ACCOUNT_TYPE_BANK && cp.getExRateId()>0);

        if (USD)
            return false;
        if (vi!=null)
            return (vi.getAttachtype()==2);
        return false;
    }

    public String getReceiptNo()
    {
        return mr.getPkey();
    }

    public ArrayList<String> getHeaderLines()
    {
        boolean USD = (cp.getCostpayAccountType()==Costpay2.ACCOUNT_TYPE_USD_CASH || cp.getCostpayAccountType()==Costpay2.ACCOUNT_TYPE_USD_CHECK)
            || (cp.getCostpayAccountType()==Costpay2.ACCOUNT_TYPE_BANK && cp.getExRateId()>0);

        ArrayList<String> ret = new ArrayList<String>();
        if (USD) {  // 一般美金
            ret.add("RECEIPT");
            ret.add(null);
            ret.add("MORRISON CHRISTIAN ASSOCIATION");
            ret.add(null);
            ret.add("Box 3000, Haddonfield, New Jersey 08300-0968");
            ret.add("Federal Tax ID# 510194177");
        }
        else {
            String receiptNo = mr.getPkey();
            if (printDonationCorner()) {
                ret.add("DONATION RECEIPT");
                ret.add("教育/宣教捐贈 收據");
            }
            else {
                ret.add("N.T. RECEIPT 收據");
                ret.add(null);
            }

            if (receiptNo.charAt(0)=='B') {
                ret.add("MORRISON ACADEMY-BETHANY CAMPUS");
                ret.add("台北伯大尼美國學校");
                ret.add("地址: 臺北市汀州路3段97號");
                ret.add("TEL: (02)2365-9691  FAX:(02)2365-9696");
            }
            else if (receiptNo.charAt(0)=='T') {
                ret.add("MORRISON ACADEMY");
                ret.add("馬 禮 遜 學 校");
                ret.add("TEL:(04)292-1171(~3) FAX:(04)295-6140");
                ret.add(null);
            }
            else { // K
                ret.add("MORRISON ACADEMY");
                ret.add("高雄馬禮遜學校");
                ret.add("地址: 81546高雄縣大社鄉嘉誠路42號");
                ret.add("TEL: 07-3561190");
            }
        }
        return ret;
    }
}
