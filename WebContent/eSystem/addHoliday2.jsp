<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    int id = Integer.parseInt(request.getParameter("id"));
    int type = Integer.parseInt(request.getParameter("type"));    
    String startTime=request.getParameter("startTime");
    String endDate=request.getParameter("endTime");
    String content=request.getParameter("days");

    String[] days=content.split("\n");
    SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm");
    SimpleDateFormat sdf2=new SimpleDateFormat("yyyy/MM/dd");

    HolidayMgr hm=HolidayMgr.getInstance();
%>
    <blockquote>
        <div class=es02>

<%
    Vector<Integer> v=new Vector();
    for(int i=0;days!=null && i<days.length ;i++){

        String[] hInfo=days[i].split("#");
        String dateString1=hInfo[0]+" "+startTime;
        String dateString2=hInfo[0]+" "+endDate;
        Date startDay=sdf.parse(dateString1);        
        Date endDay=sdf.parse(dateString2);
        Holiday h=new Holiday();



        h.setCreated   	(new Date());
        h.setType   	(type);
        h.setName   	(hInfo[1]);
        h.setStartTime   	(startDay);
        h.setEndTime   	(endDay);
        h.setUserId   	(ud2.getId());
        
        //1. 判斷目前的假日有沒有衝到
        //2. 判斷目前的event要不要調整
        Date rundate=sdf2.parse(hInfo[0]);
        Calendar d=Calendar.getInstance();
        d.setTime(rundate);
        d.add(Calendar.DATE,1);
        Date nextDay=d.getTime();
        

        boolean conflictTime=false;
        ArrayList<Holiday> ah=hm.retrieveList("startTime <='"+sdf2.format(rundate)+"' and startTime <'"+sdf2.format(nextDay)+"'","");

        for(int j=0;ah!=null &&j<ah.size();j++){

            Holiday h2=ah.get(j);

            if(!Holiday.isnotConflictTime(startDay,endDay,h2.getStartTime(),h2.getEndTime()))
            {
                conflictTime=true;
                v.add(new Integer(h2.getId()));
            }
        }

        if(!conflictTime){
            hm.create(h);
            Vector v2=Holiday.runEvent(h);
%>
                <b><%=h.getName()%></b>:&nbsp;新增成功.<br><br>

<%
        }else{
%>
                <font color=red><b><%=h.getName()%></b></font>:&nbsp;與別的假期時間衝突,新增失敗.<br><br>
<% 
       }
    }
%>
    </div>
    </blockquote>