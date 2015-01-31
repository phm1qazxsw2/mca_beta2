<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=6;
    int leftMenu=3;
%>
<%!
    static SimpleDateFormat _sdf = new SimpleDateFormat("MM/dd");
    String formatDay(Calendar c)
    {
        return _sdf.format(c.getTime()) + SchInfo.printDayOfWeek(c.get(Calendar.DAY_OF_WEEK));
    }

    static Calendar cc = Calendar.getInstance();
    int getHourOfDay(Date t, boolean isEndingHour)
    {
        cc.setTime(t);
        int ret = cc.get(Calendar.HOUR_OF_DAY);
        if (cc.get(Calendar.MINUTE)>0 && isEndingHour)
            ret += 1;
        return ret;
    }

    static SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
    String enc(Date d)
    {
        return java.net.URLEncoder.encode(sdf1.format(d));
    }

    String getTableHeader(int startHr, int endHr)
    {
        StringBuffer sb = new StringBuffer();
        sb.append("<tr bgcolor=#f0f0f0 align=center><td></td>");
        for (int i=startHr; i<endHr; i++) {
            sb.append("<td width=50 nowrap>");
            int ii = (i>24)?(i-24):i;
            sb.append(ii);
            sb.append("-");
            sb.append(ii+1);
            sb.append("</td>");
        }
        sb.append("</tr>");
        return sb.toString();
    }

    static SimpleDateFormat sdftime = new SimpleDateFormat("HH:mm");
    static SimpleDateFormat sdf2 = new SimpleDateFormat("yyyyMMdd");
    int draw_schedules(ArrayList<SchDef> schs, Date d, StringBuffer sb,  
        Map<Integer, SchDef> schdefMap, int startHr, int endHr,SchInfo info,Map<String,Vector<SchEvent>> eventMap)
        throws Exception
    {        
        int rows = 0;
        for (int i=0, s=schs.size(); i<s; i++) {
            SchDef sd = schs.get(i);

            Vector ev=eventMap.get(sdf2.format(d)+"#"+sd.getId());

            boolean haveSch=false;
            boolean isOriginal = info.isOriginal(d, sd.getId());
            int switchStatus = info.getSwitchStatus(d, sd.getId());
            if ((isOriginal && switchStatus!=SchswRecord.TYPE_OFF) || (switchStatus==SchswRecord.TYPE_ON)) { // 有班
                haveSch=true;
            }

            Date t1 = new Date();
            Date t2 = new Date();

            boolean hasTime = sd.getStartEndTime(d, t1, t2);
            int t1hour = getHourOfDay(t1, false);
            int t2hour = getHourOfDay(t2, true);
            if (t2hour<t1hour) {
                System.out.println("## t2=" + sdftime.format(t2));
                t2hour += 24;
            }

            if (hasTime) {
                if (rows>0)
                    sb.append("<tr bgcolor=#ffffff align=center valign=middle height=10>");
                rows ++;
                if ((t1hour-startHr)>0) {
                    sb.append("<td bgcolor=\"white\" colspan="+(t1hour-startHr)+"></td>");
                }
                if ((t2hour-t1hour)>0) {

                    if(haveSch){
                    //有班
                        sb.append("<td class=es02 bgcolor=\"" + sd.getColor()+"\" colspan=\"" + (t2hour-t1hour) + "\" id=\"bar_" + sd.getId()+"_" + sdf2.format(d) + "\" align=left>");
                        
                        if(switchStatus==SchswRecord.TYPE_ON)
                            sb.append("<b>"+sd.getName()+" (換班)</b>");
                        else
                            sb.append("<b>"+sd.getName()+"</b>");
                
                        if(ev !=null && ev.size()>0){
                            for(int j=0;j<ev.size();j++){
                                SchEvent se=(SchEvent)ev.get(j);
                                sb.append("&nbsp;&nbsp;<a href=\"#\" onClick=\"javascript:openwindow_phm('modifySchEvent.jsp?seId="+se.getId()+"', '修改出缺勤', 500, 420, 'addevent');return false\">"+SchEvent.getChinsesType(se.getType())+"&nbsp;");
                                sb.append(sdftime.format(se.getStartTime())+"-"+sdftime.format(se.getEndTime())+"</a>");
                            }
                        }
                        sb.append("</td>");
                    }else{
                    //沒班                        
                    sb.append("<td colspan=\"" + (t2hour-t1hour) + "\" id=\"bar_" + sd.getId()+"_" + sdf2.format(d) + "\" align=right>"+sd.getName()+"</td>");
                    }                        

                    sb.append("<script>");
                    sb.append("a[a.length]='bar_" + sd.getId()+ "_" + sdf2.format(d) + "'");
                    sb.append("</script>");
                }
                if ((endHr-t2hour)>0) {
                    sb.append("<td bgcolor=\"white\" colspan=\"" + (endHr-t2hour) + "\"></td>");
                }
            }
        }
        if (rows==0) {
            sb.append("<td bgcolor=\"white\" colspan=\"" + (endHr-startHr) + "\"></td>");
            rows = 1;
        }
        return rows;
    }
%>

<%@ include file="topMenu.jsp"%>
<%
    if(!checkAuth(ud2,authHa,700))
	{ 
       response.sendRedirect("authIndex.jsp?code=700");
	}


    int bunit=-1;
    String bunitS=request.getParameter("bunit");        
    if(bunitS !=null)
        bunit=Integer.parseInt(bunitS); 



    int membrId=-1;
    String membrIdS=request.getParameter("membrId");
    if(membrIdS !=null)
        membrId=Integer.parseInt(membrIdS);


    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");    
    Calendar c = Calendar.getInstance();
    c.set(Calendar.DAY_OF_MONTH, 1);
    Date d1 = sdf.parse(sdf.format(c.getTime())); // 為了讓時分秒歸零
    c.add(Calendar.MONTH, 1);
    c.add(Calendar.DATE, -1); 
    Date d2 = c.getTime();
    try { d1 = sdf.parse(request.getParameter("sDate")); } catch (Exception e) {}
    try { d2 = sdf.parse(request.getParameter("eDate")); } catch (Exception e) {}
    c.setTime(d2);
    c.add(Calendar.DATE, 1);
    Date nextEndDay = c.getTime();


    String query="startDate<'" + sdf1.format(nextEndDay) + "' and endDate>='" + sdf1.format(d1) + "'";

    if(bunit !=-1){
        query +=" and bunitId='"+bunit+"'";
    }

    ArrayList<SchDef> schs = SchDefMgr.getInstance().retrieveList(query, "");


    // 找出有在這段時間內的 schdefs
    ArrayList<SchMembrInfo> schsMem = SchMembrInfoMgr.getInstance().retrieveList("membrId='"+membrId+"' and startDate<'" + sdf1.format(nextEndDay) + "' and endDate>='" + sdf1.format(d1) + "'", "");

    String sdfIds=new RangeMaker().makeRange(schsMem, "getSchdefId");
    ArrayList<SchDef> schsMembr = SchDefMgr.getInstance().retrieveList("id in ( "+sdfIds+" )","");

    Map<Integer,SchDef> membrSchMap=new SortingMap(schsMembr).doSortSingleton("getId");
    

    // 找出用這些班表的人
    ArrayList<SchMembr> schmembrs=null;
    Map<Integer, Vector<SchMembr>> schmembrMap = null;
    if (schs.size()>0) {
        String schsIds = new RangeMaker().makeRange(schs, "getId");
        schmembrs = SchMembrMgr.getInstance().retrieveList("schdefId in (" + schsIds + ")", "");
        schmembrMap = new SortingMap(schmembrs).doSort("getSchdefId");
    }
    else 
        schmembrMap = new HashMap<Integer, Vector<SchMembr>>();


    // 今天有沒有請假紀錄
    ArrayList<SchEvent> schevents = SchEventMgr.getInstance().
        retrieveList("startTime>='" + sdf1.format(d1) + "' and startTime<'" + sdf1.format(nextEndDay) + "' and membrId='"+membrId+"'", " order by startTime");
    Map<String,Vector<SchEvent>> eventMap=new SortingMap(schevents).doSort("getDateDef");

    String membrids = new RangeMaker().makeRange(schmembrs, "getMembrId");
    ArrayList<Membr> membrs = MembrMgr.getInstance().retrieveList("id in (" + membrids + ")", "");
    
    Membr memX=MembrMgr.getInstance().find(" id ='"+membrId+"'");
    ArrayList<Membr> alm=new ArrayList();
    alm.add(memX);
    Map<Integer, SchInfo> schinfoMap = SchInfo.getSchInfoForMembrs(alm, d1, d2);


    int startHr = 24, endHr = 0;
    for (int i=0; i<schs.size(); i++) {
        SchDef sd = schs.get(i);
        int[] shours = sd.getStartHours();
        for (int j=0; j<shours.length; j++)
            startHr = Math.min(startHr, shours[j]);
        int[] ehours = sd.getEndHours();
        for (int j=0; j<ehours.length; j++)
            endHr = Math.max(endHr, ehours[j]);
    }
    startHr -= 1;
    endHr += 1;

    String d1str = java.net.URLEncoder.encode(sdf.format(d1));
    String d2str = java.net.URLEncoder.encode(sdf.format(d2));

    BunitMgr bm=BunitMgr.getInstance();
    ArrayList<Bunit> b=bm.retrieveListX("status ='1' and flag='0'","", _ws.getBunitSpace("buId"));

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
<script>
    
    function changeAction(){

        var xMembr=document.f1.membrId.value;
        if(xMembr=="-1")
            document.f1.action="schedule.jsp";
        else
            document.f1.action="schedule_membr_list.jsp";            
    }

</script>
<br>
<b>&nbsp;&nbsp;&nbsp;<%=memX.getName()%>-班表</b>
 
<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>

<div class=es02>
<form name="f1" action="schedule_membr_list.jsp" method="get">

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href="#" onclick="displayCalendar(document.f1.sDate,'yyyy/mm/dd',this);return false">起始日期</a>:<input type=text name="sDate" value="<%=sdf.format(d1)%>" size=8>
&nbsp;&nbsp;
<a href="#" onclick="displayCalendar(document.f1.eDate,'yyyy/mm/dd',this);return false">至</a>:<input type=text name="eDate" value="<%=sdf.format(d2)%>" size=8>
    &nbsp;&nbsp;
<%
    if(b !=null && b.size()>=0){
%>
    班表部門: <select name="bunit" size=1  onChange="javascript:changeAction2(this.value)">
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

    教職員:
<%

    if(membrs !=null && membrs.size()>0){
%>
        <select name="membrId" onChange="javascript:changeAction()">
            <option value="-1" <%=(membrId==-1)?"selected":""%>>全部</option>
<%
        for(int j=0;j<membrs.size();j++){
            Membr mem=membrs.get(j);
%>
            <option value="<%=mem.getId()%>" <%=(membrId==mem.getId())?"selected":""%>><%=mem.getName()%></option>                
<%      }   %>
        </select>
<%
    }   

%>
    <input type=submit value="查詢">
</form>
</div>
 
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  

<br>
<div class=es02>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:openwindow_phm('schedule_schsw_add.jsp?d1=<%=enc(d1)%>&d2=<%=enc(d2)%>', '新增換班', 450, 300, 'addswitch');"><img src="pic/addchangeschedule.png" border=0>&nbsp;新增換班記錄</a>
 | <a href="javascript:openwindow_phm('schedule_event_add.jsp?et=2&membrId=<%=membrId%>', '登記缺勤請假', 800, 600, 'addevent');"><img src="pic/addevent.png" border=0>&nbsp;登記請假</a>
</div>

<script>
   var a = new Array;
   var b = new Array;
   var g = new Array;
   var t = new Array;
<%
    Map<Integer, SchDef> schdefMap = new SortingMap(schs).doSortSingleton("getId");
    for (int i=0,s=schs.size(); i<s; i++) {
        SchDef sd = schs.get(i);
        Vector<SchMembr> vs = schmembrMap.get(new Integer(sd.getId()));
     %>
       b['<%=sd.getId()%>'] = '<%=phm.util.TextUtil.escapeJSString(sd.getName())%>';
       g['<%=sd.getId()%>'] = '<%=(vs==null)?0:vs.size()%>';
     <%
    }
%>
</script>

<%
    if (schs.size()==0) {
%>  <br><br> <blockquote>目前沒有班表</blockquote> <%
    return;
    }   
%>

<blockquote>
<table height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
    <%=getTableHeader(startHr, endHr)%>
<%
    SchInfo info = schinfoMap.get(new Integer(memX.getId()));


    c.setTime(d1);
    int k = 0;
    while (c.getTime().compareTo(nextEndDay)<0) {
        if (c.get(Calendar.DAY_OF_WEEK)==2 && k>5)
            out.println(getTableHeader(startHr, endHr));
        k ++;
        Date d = c.getTime();
        StringBuffer sb = new StringBuffer();

        
        
        int rows = draw_schedules(schs, d, sb, schdefMap, startHr, endHr,info,eventMap);
%>
    <tr bgcolor="white" height=10><td colspan=<%=1+(endHr-startHr)%>></td></tr>
    <tr bgcolor=#ffffff align=center valign=middle height=10>
        <td class=es02 rowspan=<%=rows%> nowrap><%=formatDay(c)%></td>
<%
        out.println(sb.toString());
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
<br>
<div class=es02>
<%

/*
    if (schdefMap.size()>0) {
        out.println("<b>此區間所有的班表:</b>");
%>
        <table border=0>

<%
        Iterator<Integer> iter = schdefRootMap.keySet().iterator();
        while (iter.hasNext()) {
            
            Integer defIn=iter.next();
            Vector<SchDef> sdv = schdefRootMap.get(defIn);
            for(int i=0;sdv !=null && i<sdv.size();i++){
                SchDef sd=sdv.get(i);
                if(i==0){
%>
                <tr>
                    <td colspan=2>
                        <b><%=sd.getName()%></b> 
                    </td>
                </tr>
<%
                }
                Vector mv=schmembrMap.get(defIn);
%>
                <tr class=es02>
                    <td width=10 bgcolor="<%=sd.getColor()%>"></td>
                    <td>
            <li><a href="javascript:openwindow_phm('schedule_detail.jsp?id=<%=sd.getId()%>', '班表詳細資料', 800, 600, 'scheduledetail')"><b><%=sd.getName()%></b></a>:<%=sd.getDescription()%>&nbsp;&nbsp;名單:&nbsp;<%=(mv !=null && mv.size()>0)?mv.size()+"人":""%>&nbsp;&nbsp;<a href="javascript:openwindow_phm('schedule_detail.jsp?id=<%=sd.getId()%>', '班表詳細資料', 800, 600, 'scheduledetail')">詳細資料</a>
                    </td>
                </tr>
<%
            }

        }
        out.println("</table>");        
    }
*/
%>
</div>
</blockquote>

<%@ include file="bottom.jsp"%>	

<script src="js/myevent.js"></script>
<script>       
    function doSelect()
    {
        var tokens = this.id.split("_");
        var schdefId = tokens[1];
        openwindow_phm('schedule_detail.jsp?id='+schdefId, '班表詳細資料', 800, 600, 'scheduledetail');
    }

    function showinfo()
    {
        var tokens = this.id.split("_");
        this.innerHTML = "<td nowrap>"+b[tokens[1]]+" ("+g[tokens[1]]+"人)</td>";
    }

    function clearinfo()
    {
        // var d = document.getElementById(this.id);
        // d.expand = false;
        this.innerHTML = "<td nowrap></td>";
    }

//    for (var i=0; i<a.length; i++) {
//        var d = document.getElementById(a[i]);
//        addevent(a[i], 'showinfo', 'mouseover');
//        addevent(a[i], 'clearinfo', 'mouseout');
//            addevent(a[i], 'doSelect', 'click');
//    }
</script>
