<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTopNotLogin.jsp"%>
<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>
<%

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm");
    SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy/MM/dd");


    int targetId = Integer.parseInt(request.getParameter("target"));
    int type = Integer.parseInt(request.getParameter("type"));
    String indexId=request.getParameter("indexId");
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

    if(sd==null){
        out.println("sd = null");
        return;
    }
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
        s.setUserId(-1);  // -1 means 自行登入
        s.setType(type);
        s.setNote(note);
        s.setSchdefId(sdId);
        s.setRestMins(restMins);
        s.setStatus(SchEvent.STATUS_PERSON_PENDDING);
%>
<div class=es02>
    &nbsp;&nbsp;&nbsp;<b><%=membr.getName()%></b>&nbsp;&nbsp;  線上請假 | 
    <a href="searchEvent.jsp?mid=<%=targetId%>&indexId=<%=indexId%>">缺勤/請假紀錄</a>
    |
    <a href="searchCard.jsp?mid=<%=targetId%>&indexId=<%=indexId%>">刷卡紀錄</a>
    | <a href="searchYearHoliday.jsp?mid=<%=targetId%>&indexId=<%=indexId%>">年假查詢</a>

</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>


<%        
        if(SchEvent.createEvent(s)){
%>
    <blockquote>
        <div class=es02><b>登入成功!</b>
        <br>
        <br>
           由於為線上請假,需由<font color=blue>主管覆核後正式生效</font>.
        <br>
        <br>
            <a href="loginEvent2.jsp?indexId=<%=indexId%>"><img src="pic/last2.png" border=0>&nbsp;繼續登入</a>
        </div>
    </blockquote>
<%
        }else{
%>
        <blockquote>
            <div class=es02>新增失敗!<br><br>可能沒有多餘的年假.</div>
            <br>
            <br>
            <a href="loginEvent2.jsp?indexId=<%=indexId%>"><img src="pic/last2.png" border=0>&nbsp;重新登入</a>
            </div>
        </blockquote>
<%
        }
    }else{
%>
    <blockquote>
        <div class=es02>新增失敗!<br><br>與現有的缺勤/請假重疊.
            <br>
            <br>
            <a href="loginEvent2.jsp?indexId=<%=indexId%>"><img src="pic/last2.png" border=0>&nbsp;重新登入</a>
            </div>
    </blockquote>
<%  
    }   
%>




