package phm.ezcounting;

import java.util.*;
import java.text.*;
import jsf.*;
import cardreader.*;

public class SchEventAuto {

    static SimpleDateFormat sdft = new SimpleDateFormat("HH:mm");
    SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat sdf2 = new SimpleDateFormat("yyyyMMdd HH:mm");
    SimpleDateFormat sdf3 = new SimpleDateFormat("yyyyMMdd");
    SimpleDateFormat sdf4 = new SimpleDateFormat("yyyyMMddHHmm");
    static long min = ((long)60)*((long)1000);
    SchEventMgr semgr=SchEventMgr.getInstance();

    public SchEventAuto(Date d,int userId) throws Exception    
    {
        Calendar c = Calendar.getInstance();
        c.setTime(d);
        c.add(Calendar.DATE, 1);
        Date nextDay = c.getTime();
        CardCheckdateMgr ccm2=CardCheckdateMgr.getInstance();
        ArrayList<CardCheckdate> ccda=ccm2.retrieveList("checkdate>='" + sdf1.format(d) + "' and checkdate<'" + sdf1.format(nextDay)+"'","");

        if(ccda !=null && ccda.size()>0)
            return;

        CardCheckdate ccdate=new CardCheckdate();
        ccdate.setCheckdate(d);
        ccdate.setCheckUser(userId);
        ccm2.create(ccdate);

        // 找出那天有班的人,原班和換班的都要考慮
        ArrayList<MembrTeacher> all_teachers = MembrTeacherMgr.getInstance().retrieveList("teacherStatus!=0", "");
        String membrIds = new RangeMaker().makeRange(all_teachers, "getMembrId");
        ArrayList<Membr> membrs = MembrMgr.getInstance().retrieveList("id in (" + membrIds + ")", "");
        Map<Integer, SchInfo> schinfoMap = SchInfo.getSchInfoForMembrs(membrs, d, d);
        ArrayList<SchDef> schdefs = SchInfo.getSchDefsWithin(d, d);

        // 處理卡的對應和讀入 membr 打卡的 entry   抓最近的卡片資料
        ArrayList<CardMembr> cards = CardMembrMgr.getInstance().retrieveList("membrId in (" + membrIds + ") and created<'"+sdf1.format(nextDay)+"'", " order by created desc");

        Map<Integer, CardMembr> membrcardMap = new SortingMap(cards).doSortSingleton("getMembrId");
        String cardIds = new RangeMaker().makeRange(cards, "getCardIdTerm");
        EntryMgr emgr = EntryMgr.getInstance();
        emgr.setDataSourceName("card");
        ArrayList<Entry> entries = emgr.retrieveList("created>'" + sdf1.format(d) + "' and created<'" + 
            sdf1.format(nextDay) + "' and cardId in (" + cardIds + ")", " order by created asc");
        Map<String, Vector<Entry>> entryMap = new SortingMap(entries).doSort("getCardId");
        // 今天有沒有請假紀錄
        ArrayList<SchEvent> schevents = SchEventMgr.getInstance().
            retrieveList("startTime>='" + sdf1.format(d) + "' and startTime<'" + sdf1.format(nextDay) + "'", " order by startTime");
        SchEventInfo seinfo = new SchEventInfo(schevents);

        for (int i=0; i<membrs.size(); i++) {
            Membr membr = membrs.get(i);
            SchInfo info = schinfoMap.get(new Integer(membr.getId()));
            Vector v=seinfo.getMembrEvents(membr);  //請假記錄
            Date endDate=new Date();
            Date startDate=new Date();
            int[] late_early_absent = new int[3];
            String[] late_info={"","",""};
            int[] late_time=new int[2]; //遲到早退的時間 傳入成為出缺勤的參數
            Vector<Entry> ve = getEntries(membr, membrcardMap, entryMap);
            getScheduleInfo(membr,d, info, schdefs, ve, late_early_absent,late_info,late_time,v,startDate,endDate);
        }
    }


   public SchEventAuto(Date d,int userId,int bunit) throws Exception    
    {
        Calendar c = Calendar.getInstance();
        c.setTime(d);
        c.add(Calendar.DATE, 1);
        Date nextDay = c.getTime();
        CardCheckdateMgr ccm2=CardCheckdateMgr.getInstance();

        if(bunit ==-1){

            ArrayList<CardCheckdate> ccda=ccm2.retrieveList("checkdate>='" + sdf1.format(d) + "' and checkdate<'" + sdf1.format(nextDay)+"'","");
            if(ccda !=null && ccda.size()>0)
                return;

            CardCheckdate ccdate=new CardCheckdate();
            ccdate.setCheckdate(d);
            ccdate.setCheckUser(userId);
            ccm2.create(ccdate);
        }

        String query="teacherStatus!=0";

        if(bunit !=-1)
            query+=" and teacherBunitId='"+bunit+"'";

        // 找出那天有班的人,原班和換班的都要考慮
        ArrayList<MembrTeacher> all_teachers = MembrTeacherMgr.getInstance().retrieveList(query, "");
        String membrIds = new RangeMaker().makeRange(all_teachers, "getMembrId");
        ArrayList<Membr> membrs = MembrMgr.getInstance().retrieveList("id in (" + membrIds + ")", "");
        Map<Integer, SchInfo> schinfoMap = SchInfo.getSchInfoForMembrs(membrs, d, d);
        ArrayList<SchDef> schdefs = SchInfo.getSchDefsWithin(d, d);

        // 處理卡的對應和讀入 membr 打卡的 entry   抓最近的卡片資料
        ArrayList<CardMembr> cards = CardMembrMgr.getInstance().retrieveList("membrId in (" + membrIds + ") and created<'"+sdf1.format(nextDay)+"'", " order by created desc");

        Map<Integer, CardMembr> membrcardMap = new SortingMap(cards).doSortSingleton("getMembrId");
        String cardIds = new RangeMaker().makeRange(cards, "getCardIdTerm");
        EntryMgr emgr = EntryMgr.getInstance();
        emgr.setDataSourceName("card");
        ArrayList<Entry> entries = emgr.retrieveList("created>'" + sdf1.format(d) + "' and created<'" + 
            sdf1.format(nextDay) + "' and cardId in (" + cardIds + ")", " order by created asc");
        Map<String, Vector<Entry>> entryMap = new SortingMap(entries).doSort("getCardId");
        // 今天有沒有請假紀錄
        ArrayList<SchEvent> schevents = SchEventMgr.getInstance().
            retrieveList("startTime>='" + sdf1.format(d) + "' and startTime<'" + sdf1.format(nextDay) + "'", " order by startTime");
        SchEventInfo seinfo = new SchEventInfo(schevents);

        for (int i=0; i<membrs.size(); i++) {
            Membr membr = membrs.get(i);
            SchInfo info = schinfoMap.get(new Integer(membr.getId()));
            Vector v=seinfo.getMembrEvents(membr);  //請假記錄
            Date endDate=new Date();
            Date startDate=new Date();
            int[] late_early_absent = new int[3];
            String[] late_info={"","",""};
            int[] late_time=new int[2]; //遲到早退的時間 傳入成為出缺勤的參數
            Vector<Entry> ve = getEntries(membr, membrcardMap, entryMap);
            getScheduleInfo(membr,d, info, schdefs, ve, late_early_absent,late_info,late_time,v,startDate,endDate);
        }
    }

     void getScheduleInfo(Membr membr,Date d, SchInfo info, ArrayList<SchDef> schdefs, Vector<Entry> ve2, int[] late_early_absent,String[] late_info,int[] late_time,Vector v,Date d1,Date d2)
        throws Exception
    {
        StringBuffer sb = new StringBuffer();

        for (int i=0; i<schdefs.size(); i++) {
            SchDef sd = schdefs.get(i);

            if(sd.getAutoRun()==0)   //人工比對
                continue;
            boolean isOriginal = info.isOriginal(d, sd.getId());
            int switchStatus = info.getSwitchStatus(d, sd.getId());
            if ((isOriginal && switchStatus!=SchswRecord.TYPE_OFF) || (switchStatus==SchswRecord.TYPE_ON)) { // 有班

                sch_content s_c=info.getSchContent(d,sd.getId()); 
                sd.getStartEndTime(d, d1, d2);

                if (s_c.type !=sch_content.TYPE_FLEXIBLE) {
                    sd.getStartEndTime(d, d1, d2);
                }else{
                    ArrayList<int[]> flexTime = s_c.flexTime;
                    
                    if(ve2==null || ve2.size()<2){
                        sd.getStartEndTime(d, d1, d2);
                    }else{
                        ArrayList<Date[]> flexDate=sd.rundate(d,flexTime);

                        if(flexDate ==null || flexDate.size()<=1){
                            sd.getStartEndTime(d, d1, d2);
                        }else{
                            Date[] resultD=sd.getFlexable(d,d1,d2,flexDate,ve2);
                            d1=resultD[0];
                            d2=resultD[1];
                        }
                    }
                }

                Vector ve=SchEventInfo.checkGoodEntry(ve2,d1,d2);

                //刷卡異常
                if (ve==null||ve.size()<2) {
                    Vector rVector=new Vector(); //回傳可請假的時段
                    boolean bResult=SchEventInfo.calcEvent(d1,d2,v,rVector);
                    if(bResult){
                        for(int k=0;rVector !=null && k<rVector.size();k++)
                        {
                            Date[] rDate=(Date[])rVector.get(k);
                            SchEvent s=new SchEvent();
                            s.setStartTime(rDate[0]);
                            s.setEndTime(rDate[1]);
                            int total = (int) ((rDate[1].getTime()-rDate[0].getTime())/((long)1000*(long)60));
                            if(s_c.offtime !=0)
                                total-=s_c.offtime;
                            if(total<0)
                                total=0;
                            int hr = total/60;
                            int mins = total%60;
                            s.setLastingHours(hr);
                            s.setLastingMins(mins);
                            s.setSchdefId(sd.getId());
                            s.setRestMins(s_c.offtime);
                            s.setRecordTime(new Date());
                            s.setModifyTime(new Date());
                            s.setMembrId(membr.getId());
                            s.setUserId(0);
                            s.setType(SchEvent.TYPE_NO_APPEAR);
                            s.setNote("系統自動計算");
                            s.setStatus(SchEvent.STATUS_READER_PENDDING);

                            SchEvent.createEvent(s);
                            //semgr.create(s);
                        }                               
                }
                continue;
            }
            // 遲到
            Entry e =(Entry)ve.get(0);
            String createdString=sdf2.format(e.getCreated());
            Date created=sdf2.parse(createdString);
            int buffer_mins=s_c.buffer;

            Calendar c=Calendar.getInstance();
            c.setTime(d1);
            c.add(Calendar.MINUTE,buffer_mins);
            Date d1Buffer=c.getTime();
    
            if (created.compareTo(d1Buffer)>0) { 

                Vector rVector=new Vector(); //可請假的時段
                boolean bResult=SchEventInfo.calcEvent(d1,created,v,rVector);
                if(bResult){
                    for(int k=0;rVector !=null && k<rVector.size();k++)
                    {
                        Date[] rDate=(Date[])rVector.get(k);
                        SchEvent s=new SchEvent();
                        s.setStartTime(rDate[0]);
                        s.setEndTime(rDate[1]);
                        int total = (int) ((rDate[1].getTime()-rDate[0].getTime())/((long)1000*(long)60));
                        int hr = total/60;
                        int mins = total%60;
                        s.setLastingHours(hr);
                        s.setLastingMins(mins);
                        s.setRecordTime(new Date());
                        s.setModifyTime(new Date());
                        s.setMembrId(membr.getId());
                        s.setUserId(0);
                        s.setSchdefId(sd.getId());
                        s.setType(SchEvent.TYPE_AB_START);
                        s.setNote("系統自動計算");
                        s.setStatus(SchEvent.STATUS_READER_PENDDING);

                        SchEvent.createEvent(s);
                        //semgr.create(s);
                    }
                }
            }

            // 早退
            e = (Entry)ve.get(ve.size()-1);
            String endString=sdf2.format(e.getCreated());
            Date endDate=sdf2.parse(endString);
            if (endDate.compareTo(d2)<0) { 
                Vector rVector=new Vector(); //可請假的時段
                boolean bResult=SchEventInfo.calcEvent(endDate,d2,v,rVector);
                if(bResult){
                    for(int k=0;rVector !=null && k<rVector.size();k++)
                    {
                        Date[] rDate=(Date[])rVector.get(k);
                        SchEvent s=new SchEvent();
                        s.setStartTime(rDate[0]);
                        s.setEndTime(rDate[1]);
                        int total = (int) ((rDate[1].getTime()-rDate[0].getTime())/((long)1000*(long)60));
                        int hr = total/60;
                        int mins = total%60;
                        s.setLastingHours(hr);
                        s.setLastingMins(mins);
                        s.setSchdefId(sd.getId());
                        s.setRecordTime(new Date());
                        s.setModifyTime(new Date());
                        s.setMembrId(membr.getId());
                        s.setUserId(0);
                        s.setType(SchEvent.TYPE_AB_ENDING);
                        s.setNote("系統自動計算");
                        s.setStatus(SchEvent.STATUS_READER_PENDDING);

                        SchEvent.createEvent(s);
                        //semgr.create(s);
                    }                               
                }
            }
        }
    }
}

    public Vector<Entry> getEntries(Membr membr, Map<Integer, CardMembr> membrcardMap, Map<String, Vector<Entry>> entryMap){
        CardMembr cm = membrcardMap.get(new Integer(membr.getId()));
        if (cm==null)
            return null;
        String cardId = cm.getCardId();
        Vector<Entry> ev = entryMap.get(cardId);
        return ev;
    }
}