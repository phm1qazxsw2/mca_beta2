<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,cardreader.*" 
    contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTopNotLogin.jsp"%>
<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>

<script type="text/javascript" src="openWindow.js"></script>
<link rel="stylesheet" href="menu.css" type="text/css">
<link rel="stylesheet" href="style.css" type="text/css">
<link href=ft02.css rel=stylesheet type=text/css>
<link rel="stylesheet" href="css/dhtmlwindow.css" type="text/css" />

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
        sb.append("  <td width=100 align=middle nowrap>刷卡時段</td>");
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
                return "&nbsp;&nbsp;<font color=blue>正式缺勤</font>";
            case SchEvent.STATUS_READER_CONFORM :
                return "&nbsp;&nbsp;<font color=blue>正式缺勤</font>";
            case SchEvent.STATUS_READER_PENDDING:
                return "<img src='images/dotx.gif' border=0>&nbsp;系統產生";
            case SchEvent.STATUS_PERSON_PENDDING:
                return "<img src='images/dotx.gif' border=0>&nbsp;<font color=blue>線上請假</font>";
        }
        return "";
    }
%>
<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf2 = new SimpleDateFormat("MM/dd");
    SimpleDateFormat sdftime = new SimpleDateFormat("HH:mm");
    SimpleDateFormat sdf3 = new SimpleDateFormat("yyyyMMdd");

    String mid=request.getParameter("mid");
    Membr membr = MembrMgr.getInstance().find("id=" +mid );

    Calendar c = Calendar.getInstance();
    c.set(Calendar.DAY_OF_MONTH, 1);

    Date d1 = c.getTime(); //sdf1.parse("2009/01/01");
    Date d2 = new Date();  // sdf1.parse(request.getParameter("d2"));
    
    try { d1 = sdf1.parse(request.getParameter("d1")); } catch (Exception e) {}
    try { d2 = sdf1.parse(request.getParameter("d2")); } catch (Exception e) {}

    c.setTime(d2);
    c.add(Calendar.DATE, 1);
    Date nextEndDay = c.getTime();

    int type=0;
    int status=-1;

    String query="membrId=" + membr.getId() + " and startTime>='" + sdf.format(d1) +"' and startTime<'" + sdf.format(nextEndDay) + "'";


    ArrayList<SchEvent> schevents = SchEventMgr.getInstance().
        retrieveList(query, "order by startTime asc");

    String queryString = request.getQueryString();

        // 今天有沒有註記紀錄
    ArrayList<Entryps> pss = EntrypsMgr.getInstance().
        retrieveList("created>='" + sdf.format(d1) + "' and created<'" + sdf.format(nextEndDay) + "' and membrId='"+mid+"'", " order by created");
    Map<String, Entryps> pssMap = new SortingMap(pss).doSortSingleton("getCreatedString");



    //出勤data
    ArrayList<Entry> entries = null;
    Map<String, Vector<Entry>> entryMap = null;
    EntryMgr emgr = EntryMgr.getInstance();
    emgr.setDataSourceName("card");
    String readerId=SchEventInfo.getMachineId();
    
    entries = emgr.retrieveList("created>='" + sdf.format(d1) + "' and created<'" + 
        sdf.format(nextEndDay)+"' "+readerId, " order by created asc");
    entryMap = new SortingMap(entries).doSort("getDateCard");

    Hashtable<String,String> ha=CardMembr.getCardDate(d1,d2,membr);
    String indexId=request.getParameter("indexId");
%>

<div class=es02>
    &nbsp;&nbsp;&nbsp;<b><%=membr.getName()%></b>&nbsp;&nbsp;  <a href="loginEvent2.jsp?indexId=<%=indexId%>">線上請假</a> |
    <a href="loginOvertime.jsp?mid=<%=mid%>&indexId=<%=indexId%>">加班登記</a> | 
    缺勤/請假紀錄
    |
    <a href="searchCard.jsp?mid=<%=mid%>&indexId=<%=indexId%>">刷卡紀錄</a>
    | <a href="searchYearHoliday.jsp?mid=<%=mid%>&indexId=<%=indexId%>">年假/補休查詢</a>
    | <a href="loginTeacherEmail.jsp?mid=<%=mid%>&indexId=<%=indexId%>">刷卡Email</a>
    &nbsp;　　　　<a href="javascript:parent.sch_qa(1);">Q&A</a>
</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  
<div class=es02>
    <blockquote>
        <form action="searchEvent.jsp" name='f1' id='f1' method="post" onsubmit="return doSubmit(this)">
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>缺勤/請假紀錄</b>&nbsp;&nbsp;
        <a href="#" onclick="displayCalendar(document.f1.d1,'yyyy/mm/dd',this);return false">起始日期:</a><input type=text name="d1" value="<%=sdf1.format(d1)%>" size=8> &nbsp;&nbsp;
        <a href="#" onclick="displayCalendar(document.f1.d2,'yyyy/mm/dd',this);return false">至:</a><input type=text name="d2" value="<%=sdf1.format(d2)%>" size=8>

        <input type=hidden name="indexId" value="<%=indexId%>">        
        <input type=hidden name="mid" value="<%=mid%>">
        <input type=submit value="查詢">
        </form>
    </blockquote>
</div>


<center>
<%
    if(schevents==null || schevents.size()<=0)
    {
%>
        <div class=es02>
            本區間沒有缺勤請假資料.
        </div>
<%
        return;
    }
%>
<div class=es02 align=left>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src='images/dotx.gif' border=0>&nbsp;為尚未確認的請假或缺勤.
</div>
<form name='f2' id='f2' method="post">
<table width="95%" border="0" cellpadding="0" cellspacing="0">
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

        if(sd ==null)
            continue;
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
            <a href="#" onclick="displayCalendar(document.f2.eid<%=e.getId()%>,'yyyy/mm/dd',this);return false"><img src="pic/blog4.gif" border=0></a>
        <%
        String newdatestring=sdf3.format(startDate);
        Entryps ep=pssMap.get(newdatestring);
    
        if(ep !=null){
        %>
            <br>
            註記: <%=ep.getPs()%>&nbsp;
<a href="#" onClick="javascript:openwindow_phm('addEntryps_m.jsp?membrId=<%=mid%>&d=<%=newdatestring%>', '註記', 400, 300, 'addevent');return false">編輯</a>
        <%  }else{   %>
            <br>
            <a href="#" onClick="javascript:openwindow_phm('addEntryps_m.jsp?membrId=<%=mid%>&d=<%=newdatestring%>', '註記', 400, 300, 'addevent');return false">新增註記</a>
        <%  }   %>
        </td>
        <td class=es02 align=middle nowrap valign=bottom><%=sdftime.format(e.getStartTime())%>-<%=sdftime.format(e.getEndTime())%></td>
        <%
        int lastingHours=e.getLastingHours();
        int lastingMins=e.getLastingMins();
        if(e.getType() <110){
            totalHour+=lastingHours;
            totalMins+=lastingMins;            
        }
        %>
        <td class=es02 align=right nowrap valign=bottom><%=(lastingHours>0 &&e.getType() <110)?lastingHours+" 時":""%><%=(lastingMins>0)?lastingMins+" 分":""%></td>
        <td class=es02 valign=bottom align=middle>
        <%
        if(ha !=null){
            String cardidX=ha.get(sdf1.format(e.getStartTime()));
            if(cardidX !=null){

                Vector<Entry> vEntry=entryMap.get(sdf1.format(e.getStartTime())+cardidX);

                if(vEntry !=null && vEntry.size()>=2){
                    Entry en1=vEntry.get(0);
                    Entry en2=vEntry.get(vEntry.size()-1);
        %>
                    <%=sdftime.format(en1.getCreated())%>-<%=sdftime.format(en2.getCreated())%>
        <%
                }else if(vEntry==null || vEntry.size()==0){
        %>                                        
                    沒有刷卡紀錄                                                  
        <%
                }else{
        %>
                    刷卡異常: <%=(vEntry.get(0)!=null)?sdftime.format(vEntry.get(0).getCreated()):""%> 
        <%
                }
            }
        }
        %>
        </td>

        <td class=es02 align=center nowrap valign=bottom>
            <%=(e.getVerifyPs()==null)?"":e.getVerifyPs()+"<br>"%>
            <%
            int userid=e.getVerifyUserId();
            if(userid==0){
                out.println("<font color=blue>尚未覆核</font>");
            }else{

                switch(e.getStatus()){
                    case SchEvent.STATUS_PERSON_CONFORM :
                    case SchEvent.STATUS_READER_CONFORM :
                        out.println("已確認 - ");
                        break;
                    case SchEvent.STATUS_READER_PENDDING:
                    case SchEvent.STATUS_PERSON_PENDDING:
                        out.println("<font color=blue>尚未確認</font> - ");
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
%>    
    <tr class=es02>
        <td align=middle>
        </td>
        <td colspan=3 align=middle>小 計</td>
        <td align=right colspan=2>
        <%
        int xmins=totalMins/60;
        totalMins=totalMins%60;
        totalHour=totalHour+xmins;
        %>
        <b><%=(totalHour!=0)?totalHour+" 小時 ":""%><%=(totalMins!=0)?totalMins+" 分":""%></b>
        </td>
        <td colspan=3></tD>
    </tr>
    </table> 
</td>
</tr>
</table>
</form>
</center>
<br>
<br>


