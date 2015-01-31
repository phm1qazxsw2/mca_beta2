package phm.accounting;

import java.util.*;
import java.text.*;
import literalstore.*;
import phm.ezcounting.*;
 
public class VchrInfo {

    private Map<Integer, Acode> acodeMap = null;
    private Map<Long, Literal> acodename1Map = null;
    private Map<Long, Literal> noteMap = null;
    private Map<Integer, Bunit> bunitMap = null;
    private Map<Integer, VchrHolder> vchrMap = null;
    private Map<Long, Literal> vchrnoteMap = null;
    private Map<Integer, jsf.User> userMap = null;

    public VchrInfo(ArrayList<VchrItem> vitems, int tran_id)
        throws Exception
    {
        AcodeMgr amgr = (tran_id==0)?AcodeMgr.getInstance():new AcodeMgr(tran_id);
        String acodeIds = new RangeMaker().makeRange(vitems, "getAcodeId");
        ArrayList<Acode> acodes = amgr.retrieveList("id in (" + acodeIds + ")","");
        String rootIds = new RangeMaker().makeRange(acodes, "getRootId");
        ArrayList<Acode> rootAcodes = amgr.retrieveList("id in (" + rootIds + ")", "");
        acodes = new phm.util.PArrayList<Acode>(acodes).concate(rootAcodes);

        acodeMap = new SortingMap(acodes).doSortSingleton("getId");
        String name1Ids = new RangeMaker().makeRange(acodes, "getName1");
        LiteralStore store = new LiteralStore(tran_id, "literal", null);
        ArrayList<Literal> name1s = store.restore(name1Ids);
        String noteIds = new RangeMaker().makeRange(vitems, "getNote");
        ArrayList<Literal> notes = store.restore(noteIds);
        acodename1Map = new SortingMap(name1s).doSortSingleton("getId");
        noteMap = new SortingMap(notes).doSortSingleton("getId");
        String bunitIds = new RangeMaker().makeRange(vitems, "getBunitId");
        ArrayList<Bunit> bunits = ((tran_id==0)?phm.ezcounting.BunitMgr.getInstance():new phm.ezcounting.BunitMgr(tran_id)).
            retrieveList("id in (" + bunitIds + ")", "");
        bunitMap = new SortingMap(bunits).doSortSingleton("getId");

        // #### handle vchr notes
        String vchrIds = new RangeMaker().makeRange(vitems, "getVchrId");
        ArrayList<VchrHolder> vchrs = ((tran_id==0)?VchrHolderMgr.getInstance():new VchrHolderMgr(tran_id)).
            retrieveList("id in (" + vchrIds + ")", "");
        String vchrNotesIds = new RangeMaker().makeRange(vchrs, "getNote");
        ArrayList<Literal> vnotes = store.restore(vchrNotesIds);
        vchrMap = new SortingMap(vchrs).doSortSingleton("getId");
        vchrnoteMap = new SortingMap(vnotes).doSortSingleton("getId");
        String userIds = new RangeMaker().makeRange(vchrs, "getUserId");
        userMap = new SortingMap(jsf.UserMgr.getInstance().retrieve("id in (" + userIds + ")", "")).doSortSingleton("getId");
    }

    public static VchrInfo getVchrInfoV(ArrayList<VchrHolder> vchrs, int tran_id)
        throws Exception
    {
        String vchrIds = new RangeMaker().makeRange(vchrs, "getId");
        ArrayList<VchrItem> vitems =  ((tran_id==0)?VchrItemMgr.getInstance():new VchrItemMgr(tran_id)).
            retrieveList("vchrId in (" + vchrIds + ")", "");
        return new VchrInfo(vitems, tran_id);
    }

    public static VchrInfo getVchrInfo(VchrItem vi, int tran_id)
        throws Exception
    {
        ArrayList<VchrItem> list = new ArrayList<VchrItem>();
        list.add(vi);
        return new VchrInfo(list, tran_id);
    }

    public static VchrInfo getVchrInfo(ArrayList<VchrItemInfo> vitems, int tran_id)
        throws Exception
    {
        ArrayList<VchrItem> temp = new ArrayList<VchrItem>(vitems.size());
        for (int i=0; i<vitems.size(); i++)
            temp.add(vitems.get(i));
        return new VchrInfo(temp, tran_id);
        /*
        AcodeMgr amgr = (tran_id==0)?AcodeMgr.getInstance():new AcodeMgr(tran_id);
        String acodeIds = new RangeMaker().makeRange(vitems, "getAcodeId");
        ArrayList<Acode> acodes = amgr.retrieveList("id in (" + acodeIds + ")","");
        String rootIds = new RangeMaker().makeRange(acodes, "getRootId");
        ArrayList<Acode> rootAcodes = amgr.retrieveList("id in (" + rootIds + ")", "");
        acodes = new phm.util.PArrayList<Acode>(acodes).concate(rootAcodes);

        VchrInfo vinfo = new VchrInfo();
        vinfo.acodeMap = new SortingMap(acodes).doSortSingleton("getId");
        String name1Ids = new RangeMaker().makeRange(acodes, "getName1");
        LiteralStore store = new LiteralStore(tran_id, "literal", null);
        ArrayList<Literal> name1s = store.restore(name1Ids);
        String noteIds = new RangeMaker().makeRange(vitems, "getNote");
        ArrayList<Literal> notes = store.restore(noteIds);
        vinfo.acodename1Map = new SortingMap(name1s).doSortSingleton("getId");
        vinfo.noteMap = new SortingMap(notes).doSortSingleton("getId");
        String bunitIds = new RangeMaker().makeRange(vitems, "getBunitId");
        ArrayList<Bunit> bunits = ((tran_id==0)?phm.ezcounting.BunitMgr.getInstance():new phm.ezcounting.BunitMgr(tran_id)).
            retrieveList("id in (" + bunitIds + ")", "");
        vinfo.bunitMap = new SortingMap(bunits).doSortSingleton("getId");

        // #### handle vchr notes
        String vchrIds = new RangeMaker().makeRange(vitems, "getVchrId");
        ArrayList<VchrHolder> vchrs = ((tran_id==0)?VchrHolderMgr.getInstance():new VchrHolderMgr(tran_id)).
            retrieveList("id in (" + vchrIds + ")", "");
        String vchrNotesIds = new RangeMaker().makeRange(vchrs, "getNote");
        ArrayList<Literal> vnotes = store.restore(vchrNotesIds);
        vinfo.vchrMap = new SortingMap(vchrs).doSortSingleton("getId");
        vinfo.vchrnoteMap = new SortingMap(vnotes).doSortSingleton("getId");
        
        return vinfo;
        */
    }

    private VchrInfo()
    {
    }

    public Date getRegisterDate(VchrItem vi)
    {
        VchrHolder v = vchrMap.get(vi.getVchrId());
        return v.getRegisterDate();
    }

    public String getSerial(VchrItem vi)
    {
        VchrHolder v = vchrMap.get(vi.getVchrId());
        return v.getSerial();
    }

    public Map<Integer, VchrHolder> getVchrMap()
    {
        return this.vchrMap;
    }

    public String getBunitName(VchrItem vi)
    {
        Bunit bu = bunitMap.get(new Integer(vi.getBunitId()));
        if (bu==null)
            return "";
        return bu.getLabel();
    }

    public String formatAcode(VchrItem item)
    {
        Acode a = acodeMap.get(new Integer(item.getAcodeId()));
        return PaymentPrinter.makePrecise(a.getMain() + " " + a.getSub(), 10, false, ' ');
    }

    private int mainLen = 6;
    private int subLen = 6;
    private int unitLen = 6;
    public void config(int mainLen, int subLen, int unitLen)
    {
        this.mainLen = mainLen;
        this.subLen = subLen;
        this.unitLen = unitLen;
    }

    public String getAcodeFullName(VchrItem item, int size, boolean printUnit)
    {
        return getAcodeFullName(item, size, printUnit, true);
    }

    public String getAcodeFullName(VchrItem item, int size, boolean printUnit, boolean acodeLink)
    {
        Acode a = acodeMap.get(new Integer(item.getAcodeId()));
        StringBuffer sb = new StringBuffer();
        if (acodeLink)
            sb.append("<a target=_blank href='history.jsp?a=" + a.getId() + "'>");
        sb.append(PaymentPrinter.makePrecise(a.getMain(), mainLen, true, ' '));
        sb.append(PaymentPrinter.makePrecise(a.getSub(), subLen, true, ' '));
        if (acodeLink)
            sb.append("</a>");
        int left = size - mainLen - subLen;
        if (printUnit) {
            sb.append(PaymentPrinter.makePrecise(getBunitName(item), unitLen, true, ' '));
            left -= unitLen;
        }
        sb.append(PaymentPrinter.makePrecise(acode_full_name(a), left, true, ' '));
        return sb.toString();
    }

    private String acode_full_name(Acode a)
    {
        StringBuffer sb = new StringBuffer();
        if (a.getRootId()!=0) {
            Acode pa = acodeMap.get(a.getRootId());
            Literal name1 = acodename1Map.get(new Long(pa.getName1()));
            sb.append(name1.getText());
            sb.append("-");
        }
        Literal name1 = acodename1Map.get(new Long(a.getName1()));
        sb.append(name1.getText());
        return sb.toString();
    }

    public String getAcodeName(VchrItem item)
    {
        Acode a = acodeMap.get(new Integer(item.getAcodeId()));
        return acode_full_name(a);
    }

    public String getMain(VchrItem item)
    {
        Acode a = acodeMap.get(new Integer(item.getAcodeId()));
        return a.getMain();
    }

    public String getSub(VchrItem item)
    {
        Acode a = acodeMap.get(new Integer(item.getAcodeId()));
        return (a.getSub()!=null)?a.getSub():"";
    }

    private static DecimalFormat mnf = new DecimalFormat("###,###,###.#");
    public String formatDebit(VchrItem item)
    {
        if (item.getFlag()==VchrItem.FLAG_CREDIT)
            return "";
        return mnf.format(item.getDebit());
    }
    public String formatCredit(VchrItem item)
    {
        if (item.getFlag()==VchrItem.FLAG_DEBIT)
            return "";
        return mnf.format(item.getCredit());
    }

    public String getNote(VchrItem item)
    {
        Literal note = noteMap.get(new Long(item.getNote()));
        if (note==null)
            return "";
        return note.getText();
    }

    public String getTotalNote(VchrItem item)
    {
        String n1 = getVchrNote(item);
        String n2 = getNote(item);

        if (n1.length()>0 && n2.length()>0) {
            if (n1.equals(n2))
                return n1;
            else
                return n1 + "," + n2;
        }
        else if (n1.length()>0 && n2.length()==0)
            return n1;
        else if (n2.length()>0)
            return n2;
        return "";
    }

    public String getVchrNote(VchrItem item)
    {
        VchrHolder v = vchrMap.get(item.getVchrId());
        Literal l = vchrnoteMap.get((long)v.getNote());
        return (l==null)?"":l.getText();
    }

    public String getVchrNote(VchrHolder v)
    {
        Literal l = vchrnoteMap.get((long)v.getNote());
        return (l==null)?"":l.getText();
    }

    public String printItem(VchrItem item)
    {
        StringBuffer sb = new StringBuffer();
        if (item.getFlag()==VchrItem.FLAG_DEBIT) {
            sb.append("借 ");
            sb.append(PaymentPrinter.makePrecise(mnf.format(item.getDebit()), 7, false, ' '));
        }
        else {
            sb.append("貸 ");
            sb.append(PaymentPrinter.makePrecise(mnf.format(item.getCredit()), 7, false, ' '));
        }
        Acode a = acodeMap.get(new Integer(item.getAcodeId()));
if (a==null)
    System.out.println("## item.getAcodeId()=" + item.getAcodeId());
        sb.append(PaymentPrinter.makePrecise(acode_full_name(a), 36, true, ' '));
        sb.append("(" + item.getBunitAcodeThreadSignedKey() + ")");
        sb.append(" ");
        sb.append(getItemNote(item));
        return sb.toString();
    }

    public String getItemNote(VchrItem vi)
    {
        Literal l = noteMap.get((long)vi.getNote());
        if (l==null)
            return "";
        return l.getText();
    }

    public String getUserName(int userId)
    {
        jsf.User u = userMap.get(userId);
        if (u==null)
            return "###";
        String name = u.getUserFullname();
        if (name==null)
            name = u.getUserLoginId();
        return name;
    }

    // acctInfo 前者是 account type, 后者是 acct id
    public int[] getCashAccountInfo(VchrItem vi)
    {
        Acode a = acodeMap.get(vi.getAcodeId());
        String sub = a.getSub();
        boolean isCashAccount = (sub!=null&&sub.indexOf("$")==0);
        if (!isCashAccount)
            return null;
        int[] ret = new int[2];
        int c = sub.indexOf("$", 1);
        ret[0] = Integer.parseInt(sub.substring(1, c)); // $1$2
        ret[1] = Integer.parseInt(sub.substring(c+1));
        return ret;
    }


    public static void print(ArrayList<VchrItem> items, int tran_id)
        throws Exception
    {
        if (items==null)
            return;
        VchrInfo info = new VchrInfo(items, tran_id);
        for (int i=0; i<items.size(); i++)
            System.out.println(info.printItem(items.get(i)));
    }

    public static void printI(ArrayList<VchrItemInfo> items, int tran_id)
        throws Exception
    {
        if (items==null)
            return;
        VchrInfo info = VchrInfo.getVchrInfo(items, tran_id);
        for (int i=0; i<items.size(); i++)
            System.out.println(info.printItem(items.get(i)));
    }

    public String getFlagForPrint(VchrItem vi)
    {
        if (vi.getFlag()==VchrItem.FLAG_DEBIT)
            return "借 　";
        else if (vi.getFlag()==VchrItem.FLAG_CREDIT)
            return "　 貸";
        else
            return "　　 ";
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
