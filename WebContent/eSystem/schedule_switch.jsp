<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%!
    SimpleDateFormat sdf=new SimpleDateFormat("HH:mm");
    String getTableHeader(Map<Integer, Vector<SchDef>> schdefMap)
    {
        StringBuffer sb = new StringBuffer();
        sb.append("<tr bgcolor=#f0f0f0 class=es02>");
        sb.append("<td width=20 align=middle></td>");

        Iterator<Integer> iter = schdefMap.keySet().iterator();
        while (iter.hasNext()) {
            sb.append("<td width=70 align=middle nowrap valign='top'><b>" + schdefMap.get(iter.next()).get(0).getName() + "</b></td>");
        }
        sb.append("</tr>");
        return sb.toString();
    }

    static SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
    String enc(Date d)
    {
        return java.net.URLEncoder.encode(sdf1.format(d));
    }

    SchswRecordx findOther(SchswRecordx r, ArrayList<SchswRecordx> xrecords)
    {
        for (int i=0; i<xrecords.size(); i++) {
            if (xrecords.get(i).getMembrId()!=r.getMembrId())
                return xrecords.get(i);
        }
        return null;
    }

    String getEventMembrNames(SchEventInfo info, Vector<SchEvent> ve)
    {
        StringBuffer sb = new StringBuffer();
        for (int i=0; i<ve.size(); i++) {
            SchEvent se=ve.get(i);
            
            if (i>0) sb.append("<br>");
            sb.append(SchEvent.getChinsesType(se.getType())+":");
            sb.append("<a href=\"#\" onClick=\"javascript:openwindow_phm('modifySchEvent.jsp?seId="+se.getId()+"', '修改出缺勤', 500, 420, 'addevent');return false\">");
            sb.append(info.getMembrName(ve.get(i)));
            sb.append("</a><br>");
            sb.append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+sdf.format(se.getStartTime())+"-"+sdf.format(se.getEndTime()));
        }
        return sb.toString();
    }
%>
<%
    int topMenu=6;
    int leftMenu=3;
%>
<%@ include file="topMenuAdvanced.jsp"%>
<%

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdfxx = new SimpleDateFormat("yyyyMMdd");
    SimpleDateFormat sdftime=new SimpleDateFormat("HH:mm");
    Calendar c = Calendar.getInstance();
    c.set(Calendar.DAY_OF_MONTH, 1);
    Date d1 = c.getTime();
    c.add(Calendar.MONTH, 1);
    c.add(Calendar.DATE, -1); 
    Date d2 = c.getTime();
    try { d1 = sdf.parse(request.getParameter("sDate")); } catch (Exception e) {}
    try { d2 = sdf.parse(request.getParameter("eDate")); } catch (Exception e) {}
    c.setTime(d2);
    c.add(Calendar.DATE, 1);
    Date nextEndDay = c.getTime();


    int bunit=(ud2.getUserBunitCard()==0)?-1:ud2.getUserBunitCard();
    String bunitS=request.getParameter("bunit");        
    if(bunitS !=null)
        bunit=Integer.parseInt(bunitS); 

    BunitMgr bm=BunitMgr.getInstance();
    ArrayList<Bunit> b=bm.retrieveListX("status ='1' and flag='0'","", _ws.getBunitSpace("buId"));

    String query="startDate<'" + sdf1.format(nextEndDay) + "' and endDate>='" + sdf1.format(d1) + "'";
    if(bunit !=-1){
        query +=" and bunitId='"+bunit+"'";
    }    

    // 找出有在這段時間內的 schdefs
    ArrayList<SchDef> schdefs = SchDefMgr.getInstance().retrieveList(query, "");

    int type = -1;
    try { type = Integer.parseInt(request.getParameter("type")); } catch (Exception e) {}

    // 找出這段時間有調班的資料
    ArrayList<SchswRecordx> xrecords = SchswRecordxMgr.getInstance().
        retrieveList("occurDate>='" + sdf1.format(d1) + "' and occurDate<'" + 
            sdf1.format(nextEndDay) + "'", "");

    Map<String, Vector<SchswRecordx>> xrecordMap = new SortingMap(xrecords).doSort("getDateSchdefId");
    Map<Integer, Vector<SchDef>> schdefMap = new SortingMap(schdefs).doSort("getMyRootId");
    Map<Integer, SchDef> schdefIdMap = new SortingMap(schdefs).doSortSingleton("getId");
    // ############ 請假資料 ##########


    ArrayList<SchEvent> schevents = SchEventMgr.getInstance().
        retrieveList("startTime>='" + sdf1.format(d1) + "' and startTime<'" + sdf1.format(nextEndDay) + 
        "'", "");
//System.out.println("### schevents=" + schevents.size());
    SchEventInfo eventinfo = new SchEventInfo(schevents);



%>
<%@ include file="leftMenu6_sch.jsp"%>
<script>
    function setTarget_1(id, name)
    {
        setup_target_1(id, name);
    }

    function setTarget_2(id, name)
    {
        setup_target_2(id, name);
    }

    function openPicker()
    {
        if (get_target_1()==null || get_target_2()==null) {
            alert("來源和對象尚未指定");
            return;
        }
        if (get_target_1()!=get_target_2()) {
            openwindow_phm2("schedule_schsw_pick.jsp?month="+get_month()+"&id1="+get_target_1()+"&id2="+get_target_2(), "調班", 900, 700, "swtichpick");
        }
        else {
            openwindow_phm2("schedule_schsw_self.jsp?month="+get_month()+"&id1="+get_target_1(), "調班", 900, 700, "swtichpick");
        }
        //openwindow_phm2("schedule_schsw_pick2.jsp?month="+get_month()+"&id1="+get_target_1()+"&id2="+get_target_2(), "選班", 900, 700, "swtichpick");        
        //location.href = "schedule_schsw_pick.jsp?month="+get_month()+"&id1="+get_target_1()+"&id2="+get_target_2();
    }

    function openFinder(which)
    {
        openwindow_phm2("schedule_find_target.jsp?field=" + which, "選擇對象", 400, 500, "settarget"+which);
    }
</script>
<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>

<br>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/changeschedule.png" border=0>&nbsp;換班請假記錄</b>
</div> 

<div class=es02>
<form action="schedule_switch.jsp" method="get" onsubmit="return doSubmit(this)"  name="f1" id="f1">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href="#" onclick="displayCalendar(document.f1.sDate,'yyyy/mm/dd',this);return false">起始日期:</a><input type=text name="sDate" value="<%=sdf.format(d1)%>" size=8> &nbsp;&nbsp;
<a href="#" onclick="displayCalendar(document.f1.eDate,'yyyy/mm/dd',this);return false">至:</a><input type=text name="eDate" value="<%=sdf.format(d2)%>" size=8>
    &nbsp;&nbsp;
<%
    if(b !=null && b.size()>0){
%>
    班表部門: <select name="bunit" size=1>
                <option value="-1" <%=(bunit==-1)?"selected":""%>>全部</option>
    <%          
                for(int j=0;j<b.size();j++){    
                    Bunit bb=b.get(j);
    %>
                    <option value="<%=bb.getId()%>" <%=(bunit==bb.getId())?"selected":""%>><%=bb.getLabel()%></option>
    <%          }   %>
                <option value="0" <%=(bunit==0)?"selected":""%>>跨部門</option>
            </select>
<%
    }else{
%>
        <input type=hidden name="bunit" value="-1">
<%  }   %>
    <input type=submit value="查詢">
</form>
</div>
 

<form name="f">
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  

<br>
<div class=es02>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:openwindow_phm('schedule_schsw_add.jsp?d1=<%=enc(d1)%>&d2=<%=enc(d2)%>', '新增換班', 450, 300, 'addswitch');"><img src="pic/addchangeschedule.png" border=0>&nbsp;新增換班記錄</a>
 | <a href="javascript:openwindow_phm('schedule_event_add.jsp?et=2&bunit=<%=bunit%>', '登記缺勤請假', 800, 600, 'addevent');"><img src="pic/addevent.png" border=0>&nbsp;登記請假</a>
</div>
<br>
<blockquote>
<div class=es02>* 為有換班記錄的人員,該班表必須出席.</div>
<table height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
	
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
    <%=getTableHeader(schdefMap)%>
<%
    c.setTime(d1);
    Map<Integer, Vector<SchEvent>> eventMap = new SortingMap(schevents).doSort("getDateDef");
    int k = 0;
    while (c.getTime().compareTo(nextEndDay)<0) {
        if (c.get(Calendar.DAY_OF_WEEK)==2 && k>5)
            out.println(getTableHeader(schdefMap));
        k++;
        ArrayList<SchEvent> events = eventinfo.getEventsOnDate(c.getTime());

%>
    <tr bgcolor=#ffffff  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
        <td class=es02 align=center nowrap valign=top>
            <%=c.get(Calendar.MONTH)+1%>/<%=c.get(Calendar.DAY_OF_MONTH)%>
            (<%=SchInfo.printDayOfWeek( c.get(Calendar.DAY_OF_WEEK))%>)
        </td>
<%  
        Iterator<Integer> iter = schdefMap.keySet().iterator();
        while (iter.hasNext()) {
            Vector<SchDef> sameroot_sds = schdefMap.get(iter.next());
%>
        <td class=es02 nowrap valign=top>
<%

            for (int j=0; j<sameroot_sds.size(); j++) {
                SchDef sd = sameroot_sds.get(j);
                Date d1x=new Date();
                Date d2x=new Date();
                sd.getStartEndTime(c.getTime(), d1x, d2x);
                boolean sx=false;
                //請假
                String searchWord=sdfxx.format(c.getTime())+"#"+String.valueOf(sd.getId());
                Vector<SchEvent> ve = eventMap.get(searchWord);
                if (ve!=null && ve.size()>0) {
                    out.println(getEventMembrNames(eventinfo, ve));
                    sx=true;
                }

                //換班
                Vector<SchswRecordx> records = xrecordMap.get(sdf1.format(c.getTime()) + "#" + sd.getId());
                if (records!=null) {
                    for (int i=0; i<records.size(); i++) {
                        SchswRecordx r = records.get(i);
                        if (r.getType()==SchswRecord.TYPE_ON) {
                            if(sx)
                                out.println("<br>");
                            String adv = "原班為";
                            if (r.getMembrId()==r.getReqMembrId()) { // 這樣被換的那個就不用 link 了
                                adv = "原班為";
                                out.println("<br><font color=blue>* 換班:</font>");
                      %>
                        <a href="javascript:openwindow_phm2('schedule_schsw_detail.jsp?swId=<%=r.getSchswId()%>', '調班', 900, 700, 'swtichpick')">
                      <%
                            }else{
                                out.println("<br><font color=blue>* 換班:</font>");
                            }
                            out.println(r.getMembrName()+"</a><br>");

                            out.println("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+sdftime.format(d1x)+"-"+sdftime.format(d2x)+"<br>");
                            SchswRecordx other = findOther(r, xrecords);
                            out.println("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+adv+other.getMembrName()+"("+r.getSchswId()+")");                        
                            out.println("<br>");
                        }
                    }
                }
            }
%>    
        </td>
<%
        }
%>    
    </tr>	
<%
        c.add(Calendar.DATE, 1);
    }
%>
    </table> 

</td>
</tr>
</table>
</form>
</blockquote>
<br>
<br>
<%@ include file="bottom.jsp"%>
