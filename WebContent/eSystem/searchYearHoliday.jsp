<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,cardreader.*" 
    contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTopNotLogin.jsp"%>
<%!
    String getTableHeader() 
    {
        StringBuffer sb = new StringBuffer();

        sb.append("<tr bgcolor=#f0f0f0 class=es02>");
        sb.append("  <td width=40 align=middle>狀態</td>");
        sb.append("  <td width=70 align=middle>類型</td>");
        sb.append("  <td width=40 align=middle>班表</td>");
        sb.append("  <td width=70 align=middle>日期</td>");
        sb.append("  <td width=100 align=middle nowrap>缺勤時段</td>");
        sb.append("  <td width=70 align=middle>缺勤時間</td>");
        sb.append("  <td width=70 align=middle>覆核人</td>");
        sb.append("</tr>");
        return sb.toString();
    }

    String getDay(SchEvent e)
    {
        int d = e.getEndTime().getDate()-e.getStartTime().getDate();
        if (d==0) return "";
        if (d==1) return "隔天";
        return e.getEndTime().getDate()+"號";
    }

    String printStatus(int status){

        switch(status){
            case SchEvent.STATUS_PERSON_CONFORM :
                return "&nbsp;&nbsp;正式缺勤";
            case SchEvent.STATUS_READER_CONFORM :
                return "&nbsp;&nbsp;正式缺勤";
            case SchEvent.STATUS_READER_PENDDING:
                return "<img src='images/dotx.gif' border=0>&nbsp;系統產生";
            case SchEvent.STATUS_PERSON_PENDDING:
                return "<img src='images/dotx.gif' border=0>&nbsp;線上請假";
        }
        return "";
    }
%>
<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf2 = new SimpleDateFormat("MM/dd");
    SimpleDateFormat sdftime = new SimpleDateFormat("HH:mm");

    String mid=request.getParameter("mid");
    Membr membr = MembrMgr.getInstance().find("id=" +mid );


    String indexId=request.getParameter("indexId");
%>

<div class=es02>
    &nbsp;&nbsp;&nbsp;<b><%=membr.getName()%></b>&nbsp;&nbsp;  <a href="loginEvent2.jsp?indexId=<%=indexId%>">線上請假</a> | 
        <a href="loginOvertime.jsp?mid=<%=mid%>&indexId=<%=indexId%>">加班登記</a> |
        <a href="searchEvent.jsp?mid=<%=mid%>&indexId=<%=indexId%>">缺勤/請假紀錄</a>
    |
    <a href="searchCard.jsp?mid=<%=mid%>&indexId=<%=indexId%>">刷卡紀錄</a>
    | 年假/補休查詢 | <a href="loginTeacherEmail.jsp?mid=<%=mid%>&indexId=<%=indexId%>">刷卡Email</a>
    &nbsp;　　　　<a href="javascript:parent.sch_qa(1);">Q&A</a>
</div>

<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>


<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<%
    YearHolidayMgr yhm=YearHolidayMgr.getInstance();
    ArrayList<YearHoliday> yh=yhm.retrieveList("","order by id desc");

    if(yh ==null || yh.size()<=0){
%>
        <br>
        <br>
        <blockquote>
            <div class=es02>
                系統尚未設定年假.
            </div>            
        </blockquote>
<%
        return;
    }

    YearHoliday yhh=yh.get(0);

    YearMembrMgr ymm=YearMembrMgr.getInstance();
    ArrayList<YearMembr> aym=ymm.retrieveList("yearHolidayId='"+yhh.getId()+"'","");
    Map<Integer, YearMembr> ykMap = new SortingMap(aym).doSortSingleton("getMembrId");

    YearMembr ym=ykMap.get(new Integer(membr.getId()));

    if(ym ==null){
%>
        <br>
        <br>
        <blockquote>
            <div class=es02>
                管理者尚未登入你的年假.
            </div>            
        </blockquote>
<%      
        return;
    }

    float hours=(float)ym.getMins()/(float)60;

    float ov=(float)ym.getOvertime()/(float)60;

%>
    <br>
    <br>
    <blockquote>
    <div class=es02>
        <b><%=yhh.getName()%>可休假時數</b>(已覆核的正式時數):<br><br>


    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;年假時數為:&nbsp;<font color=blue><%=hours%>小時</font> ;   補休時數為: <font color=blue><%=ov%>小時</font>
    </div>
    <br>

<%
    Calendar c=Calendar.getInstance();
    c.setTime(yhh.getEndDate());
    c.add(Calendar.DATE,1);    
    Date nextEndDay=c.getTime();

    ArrayList<SchEvent> schevents = SchEventMgr.getInstance().retrieveList("startTime>='" + sdf1.format(yhh.getStartDate()) + "' and startTime<'" + sdf1.format(nextEndDay) + "' and membrId='"+mid+"' and (type='"+SchEvent.TYPE_YEAR+"' or type='"+SchEvent.TYPE_OVERTIME+"')", "");

    if(schevents ==null || schevents.size()<=0){
%>
    <div class=es02>        
        目前尚未使用任何年假/補休.
    </div>
    </blockquote>
<%
        return;
    }
%>
    <br>
    <div class=es02>
    <b>已使用的年假/補休:</b><br>
    </div>
<blockquote>
<form action="searchEvent.jsp" name='f1' id='f1' method="post">
    <table border="0" cellpadding="0" cellspacing="0">
    <tr align=left valign=top>
    <td bgcolor="#e9e3de">
        <table width="100%" border=0 cellpadding=4 cellspacing=1>
    
        <%=getTableHeader()%>
    <%
    int totalHour=0;
    int totalMins=0;
    boolean showButtom=false;
    UserMgr um=UserMgr.getInstance();        
    SchDefMgr sdm=SchDefMgr.getInstance();

    Iterator<SchEvent> iter = schevents.iterator();
    while (iter.hasNext()) {

            SchEvent e = iter.next();
            SchDef sd=sdm.find("id="+e.getSchdefId());
    %>
   <tr bgcolor=#ffffff  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
        <td class=es02 align=left nowrap valign=bottom>
            <%=printStatus(e.getStatus())%> 
        <%
            String bgcolorX="";

            if(e.getStatus()<2){
                bgcolorX=" bgcolor='#ffff66'";
                switch(e.getType()){
                    case SchEvent.TYPE_BUSINESS: 
                        bgcolorX=" bgcolor='#99CCFF'";
                        break;
                    case SchEvent.TYPE_YEAR:
                        bgcolorX=" bgcolor='#99CCFF'";
                    case SchEvent.TYPE_OVERTIME:
                        bgcolorX=" bgcolor='#99CCFF'";
                        break;
                }
            }
        %>
        </td>
        <td class=es02 align=middle nowrap valign=bottom <%=bgcolorX%>>
            <%=SchEvent.getChinsesType(e.getType())%>
        </td>
        <td class=es02 align=left nowrap valign=bottom>        
            <%=sd.getName()%>
        </td>
        <td class=es02 align=left nowrap valign=bottom>
            <%  
                Date startDate=e.getStartTime();
                out.println(sdf2.format(startDate));
                out.println("("+SchInfo.printDayOfWeek(startDate.getDay()+1)+")");
            %>
            <input type=hidden name="eid<%=e.getId()%>" value="<%=sdf1.format(e.getStartTime())%>">
            <a href="#" onclick="displayCalendar(document.f1.eid<%=e.getId()%>,'yyyy/mm/dd',this);return false"><img src="pic/blog4.gif" border=0></a>
        </td>
        <td class=es02 align=middle nowrap valign=bottom><%=sdftime.format(e.getStartTime())%>-<%=sdftime.format(e.getEndTime())%></td>
        <%
        int lastingHours=e.getLastingHours();
        int lastingMins=e.getLastingMins();

        totalMins+=(lastingHours*60)+lastingMins;       
        %>
        <td class=es02 align=right nowrap valign=bottom><%=(lastingHours>0 &&e.getType() <110)?lastingHours+" 時":""%><%=(lastingMins>0)?lastingMins+" 分":""%></td>
        <td class=es02 align=center nowrap valign=bottom>
            <%
            int userid=e.getVerifyUserId();
            if(userid==0){
                out.println("尚未覆核");
            }else{

                switch(e.getStatus()){
                    case SchEvent.STATUS_PERSON_CONFORM :
                    case SchEvent.STATUS_READER_CONFORM :
                        out.println("已確認 - ");
                        break;
                    case SchEvent.STATUS_READER_PENDDING:
                    case SchEvent.STATUS_PERSON_PENDDING:
                        out.println("尚未確認 - ");
                        break;
                }
                User u=(User)um.find(userid);
                if(u !=null)
                    out.println(u.getUserFullname());
            }
            %>
        </td>
    </tr>
    <%  
        }   
        int xhour=totalMins/60;
        int xmin=totalMins%60;
    %>
    <tr class=es02>
        <td colspan=5 align=middle>已請年假/補休小計:</td>
        <td colspan=2><b><%=(xhour>0)?xhour+"小時":""%><%=(xmin>0)?xmin+"分鐘":""%></b></td>
    </tr>
    </table>
    </td>
    </tr>
    </table>
</blockquote>
</form>

    <br>
    <div class=es02>
<%
    int restmins=(ym.getMins()+ym.getOvertime())-totalMins;

    int xhour2=restmins/60;
    int xmin2=restmins%60;

    float restHour=(float)restmins/(float)60;
%>

    <b>剩餘年假/補休時數: <font color=blue><%=restHour%></font>小時</b>
    <br>
    <br>
    </div>