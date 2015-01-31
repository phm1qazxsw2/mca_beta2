package phm.ezcounting;

import java.util.*;
import java.text.*;
import jsf.*;

public class SchswDescription
{
    private Map<Integer, User> userMap = null;  
    private Map<Integer, Vector<SchswRecord>> schswMap = null;
    private Map<Integer, Membr> membrMap = null;
    private Map<Integer, SchDef> schdefMap = null;

    public SchswDescription(ArrayList<Schsw> swtches)
        throws Exception
    {
        if (swtches.size()==0) {
            userMap = new HashMap<Integer, User>();
            return;
        }
        String userIds = new RangeMaker().makeRange(swtches, "getUserId");
        userMap = new SortingMap(UserMgr.getInstance().retrieve("id in (" + userIds + ")", "")).doSortSingleton("getId");
        String schswIds = new RangeMaker().makeRange(swtches, "getId");
        ArrayList<SchswRecord> schswrecords = SchswRecordMgr.getInstance().retrieveList("schswId in (" + schswIds + ")", "");
        schswMap = new SortingMap(schswrecords).doSort("getSchswId");
        String membrIds = new RangeMaker().makeRange(schswrecords, "getMembrId");
        membrMap = new SortingMap(MembrMgr.getInstance().retrieveList("id in (" + membrIds + ")", "")).doSortSingleton("getId");
        String schdefIds = new RangeMaker().makeRange(schswrecords, "getSchdefId");
        schdefMap = new SortingMap(SchDefMgr.getInstance().retrieveList("id in (" + schdefIds + ")", "")).doSortSingleton("getId");
    }

    public String getDetail(Schsw sw)
        throws Exception
    {
        Vector<SchswRecord> vs = schswMap.get(new Integer(sw.getId()));
        Map<String, Vector<SchswRecord>> tmp = new SortingMap(vs).doSort("getKey");
        Iterator<String> iter = tmp.keySet().iterator();
        StringBuffer sb = new StringBuffer();
        String sch_off = null;
        String sch_on = null;
        Membr membr1 = null, membr2 = null;
        String tmpday = "";
        String tmpschName = "";
        while (iter.hasNext()) {
            String key = iter.next();
            String[] tokens = key.split("#"); // date#schdefId#schswId
            Vector<SchswRecord> vs2 = tmp.get(key);
            String date = tokens[0];
            String schName = getSchName(vs2.get(0));
            for (int i=0; i<vs2.size(); i++) {
                if (vs2.get(i).getType()==SchswRecord.TYPE_OFF) {
                    membr1 = membrMap.get(new Integer(vs2.get(i).getMembrId()));
                } else {
                    membr2 = membrMap.get(new Integer(vs2.get(i).getMembrId()));
                }
            }
            if (membr1!=null && membr2!=null && membr1.getId()!=membr2.getId()) // 不同人
                sb.append(sdf.format(sdf1.parse(date)) + " " + schName + " " + membr1.getName() + "-->" + membr2.getName() + "<br>");
            else
                return getDescriptionForSamePerson(sw);
        }
        return sb.toString();
    }

    private static SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
    private static SimpleDateFormat sdf = new SimpleDateFormat("dd");
    String getDescriptionForSamePerson(Schsw sw)
        throws Exception
    {
        Vector<SchswRecord> vs = schswMap.get(new Integer(sw.getId()));
        Map<Integer, Vector<SchswRecord>> tmp = new SortingMap(vs).doSort("getType");
        Vector<SchswRecord> offs = tmp.get(new Integer(SchswRecord.TYPE_OFF));
        Vector<SchswRecord> ons = tmp.get(new Integer(SchswRecord.TYPE_ON));
        Membr membr = membrMap.get(new Integer(vs.get(0).getMembrId()));
        StringBuffer sb = new StringBuffer();
        sb.append(membr.getName());
        sb.append(" ");
        for (int i=0; i<offs.size(); i++) {
            SchswRecord r = offs.get(i);
            sb.append(sdf.format(r.getOccurDate()) + " " + getSchName(r));
        }
        sb.append("-->");
        for (int i=0; i<ons.size(); i++) {
            SchswRecord r = ons.get(i);
            sb.append(sdf.format(r.getOccurDate()) + " " + getSchName(r));
        }
        return sb.toString();
    }

    private String getSchName(SchswRecord r)
        throws Exception
    {
        SchDef sdef = schdefMap.get(new Integer(r.getSchdefId()));
        return sdef.getName();
    }

    public String getStatus(Schsw sw)
    {
        return "未核準";
    }

    public String getUserName(Schsw sw)
    {
        User u = userMap.get(new Integer(sw.getUserId()));
        if (u==null)
            return "####";
        if (u.getUserFullname().length()>0)
            return u.getUserFullname();
        else
            return u.getUserLoginId();
    }
}