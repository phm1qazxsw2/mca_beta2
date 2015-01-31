package phm.ezcounting;

import java.util.*;
import java.text.*;

public class SchInfo {

    private ArrayList<SchDefMembr> schmembrs = null;
    private Map<Integer, SchDefMembr> schMap = null;
    private Map<Integer, SchDef> schMapSw = null;
    private Map<String, SchswRecord> swrecordMap = null;
    private Map<String, SchswRecord> swrecordMap2 = null;
    private static SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    private Membr membr = null;

    public static SchInfo getSchInfo(Membr membr, Date d1, Date d2) 
        throws Exception    
    {        
        Calendar c = Calendar.getInstance();
        c.setTime(d2);
        c.add(Calendar.DATE, 1);
        Date nextEndDay = c.getTime();

        // 此人在段時間的所有原班表資料
        ArrayList<SchDefMembr> schmembrs = SchDefMembrMgr.getInstance().retrieveList("membrId=" + membr.getId()
                    + " and startDate<'" + sdf.format(nextEndDay) + "' and endDate>='" + sdf.format(d1) + "'", ""); 
            
/*
System.out.println("membrId=" + membr.getId()
                    + " and startDate<'" + sdf.format(nextEndDay) + "' and endDate>='" + sdf.format(d1) + "'");        

*/


        if(schmembrs==null || schmembrs.size()<=0){
            
            System.out.println("nothing");
        }else{
            System.out.println("schmembrs  "+schmembrs.size());

            SchDefMembr sdfa=schmembrs.get(0);
                
            System.out.println("aaa"+sdfa.getSchdefId());

        
        }


        // 此人在此月的所有換班資料
        ArrayList<SchswRecord> swrecords = SchswRecordMgr.getInstance().
            retrieveList("membrId=" + membr.getId() + " and occurDate>='" + sdf.format(d1) + 
            "' and occurDate<'" + sdf.format(nextEndDay)+ "'", "");

        String schdefIds = new RangeMaker().makeRange(swrecords, "getSchdefId");
        Map<Integer, SchDef> schMapSw = new SortingMap(SchDefMgr.getInstance().retrieveList
            ("id in (" + schdefIds + ")", "")).doSortSingleton("getId");

        return new SchInfo(membr, schmembrs, swrecords, schMapSw);
    }

    public static Map<Integer, SchInfo> getSchInfoForMembrs(ArrayList<Membr> membrs, Date d1, Date d2)
        throws Exception  
    {
        Calendar c = Calendar.getInstance();
        c.setTime(d2);
        c.add(Calendar.DATE, 1);
        Date nextEndDay = c.getTime();

        // 這些人此段時間的所有原班表資料
        String membrIds = new RangeMaker().makeRange(membrs, "getId");
        ArrayList<SchDefMembr> all_schmembrs = SchDefMembrMgr.getInstance().retrieveList("membrId in (" + 
            membrIds + ") and startDate<'" + sdf.format(nextEndDay) + "' and endDate>='" + sdf.format(d1) + "'", ""); 

        // 這些人此段時間的所有換班資料
        ArrayList<SchswRecord> all_swrecords = SchswRecordMgr.getInstance().
            retrieveList("membrId in (" + membrIds + ") and occurDate>='" + sdf.format(d1) + 
            "' and occurDate<'" + sdf.format(nextEndDay)+ "'", "");

        Map<Integer, Vector<SchDefMembr>> schmembrMap = new SortingMap(all_schmembrs).doSort("getMembrId");
        Map<Integer, Vector<SchswRecord>> swrecordMap = new SortingMap(all_swrecords).doSort("getMembrId");
        String schdefIds = new RangeMaker().makeRange(all_swrecords, "getSchdefId");
        Map<Integer, SchDef> schMapSw = new SortingMap(SchDefMgr.getInstance().retrieveList("id in (" + schdefIds + ")", "")).
            doSortSingleton("getId");

        Map<Integer, SchInfo> ret = new HashMap<Integer, SchInfo>(membrs.size());
        Iterator<Membr> iter = membrs.iterator();
        while (iter.hasNext()) {
            Membr membr = iter.next();
            Integer mid = new Integer(membr.getId());
            Vector<SchDefMembr> schmembrs = schmembrMap.get(mid);
            Vector<SchswRecord> swrecords = swrecordMap.get(mid);
            ArrayList<SchDefMembr> tmp1 = new ArrayList<SchDefMembr>((schmembrs!=null)?schmembrs.size():0);
            for (int i=0; schmembrs!=null&&i<schmembrs.size(); i++)
                tmp1.add(schmembrs.get(i));
            ArrayList<SchswRecord> tmp2 = new ArrayList<SchswRecord>((swrecords!=null)?swrecords.size():0);
            for (int i=0; swrecords!=null&&i<swrecords.size(); i++)
                tmp2.add(swrecords.get(i));
            ret.put(mid, new SchInfo(membr, tmp1, tmp2, schMapSw));
        }
        return ret;
    }

    // schMap2 是換班的 schdef
    protected SchInfo(Membr membr, ArrayList<SchDefMembr> schmembrs, ArrayList<SchswRecord> swrecords, 
        Map<Integer, SchDef> schMapSw)
        throws Exception
    {
        this.schmembrs = schmembrs;
        // 此人在此月的所有 schdef
        this.schMap = new SortingMap(schmembrs).doSortSingleton("getSchdefId");
        this.swrecordMap = (swrecords==null||swrecords.size()==0)?new HashMap<String, SchswRecord>():
            new SortingMap(swrecords).doSortSingleton("getDateSchdefId"); // Date+SchdefId(那一天的那個班)
        this.swrecordMap2 = (swrecords==null||swrecords.size()==0)?new HashMap<String, SchswRecord>():
            new SortingMap(swrecords).doSortSingleton("getKey"); // Date+SchdefId+SchswId(換班那筆改的)
        this.schMapSw = schMapSw;
        this.membr = membr;
    }

    public int getMembrId()
    {
        return this.membr.getId();
    }

    public String getMembrName()
    {
        return this.membr.getName();
    }

    public boolean changedBy(Date d, int schdefId, int schswId) 
    {
        String k = SchswRecord.sdf.format(d) + "#" + schdefId + "#" + schswId;
        return (swrecordMap2.get(k)!=null);
    }

    // TYPE_ON
    // TYPE_OFF
    // 0 : nothing
    public int getSwitchStatus(Date d, int schdefId)
    {
        String k = SchswRecord.sdf.format(d) + "#" + schdefId;
        SchswRecord r = swrecordMap.get(k);
        if (r==null)
            return 0;
        return r.getType();
    }

    public boolean isOriginal(Date d, int schdefId) 
        throws Exception
    {
        // 沒換班看原來有沒有班
        SchDefMembr sdm = schMap.get(new Integer(schdefId));
        return (sdm!=null&&sdm.hasDay(d)!=null);
    }

    public boolean isSchDef(int schdefId) 
    throws Exception
    {
        // 沒換班看原來有沒有班
        SchDefMembr sdm = schMap.get(new Integer(schdefId));
        return (sdm!=null);
    }

    public sch_content getSchContent(Date d, int schdefId)
        throws Exception
    {
        SchDef sd = schMap.get(new Integer(schdefId));
        if(sd==null) {
            sd = this.schMapSw.get(schdefId);
            if (sd==null)
                return null; 
        }
        
        sch_content c = sd.hasDay(d);
        return c;
    }

    public static String printDayOfWeek(int i)
    {
        switch (i) {
            case 1: return "日";
            case 2: return "一";
            case 3: return "二";
            case 4: return "三";
            case 5: return "四";
            case 6: return "五";
            case 7: return "六";
        }
        return "##";
    }

    public static ArrayList<SchDef> getSchDefsWithin(Date d1, Date d2)
    {
        Calendar c = Calendar.getInstance();
        c.setTime(d2);
        c.add(Calendar.DATE, 1);
        Date nextEndDay = c.getTime();

        return SchDefMgr.getInstance().retrieveList("startDate<'" + sdf.format(nextEndDay) + 
            "' and endDate>='" + sdf.format(d1) + "'", "order by rootId asc");
    }


    public static ArrayList<SchDef> getSchDefsWithin(Date d1, Date d2,int bunit)
    {
        Calendar c = Calendar.getInstance();
        c.setTime(d2);
        c.add(Calendar.DATE, 1);
        Date nextEndDay = c.getTime();
        
        String query="startDate<'" + sdf.format(nextEndDay) + "' and endDate>='" + sdf.format(d1) + "'";

        if(bunit != -1)
            query+=" and bunitId='"+bunit+"'";                

        return SchDefMgr.getInstance().retrieveList(query, "order by id asc");
    }
   
    public Map<Date, SchDef> getBoundary(int boundType, Date d)
        throws Exception
    {
        Map<Date, SchDef> ret = new LinkedHashMap<Date, SchDef>();
        // 該時段所有的班
        Calendar c = Calendar.getInstance();
        c.setTime(d);
        c.add(Calendar.DATE, 1);
        Date d2 = c.getTime();
        ArrayList<SchDef> schdefs = SchDefMgr.getInstance().retrieveList(
            "startDate<'"+sdf.format(d2)+"' and endDate>'" + sdf.format(d) + "'", "");
        for (int i=0; i<schdefs.size(); i++) {
            SchDef sd = schdefs.get(i);
            int status = getSwitchStatus(d, sd.getId());
            if ((isOriginal(d, sd.getId()) && status!=SchswRecord.TYPE_OFF) || // 如果原班有且沒調走
                (status==SchswRecord.TYPE_ON)) // 或原班沒有但有調來
            { 
                Date dx1 = new Date(), dx2 = new Date();
                sd.getStartEndTime(d, dx1, dx2);
                ret.put((boundType==0)?dx1:dx2, sd);
            }
         }
         return ret;
    }

    public Map<Integer, Vector> getBoundaryVector(Date d)
        throws Exception
    {
        Vector v=new Vector();
        Map<Integer, Vector> ret = new LinkedHashMap<Integer, Vector>();
        // 該時段所有的班
        Calendar c = Calendar.getInstance();
        c.setTime(d);
        c.add(Calendar.DATE, 1);
        Date d2 = c.getTime();
        ArrayList<SchDef> schdefs = SchDefMgr.getInstance().retrieveList(
            "startDate<'"+sdf.format(d2)+"' and endDate>='" + sdf.format(d) + "'", "");

System.out.println("### xxx ###  startDate<'"+sdf.format(d2)+"' and endDate>'" + sdf.format(d) + "'");

System.out.println("schdefs ="+schdefs.size());

        for (int i=0; i<schdefs.size(); i++) {
            SchDef sd = schdefs.get(i);

System.out.println("schdef id ="+sd.getId());
            int status = getSwitchStatus(d, sd.getId());

            if(isOriginal(d, sd.getId())){
                System.out.println("yes");
            }else{
                System.out.println("no");
            }


            if ((isOriginal(d, sd.getId()) && status!=SchswRecord.TYPE_OFF) || // 如果原班有且沒調走
                (status==SchswRecord.TYPE_ON)) // 或原班沒有但有調來
            { 

System.out.println("in if");

                Date dx1 = new Date(), dx2 = new Date();
                sd.getStartEndTime(d, dx1, dx2);
                v=new Vector();
                v.add((SchDef)sd);
                v.add((Date)dx1);
                v.add((Date)dx2);

                ret.put(new Integer(sd.getId()), v);
            }
         }
         return ret;
    }
}
