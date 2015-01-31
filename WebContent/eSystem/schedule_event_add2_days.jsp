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

    String d1=request.getParameter("d1").trim();
    String d2=request.getParameter("d2").trim();                


    int sdId=0;

    String[] boundaryTime=request.getParameterValues("boundaryTime");    
    StringBuffer sb=new StringBuffer();

    if(boundaryTime!=null){

        for(int i=0;i<boundaryTime.length;i++){

            int restMins=0;

            String[] sdidXX=boundaryTime[i].split("#");                               
            sdId=Integer.parseInt(sdidXX[0]);
            Date nowDate=sdf2.parse(sdidXX[1]);
            Date startTime = sdf.parse(sdidXX[1]+" "+d1);
            Date endTime = sdf.parse(sdidXX[1]+" "+d2);    

            Calendar c2=Calendar.getInstance();
            c2.setTime(nowDate);
            c2.add(Calendar.DATE,1);
            Date nextDate=c2.getTime();

            ArrayList<SchEvent> schevents = SchEventMgr.getInstance().retrieveList("startTime>='" + sdidXX[1] + "' and startTime<'" + sdf2.format(nextDate) + "' and membrId='"+targetId+"' and schdefId='"+sdId+"'", " order by startTime");

            Vector rVector=new Vector();
            Vector v3=new Vector();
            for(int j=0;j<schevents.size();j++){
                v3.add((SchEvent)schevents.get(j));
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
                Membr membr = MembrMgr.getInstance().find("id=" + targetId);
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
                s.setUserId(ud2.getId());
                s.setType(type);
                s.setNote(note);
                s.setSchdefId(sdId);
                s.setRestMins(restMins);

                SchEvent.createEvent(s);

                sb.append("<font color=blue>"+sd.getName()+"</font>: "+sdf.format(startTime)+"-"+sdf.format(endTime)+" 新增成功.<br>");
            }else{
                sb.append("<font color=red>"+sd.getName()+"</font>: "+sdf.format(startTime)+"-"+sdf.format(endTime)+" 新增失敗.<br>");
            }
        }
%>
    <blockquote>
        <div class=es02>新增結果:<br>
            <blockquote>
                <%=sb.toString()%>
            </blockquote>
    </blockquote>


<%
    }else{
%>
    <blockquote>
        <div class=es02>新增失敗!<br><br>沒有選擇班表.</div>
    </blockquote>
<%      
    }
%>
<script>
  parent.do_reload = true;
</script>