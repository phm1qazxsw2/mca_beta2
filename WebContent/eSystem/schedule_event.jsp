<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%!
    String getTableHeaderInfo()
    {
        StringBuffer sb = new StringBuffer();
        sb.append("<tr bgcolor=#f0f0f0 class=es02>");
        sb.append("<td align=middle></td>");
        sb.append("<td align=middle colspan=2>缺勤(人工登入)</td>");
        sb.append("<td></td>");
        sb.append("<td align=middle colspan=4>缺勤(刷卡紀錄)</td>");
        sb.append("<td></td>");
        sb.append("<td align=middle colspan=5>缺勤沖銷</td>");
        sb.append("<td bgcolor='#f0f0f0'></td>");
        sb.append("<td colspan=5 align=center>超勤</td>");
        sb.append("</tr>");
        return sb.toString();
    }

    String getTableHeader()
    {
        StringBuffer sb = new StringBuffer();
        sb.append("<tr bgcolor=#f0f0f0 class=es02>");
        sb.append("<td align=middle></td>");
        sb.append("<td align=middle>15分以內</td>");
        sb.append("<td align=middle>15分以上</td>");
        sb.append("<td>-</td>");
        sb.append("<td align=middle>遲到</td>");
        sb.append("<td align=middle>早退</td>");
        sb.append("<td align=middle>缺勤</td>");
        sb.append("<td align=middle>刷卡異常</td>");
        sb.append("<td>-</td>");
        sb.append("<td align=middle>請假</td>");
        sb.append("<td align=middle>公出</td>");
        sb.append("<td align=middle>生病</td>");
        sb.append("<td></td>");
        sb.append("<td align=middle>未消缺勤</td>");
        sb.append("<td bgcolor='#f0f0f0'></td>");
        sb.append("<td align=middle>超勤</td>");
        sb.append("<td>-</td>");
        sb.append("<td align=middle>加班</td>");
        sb.append("<td>=</td>");
        sb.append("<td align=middle>未消超勤</td>");
        sb.append("</tr>");
        return sb.toString();
    }

    String printHrMin(int min)
    {
        if (min==0) return "";
        if (min<60)
            return min + "分";
        int hr = 0;
        hr = min/60;
        min = min%60;

        StringBuffer sb = new StringBuffer();
        if (hr>0)
            sb.append(hr+"時");
        if (min>0)
            sb.append(min+"分");
        return sb.toString();
    }

    String getBelow15Text(Vector<SchEvent> v)
    {
        if (v==null) return "";
        int min = 0;
        for (int i=0; i<v.size(); i++)
            min += v.get(i).getTimeSpan();
        return v.size() + "次(" + printHrMin(min) + ")";
    }

    String getAbove15Text(Vector<SchEvent> v15, Vector<SchEvent> vall, Map<String, Integer> tmp)
    {
        if (vall==null) return "";
        int min15 = 0;
        int t15 = 0;
        if (v15!=null) {
            t15 = v15.size();
            for (int i=0; i<t15; i++)
                min15 += v15.get(i).getTimeSpan();
        }
        int minAll = 0;
        for (int i=0; i<vall.size(); i++)
            minAll += vall.get(i).getTimeSpan();

        tmp.put("absent", new Integer(minAll));

        if ((vall.size()-t15)==0)
            return "";
        return (vall.size()-t15) + "次(" + printHrMin(minAll-min15) + ")";
    }

    String getDeductText(Vector<SchEvent> v1, Vector<SchEvent> v2, Map<String, Integer> tmp, String key)
    {
        int min = SchEventInfo.calcDeduct(v1, v2);
        tmp.put(key, new Integer(min));
        StringBuffer sb = new StringBuffer();
        if (v1!=null)
            sb.append(v1.size() + "次");
        if (min>0)
            sb.append("(" + printHrMin(min) + ")");
        return sb.toString();
    }
%>
<%
    int topMenu=6;
    int leftMenu=1;
%>
<%@ include file="topMenuAdvanced.jsp"%>
<%
    if(!checkAuth(ud2,authHa,104))
    {
        response.sendRedirect("authIndex.jsp?code=104");
    }

    //int type = -1;
    //try { type = Integer.parseInt(request.getParameter("type")); } catch (Exception e) {}
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
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

    ArrayList<SchEvent> schevents = SchEventMgr.getInstance().
        retrieveList("startTime>='" + sdf1.format(d1) + "' and startTime<'" + sdf1.format(nextEndDay) + "'", "");
    
    SchEventInfo info = new SchEventInfo(schevents);
    String d1str = java.net.URLEncoder.encode(sdf1.format(d1));
    String d2str = java.net.URLEncoder.encode(sdf1.format(d2));
%>
<%@ include file="leftMenu6.jsp"%>

<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>

<br>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;出勤統計</b>
</div>

<div class=es02>
<form action="schedule_event.jsp" name='f1' id='f1' method="get" onsubmit="return doSubmit(this)">

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href="#" onclick="displayCalendar(document.f1.sDate,'yyyy/mm/dd',this);return false">起始日期:</a><input type=text name="sDate" value="<%=sdf.format(d1)%>" size=8> &nbsp;&nbsp;
<a href="#" onclick="displayCalendar(document.f1.eDate,'yyyy/mm/dd',this);return false">至:</a><input type=text name="eDate" value="<%=sdf.format(d2)%>" size=8>
    &nbsp;&nbsp;
    <input type=submit value="查詢">
</form>
</div>
 

<form name="f">
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  

<br>
<div class=es02>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:openwindow_phm2('schedule_event_add.jsp?et=1', '登記缺勤超勤', 900, 700, 'addevent');"><img src="pic/costAdd.png" border=0>&nbsp;登記缺勤超勤</a>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:openwindow_phm2('schedule_event_add.jsp?et=2', '登記請假加班', 900, 700, 'addevent');"><img src="pic/costAdd.png" border=0>&nbsp;登記請假加班</a>
</div>

<br>

<blockquote>

<%
    if (schevents.size()==0) {
    %>區段內無出缺勤請假資料<%
        return;
    }
%>

<table height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
	
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
    <%=getTableHeaderInfo()%>
<%
    int k = 0;
    Iterator<Membr> iter = info.getMembrIterator();
    while (iter.hasNext()) {
        Membr membr = iter.next();
        if (k%7==0)
            out.println(getTableHeader());
        k++;

        Vector<SchEvent> events = info.getMap(membr, SchEvent.TYPE_ABSENT);

        Vector<SchEvent> below15 = null;
        if (events!=null) {
            Map<Integer, Vector<SchEvent>> divideMap = new SortingMap(events).doSort("divideBy15");
            below15 = divideMap.get(new Integer(0));
        }

        Vector<SchEvent> cv1 = info.getMap(membr, SchEvent.TYPE_PERSONAL);
        Vector<SchEvent> cv2 = info.getMap(membr, SchEvent.TYPE_BUSINESS);
        Vector<SchEvent> cv3 = info.getMap(membr, SchEvent.TYPE_SICK);
%>

    <tr bgcolor=#ffffff  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'"  align=center valign=middle>
        <td class=es02 nowrap><a href="javascript:openwindow_phm2 ('schedule_event_membr.jsp?mid=<%=membr.getId()%>&d1=<%=d1str%>&d2=<%=d2str%>', '出缺勤記錄', 900,700,'scheventmembr');"><%=membr.getName()%></a></td>
        <td class=es02><%=getBelow15Text(below15)%></td>
        <td class=es02><%
            Map<String, Integer> tmp = new HashMap<String, Integer>();
            tmp.put("absent", new Integer(0));
            tmp.put("personal", new Integer(0));
            tmp.put("business", new Integer(0));
            tmp.put("sick", new Integer(0));

            out.println(getAbove15Text(below15, events, tmp));
            int absent_total = tmp.get("absent").intValue();
        %>
        </td>
        <td class=es02>-</td>
        <td class=es02 colspan=4> aaaa</td>
        <td class=es02>-</td>
        <td class=es02 align=left><%=getDeductText(cv1, events, tmp, "personal")%></td>
        <td class=es02><%=getDeductText(cv2, events, tmp, "business")%></td>
        <td class=es02><%=getDeductText(cv3, events, tmp, "sick")%></td>
        <td class=es02>=</td>
        <td class=es02><%
            int n1 = tmp.get("personal").intValue();
            int n2 = tmp.get("business").intValue();
            int n3 = tmp.get("sick").intValue();
            int remain = absent_total - (n1+n2+n3);
            out.println(printHrMin(remain));
        %>
        </td>
        <td class=es02 bgcolor="#f0f0f0"></td>
        <td class=es02></td>
        <td class=es02>-</td>
        <td class=es02></td>
        <td class=es02>=</td>
        <td class=es02></td>

    </tr>	
<%
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
