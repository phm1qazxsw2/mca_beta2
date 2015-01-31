package phm.accounting;

import java.util.*;
import java.text.*;
import literalstore.*;
import phm.ezcounting.*;

public class AcodeInfo {

    private Map<Integer, Acode> rootMap = null;
    private Map<Long, Literal> acodename1Map = null;
    private Map<Long, ArrayList<Acode>> childrenMap = null;

    public static AcodeInfo getInstance(Acode a)
        throws Exception
    {
        return getInstance(a, 0);
    }

    public static AcodeInfo getInstance(Acode a, int tran_id)
        throws Exception
    {
        ArrayList<Acode> acodes = new  ArrayList<Acode>();
        acodes.add(a);
        return new AcodeInfo(acodes, tran_id);
    }

    public AcodeInfo(ArrayList<Acode> acodes)
        throws Exception
    {
        this(acodes, 0);
    }

    public AcodeInfo(ArrayList<Acode> acodes, int tran_id)
        throws Exception
    {
        // 2008-12-21 peter, move childrenMap before dealing with root
        childrenMap =  new SortingMap(acodes).doSortA("getRootId");

        String rootIds = new RangeMaker().makeRange(acodes, "getRootId");
        ArrayList<Acode> rootAcodes = ((tran_id==0)?AcodeMgr.getInstance():new AcodeMgr(tran_id)).retrieveList("id in (" + rootIds + ")", "");
        rootMap = new SortingMap(rootAcodes).doSortSingleton("getId");

        acodes = new phm.util.PArrayList<Acode>(acodes).concate(rootAcodes);
        String name1Ids = new RangeMaker().makeRange(acodes, "getName1");
        LiteralStore store = new LiteralStore(tran_id, "literal", null);
        ArrayList<Literal> name1s = store.restore(name1Ids);
        acodename1Map = new SortingMap(name1s).doSortSingleton("getId");
    }

    public ArrayList<Acode> getMainAcodes()
    {
        return childrenMap.get(0);
    }

    public ArrayList<Acode> getSubAcode(Acode root)
    {
        return childrenMap.get(root.getId());
    }

    public String getMainSub(Acode a)
    {
        return getMainSub(a, true);
    }
    public String getMainSub(Acode a, boolean doSeperate)
    {
        StringBuffer sb = new StringBuffer();
        sb.append(a.getMain());
        String sub = a.getSub();
        if (sub!=null&&sub.length()>0) {
            if (doSeperate)
                sb.append(' ');
            sb.append(sub);
        }
        return sb.toString();
    }

    public String getName(Acode a)
    {
        Literal name1 = null;
        StringBuffer sb = new StringBuffer();
        /* ## for 馬禮遜
        if (a.getRootId()>0) {
            Acode ra = rootMap.get(a.getRootId());
            name1 = acodename1Map.get(new Long(ra.getName1()));
            sb.append(name1.getText());
            sb.append('-');
        }
        */
        name1 = acodename1Map.get(new Long(a.getName1()));
        sb.append(name1.getText());
        return sb.toString();
    }

    public String getMyName(Acode a)
    {
        Literal name1 = acodename1Map.get(new Long(a.getName1()));
        return name1.getText();
    }

    public String getCatName(Acode a)
    {
        return "###";
    }

}
