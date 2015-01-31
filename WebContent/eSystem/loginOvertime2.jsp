<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTopNotLogin.jsp"%>
<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm");
    SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy/MM/dd");

    int targetId = Integer.parseInt(request.getParameter("target"));
    String indexId=request.getParameter("indexId");

    Membr membr = MembrMgr.getInstance().find("id=" + targetId);

    String sdate=request.getParameter("startTime");
    String d1=sdate+" "+request.getParameter("d1").trim();
    String d2=sdate+" "+request.getParameter("d2").trim();      
    String ps = request.getParameter("ps");

    Date startTime = sdf.parse(d1);
    Date endTime = sdf.parse(d2);    

    int confirmType = Integer.parseInt(request.getParameter("confirmType"));
    int xtimex = Integer.parseInt(request.getParameter("xtime"));


    long restmins=((long)endTime.getTime()-(long)startTime.getTime())/(long)(1000*60);

    OvertimeMgr om=OvertimeMgr.getInstance();
    Overtime ot=new Overtime();
    ot.setCreated   	(new Date());
    ot.setMembrId   	(targetId);
    ot.setStartDate   	(startTime);
    ot.setEndDate   	(endTime);
    ot.setMins   	((int)restmins);
    ot.setPs   	(ps);
    ot.setEditUser(0);
    ot.setStatus   	(Overtime.STATUS_ONLINE);
    ot.setTimes(xtimex);
    ot.setConfirmType   	(confirmType);
   
    om.create(ot);

%>
<div class=es02>
    &nbsp;&nbsp;&nbsp;<b><%=membr.getName()%></b>&nbsp;&nbsp;  
    <a href="loginEvent2.jsp?indexId=<%=indexId%>">線上請假</a> | 加班登記 |
    <a href="searchEvent.jsp?mid=<%=targetId%>&indexId=<%=indexId%>">缺勤/請假紀錄</a> |
    <a href="searchCard.jsp?mid=<%=targetId%>&indexId=<%=indexId%>">刷卡紀錄</a>
    | <a href="searchYearHoliday.jsp?mid=<%=targetId%>&indexId=<%=indexId%>">年假/補休查詢</a>
    | <a href="loginTeacherEmail.jsp?mid=<%=targetId%>&indexId=<%=indexId%>">刷卡Email</a>
    &nbsp;　　　　<a href="javascript:parent.sch_qa(1);">Q&A</a>
</div>


<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

    <blockquote>
        <div class=es02><b>登入成功!</b>
        <br>
        <br>
           由於為線上請假,需由<font color=blue>主管覆核後正式生效</font>.
        <br>
        <br>
        <a href="searchYearHoliday.jsp?indexId=<%=indexId%>&mid=<%=targetId%>&m=1">年假/補休查詢</a>
