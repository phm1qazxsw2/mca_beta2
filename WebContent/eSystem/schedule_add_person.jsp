<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    SimpleDateFormat sdf1xx = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf4 = new SimpleDateFormat("yyyyMMddHHmm");
    SimpleDateFormat sdf2 = new SimpleDateFormat("yyyyMMdd");

    String d1String=request.getParameter("d1");
    String d2String=request.getParameter("d2");
    int membrId=Integer.parseInt(request.getParameter("membrId"));
    int type=Integer.parseInt(request.getParameter("type"));
    int sdId=Integer.parseInt(request.getParameter("sdId"));

    Date d1=sdf4.parse(d1String);
    Date d2 =new Date();
    
    if(d2String !=null)
        d2=sdf4.parse(d2String);
    Date rundate=sdf2.parse(d1String.substring(0,8));

    String note = "";

    int restMins=0;
    
    SchDef sd=SchDefMgr.getInstance().find("id="+sdId);
    Date startTime2=new Date();

    String startTime2S=request.getParameter("startTime2"); 
    if(startTime2S !=null)
          startTime2=sdf4.parse(startTime2S);

    Date endTime2=new Date();
    String endTime2S=request.getParameter("endTime2"); 
    if(endTime2S !=null)
          endTime2=sdf4.parse(endTime2S);

    //sch_content sc2 = sd.getSchContent();
    //ArrayList<int[]> flexTime = s_c.flexTime;
    //sd.getStartEndTime(rundate,startTime2,endTime2);   //換成班表限定的範圍


    if(d1.compareTo(startTime2)<0)
        d1=startTime2;
    if(endTime2.compareTo(d2)<0)
        d2=endTime2;

    if(d1.compareTo(startTime2)==0 && d2.compareTo(endTime2)==0){
        Membr membr = MembrMgr.getInstance().find("id=" + membrId);
        SchInfo info = SchInfo.getSchInfo(membr, rundate, rundate);
        sch_content s_c=info.getSchContent(rundate,sdId);
        restMins=s_c.offtime;
    }
    
   

    int total = (int) ((d2.getTime()-d1.getTime())/((long)1000*(long)60));
    if(restMins !=0)
        total-=restMins;
    if(total <0)
        total=0;
    int hours=total/60;
    int mins=total-(hours*60);
    
    SchEventMgr semgr = SchEventMgr.getInstance();
    SchEvent s = new SchEvent();
    
    s.setStartTime(d1);
    s.setEndTime(d2);
    s.setLastingHours(hours);
    s.setLastingMins(mins);
    s.setRecordTime(new Date());
    s.setModifyTime(new Date());
    s.setMembrId(membrId);
    s.setUserId(ud2.getId());
    s.setType(type);
    s.setNote(note);
    s.setSchdefId(sdId);
    s.setStatus(SchEvent.STATUS_PERSON_CONFORM);
    s.setRestMins(restMins);

    s.setVerifyDate(new Date());
    s.setVerifyUserId(ud2.getId());

    SchEvent.createEvent(s);
    //semgr.create(s);

    response.sendRedirect("schedule_daily.jsp?d="+sdf1xx.format(d1));

%>