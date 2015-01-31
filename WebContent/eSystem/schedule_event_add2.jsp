<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm");
    SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy/MM/dd");

    int targetId = Integer.parseInt(request.getParameter("target"));
    int type = Integer.parseInt(request.getParameter("type"));
    int boundType = (type==SchEvent.TYPE_AB_START || type==SchEvent.TYPE_OT_BEFORE)?0:1; // 開始 or 結束
    int dirType = (type==SchEvent.TYPE_AB_START || type==SchEvent.TYPE_OT_AFTER)?0:1;  // 往后算 or 往前算
    String note = request.getParameter("note");

    SchEventMgr semgr = SchEventMgr.getInstance();
    SchEvent s = new SchEvent();

    String sdate=request.getParameter("startTime");
    String d1=sdate+" "+request.getParameter("d1").trim();
    String d2=sdate+" "+request.getParameter("d2").trim();      

//out.println("d1 String:"+d1+","+d2+"<br>");
    Membr membr = MembrMgr.getInstance().find("id=" + targetId);
    Date startTime = sdf.parse(d1);
    Date endTime = sdf.parse(d2);    
    Date nowDate=sdf2.parse(sdate);
    int sdId=0;
    int restMins=0;
    String boundaryTime=request.getParameter("boundaryTime");
    String restMinsS=request.getParameter("restMins");    

    if(boundaryTime!=null)
        sdId=Integer.parseInt(boundaryTime);

    if(restMinsS !=null)
        restMins=Integer.parseInt(restMinsS);


    Calendar c2=Calendar.getInstance();
    c2.setTime(nowDate);
    c2.add(Calendar.DATE,1);
    Date nextDate=c2.getTime();

    ArrayList<SchEvent> schevents = SchEventMgr.getInstance().retrieveList("startTime>='" + sdate + "' and startTime<'" + sdf2.format(nextDate) + "' and membrId='"+targetId+"' and    schdefId='"+sdId+"'", " order by startTime");

    Vector rVector=new Vector();
    Vector v3=new Vector();
    for(int i=0;i<schevents.size();i++){
        v3.add((SchEvent)schevents.get(i));
    }

    SchDef sd=SchDefMgr.getInstance().find("id="+sdId);
    Date startTime2=new Date();            
    Date endTime2=new Date();
    sd.getStartEndTime(nowDate,startTime2,endTime2);   //換成班表限定的範圍


    if(startTime.compareTo(startTime2)<0)
        startTime=startTime2;
    if(endTime2.compareTo(endTime)<0)
        endTime=endTime2;

    if(startTime.compareTo(startTime2)==0 && endTime.compareTo(endTime2)==0){

        SchInfo info = SchInfo.getSchInfo(membr, nowDate, nowDate);
        sch_content s_c=info.getSchContent(nowDate,sdId);
        restMins=s_c.offtime;
    }
        
    boolean vResult=SchEventInfo.calcOldEvent(startTime,endTime,v3);
    String vps=request.getParameter("vps");

    if(vResult){

        s.setStartTime(startTime);
        s.setEndTime(endTime);
        int total = (int) ((endTime.getTime()-startTime.getTime())/((long)1000*(long)60));
        
        if(restMins !=0)
            total-=restMins;
        if(total<0)
            total=0;
        int hr = total/60;
        int mins = total%60;
        s.setLastingHours(hr);
        s.setLastingMins(mins);
        s.setRecordTime(new Date());
        s.setModifyTime(new Date());
        s.setMembrId(targetId);
        s.setUserId(ud2.getId());
        s.setType(type);
        s.setNote(note);
        s.setSchdefId(sdId);
        s.setRestMins(restMins);
        s.setVerifyDate(new Date());
        s.setVerifyPs(vps);
        s.setVerifyUserId(ud2.getId());

        
        if(SchEvent.createEvent(s)){
%>
    <blockquote>
        <div class=es02>新增成功!
        <br>
        <br>
            <a href="schedule_event_add.jsp">繼續登入</a>
        </div>
    </blockquote>
<%
        }else{
%>
        <blockquote>
            <div class=es02>新增失敗!<br><br>可能沒有多餘的年假.</div>
        </blockquote>
<%
        }
    }else{
%>
    <blockquote>
        <div class=es02>新增失敗!<br><br>與現有的缺勤/請假重疊.</div>
    </blockquote>
<%  
    }   
%>
<script>
  parent.do_reload = true;
</script>