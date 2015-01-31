package phm.ezcounting;

import java.util.*;
import java.text.*;
import jsf.*;
import cardreader.*;

public class SchEventInfo {

    ArrayList<Membr> membrs = null;
    private Map<Integer, User> userMap = null;
    DecimalFormat df = new DecimalFormat("##.#");    
    private Map<Integer, Vector<SchEvent>> scheventMap = null;
    private Map<Integer, Vector<SchEvent>> scheventMap2 = null;
    private Map<String, Vector<SchEvent>> scheventMap3 = null;
    private ArrayList<SchEvent> events;
    private Map<Date, ArrayList<SchEvent>> dayeventMap;
    private Map<Integer, Membr> membrMap;

    public SchEventInfo(ArrayList<SchEvent> events) 
        throws Exception    
    {
        this.events = events;
        if (events==null || events.size()==0) {
            membrs = new ArrayList<Membr>();
            userMap = new HashMap<Integer, User>();
            membrMap = new HashMap<Integer, Membr>();
            scheventMap = new HashMap<Integer, Vector<SchEvent>>();
            scheventMap2 = new HashMap<Integer, Vector<SchEvent>>();
            scheventMap3 = new HashMap<String, Vector<SchEvent>>(); 
            return;
        }
        String membrIds = new RangeMaker().makeRange(events, "getMembrId");
        membrs = MembrMgr.getInstance().retrieveList("id in (" + membrIds + ")", "");
        membrMap = new SortingMap(membrs).doSortSingleton("getId");
        String userIds = new RangeMaker().makeRange(events, "getUserId");
        userMap = new SortingMap(UserMgr.getInstance().retrieve("id in (" + userIds + ")", "")).doSortSingleton("getId");
        scheventMap = new SortingMap(events).doSort("getMembrTypeKey");
        scheventMap2 = new SortingMap(events).doSort("getMembrId");
        scheventMap3 = new SortingMap(events).doSort("getDateDefMembr");

        df.setMaximumFractionDigits(1);
    }

    public Vector<SchEvent> getMembrEvents(Membr m)
    {
        return scheventMap2.get(new Integer(m.getId()));
    }

    SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMdd");
    public Vector<SchEvent> getDateDefMembr(Date rundate,int defId,int membrId)
    {
        return scheventMap3.get(sdf.format(rundate)+"#"+defId+"#"+membrId);
    }

    public Vector<SchEvent> getMap(Membr m, int type)
    {
        return scheventMap.get(m.getId() + "#" + type);
    }

    public Iterator<Membr> getMembrIterator()
    {
        return membrs.iterator();
    }


    public String getStatus(SchEvent e)
    {
        return "未核準";
    }

    public String getMembrName(SchEvent e)
    {
        Membr mb = membrMap.get(new Integer(e.getMembrId()));
        if (mb==null)
            return "####";
        return mb.getName();
    }

    public String getUserName(SchEvent e)
    {
        User u = userMap.get(new Integer(e.getUserId()));
        if (u==null)
            return "####";
        if (u.getUserFullname().length()>0)
            return u.getUserFullname();
        else
            return u.getUserLoginId();
    }

    private static SimpleDateFormat _sdf = new SimpleDateFormat("yyyy-MM-dd");
    public ArrayList<SchEvent> getEventsOnDate(Date d)
        throws Exception
    {
        if (dayeventMap==null) {
            dayeventMap = new HashMap<Date, ArrayList<SchEvent>>();
            Calendar c = Calendar.getInstance();
            for (int i=0; i<this.events.size(); i++) {
                SchEvent e = this.events.get(i);
                Date d1 = _sdf.parse(_sdf.format(e.getStartTime()));
                Date d2 = e.getEndTime();
                c.setTime(d1);
                while (c.getTime().compareTo(d2)<=0) {
                    ArrayList<SchEvent> a = dayeventMap.get(c.getTime());
                    if (a==null) {
                        a = new ArrayList<SchEvent>();
                        dayeventMap.put(c.getTime(), a);
                    }
                    a.add(e);
                    c.add(Calendar.DATE, 1);
                }
            }
        }
        return dayeventMap.get(_sdf.parse(_sdf.format(d)));
    }

    //計算缺勤  = 缺勤 - 請假
    public static boolean calcEvent(Date d1,Date d2,Vector v,Vector rVector){

        if(v ==null || v.size()<=0){
            Date[] xDate={d1,d2};
            rVector.add(xDate);
            return true;
        }

        Date e1=null;
        Date e2=null;
        
        SimpleDateFormat sdf=new SimpleDateFormat("HH:mm");
        SimpleDateFormat sdf2=new SimpleDateFormat("yyyy/MM/dd HH:mm");

        boolean runTotal=false;
        for(int i=0;i<v.size();i++){

            SchEvent se=(SchEvent)v.get(i);

            //System.out.println("o1: "+se.getStartTime().getTime());
            //System.out.println("o2: "+se.getEndTime().getTime());        

            Date fixStart=new Date();
            try{
                fixStart=sdf2.parse(sdf2.format(se.getStartTime()));
            }catch(Exception ex){}                
            se.setStartTime(fixStart);
    
            Date fixEnd=new Date();
            try{
                fixEnd=sdf2.parse(sdf2.format(se.getEndTime()));
            }catch(Exception ex){}                    
            se.setEndTime(fixEnd);

            /*
            System.out.println("se id: "+se.getId());
            System.out.println("d1: "+d1.getTime());
            System.out.println("eS: "+se.getStartTime().getTime());
            System.out.println("d2: "+d2.getTime());
            System.out.println("eD: "+se.getEndTime().getTime());  
            System.out.println("");
            System.out.println("");
            */


            //判斷有效 event
            if((se.getEndTime().compareTo(d1)>0 && se.getStartTime().compareTo(d2)<0) || (se.getStartTime().compareTo(d2)<0 && d1.compareTo(se.getEndTime())>0) || (d1.compareTo(se.getStartTime())==0 && d2.compareTo(se.getEndTime())==0)){

                //System.out.println("d1="+sdf.format(d1)+" d2="+sdf.format(d2)+",e1="+sdf.format(se.getStartTime())+",e2="+sdf.format(se.getEndTime()));
                runTotal=true;
                if(e1==null){
                    e1=se.getStartTime();

                    if(e1.compareTo(d1)<0)
                        e1=d1;

                    e2=se.getEndTime();
                    continue;
                }

                if(e2.compareTo(se.getStartTime())<0){
                    Date[] xDate={e2,se.getStartTime()};
                    rVector.add(xDate);
                }                    

                if(se.getEndTime().compareTo(d2)<0)
                    e2=se.getEndTime();
                else
                    e2=d2;
            }
        }     

        //System.out.println("e1="+sdf.format(e1)+" e2="+sdf.format(e2));               

        if(!runTotal || (e1==null && e2==null)){    //有event , 但不是在d1 -d2的範圍內
            Date[] xDate={d1,d2};
            rVector.add(xDate);
            return true;
        }       
     
        //全請了
        if(e1.compareTo(d1)<=0 && d2.compareTo(e2)<=0){       
            return false;
        }
        
        if(e1.compareTo(d1)<=0 && d2.compareTo(e2)>0)  //後面請不夠
        {
            Date[] xDate={e2,d2};
            rVector.add(xDate);
            return true;
        }            

        if(d2.compareTo(e2)<=0 && d1.compareTo(e1)<0)  //前面沒請
        {
            Date[] xDate={d1,e1};
            rVector.add(xDate);
            return true;
        }            

        if(d1.compareTo(e1)<0 && e2.compareTo(d2)<0)  //請中間
        {
            Date[] xDate={d1,e1};
            rVector.add(xDate);

            Date[] xDate2={e2,d2};
            rVector.add(xDate2);

            return true;
        }
        return false;            
    }

    public static Vector checkGoodEntry(Vector ve2,Date d1,Date d2){
        
        //預設ve2 按時間順序排序
        SimpleDateFormat sdf=new SimpleDateFormat("HH:mm");
        if(ve2==null || ve2.size()<2)
            return ve2;
        Vector v=new Vector();
        int nowStart=0;
        int endStart=0;
        boolean bStart=true;
        boolean bEnd=true;
        for(int i=0;i<ve2.size();i++){

            Date entrydate=(Date)((Entry)ve2.get(i)).getCreated();
            if(i==0 && d1.compareTo(entrydate)<=0){
                nowStart=0;
                bStart=false;
                break;
            }
            if(bStart){
                if(entrydate.compareTo(d1)<=0){
                    nowStart=i;
                }
            }
        }

        for(int i=0;i<ve2.size();i++){
            int nowRun=ve2.size()-1-i;
            Date entrydate=(Date)((Entry)ve2.get(nowRun)).getCreated();
            if(i==0 && entrydate.compareTo(d2)<=0){
                endStart=nowRun;
                bEnd=false;
                break;
            }
            if(bEnd){
                if(d2.compareTo(entrydate)<=0)
                {
                    if(endStart ==0){
                        endStart=nowRun;
                    }
                }                
            }
        }    

        for(int i=nowStart;i<=endStart;i++){
            Entry e=(Entry)ve2.get(i);
            v.add((Entry)e);
        }
        return v;
    }


    public static String getMachineId(){

        PaySystemMgr pmzx=PaySystemMgr.getInstance();
        PaySystem pZ2=(PaySystem)pmzx.find(1);

        String readerId="";
        if(pZ2.getCardmachine() !=null && pZ2.getCardmachine().length()>0){
            String[] mid=pZ2.getCardmachine().split("#");

            if(mid.length<=0){
                readerId+=" and machineId='"+pZ2.getCardmachine()+"'";
            }else{
                readerId=" and machineId in (";
                for(int f=0;f<mid.length;f++){
                    
                    readerId+=mid[f];
                    if(mid.length==2){
                        if(f==0)
                            readerId+=",";                            
                    }else{
                        if(f !=0 && f !=(mid.length-1))
                            readerId+=",";
                    }
                }
                readerId+=")";            
            }  
        }
        return readerId;
    }

 
    //計算時間是否重疊
    public static boolean calcOldEvent(Date d1,Date d2,Vector v){

        if(v ==null || v.size()<=0){
            return true;
        }

        for(int i=0;i<v.size();i++){

            SchEvent se=(SchEvent)v.get(i);
            
            if(se.getStartTime().compareTo(d1)==0)
                return false;

            if(d1.compareTo(se.getStartTime())<0 && se.getStartTime().compareTo(d2)<0)  
                return false;

            if(se.getEndTime().compareTo(d2)<0 && d1.compareTo(se.getEndTime())<0)  
                return false;
        }     
        return true;            
    }


    // ##################### 請假沖掉部分的計算 ############################
    // 計算 v1 可被 v2 deduct 的有哪些
    private static long MINUTE = (long)1000*(long)60;
    public static int calcDeduct(Vector<SchEvent> v1, Vector<SchEvent> v2)
    {
        long ret = 0;
        if (v1==null||v2==null)
            return 0;
        // 先暴力下，到時 v2 要先 sort 弄成可 binary search
        for (int i=0, s=v1.size(); i<s; i++ ) {
            SchEvent e1 = v1.get(i);
            for (int j=0, s2=v2.size(); j<s2; j++) {
                SchEvent e2 = v2.get(j);
                if (e2.getStartTime().compareTo(e1.getEndTime())>0) 
                    continue;
                if (e2.getEndTime().compareTo(e1.getStartTime())<0)
                    continue;
                Date biggerStart = (e1.getStartTime().compareTo(e2.getStartTime())<0)?e2.getStartTime():e1.getStartTime();
                Date smallerEnd =  (e1.getEndTime().compareTo(e2.getEndTime())<0)?e1.getEndTime():e2.getEndTime();
                ret += (smallerEnd.getTime()-biggerStart.getTime());
            }
        }
        return (int)(ret/MINUTE);
    }
    // #####################################################################
}