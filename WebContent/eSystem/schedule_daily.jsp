<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,cardreader.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=6;
    int leftMenu=3;
%>
<style type="text/css">

.confirmEvent1{
    background: #FFFF66;
}
.confirmEvent2{
    background: #99CCFF;
}

</style>
<%@ include file="topMenu.jsp"%>
<%!

    String replaceWeek(int weekday){

        switch(weekday){
            case 0:
                return "星期日";
            case 1:
                return "星期一";
            case 2:
                return "星期二";
            case 3:
                return "星期三";
            case 4:
                return "星期四";
            case 5:
                return "星期五";
            case 6:
                return "星期六";
        }
        return "";
    }

    //late_early_absent[0]  遲到
    //late_early_absent[1]  下班未刷/未刷卡
    static SimpleDateFormat sdft = new SimpleDateFormat("HH:mm");
    SimpleDateFormat sdf2 = new SimpleDateFormat("yyyyMMdd HH:mm");
    SimpleDateFormat sdf3 = new SimpleDateFormat("yyyyMMdd");
    SimpleDateFormat sdf5 = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf4 = new SimpleDateFormat("yyyyMMddHHmm");
    String formatTime(Date d1, Date d2)
    {
        return sdft.format(d1) + "-" + sdft.format(d2);
    }
    static long min = ((long)60)*((long)1000);
    String getScheduleInfo(Membr membr,Date d, SchInfo info, ArrayList<SchDef> schdefs, Vector<Entry> ve2, int[] late_early_absent,String[] late_info,int[] late_time,Vector vEvent,Date d1,Date d2,boolean done,String[] runId)
        throws Exception
    {
        StringBuffer sb = new StringBuffer();
        int nowString=0;
        StringBuffer sb2 = new StringBuffer();
        int[] haveData=new int[2];
        for (int i=0; i<schdefs.size(); i++) {
            SchDef sd = schdefs.get(i);
           
            boolean isOriginal = info.isOriginal(d, sd.getId());
            int switchStatus = info.getSwitchStatus(d, sd.getId());
            if ((isOriginal && switchStatus!=SchswRecord.TYPE_OFF) || (switchStatus==SchswRecord.TYPE_ON)) { // 有班
                
                sb2.append(sd.getId());
                if(nowString !=0)        
                    sb2.append(",");
                nowString++;

                sch_content s_c=info.getSchContent(d,sd.getId());                
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

                if (sb.length()>0) sb.append("<br>");
   
                sb.append("<a href=\"javascript:openwindow_phm('schedule_detail.jsp?id="+sd.getId()+"', '班表詳細資料', 800, 600, 'scheduledetail')\">"+((sd.getAutoRun()==0)?"<font color=blue>*</font>":"")+sd.getName()+"</a>");

                sb.append("<br>&nbsp;&nbsp;" + formatTime(d1, d2));        

                sb.append("<br>&nbsp;&nbsp;<a href=\"javascript:openwindow_phm('schedule_event_add.jsp?et=1&membrId="+membr.getId()+"&d1="+sdf3.format(d)+"', '登記缺勤請假', 800, 600, 'addevent');\">缺勤</a> | <a href=\"javascript:openwindow_phm('schedule_event_add.jsp?et=2&membrId="+membr.getId()+"&d1="+sdf3.format(d)+"', '登記缺勤請假', 800, 600, 'addevent');\">請假</a>");        

                if(!done)
                    continue;
                
                Date rightnow=new Date();
                Vector<Entry> ve=SchEventInfo.checkGoodEntry(ve2,d1,d2);
                boolean xrun=false;
                //刷卡異常
                 if (ve==null|| ve.size()<2) {                                    
                    if(d2.compareTo(rightnow)<=0)   //今天過了
                    {
                        xrun=true;

                        if(haveData[0]!=0)
                            late_info[1]+="<br><br>";  
                        
                        if(ve!=null && ve.size()>0){
                            late_early_absent[1] = 1; // 下班未刷             
                            late_info[1]+="下班未刷: "+sd.getName();
                        }else{ 
                            late_early_absent[1] = 2; // 缺席
                            late_info[1]+="缺勤: "+sd.getName();
                        }

                        Vector rVector=new Vector(); //回傳可請假的時段                                    
                        boolean bResult=SchEventInfo.calcEvent(d1,d2,vEvent,rVector);
                        if(bResult){
                                    
                                for(int k=0;rVector !=null && k<rVector.size();k++)
                                {       
                                    Date[] aaa=(Date[])rVector.get(k);
                                    late_info[1]+="<br>"+sdft.format(aaa[0])+"-"+sdft.format(aaa[1]);
                                    int late=(int) ((aaa[1].getTime()-aaa[0].getTime())/min);
                                    late_early_absent[2] += late;
                                late_info[1]+="&nbsp; <a href=\"schedule_add_person.jsp?membrId="+membr.getId()+"&sdId="+sd.getId()+"&type="+SchEvent.TYPE_NO_APPEAR+"&d1="+sdf4.format(aaa[0])+"&d2="+sdf4.format(aaa[1])+"&restMins=0&startTime2="+sdf4.format(d1)+"&endTime2="+sdf4.format(d2)+"\" onClick=\"return(confirm('確認產生此缺勤?'))\">缺勤</a>";

                                    late_info[1]+=" | <a href=\"schedule_add_person.jsp?membrId="+membr.getId()+"&sdId="+sd.getId()+"&type="+SchEvent.TYPE_PERSONAL+"&d1="+sdf4.format(aaa[0])+"&d2="+sdf4.format(aaa[1])+"&restMins=0&startTime2="+sdf4.format(d1)+"&endTime2="+sdf4.format(d2)+"\" onClick=\"return(confirm('確認產生此請假?'))\">請假</a>";

                                haveData[0]++;
                            }                               
                        }else{                                    
                            int late=(int) ((d2.getTime()-d1.getTime())/min);
                            late_info[1]+="<div class=esxx>"+sdft.format(d1)+"-"+sdft.format(d2)+"("+late+" 分)";
                            late_info[1]+="<br>已有請假/缺勤紀錄</div>";
                            haveData[0]=0;
                        }                                    
                    }else if(d1.compareTo(rightnow)<=0 && ve==null){

                        late_early_absent[0] = 1; // 缺席
                        late_info[0]+="遲到: "+sd.getName();
                        late_info[0]+="<br>"+sdft.format(d1)+"-"+sdft.format(rightnow);
                    }
                    if(xrun || ve==null)
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

                    if(rightnow.compareTo(d1Buffer)<0)
                        break;
 
                    Vector rVector=new Vector(); //可請假的時段
                    boolean bResult=SchEventInfo.calcEvent(d1,created,vEvent,rVector);
                    if(haveData[1]!=0)
                        late_info[0]+="<br>";

                    late_info[0]+="遲到: "+sd.getName();
                    if(bResult){
                        for(int k=0;rVector !=null && k<rVector.size();k++)
                        {
                            Date[] aaa=(Date[])rVector.get(k);
                            late_info[0]+="<br>"+sdft.format(aaa[0])+"-"+sdft.format(aaa[1]);
                            int late=(int) ((aaa[1].getTime()-aaa[0].getTime())/min);
                            late_early_absent[0] += late;
                            late_info[0]+="&nbsp;"+" <a href=\"schedule_add_person.jsp?membrId="+membr.getId()+"&type="+SchEvent.TYPE_PERSONAL+"&d1="+sdf4.format(aaa[0])+"&d2="+sdf4.format(aaa[1])+"&sdId="+sd.getId()+"&startTime2="+sdf4.format(d1)+"&endTime2="+sdf4.format(d2)+"\">請假</a>";

                            late_info[0]+="| <a href=\"schedule_add_person.jsp?membrId="+membr.getId()+"&type="+SchEvent.TYPE_AB_START+"&d1="+sdf4.format(aaa[0])+"&d2="+sdf4.format(aaa[1])+"&sdId="+sd.getId()+"&startTime2="+sdf4.format(d1)+"&endTime2="+sdf4.format(d2)+"\">缺勤</a>";
                        }
                        haveData[1]++;                               
                    }else{

                        int late=(int) ((created.getTime()-d1.getTime())/min);
                        late_early_absent[0] += late;
                        late_info[0]+="<div class=esxx>"+sdft.format(d1)+"-"+sdft.format(created)+"("+late+" 分)";
                        late_info[0]+="<br>已有請假/缺勤紀錄</div>";
                        haveData[1]=0;
                    }
                }                
                if(ve.size()<=1){
                    continue;
                }
                // 早退
                e = ve.get(ve.size()-1);
                String endString=sdf2.format(e.getCreated());
                Date endDate=sdf2.parse(endString);
                if (endDate.compareTo(d2)<0) { 

                    if(rightnow.compareTo(d2)<0)
                        break;

                    if(haveData[1]!=0)
                            late_info[0]+="<br>";
                    late_info[0]+="<br>早退: "+sd.getName();
                    Vector rVector=new Vector(); //可請假的時段
                    boolean bResult=SchEventInfo.calcEvent(endDate,d2,vEvent,rVector);

                    if(bResult){
                        for(int k=0;rVector !=null && k<rVector.size();k++)
                        {
                            Date[] aaa=(Date[])rVector.get(k);
                            late_info[0]+="<br>"+sdft.format(aaa[0])+"-"+sdft.format(aaa[1]);

                            int early=(int) ((aaa[1].getTime()-aaa[0].getTime())/min);
                            late_early_absent[0] += early;

                            late_info[0]+="&nbsp;"+" <a href=\"schedule_add_person.jsp?membrId="+membr.getId()+"&type="+SchEvent.TYPE_PERSONAL+"&d1="+sdf4.format(aaa[0])+"&d2="+sdf4.format(aaa[1])+"&sdId="+sd.getId()+"&startTime2="+sdf4.format(d1)+"&endTime2="+sdf4.format(d2)+"\">請假</a>";

                        late_info[0]+="| <a href=\"schedule_add_person.jsp?membrId="+membr.getId()+"&type="+SchEvent.TYPE_AB_ENDING+"&d1="+sdf4.format(aaa[0])+"&d2="+sdf4.format(aaa[1])+"&sdId="+sd.getId()+"&startTime2="+sdf4.format(d1)+"&endTime2="+sdf4.format(d2)+"\">缺勤</a>";
                        }                               
                        haveData[1]++;
                    }else{
                        int early=(int) ((d2.getTime()-endDate.getTime())/min);
                        late_early_absent[0] += early;
                        late_info[0]+="<div class=esxx>"+sdft.format(endDate)+"-"+sdft.format(d2)+"("+early+" 分)";
                        late_info[0]+="<br>已有請假/缺勤紀錄</div>";
                        haveData[1]=0;
                    }
                }
            }
        }             
        runId[0]=sb2.toString();
        return sb.toString();
    }

    String switchStatus(int status){

        switch(status){
            
            case 0:
                return "&nbsp;&nbsp;&nbsp;正式缺勤";
            case 1:
                return "&nbsp;&nbsp;&nbsp;正式缺勤";                
            case 2:
                return "<img src='images/dotx.gif' border=0>&nbsp;未確認 Pendding";                
        }
        return "";
    }

    String switchType(int type){

        switch(type){
            case SchEvent.TYPE_PERSONAL:
                return "<b>事假</b> (扣薪)";                
            case SchEvent.TYPE_BUSINESS:
                return "<b>公假</b> (不扣薪)";                
            case SchEvent.TYPE_SICK:
                return "<b>病假</b> (扣薪)";                
            case SchEvent.TYPE_OTHER:
                return "<b>其他假</b> (不扣薪)";                
            case SchEvent.TYPE_YEAR:
                return "<b>年假</b> (不扣薪)";                
            case SchEvent.TYPE_OVERTIME:
                return "<b>補休</b> (不扣薪)";                
            case SchEvent.TYPE_AB_START:
                return "<b>遲到</b> (扣薪)";  
            case SchEvent.TYPE_AB_ENDING:
                return "<b>早退</b> (扣薪)";   
            case SchEvent.TYPE_NO_APPEAR:
                return "<b>缺勤</b> (扣薪)";               
            case Holiday.TYPE_HOLIDAY_OFFICE:
                return "<b>國定假日</b> (不扣薪)";               
            case Holiday.TYPE_HOLIDAY_WEATHER:
                return "<b>颱風假</b> (不扣薪)";               
            case Holiday.TYPE_HOLIDAY_COMPANY:
                return "<b>員工旅行</b> (不扣薪)";               
            case Holiday.TYPE_HOLIDAY_OTHER:
                return "<b>其他公假</b> (不扣薪)";               
            default:
                return "";
        }
    }

    Vector<Entry> getEntries(Membr membr, Map<Integer, CardMembr> membrcardMap, Map<String, Vector<Entry>> entryMap)
    {
        CardMembr cm = membrcardMap.get(new Integer(membr.getId()));
        if (cm==null)
            return null;
        String cardId = cm.getCardId();
        Vector<Entry> ev = entryMap.get(cardId);
        return ev;
    }

    String getPunchInfo(Vector<Entry> ev,String[] runId,int membrId)
    {
        if (ev==null)
            return "";
        StringBuffer sb = new StringBuffer();
        boolean showDot=false;
        for (int i=0; i<ev.size(); i++) {
            
            if(i>1 && i<(ev.size()-1)){
                if(!showDot){
                    showDot=true;
                    sb.append("&nbsp;.......&nbsp;&nbsp;"); 
                }
                continue;
            }
            Entry e = ev.get(i);
            if(i==1){ sb.append(","); }

            if(e.getDatatype()==1){
                sb.append("<a href=\"#\" onClick=\"javascript:openwindow_phm('modifyCardReader.jsp?eId="+e.getId()+"&membrId="+membrId+"', '補登刷卡', 400, 300, 'addevent');return false\">"+sdft.format(e.getCreated())+"</a>");
            }else{
                sb.append(sdft.format(e.getCreated()));
            }            

            if(i>0 && (i%2)==1 &&(i !=(ev.size()-1)))
                sb.append("<br>");

            if(i==(ev.size()-1)){
                
                String sday=java.net.URLEncoder.encode(sdf5.format(e.getCreated()));     
                sb.append("<div class=es02 align=right><a href=\"#\" onClick=\"javascript:openwindow_phm('listCardReader.jsp?cardId="+e.getCardId()+"&d1="+sday+"&sdIds="+runId[0]+"&membrId="+membrId+"', '刷卡明細', 500, 550, 'addevent');return false\">共"+ev.size()+"筆</a></div>");

            }
        }
        return sb.toString();
    }
%>
<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat sdf2 = new SimpleDateFormat("HH:mm");
    SimpleDateFormat sdf3 = new SimpleDateFormat("yyyyMMdd");
    SimpleDateFormat sdf4 = new SimpleDateFormat("yyyyMMddHHmm");
    SimpleDateFormat sdf5 = new SimpleDateFormat("HHmm");              

    Date d = sdf.parse(sdf.format(new Date())); // 為了讓時分秒歸零
    try { d = sdf.parse(request.getParameter("d")); } catch (Exception e) {}
    Calendar c = Calendar.getInstance();
    c.setTime(d);
    c.add(Calendar.DATE, 1);
    Date nextDay = c.getTime();
    c.setTime(new Date());
    c.add(Calendar.DATE, -1);
    Date now=c.getTime();

    c.setTime(new Date());
    c.add(Calendar.DATE, 1);
    Date now2=c.getTime();
             
    boolean showCard=false;
    boolean afterDate=false;

    if(d.before(new Date())){
        showCard=true;
   }

    if(d.before(now))
        afterDate=true;

    int bunit=(ud2.getUserBunitCard()==0)?-1:ud2.getUserBunitCard();
    String bunitS=request.getParameter("bunit");        
    if(bunitS !=null)
        bunit=Integer.parseInt(bunitS); 

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
    ArrayList<CardMembr> cards = CardMembrMgr.getInstance().retrieveList("membrId in (" + membrIds + ") and created<'"+sdf.format(nextDay)+"'", "group by membrId desc");
    Map<Integer, CardMembr> membrcardMap = new SortingMap(cards).doSortSingleton("getMembrId");

    ArrayList<Entry> entries = null;
    Map<String, Vector<Entry>> entryMap = null;
    if(cards !=null && cards.size()>0){
    
        String cardIds = new RangeMaker().makeRange(cards, "getCardIdTerm");
        EntryMgr emgr = EntryMgr.getInstance();
        emgr.setDataSourceName("card");
        String readerId=SchEventInfo.getMachineId();
        
        entries = emgr.retrieveList("created>='" + sdf1.format(d) + "' and created<'" + 
            sdf1.format(nextDay) + "' and cardId in (" + cardIds + ")"+readerId, " order by created asc");
        entryMap = new SortingMap(entries).doSort("getCardId");
    }

    // 今天有沒有註記紀錄
    ArrayList<Entryps> pss = EntrypsMgr.getInstance().
        retrieveList("created>='" + sdf1.format(d) + "' and created<'" + sdf1.format(nextDay) + "'", " order by created");
    Map<Integer, Entryps> pssMap = new SortingMap(pss).doSortSingleton("getMembrId");

    // 今天有沒有請假紀錄
    ArrayList<SchEvent> schevents = SchEventMgr.getInstance().
        retrieveList("startTime>='" + sdf1.format(d) + "' and startTime<'" + sdf1.format(nextDay) + "'", " order by startTime");
    SchEventInfo seinfo = new SchEventInfo(schevents);

    //今天有沒有處理
    CardCheckdateMgr ccm=CardCheckdateMgr.getInstance();
    ArrayList<CardCheckdate> ccd=ccm.retrieveList("checkdate>='" + sdf1.format(d) + "' and checkdate<'" + sdf1.format(nextDay)+"'","");
    boolean checkdate=false;
    if(ccd !=null && ccd.size()>0)
        checkdate=true;

    if(bunit !=-1)
        checkdate=true;
%>
<%@ include file="leftMenu6_sch.jsp"%>
<br>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;<img src="images/rfidx.png" border=0>&nbsp;考勤日報表</b>
</div>
<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>

<blockquote>
<table border=0>
    <tr class=es02>
<%
    Calendar c2 = Calendar.getInstance();
    c.setTime(d);
    c.add(Calendar.DATE, -1);
    Date lastDay = c.getTime();



    BunitMgr bm=BunitMgr.getInstance();
    ArrayList<Bunit> b=bm.retrieveListX("status ='1' and flag='0'","", _ws.getBunitSpace("buId"));


%>
    <form name="f1" action="schedule_daily.jsp" method="get">
    <td>
        <input type=button value="&nbsp;&nbsp;<-&nbsp;&nbsp;" onClick="window.location='schedule_daily.jsp?d=<%=sdf.format(lastDay)%>&bunit='+this.form.bunit.value">
    </td>

    <td nowrap>
        &nbsp;&nbsp;&nbsp;<b>資料日期:</b> <input type=text name="d" value="<%=sdf.format(d)%>" size=8 onchange="this.disabled=false; this.form.submit();" disabled>
        &nbsp;(<%=replaceWeek(d.getDay())%>)
        <a href="#" onclick="displayCalendar(document.f1.d,'yyyy/mm/dd',this);return false"><img src="pic/blog4.gif" border=0></a>
        &nbsp;&nbsp;
    </td>
<%
    if(b !=null && b.size()>0){
%>
    <td>
    部門: <select name="bunit" size=1  onChange="window.location='schedule_daily.jsp?d=<%=sdf.format(d)%>&bunit='+this.value">
                <option value="-1" <%=(bunit==-1)?"selected":""%>>全部</option>
    <%          
                for(int j=0;j<b.size();j++){    
                    Bunit bb=b.get(j);
    %>
                    <option value="<%=bb.getId()%>" <%=(bunit==bb.getId())?"selected":""%>><%=bb.getLabel()%></option>
    <%          }   %>
                <option value="0" <%=(bunit==0)?"selected":""%>>未定</option>
            </select>
    </td>
<%
    }else{
%>
        <input type=hidden name="bunit" value="-1">
<%  }   %>

    <td>
        <input type=button value="&nbsp;&nbsp;->&nbsp;&nbsp;" onClick="window.location='schedule_daily.jsp?d=<%=sdf.format(nextDay)%>&bunit='+this.form.bunit.value">
    </td>
    </form>        
    </tr>
</table>    
 </blockquote>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  
<%
   if(afterDate){
%>
<br>
<center>
    <table border=0>
    <tr>
    <tD>
        <form action="auto_schedule_daily.jsp" method="post">        
            <input type=hidden name="d" value="<%=sdf.format(d)%>">
            <input type=hidden name="bunit" value="<%=bunit%>">
            <%  if(bunit !=-1){ %>
                <input type=submit value="系統產生缺勤">
            <%  }else{  %>
                <input type=submit value="系統產生缺勤" <%=(checkdate)?"disabled":""%>>
            <%  }   %>
        </form>
    </td>
    <td>
        <form action="delete_schedule_daily_reader.jsp" method="post">        
            <input type=hidden name="d1" value="<%=sdf.format(d)%>">
            <input type=hidden name="d2" value="<%=sdf.format(d)%>">
            <input type=hidden name="bunit" value="<%=bunit%>">
            <input type=hidden name="type" value="1">
            <input type=submit value="刪除系統產生的缺勤" <%=(checkdate)?"":"disabled"%>>
        </form>
    </td>
    <td>
        <form action="confirm_schedule_daily_reader.jsp" method="post">        
            <input type=hidden name="d1" value="<%=sdf.format(d)%>">
            <input type=hidden name="d2" value="<%=sdf.format(d)%>">
            <input type=hidden name="bunit" value="<%=bunit%>">
            <input type=hidden name="type" value="1">
            <input type=submit value="覆核系統產生的缺勤" <%=(checkdate)?"":"disabled"%>>
        </form>
    </td>
    </tr>
    </table>
</center>
<%  }else{   %>
    <br>
<div class=es02 align=left>
&nbsp;&nbsp;&nbsp;&nbsp;
<a href="javascript:openwindow_phm2('schedule_event_add.jsp?et=1&d1=<%=sdf3.format(d)%>&bunit=<%=bunit%>', '登記缺勤請假', 800, 600, 'addevent');"><img src="pic/addevent2.png" border=0>&nbsp;登記缺勤</a> | <a href="javascript:openwindow_phm2('schedule_event_add.jsp?et=2&d1=<%=sdf3.format(d)%>&bunit=<%=bunit%>', '登記缺勤請假', 800, 600, 'addevent');"><img src="pic/addevent.png" border=0>&nbsp;登記請假</a>

</div>
<%  }   %>
<blockquote>
<font color=blue>*</font> <font class=es02>為加班模式,系統將不會主動產生缺勤.</font>
<table height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
    <tr bgcolor=#f0f0f0 class=es02>
        <td align=middle rowspan=2>姓名</td>
        <td width=70 align=middle  rowspan=2>班表資訊</td>
        <td width=70 align=middle  rowspan=2>刷卡紀錄</td>
        <td colspan=2 align=middle>系統比對試算</td>
        <td rowspan=2 align=middle width=130 bgcolor="#FFFFFF"><b>缺勤/請假紀錄</b></td>
    </tr>
    <tr bgcolor=#f0f0f0 class=es02>
        <td width=120 align=middle>遲到/早退</td><td width=120 align=middle>缺勤</td>
    </tr>
<%
    for (int i=0; i<membrs.size(); i++) {
        Membr membr = membrs.get(i);
        SchInfo info = schinfoMap.get(new Integer(membr.getId()));

        Vector vEvent=seinfo.getMembrEvents(membr);  //請假記錄

        Entryps ep=pssMap.get(new Integer(membr.getId()));
%>
    <tr bgcolor=#ffffff  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
        <td class=es02 align=left valign=top>
                    <a href="javascript:openwindow_phm('modifyTeacherCard.jsp?teacherId=<%=membr.getSurrogateId()%>','教職員基本資料',800,550,true);"><%=membr.getName()%></a>
            <%
                String cardId="";
                CardMembr cmxx=membrcardMap.get(new Integer(membr.getId()));
                if(cmxx !=null){
                    cardId=cmxx.getCardId();
                    if(cmxx.getCardId().indexOf("mm")==-1)
                        out.println("<br>"+cmxx.getCardId());
                    else
                        out.println("<br>尚未設定卡片");
                }else{
                        out.println("<br>尚未設定卡片");
                }

                if(ep!=null && ep.getPs().length()>0){
                    String pscontent=ep.getPs().replace("\n","<br>");
            %>
                <br>
                <font color=red>*</font> <%=pscontent%>
            <%  }   %>

        </td>
        <td class=es02 nowrap  valign=top>
        <%
            Date endDate=new Date();
            Date startDate=new Date();
            int[] late_early_absent = new int[3];
            String[] late_info={"","",""};
            int[] late_time=new int[2]; //遲到早退的時間 傳入成為出缺勤的參數
            Vector<Entry> ve = getEntries(membr, membrcardMap, entryMap);
            String[] runId={""};
            out.println(getScheduleInfo(membr,d, info, schdefs, ve, late_early_absent,late_info,late_time,vEvent,startDate,endDate,showCard,runId));
        %>
        </td>
        <td class=es02 nowrap>
        <%  
            out.println(getPunchInfo(ve,runId,membr.getId()));
        %>
        <% 
            if (late_early_absent[1]==2){
                out.println("<br>未刷卡");
            }else if (late_early_absent[1]==1){
                out.println("<br>下班未刷");
            }              
            if(showCard){
        %>
        <br>
<a href="#" onClick="javascript:openwindow_phm('addCardReader.jsp?membrId=<%=membr.getId()%>&d=<%=sdf3.format(d)+sdf5.format(startDate)%>&sdIds=<%=runId[0]%>&cardId=<%=cardId%>', '補登刷卡', 400, 300, 'addevent');return false">補登</a> |
<a href="#" onClick="javascript:openwindow_phm('addEntryps.jsp?membrId=<%=membr.getId()%>&d=<%=sdf3.format(d)+sdf5.format(startDate)%>', '註記', 400, 300, 'addevent');return false">註記</a>


        <%  }   %>
        </td>
        <td class=es02 nowrap align=left valign=top>
            <%  if(late_early_absent[0]!=0){    %>
                    <%=late_info[0]%>
            <%  } %>                
        </td>
        <td class=es02 nowrap align=left valign=top>
            <%  if(late_early_absent[1]!=0){    %>
                    <%=late_info[1]%>
            <%  }   %>
        </td>
        <td class=es02 bgcolor="#FFFFFF" nowrap align=left valign=top>
        <%

            for(int j=0;vEvent !=null && j<vEvent.size();j++){
                SchEvent se=(SchEvent)vEvent.get(j);
                String divClass="es02";            
                if(se.getStatus()<2){
                    divClass="confirmEvent1";
                    switch(se.getType()){
                        case SchEvent.TYPE_BUSINESS: 
                        case SchEvent.TYPE_YEAR:
                        case SchEvent.TYPE_OVERTIME:
                        case SchEvent.TYPE_OTHER:
                            divClass="confirmEvent2";
                            break;
                    }
                }
        %>
            <div class='<%=divClass%>'>
            <%
            if(se.getStatus()==SchEvent.STATUS_READER_PENDDING){
                out.println("<img src='images/dotx.gif' border=0>&nbsp;<b>未確認缺勤</b> (系統產生) ");  //+switchType(se.getType())
            }else if(se.getStatus()==SchEvent.STATUS_PERSON_PENDDING){
                out.println("<b>線上請假</b> "+switchType(se.getType()));
            }else{
                out.println(switchType(se.getType()));
            }
            %>
            </div>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=sdf2.format(se.getStartTime())%>-<%=sdf2.format(se.getEndTime())%> (<%=(se.getLastingHours()>0)?se.getLastingHours()+"時":""%><%=(se.getLastingMins()>0)?se.getLastingMins()+"分":""%>)
<a href="#" onClick="javascript:openwindow_phm('modifySchEvent.jsp?seId=<%=se.getId()%>', '修改出缺勤', 500, 420, 'addevent');return false">修改</a> <br>

        <%  }   %>
        </td>
    </tr>	
<%
    }
%>
    </table> 

</td>
</tr>
</table>
</form>
</blockquote>
<%@ include file="bottom.jsp"%>