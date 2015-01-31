<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,cardreader.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    int seId=Integer.parseInt(request.getParameter("seId"));

    SchEventMgr sem=SchEventMgr.getInstance();
    SchEvent se=sem.find("id="+seId);

    String sTime=request.getParameter("sTime");
    String eTime=request.getParameter("eTime");
    String sDateString=request.getParameter("sDate");
    int status=0; 
    // 全部改為人工確認 Integer.parseInt(request.getParameter("status"));
    try{
        status=Integer.parseInt(request.getParameter("conformStatus"));
    }catch(Exception ex){}    


    int type=Integer.parseInt(request.getParameter("type"));
    SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm");
    SimpleDateFormat sdfx=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
    SimpleDateFormat sdf2=new SimpleDateFormat("yyyy/MM/dd");

    String sDateS=sDateString+" "+sTime;
    String eDateS=sDateString+" "+eTime;
    int restMins=0;
    String restMinsS=request.getParameter("restMins");    

    try{
        restMins=Integer.parseInt(restMinsS);
    }catch(Exception e){}

    Date sDate=sdf.parse(sDateS);
    Date eDate=sdf.parse(eDateS);
    String ps=request.getParameter("ps");

    long sLong=eDate.getTime()-sDate.getTime();
    int mins=(int)(sLong/(1000*60));
    if(restMins !=0)
        mins-=restMins;

    if(mins<0)        
        mins=0;

    int hours=(int)mins/60;
    mins=mins-hours*60;

    Date sdate=sdf2.parse(sDateString);

    Calendar c2=Calendar.getInstance();
    c2.setTime(sdate);
    c2.add(Calendar.DATE,1);
    Date nextDate=c2.getTime();

    ArrayList<SchEvent> schevents = SchEventMgr.getInstance().retrieveList("startTime>='" + sDateString + "' and startTime<'" + sdf2.format(nextDate) + "' and membrId='"+se.getMembrId()+"' and    schdefId='"+se.getSchdefId()+"' and id !="+seId, " order by startTime");

    Vector rVector=new Vector();
    Vector v3=new Vector();
    for(int i=0;i<schevents.size();i++){
        v3.add((SchEvent)schevents.get(i));
    }

    boolean vResult=SchEventInfo.calcOldEvent(sDate,eDate,v3);

    if(vResult){

        //se.setModifyTime(new Date());
        //se.setUserId(ud2.getId());
        //sem.save(se);

        se.setStartTime(sDate);    
        se.setEndTime(eDate);   
        se.setLastingHours(hours);
        se.setLastingMins(mins);
        se.setStatus(status);
        se.setRestMins(restMins);
        se.setType(type);
        se.setVerifyDate(new Date());
        se.setVerifyPs(ps);
        se.setVerifyUserId(ud2.getId());

            
        if(SchEvent.modifyEvent(se)){

            response.sendRedirect("modifySchEvent.jsp?seId="+se.getId()+"&m=1");
        }else{
%>
        <blockquote>
            <div class=es02>修改失敗.
            <br><br>
            年假/補休時數不足或尚未設定.
            <br>
            <a href="modifySchEvent.jsp?seId=<%=se.getId()%>">重新設定</a>
            </div>            
        </blockquote>
<%
        }
    }else{
%>
        <blockquote>
            <div class=es02>修改失敗.
            <br><br>
            與現有的缺勤/請假重疊.
            <br>
            <a href="modifySchEvent.jsp?seId=<%=se.getId()%>">重新設定</a>
            </div>            
        </blockquote>
<%  }   %>

