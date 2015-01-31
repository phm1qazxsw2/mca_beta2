package phm.ezcounting;

import java.util.*;
import java.text.*;
import jsf.*;

public class ChequeDescription
{
    private static SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    private ArrayList<Cheque> cheques;
    private Map<Integer/*chequeId*/, Vector<BillPaidInfo>> billPaidMap = null;
    private Map<Integer/*costpayId*/, Vector<VPaidItem>> vpaidMap = null;

    public ChequeDescription(ArrayList<Cheque> cheques)
    {
        this.cheques = cheques;
    }

    private static SimpleDateFormat sdf2 = new SimpleDateFormat("MM");
    public String getDescription(Cheque ch)
        throws Exception
    {
        preparePayInfo();
        String desc = ch.getTitle();
        if (desc==null)
            desc = "";
        Vector<BillPaidInfo> pv = billPaidMap.get(new Integer(ch.getId()));
        Vector<VPaidItem> vv = vpaidMap.get(new Integer(ch.getCostpayId()));
        if (pv!=null) {
            for (int i=0; i<pv.size(); i++) {
                BillPaidInfo bp = pv.get(i);
                if (desc.length()>0) desc += "<br>";
                desc += "　　銷 " + sdf2.format(bp.getBillMonth()) + "月 " + bp.getBillPrettyName() + bp.getPaidAmount();
            }
        }
        else if (vv!=null) {
            for (int i=0; i<vv.size(); i++) {
                VPaidItem vp = vv.get(i);
                if (desc.length()>0) desc += "<br>";
                desc += "    銷 " + sdf.format(vp.getRecordTime()) + " " + vp.getTitle();
            }
        }
        return desc;
    }

    private void preparePayInfo() 
        throws Exception
    {
        if (billPaidMap==null) {
            String chequeIds = new RangeMaker().makeRange(cheques, "getId");
            ArrayList<BillPaidInfo> paids = BillPaidInfoMgr.getInstance().
                retrieveList("billpay.chequeId in (" + chequeIds + ")", "");
            billPaidMap = new SortingMap(paids).doSort("getChequeId");
        }
        if (vpaidMap==null) {
            String costpayIds = new RangeMaker().makeRange(cheques, "getCostpayId");
            ArrayList<VPaidItem> paiditems = VPaidItemMgr.getInstance().
                retrieveList("costpayId in (" + costpayIds + ")","");
            vpaidMap = new SortingMap(paiditems).doSort("getCostpayId");
        }
    }
}