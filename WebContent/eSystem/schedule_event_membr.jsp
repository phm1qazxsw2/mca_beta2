<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,cardreader.*" 
    contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
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
        sb.append("  <td width=70 align=middle></td>");
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
    Membr membr = MembrMgr.getInstance().find("id=" + request.getParameter("mid"));
    Date d1 = sdf1.parse(request.getParameter("d1"));
    Date d2 = sdf1.parse(request.getParameter("d2"));
    
    Calendar c = Calendar.getInstance();
    c.setTime(d2);
    c.add(Calendar.DATE, 1);
    Date nextEndDay = c.getTime();

    int type=0;
    int status=-1;
    String typeS=request.getParameter("type");
    String statusS=request.getParameter("stutus");
    if(typeS !=null)
        type=Integer.parseInt(typeS);
    if(statusS !=null)
        status=Integer.parseInt(statusS);

    String query="membrId=" + membr.getId() + " and startTime>='" + sdf.format(d1) +"' and startTime<'" + sdf.format(nextEndDay) + "'";

    if(status ==1)  //pending
        query +=" and status >='2' ";
    else if(status ==2)   //不計薪
        query +=" and status < '2' and (type='2' or type='6' or type='5' or type='7' or type='110' or type='111' or type='112' or type='113')";
    else if(status ==3)  //其他正式假
        query +=" and status < '2' and type!='2' and type!='6' and type!='5' and type!='7'";


/*
    if(status==SchEvent.STATUS_PERSON_CONFORM || status==SchEvent.STATUS_READER_CONFORM)
        query+=" and (status ="+SchEvent.STATUS_PERSON_CONFORM + " or status ="+SchEvent.STATUS_READER_CONFORM +" )" ;
    else if(status !=-1)            
        query+=" and status ="+status;
*/


    ArrayList<SchEvent> schevents = SchEventMgr.getInstance().
        retrieveList(query, "order by startTime asc");

    String queryString = request.getQueryString();

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
%>
<div class=es02>
&nbsp;&nbsp;&nbsp;&nbsp;<b><%=membr.getName()%> <%=sdf.format(d1)%>&nbsp;至&nbsp;<%=sdf.format(d2)%> 缺勤紀錄</b>
</div>

<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>


<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  

<blockquote>
<form action="confirmEventStatus.jsp" method="post" name="f1" id="f1">
<table height="" border="0" cellpadding="0" cellspacing="0">
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
            if(e.getStatus() ==SchEvent.STATUS_READER_PENDDING || e.getStatus() ==SchEvent.STATUS_PERSON_PENDDING){
                showButtom=true;
        %>
                <input type="checkbox" name="eId" value="<%=e.getId()%>">
        <%  }   %>
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
                    case SchEvent.TYPE_OVERTIME:
                        bgcolorX=" bgcolor='#99CCFF'";
                        break;
                    case SchEvent.TYPE_OTHER:
                        bgcolorX=" bgcolor='#99CCFF'";
                        break;
                    case Holiday.TYPE_HOLIDAY_OFFICE:
                        bgcolorX=" bgcolor='#99CCFF'";
                        break;
                    case Holiday.TYPE_HOLIDAY_WEATHER:
                        bgcolorX=" bgcolor='#99CCFF'";
                        break;
                    case Holiday.TYPE_HOLIDAY_COMPANY:
                        bgcolorX=" bgcolor='#99CCFF'";
                        break;
                    case Holiday.TYPE_HOLIDAY_OTHER:
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
                }else if(vEntry==null || vEntry.size()<=0){
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
            
            <%=(e.getVerifyPs()==null)?"":e.getVerifyPs()+"-<br>"%>
            <%
            int userid=e.getVerifyUserId();
            if(userid==0){
                out.println("");
            }else{
                User u=(User)um.find(userid);
                if(u !=null)
                    out.println(u.getUserFullname());
            }
            %>
        </td>
        <td class=es02 align=center nowrap valign=bottom>
            <a href="#" onClick="javascript:openwindow_phm('modifySchEvent.jsp?seId=<%=e.getId()%>', '修改出缺勤', 500, 420, 'addevent');return false">修改</a>
        </td>
    </tr>	
<%
    }
%>    
    <tr class=es02>
        <td align=middle>
            <%
            if(showButtom){
            %>                
                <input type=hidden name="queryString" value="<%=queryString%>">
                <input type=submit value="覆核"></td>
            <%  }else{   %>
            </td>
            <%  }   %>
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
</blockquote>
