<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,cardreader.*" 
    contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%!
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf2 = new SimpleDateFormat("MM/dd");
    SimpleDateFormat sdftime = new SimpleDateFormat("HH:mm");
    String getTableHeaderInfo(ArrayList<SchDef> schdefs)
    {
        StringBuffer sb = new StringBuffer();
        sb.append("<tr bgcolor=#f0f0f0 class=es02>");
        sb.append("<td align=middle>&nbsp;日期 /班表</td>");
        for(int i=0;i<schdefs.size();i++){
            SchDef sd=schdefs.get(i);
            sb.append("<td align=middle nowrap><b>"+sd.getName()+"</b></td>");
        }
        sb.append("</tr>");
        return sb.toString();
    }

    String getTableHeaderInfo2(Map<Integer, Vector<SchDef>> schdefRootMap)
    {
        StringBuffer sb = new StringBuffer();
        sb.append("<tr bgcolor=#f0f0f0 class=es02>");
        sb.append("<td align=middle>&nbsp;教職員 <br>&nbsp;&nbsp;\\班別</td>");

        Iterator<Integer> iter = schdefRootMap.keySet().iterator();
        while (iter.hasNext()) {

//        for(int i=0;i<schdefs.size();i++){
            Integer defIn=iter.next();
            Vector<SchDef> sdv = schdefRootMap.get(defIn);
            //SchDef sd=schdefs.get(i);
            if(sdv !=null){
                SchDef sd=sdv.get(0);
                sb.append("<td align=middle nowrap><b>"+sd.getName()+"</b><br>"+(sd.getAutoRun()==1?"(缺勤主動比對)":"(缺勤人工登入)")+"</td>");
            }
        }
        sb.append("</tr>");
        return sb.toString();
    }

    String printHrMin(int min)
    {
        if (min==0) return " 0 分";
        if (min<60)
            return min+" 分";

        int hr = 0;
        hr = min/60;
        min = min%60;
        StringBuffer sb = new StringBuffer();
        
        sb.append(hr+" 時");
        if(min !=0)
            sb.append(min+" 分");
        return sb.toString();
    }

    int countEvent(Vector<SchEvent> event){
        
        if(event ==null || event.size()<0)
            return 0;

        int total=0;
        for(int i=0;i<event.size();i++){
            SchEvent se=event.get(i);
            total+=(se.getLastingHours()*60)+se.getLastingMins();
        }
        return total;
    }

    String switchType(int type){

        switch(type){
            case SchEvent.TYPE_PERSONAL:
                return "<font color=blue>事假:</font>";                
            case SchEvent.TYPE_BUSINESS:
                return "<font color=blue>公假:</font>";                
            case SchEvent.TYPE_SICK:
                return "<font color=blue>病假:</font>";                
            case SchEvent.TYPE_OTHER:
                return "<font color=blue>其他假:</font>";                
            case SchEvent.TYPE_AB_START:
                return "<font color=blue>遲到:</font>";  
            case SchEvent.TYPE_AB_ENDING:
                return "<font color=blue>早退:</font>";   
            case SchEvent.TYPE_NO_APPEAR:
                return "<font color=blue>未出席:</font>";               
            case Holiday.TYPE_HOLIDAY_OFFICE:
                return "<font color=blue>國定假日:</font>";               
            case Holiday.TYPE_HOLIDAY_WEATHER:
                return "<font color=blue>颱風假:</font>";               
            case Holiday.TYPE_HOLIDAY_COMPANY:
                return "<font color=blue>員工旅行:</font>";               
            case Holiday.TYPE_HOLIDAY_OTHER:
                return "<font color=blue>其他:</font>";               
            default:
                return "";
        }
    }
%>
<%
    int topMenu=6;
    int leftMenu=3;
%>
<%@ include file="topMenuAdvanced.jsp"%>
<%
    //int type = -1;
    //try { type = Integer.parseInt(request.getParameter("type")); } catch (Exception e) {}
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdfday = new SimpleDateFormat("MM/dd");
    SimpleDateFormat sdftime = new SimpleDateFormat("HH:mm");
    SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat sdf2 = new SimpleDateFormat("yyyyMMdd");
    Calendar c = Calendar.getInstance();
    c.set(Calendar.DAY_OF_MONTH, 1);
    Date d1 = c.getTime();
    c.add(Calendar.MONTH, 1);
    c.add(Calendar.DATE, -1); 
    Date d2 = new Date();
    try { d1 = sdf.parse(request.getParameter("sDate")); } catch (Exception e) {}
    try { d2 = sdf.parse(request.getParameter("eDate")); } catch (Exception e) {}
    c.setTime(d2);
    c.add(Calendar.DATE, 1);
    Date nextEndDay = c.getTime();

    long oneday=(long)(1000*60*60*24);
    long duringLong2=d2.getTime()-d1.getTime();
    if(duringLong2 <0)
        return;

    int duringDate=(int)(duringLong2/oneday);
    duringDate++;


    int bunit=-1;
    String bunitS=request.getParameter("bunit");        
    if(bunitS !=null)
        bunit=Integer.parseInt(bunitS); 

    BunitMgr bm=BunitMgr.getInstance();
    ArrayList<Bunit> b=bm.retrieveListX("status ='1' and flag='0'","", _ws.getBunitSpace("buId"));

    int showType=0;
    String showTypeS=request.getParameter("showType");
    if(showTypeS!=null)
        showType=Integer.parseInt(showTypeS);

    String query2="startTime>='" + sdf1.format(d1) + "' and startTime<'" + sdf1.format(nextEndDay) + "'";

    if(showType ==1)  //pending
        query2 +=" and status >='2' ";
    else if(showType ==2)   //不計薪
        query2 +=" and status < '2' and (type='2' or type='6')";
    else if(showType ==3)  //其他正式假
        query2 +=" and status < '2' and type!='2' and type!='6'";


    ArrayList<SchEvent> schevents = SchEventMgr.getInstance().retrieveList(query2, "");    

    Map<String,Vector<SchEvent>> eventMap=new SortingMap(schevents).doSort("dateSchDef");

    String d1str = java.net.URLEncoder.encode(sdf.format(d1));
    String d2str = java.net.URLEncoder.encode(sdf.format(d2));


    //出勤data
    ArrayList<Entry> entries = null;
    Map<String, Vector<Entry>> entryMap = null;
    EntryMgr emgr = EntryMgr.getInstance();
    emgr.setDataSourceName("card");
    String readerId=SchEventInfo.getMachineId();
    
    entries = emgr.retrieveList("created>='" + sdf.format(d1) + "' and created<'" + 
        sdf.format(nextEndDay)+"' "+readerId, " order by created asc");
    entryMap = new SortingMap(entries).doSort("getDateCard");
%>
<%@ include file="leftMenu6_sch.jsp"%>

<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>
<br>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/event1.png" border=0>&nbsp;缺勤統計</b>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
<%=(showType==0)?"顯示全部":"<a href=\"schedule_detail_excel.jsp?sDate="+d1str+"&eDate="+d2str+"&bunit="+bunit+"&showType=0\">顯示全部</a>"%>
 | <%=(showType==1)?"顯示未確認的缺勤":"<a href=\"schedule_detail_excel.jsp?sDate="+d1str+"&eDate="+d2str+"&bunit="+bunit+"&showType=1\">顯示未確認的缺勤</a>"%>
 | <%=(showType==2)?"顯示不扣薪缺勤":"<a href=\"schedule_detail_excel.jsp?sDate="+d1str+"&eDate="+d2str+"&bunit="+bunit+"&showType=2\">顯示不扣薪缺勤</a>"%>

 | <%=(showType==3)?"顯示正式缺勤":"<a href=\"schedule_detail_excel.jsp?sDate="+d1str+"&eDate="+d2str+"&bunit="+bunit+"&showType=3\">顯示正式缺勤</a>"%>
</div>

<div class=es02>
<form action="schedule_detail_excel.jsp" name='f1' id='f1' method="get" onsubmit="return doSubmit(this)">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href="#" onclick="displayCalendar(document.f1.sDate,'yyyy/mm/dd',this);return false">起始日期:</a><input type=text name="sDate" value="<%=sdf.format(d1)%>" size=8> &nbsp;&nbsp;
<a href="#" onclick="displayCalendar(document.f1.eDate,'yyyy/mm/dd',this);return false">至:</a><input type=text name="eDate" value="<%=sdf.format(d2)%>" size=8>
    &nbsp;&nbsp;
<%
    if(b !=null && b.size()>0){
%>
    部門: <select name="bunit" size=1>
                <option value="-1" <%=(bunit==-1)?"selected":""%>>全部</option>
    <%          
                for(int j=0;j<b.size();j++){    
                    Bunit bb=b.get(j);
    %>
                    <option value="<%=bb.getId()%>" <%=(bunit==bb.getId())?"selected":""%>><%=bb.getLabel()%></option>
    <%          }   %>
                <option value="0" <%=(bunit==0)?"selected":""%>>未定</option>
            </select>
<%
    }else{
%>
        <input type=hidden name="bunit" value="-1">
<%  }   %>
    &nbsp;&nbsp;
    <input type=submit value="查詢">
</form>
</div>
 

<form name="f">
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  

<br>
<div class=es02>
&nbsp;&nbsp;&nbsp;&nbsp;
<a href="javascript:openwindow_phm2('schedule_event_add.jsp?et=1&bunit=<%=bunit%>', '登記缺勤請假', 800, 600, 'addevent');"><img src="pic/addevent2.png" border=0>&nbsp;登記缺勤</a> | <a href="javascript:openwindow_phm2('schedule_event_add.jsp?et=2&bunit=<%=bunit%>', '登記缺勤請假', 800, 600, 'addevent');"><img src="pic/addevent.png" border=0>&nbsp;登記請假</a> | <a href="#" onClick="javascript:openwindow_phm('schedule_detail_excel_output.jsp?sDate=<%=d1str%>&eDate=<%=d2str%>&bunit=<%=bunit%>', '缺勤統計 Excel', 400, 320, 'addevent');return false"><img src="pic/excel2.png" border=0>&nbsp;輸出excel</a>

<%
    if(showType==1){
%>
<br>&nbsp;&nbsp;&nbsp;&nbsp;
    <img src="images/dotx.gif" border=0> &nbsp;將尚未確認(pendding)的缺勤資料
<a href="delete_schedule_daily_reader.jsp?d1=<%=sdf.format(d1)%>&d2=<%=sdf.format(d2)%>&bunit=<%=bunit%>" onClick="return(confirm('確認刪除全部pendding的缺勤資料?'))">全部刪除</a> or 
<a href="confirm_schedule_daily_reader.jsp?d1=<%=sdf.format(d1)%>&d2=<%=sdf.format(d2)%>&bunit=<%=bunit%>"  onClick="return(confirm('確認全部pendding缺勤轉為正式缺勤?'))">全部確認</a>
<%
    }
%>
</div>

<%
    String query="";

    ArrayList<MembrTeacher> all_teachers = MembrTeacherMgr.getInstance().retrieveList(query, "");
    String membrIds = new RangeMaker().makeRange(all_teachers, "getMembrId");
    ArrayList<Membr> membrs = MembrMgr.getInstance().retrieveList("id in (" + membrIds + ")", "");
    Map<Integer, Membr> membrMap = new SortingMap(membrs).doSortSingleton("getId");

    Map<Integer, SchInfo> schinfoMap = SchInfo.getSchInfoForMembrs(membrs, d1, d2);

    ArrayList<SchDef> schdefs = SchInfo.getSchDefsWithin(d1, d2,bunit);
    Map<Integer, Vector<SchDef>> schdefRootMap = new SortingMap(schdefs).doSort("getAllRootId");


    // 處理卡的對應和讀入 membr 打卡的 entry   抓最近的卡片資料
/*
    ArrayList<CardMembr> cards = CardMembrMgr.getInstance().retrieveList("membrId in (" + membrIds + ") and created<'"+sdf.format(nextDay)+"'", " order by created desc");
    Map<Integer, CardMembr> membrcardMap = new SortingMap(cards).doSortSingleton("getMembrId");
*/
%>

<%
    if(schdefs ==null || schdefs.size()<=0){
%>
    <blockquote>
        <div class=es02>
        本期間沒有班表.
        </div>            
    </blockquote>
        <%@ include file="bottom.jsp"%>
<%
        return;
    }
%>
<div class=es02 align=center>
<a href="schedule_event2.jsp?sDate=<%=d1str%>&eDate=<%=d2str%>&bunit=<%=bunit%>&showType=<%=showType%>">依名單排序</a>| 依日期排序
</div>

<blockquote>
    <table height="" border="0" cellpadding="0" cellspacing="0">
    <tr align=left valign=top>
    <td bgcolor="#e9e3de">
        <table width="100%" border=0 cellpadding=4 cellspacing=1>
           <%=getTableHeaderInfo2(schdefRootMap)%>
        <%  
            for(int i=0;i<duringDate;i++)
            {
                Calendar c2=Calendar.getInstance();
                c2.setTime(d1);
                c2.add(Calendar.DATE,i);
                Date rundate=c2.getTime();

                String rx=sdf2.format(rundate);

                if(i>0 && (i%10)==0)
                    out.println(getTableHeaderInfo2(schdefRootMap));
        %>
            <tr class=es02 bgcolor=ffffff>
                <td align=middle>
                <a href="schedule_daily.jsp?d=<%=sdf.format(rundate)%>&bunit=<%=bunit%>">
                    <%=sdf.format(rundate)%></a>(<%=SchInfo.printDayOfWeek(c2.get(Calendar.DAY_OF_WEEK))%>)
                </td>
                
                <%
                for(int j=0;j<schdefs.size();j++){
                %>
                <td>
                <%    
                SchDef sd=schdefs.get(j);
                    String eventIndex=sdf2.format(rundate)+"#"+sd.getId();
                    
                    Vector v=eventMap.get(eventIndex);

                    for(int k=0;v !=null &&k<v.size();k++){
                        SchEvent se=(SchEvent)v.get(k); 

                        Membr m=membrMap.get(new Integer(se.getMembrId()));
                        if(m !=null){

                            if(se.getStatus()==SchEvent.STATUS_READER_PENDDING)
                                out.println("<img src='images/dotx.gif' border=0>");
                            else
                                out.println("&nbsp;&nbsp;");
                %>
                <%=switchType(se.getType())%>&nbsp;
                        <%=m.getName()%><br>

                        &nbsp;&nbsp;&nbsp;<a href="#" onClick="javascript:openwindow_phm('modifySchEvent.jsp?seId=<%=se.getId()%>', '修改出缺勤', 500, 420, 'addevent');return false">
                        缺勤時間:<%=sdftime.format(se.getStartTime())+"-"+sdftime.format(se.getEndTime())%>
                        (共: <%=(se.getLastingHours()!=0)?se.getLastingHours()+"小時":""%><%=(se.getLastingMins()!=0)?se.getLastingMins()+"分鐘":""%>)</a><br>
                            <%
                            Hashtable<String,String> ha=CardMembr.getCardDate(rundate,rundate,m);
                            if(ha !=null){
                                String cardidX=ha.get(sdf.format(rundate));
                                if(cardidX !=null){

                                    Vector<Entry> vEntry=entryMap.get(sdf.format(rundate)+cardidX);

                                    if(vEntry !=null && vEntry.size()>=2){
                                        Entry en1=vEntry.get(0);
                                        Entry en2=vEntry.get(vEntry.size()-1);
                            %>
                                        &nbsp;&nbsp;&nbsp;&nbsp;刷卡紀錄          :<%=sdftime.format(en1.getCreated())%>-<%=sdftime.format(en2.getCreated())%>
                            <%
                                    }else if(vEntry==null || vEntry.size()==0){
                            %>                                        
                                        &nbsp;&nbsp;&nbsp;&nbsp;沒有刷卡紀錄                                                  
                            <%
                                    }else{
                            %>
                                        &nbsp;&nbsp;&nbsp;&nbsp;刷卡異常: <%=(vEntry.get(0)!=null)?sdftime.format(vEntry.get(0).getCreated()):""%> 
                            <%
                                    }
                                }
                            }
                            %>
                            <br>
                            <br>
                <%
                        }
                    }
                %>
                </td>    
                <%
                }
                %>
            </tr>                
        <%
            }
        %>
        </table>
    </td>
    </tr>
    </table>
</blockquote>

<br>
<br>
<%@ include file="bottom.jsp"%>
