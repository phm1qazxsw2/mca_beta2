<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,cardreader.*" 
    contentType="text/html;charset=UTF-8"%>
<%!
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf2 = new SimpleDateFormat("MM/dd");
    SimpleDateFormat sdftime = new SimpleDateFormat("HH:mm");
    String getTableHeaderInfo(ArrayList<SchDef> schdefs)
    {
        StringBuffer sb = new StringBuffer();
        sb.append("<tr bgcolor=#f0f0f0 class=es02>");
        sb.append("<td align=middle>&nbsp;教職員 <br>&nbsp;&nbsp;\\班別</td>");
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
                sb.append("<td align=middle nowrap><b>"+sd.getName()+"</b><br>"+(sd.getAutoRun()==1?"(正常班模式)":"(加班模式)")+"</td>");
            }
        }
        sb.append("</tr>");
        return sb.toString();
    }

    String printHrMin(int min)
    {
        if (min==0) return " 0 分鐘";
        if (min<60)
            return min+" 分鐘";

        int hr = 0;
        hr = min/60;
        min = min%60;
        StringBuffer sb = new StringBuffer();
        
        sb.append(hr+" 小時");
        if(min !=0)
            sb.append(min+" 分鐘");
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

    String checkEvent(Map<String,Vector<SchEvent>> eventMap,Map<Integer,Membr> membrMap,String rundate,int type){

        String indexString=rundate+"#"+type;

        Vector v=eventMap.get(indexString);

        if(v ==null || v.size()<=0){
            return "&nbsp;";
        }else{
 
            StringBuffer sb=new StringBuffer();
            for(int i=0;i<v.size();i++){
                SchEvent se=(SchEvent)v.get(i);
                Membr m=membrMap.get(new Integer(se.getMembrId()));
                String xhour="";
                if(se.getLastingHours()!=0)
                    xhour=se.getLastingHours()+"小時";
                if(se.getLastingMins()!=0)
                    xhour+=se.getLastingMins()+"分鐘";
                
                if(se.getStatus()==SchEvent.STATUS_READER_PENDDING)
                    sb.append("<font color=blue>*</font>");

               sb.append("<a href=\"#\" onClick=\"javascript:openwindow_phm('modifySchEvent.jsp?seId="+se.getId()+"', '輸出出勤excel',500, 420, 'addevent');return false\">");
                sb.append(m.getName()+"<br>&nbsp;&nbsp;"+xhour+"<br>");
                sb.append("&nbsp;&nbsp;"+sdftime.format(se.getStartTime())+"-"+sdftime.format(se.getEndTime())+"<br><br>");
                sb.append("</a>");
            }
            return sb.toString();
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


    int bunit=(ud2.getUserBunitCard()==0)?-1:ud2.getUserBunitCard();
    String bunitS=request.getParameter("bunit");        
    if(bunitS !=null)
        bunit=Integer.parseInt(bunitS); 

    BunitMgr bm=BunitMgr.getInstance();
    ArrayList<Bunit> b=bm.retrieveListX("status ='1' and flag='0'","", _ws.getBunitSpace("buId"));


    ArrayList<SchEvent> schevents = SchEventMgr.getInstance().
        retrieveList("startTime>='" + sdf1.format(d1) + "' and startTime<'" + sdf1.format(nextEndDay) + "'", "");    
    SchEventInfo infoevent = new SchEventInfo(schevents);


    // 今天有沒有註記紀錄
    ArrayList<Entryps> pss = EntrypsMgr.getInstance().
        retrieveList("created>='" + sdf1.format(d1) + "' and created<'" + sdf1.format(nextEndDay) + "'", " order by created");
    Map<String, Entryps> pssMap = new SortingMap(pss).doSortSingleton("getDateMembr");

    String d1str = java.net.URLEncoder.encode(sdf.format(d1));
    String d2str = java.net.URLEncoder.encode(sdf.format(d2));

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
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/event2.png" border=0>&nbsp;出勤統計</b>
</div>

<div class=es02>
<form action="schedule_schdef_info.jsp" name='f1' id='f1' method="get" onsubmit="return doSubmit(this)">

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href="#" onclick="displayCalendar(document.f1.sDate,'yyyy/mm/dd',this);return false">起始日期:</a><input type=text name="sDate" value="<%=sdf.format(d1)%>" size=8> &nbsp;&nbsp;
<a href="#" onclick="displayCalendar(document.f1.eDate,'yyyy/mm/dd',this);return false">至:</a><input type=text name="eDate" value="<%=sdf.format(d2)%>" size=8>
    &nbsp;&nbsp;
<%
    if(b !=null && b.size()>0){
%>
    職員部門: <select name="bunit" size=1>
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
            <a href="#" onClick="javascript:openwindow_phm('schedule_detail_excel_output2.jsp?sDate=<%=d1str%>&eDate=<%=d2str%>', '修改出缺勤', 400, 320, 'addevent');return false"><img src="pic/excel2.png" border=0>&nbsp;輸出excel</a>
</div>
<br>
<%
    String query="teacherStatus!=0";

    if(bunit !=-1)
        query+=" and teacherBunitId='"+bunit+"'";

    ArrayList<MembrTeacher> all_teachers = MembrTeacherMgr.getInstance().retrieveList(query, "");
    String membrIds = new RangeMaker().makeRange(all_teachers, "getMembrId");
    ArrayList<Membr> membrs = MembrMgr.getInstance().retrieveList("id in (" + membrIds + ")", "");
    Map<Integer, SchInfo> schinfoMap = SchInfo.getSchInfoForMembrs(membrs, d1, d2);

    ArrayList<SchDef> schdefs = SchInfo.getSchDefsWithin(d1, d2,bunit);
    Map<Integer, Vector<SchDef>> schdefRootMap = new SortingMap(schdefs).doSort("getAllRootId");


    // 處理卡的對應和讀入 membr 打卡的 entry   抓最近的卡片資料
/*
    ArrayList<CardMembr> cards = CardMembrMgr.getInstance().retrieveList("membrId in (" + membrIds + ") and created<'"+sdf.format(nextDay)+"'", " order by created desc");
    Map<Integer, CardMembr> membrcardMap = new SortingMap(cards).doSortSingleton("getMembrId");
*/
%>
<blockquote>
<%
    if(schdefs ==null || schdefs.size()<=0){
%>
        <div class=es02>
        本期間沒有班表.
        </div>            
        <%@ include file="bottom.jsp"%>
<%
        return;
    }

%>
<font color=blue>*</font><font class=es02>為加班模式,依打卡時間計算出勤的鐘點.</font>
<table height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
	
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
       <%=getTableHeaderInfo2(schdefRootMap)%>
<%
    for (int i=0;membrs!=null && i<membrs.size(); i++) {

        if(i !=0 && (i%10)==0)
            out.println(getTableHeaderInfo2(schdefRootMap));
        Membr membr = membrs.get(i);
        SchInfo info = schinfoMap.get(new Integer(membr.getId()));
%>
    <tr bgcolor=#ffffff class=es02>
        <td nowrap><b><%=(membr !=null)?membr.getName():""%></b>
        <%

        //拿這段區間的卡號
        Hashtable<String,String> ha=CardMembr.getCardDate(d1,d2,membr);
        %>
        </td>
        <%
        Date rightnow=new Date();
        long mins=(long)1000*60;

        Iterator<Integer> iter = schdefRootMap.keySet().iterator();
        while (iter.hasNext()) {

            int totalWork=0;
            Integer defIn=iter.next();
            Vector<SchDef> sdv = schdefRootMap.get(defIn);        
            out.println("<td align=left valign=top nowrap>");    

            int validTime=0;
            for(int j=0;sdv !=null && j<sdv.size();j++){

                SchDef sd=sdv.get(j);

                Date startDate=new Date();
                Date endDate=new Date();

                for(int k=0;k<duringDate;k++){                                
                    Calendar c2=Calendar.getInstance();
                    c2.setTime(d1);
                    c2.add(Calendar.DATE,k);
                    Date rundate=c2.getTime();

                    if(rundate.compareTo(sd.getStartDate())<0 || sd.getEndDate().compareTo(rundate)<0 || rightnow.compareTo(rundate)<=0)
                        continue;

                    boolean isOriginal = info.isOriginal(rundate, sd.getId());
                    int switchStatus = info.getSwitchStatus(rundate, sd.getId());
                    int entryX=0;  //沒班 但有刷

                    StringBuffer sbx=new StringBuffer();
                    Vector<Entry> vEntry=null;
                    if(ha !=null){
                        String cardidX=ha.get(sdf.format(rundate));
                        if(cardidX !=null){
                            vEntry=entryMap.get(sdf.format(rundate)+cardidX);

                            if(vEntry !=null && vEntry.size()>=1){
                                if(info.isSchDef(sd.getId()))
                                    entryX++;
                                if(vEntry.size()==1){
                                    sbx.append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;刷卡記錄不完整:"+sdftime.format(vEntry.get(0).getCreated()));                                
                                }else{
                                    validTime++;
                                    for(int k2=0;k2<vEntry.size();k2++){
                                        Entry en=vEntry.get(k2);
                                        if(k2==0 || (k2==(vEntry.size()-1))){
                                            if(k2 ==0)
                                                sbx.append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;刷卡時間:");
                                            if(k2 !=0)
                                                sbx.append("-");                        
                                            sbx.append(sdftime.format(en.getCreated()));
                                        }
                                    }
                                }
                            }else{
                                sbx.append(" &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;無刷卡記錄");                        
                            }
                        }else{
                                sbx.append(" &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;未設定卡片");                        
                        }
                    }

                    if ((isOriginal && switchStatus!=SchswRecord.TYPE_OFF) || (switchStatus==SchswRecord.TYPE_ON)) { // 有班

                        sch_content s_c=info.getSchContent(rundate,sd.getId());                
                        sd.getStartEndTime(rundate, startDate, endDate);                            
                        if(sd.getAutoRun()==1){
                            out.println(sdfday.format(startDate)+"("+SchInfo.printDayOfWeek(startDate.getDay()+1)+")");
                            int offtime=0;                    
                            if(s_c !=null)    
                                offtime=s_c.offtime;

                            int thismins=(int)((endDate.getTime()-startDate.getTime())/mins)-offtime;
                            Vector vEvent=infoevent.getDateDefMembr(rundate,sd.getId(),membr.getId());

                            int totalEvent=0;

                            totalWork+=thismins;
                            if(vEvent !=null && vEvent.size()>0){
                                totalEvent=countEvent(vEvent);
                                totalWork-=totalEvent;
                            }

                            out.println(" <font color=blue>出勤:"+printHrMin(thismins-totalEvent)+"</font>");  
                            if(vEvent !=null && vEvent.size()>0){
                                if(vEvent.size()==1){
                                    SchEvent se=(SchEvent)vEvent.get(0);
                                    out.println("&nbsp;<a href=\"#\" onClick=\"javascript:openwindow_phm('modifySchEvent.jsp?seId="+se.getId()+"', '修改出缺勤', 500, 420, 'addevent');return false\">("+se.getChinsesType(se.getType())+":"+printHrMin(totalEvent)+")</a>");  
                                }else{
                                    out.println("&nbsp;<a href=\"javascript:openwindow_phm2 ('schedule_event_membr.jsp?mid="+membr.getId()+"&d1="+d1str+"&d2="+d2str+"&stutus=-1', '出缺勤記錄', 800,600,'scheventmembr');\">(缺勤:"+printHrMin(totalEvent)+")</a>");  
                                }
                            }
                            out.println("<br>");
                            out.println("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+sbx.toString()+"<br>");
                        }else{
                            out.println(sdfday.format(startDate));
                            if(vEntry==null){
                                out.println(" 無刷卡記錄");
                                
                            }else if(vEntry.size()<=1){
                                out.println(" 刷卡記錄不完整 "+sdftime.format(vEntry.get(0).getCreated()));
                            }else{

                                Date[] validDate=CardMembr.getValidTime(vEntry,startDate, endDate);
                                int validMins=(int)((validDate[1].getTime()-validDate[0].getTime())/(long)(1000*60));
                                out.println("<font color=blue> *出勤時間:"+printHrMin(validMins)+"</font><br>");


                                //out.println(sdftime.format(validDate[0])+"-"+sdftime.format(validDate[1])+"<br>");
                                out.println("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+sbx.toString());   
                                totalWork+=validMins;
                            }
                            out.println("<br>");
                        }                       

                        Entryps eps=pssMap.get(sdf2.format(rundate)+"#"+String.valueOf(membr.getId()));
                        if(eps !=null){
                            out.println("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;註記:"+eps.getPs()+"<br>");
                        }     
                    }else{
                        if(entryX !=0){
                            if(sd.getAutoRun()==1)
                                out.println(sdfday.format(rundate)+"<font color=red> "+sbx.toString()+"</font><br>");
                            else
                                out.println(sdfday.format(rundate)+" <font color=red>*"+sbx.toString()+"</font><br>");
                        }

                    }
                } 
                if(totalWork !=0)
                    out.println("<br><div align=right>有效刷卡:<font color=blue><b>"+validTime+"</b></font> 天 出勤小計:<b><font color=blue>"+printHrMin(totalWork)+"</font></b></div><br>");
            }   

            out.println("</td>");   
        }
    %>
    </tr>

<%  }   %>
</table>
    </td>
    </tr>
    </table>
    </blockquote>

<br>
<br>
<%@ include file="bottom.jsp"%>
