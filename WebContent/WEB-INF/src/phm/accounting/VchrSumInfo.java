package phm.accounting;

import java.util.*;
import java.text.*;
import literalstore.*;
import phm.ezcounting.*;

public class VchrSumInfo {

    private Map<Integer, Acode> acodeMap = null;
    private Map<Long, Literal> acodename1Map = null;
    // private Map<Integer, Bunit> bunitMap = null;
    private boolean show_main_only = false;

    public VchrSumInfo(ArrayList<VchrItemSum> sums, boolean show_main_only, int tran_id)
        throws Exception
    {
        this.show_main_only = show_main_only;

        AcodeMgr amgr = (tran_id>0)?new AcodeMgr(tran_id):AcodeMgr.getInstance();
        String acodeIds = new RangeMaker().makeRange(sums, "getAcodeId");
        ArrayList<Acode> acodes = amgr.retrieveList("id in (" + acodeIds + ")","");
        String rootIds = new RangeMaker().makeRange(acodes, "getRootId");
        ArrayList<Acode> rootAcodes = amgr.retrieveList("id in (" + rootIds + ")", "");
        acodes = new phm.util.PArrayList<Acode>(acodes).concate(rootAcodes);

        acodeMap = new SortingMap(acodes).doSortSingleton("getId");
        String name1Ids = new RangeMaker().makeRange(acodes, "getName1");
        LiteralStore store = new LiteralStore(tran_id, "literal", null);
        ArrayList<Literal> name1s = store.restore(name1Ids);
        acodename1Map = new SortingMap(name1s).doSortSingleton("getId");

        /*
        String bunitIds = new RangeMaker().makeRange(sums, "getBunitId");
        ArrayList<Bunit> bunits = ((tran_id==0)?BunitMgr.getInstance():new BunitMgr(tran_id)).
            retrieveList("id in (" + bunitIds + ")", "");
        bunitMap = new SortingMap(bunits).doSortSingleton("getId");    
        */
    }

    private int mainLen = 6;
    private int subLen = 6;
    public void setMainSubPrintSize(int mainLen, int subLen)
    {
        this.mainLen = mainLen;
        this.subLen = subLen;
    }
    public String getAcodeFullName(int acodeId, int size)
    {
        Acode a = acodeMap.get(acodeId);
        if (this.show_main_only && a.getRootId()>0) {
            a = acodeMap.get(a.getRootId());
        }
        StringBuffer sb = new StringBuffer();
        sb.append(PaymentPrinter.makePrecise(a.getMain(), mainLen, true, ' '));
        sb.append(PaymentPrinter.makePrecise(a.getSub(), subLen, true, ' '));
        int left = size - mainLen - subLen;
        if (left>0)
            sb.append(PaymentPrinter.makePrecise(acode_full_name(a), left, true, ' '));
        else
            sb.append(acode_full_name(a));
        return sb.toString();
    }

    private String acode_full_name(Acode a)
    {
        StringBuffer sb = new StringBuffer();
        if (a.getRootId()!=0) {
            Acode pa = acodeMap.get(a.getRootId());
            Literal name1 = acodename1Map.get(new Long(pa.getName1()));
            sb.append(name1.getText());
            sb.append(" ");
        }
        Literal name1 = acodename1Map.get(new Long(a.getName1()));
        sb.append(name1.getText());
        return sb.toString();
    }

    public String getMain(VchrItemSum sum)
    {
        Acode a = acodeMap.get(sum.getAcodeId());
        return a.getMain();
    }

    public String getSub(VchrItemSum sum)
    {
        Acode a = acodeMap.get(sum.getAcodeId());
        if (this.show_main_only)
            return "";
        return a.getSub();
    }

    /*
    public String getBunitName(VchrItemSum sum)
    {
        Bunit bu = bunitMap.get(new Integer(sum.getBunitId()));
        if (bu==null)
            return "";
        return bu.getLabel();
    }
    */

    public String getAcodeName(VchrItemSum sum)
    {
        Acode a = acodeMap.get(sum.getAcodeId());
        if (this.show_main_only && a.getRootId()>0)
            a = acodeMap.get(a.getRootId());
        return acode_full_name(a);
    }

    public int getNominalAcodeId(VchrItemSum sum)
    {
        Acode a = acodeMap.get(sum.getAcodeId());
        if (this.show_main_only && a.getRootId()>0)
            a = acodeMap.get(a.getRootId());
        return a.getId();
    }


    public double getNominalDebit(VchrItemSum sum)
    {
        double d = sum.getDebit();
        double c = sum.getCredit();
        return (d>c)?(d-c):0;
    }

    public double getNominalCredit(VchrItemSum sum)
    {
        double d = sum.getDebit();
        double c = sum.getCredit();
        return (c>d)?(c-d):0;
    }

    private DecimalFormat mnf = new DecimalFormat("###,###.#");   
    public String printSum(VchrItemSum sum)
    {
        StringBuffer sb = new StringBuffer();
        sb.append(getAcodeFullName(sum.getAcodeId(), 36));
        sb.append(PaymentPrinter.makePrecise(mnf.format(sum.getDebit()), 12, false, ' '));
        sb.append(PaymentPrinter.makePrecise(mnf.format(sum.getCredit()), 15, false, ' '));
        sb.append(PaymentPrinter.makePrecise(mnf.format(sum.getDebit()-sum.getCredit()), 15, false, ' '));

        return sb.toString();
    }

    public String printTableSum(VchrItemSum sum,double total,boolean show_main)
    {
        this.show_main_only=show_main;
        StringBuffer sb = new StringBuffer();
        sb.append("<td class=es02>"+getTableAcodeFullName(sum.getAcodeId())+"</td>");
        sb.append("<td align=right class=es02>"+((total<0)?"("+mnf.format(total*-1)+")":mnf.format(total))+"</td>");
        return sb.toString();
    }

    public String getTableAcodeFullName(int acodeId)
    {
        Acode a = acodeMap.get(acodeId);
        if (this.show_main_only && a.getRootId()>0) {
            a = acodeMap.get(a.getRootId());
        }
        StringBuffer sb = new StringBuffer();
        sb.append(a.getMain());
        sb.append(" "+a.getSub());
        sb.append("&nbsp;"+acode_full_name(a));

        return sb.toString();
    }
    public static void print(ArrayList<VchrItem> items, int tran_id)
        throws Exception
    {
        VchrInfo info = new VchrInfo(items, tran_id);
        for (int i=0; i<items.size(); i++)
            System.out.println(info.printItem(items.get(i)));
    }

    /*
    public static String getVchrDescription(VchrHolder v)
    {
        if (v.getSrcType()==VchrHolder.SRC_TYPE_BILL) {
            return "<a href='show_bill.jsp?tid=" + v.getSrcInfo() + "'>學費帳單</a>";
        }
        return "";
    }
    */
}
