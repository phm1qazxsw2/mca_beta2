<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm");
    SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy/MM/dd");
    int otId = Integer.parseInt(request.getParameter("otId"));


    OvertimeMgr om=OvertimeMgr.getInstance();
    Overtime ot=om.find("id='"+otId+"'");

    if(ot==null){
%>
        <blockquote>
            <div class=es02>
                沒有此筆資料.
            </div>
        </blockquote>
<%
        return;
    }

    String sdate=request.getParameter("startTime");
    String d1=sdate+" "+request.getParameter("d1").trim();
    String d2=sdate+" "+request.getParameter("d2").trim();      
    String ps = request.getParameter("ps");

    Date startTime = sdf.parse(d1);
    Date endTime = sdf.parse(d2);    

    int status = Integer.parseInt(request.getParameter("status"));
    int xtimex = Integer.parseInt(request.getParameter("xtime"));
    int confirmType = Integer.parseInt(request.getParameter("confirmType"));

    String confirmPs = request.getParameter("confirmPs");

    long restmins=((long)endTime.getTime()-(long)startTime.getTime())/(long)(1000*60);

    float xtime=(float)1.0;

    if(xtimex==1)
        xtime=(float)1.2;
    else if(xtimex==2)   
        xtime=(float)1.5;                         
    int confirmMins=(int)((float)restmins*xtime);
    
    ot.setStartDate   	(startTime);
    ot.setEndDate   	(endTime);
    ot.setMins   	((int)restmins);
    ot.setPs   	(ps);
    ot.setStatus   	(status);
    ot.setTimes(xtimex);
    ot.setConfirmType   	(confirmType);

    if(status==1)  //正式加班
        ot.setConfirmMins   	(confirmMins);
    ot.setConfirmPs   	(confirmPs);
    ot.setUserId   	(ud2.getId());
    om.save(ot);

                    //正式  & 補休時數
    if(status==1 && confirmType==0){ 

        int yearHolidayId = Integer.parseInt(request.getParameter("yearHolidayId"));
        YearMembrMgr ymm=YearMembrMgr.getInstance();
        ArrayList<YearMembr> ymA=ymm.retrieveList("membrId='"+ot.getMembrId()+"'","order by id desc");

        YearMembr ym=new YearMembr();
        if(ymA==null || ymA.size()<=0){

            ym.setCreated   	(new Date());
            ym.setMembrId   	(ot.getMembrId());
            ym.setYearHolidayId   	(yearHolidayId);
            ym.setMins   	(0);
            ym.setOvertime   	(confirmMins);
            ym.setUserId(ud2.getId());   
            ymm.create(ym);
        }else{
            ym=ymA.get(0);
            int oldOvertime=ym.getOvertime();
            ym.setOvertime(oldOvertime+confirmMins);
            ymm.save(ym);
        }
    }

%>
<div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>
&nbsp;覆核加班</b>
</div>
<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>


<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<blockquote>
    <div class=es02>
    <%
        if(status==1){
    %>
        覆核成功.
    <%  }else{  %>
        成功修改加班內容.

    <%  }   %>
    <br>
    <br>
    </div>
</blockquote>



