<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,cardreader.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=6;
    int leftMenu=4;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu6_sch.jsp"%>
<br>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/event1.png" border=0>&nbsp;假期列表</b>
<br>
<%
    SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf2=new SimpleDateFormat("HH:mm");
    SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
    
    String yearX=String.valueOf(new Date().getYear()+1900);    
    Date d1=sdf.parse(yearX+"/01/01");
    Calendar c = Calendar.getInstance();
    c.setTime(d1);
    c.add(Calendar.YEAR, 1);
    c.add(Calendar.DATE, -1); 
    Date d2 = c.getTime();
    try { d1 = sdf.parse(request.getParameter("sDate")); } catch (Exception e) {}
    try { d2 = sdf.parse(request.getParameter("eDate")); } catch (Exception e) {}
    c.setTime(d2);
    c.add(Calendar.DATE, 1);
    Date nextEndDay = c.getTime();

%>


</div>
<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>


<div class=es02>
<form action="holiday.jsp" name='f1' id='f1' method="get" onsubmit="return doSubmit(this)">

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href="#" onclick="displayCalendar(document.f1.sDate,'yyyy/mm/dd',this);return false">起始日期:</a><input type=text name="sDate" value="<%=sdf.format(d1)%>" size=8> &nbsp;&nbsp;
<a href="#" onclick="displayCalendar(document.f1.eDate,'yyyy/mm/dd',this);return false">至:</a><input type=text name="eDate" value="<%=sdf.format(d2)%>" size=8>
    &nbsp;&nbsp;
    <input type=submit value="查詢">
</form>
</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  

<blockquote>
<div class=es02>                    
<a href="javascript:openwindow_phm('addHoliday.jsp?id=-1','新增假期',800,550,true);"><img src="pic/add.gif" border=0 width=12>&nbsp;新增假期</a>
</div>

<table width="80%" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
	
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
    <tr bgcolor=#f0f0f0 class=es02>
        <tD>日期</td><td>假別</tD><td>名稱</td><td>登入人</td><td>請假筆數</td><td></td>
    </tR>
<%


    HolidayMgr hm=HolidayMgr.getInstance();
    ArrayList<Holiday> ha=hm.retrieveList("startTime>='" + sdf1.format(d1) + "' and startTime<'" + sdf1.format(nextEndDay) + "'","order by startTime asc");
       
    ArrayList<SchEvent> se=SchEventMgr.getInstance().retrieveList("startTime>='" + sdf1.format(d1) + "' and startTime<'" + sdf1.format(nextEndDay) + "'","order by startTime asc");

    Map<Integer, Vector<SchEvent>> seMap = new SortingMap(se).doSort("getHolidayId");

    UserMgr um=UserMgr.getInstance();
    for(int i=0;ha !=null && i<ha.size();i++){

        Holiday ho=ha.get(i);
        User u=(User)um.find(ho.getUserId());
%>
    <tr bgcolor=ffffff class=es02>
        <td><%=sdf.format(ho.getStartTime())%></td>
        <td><%=SchEvent.getChinsesType(ho.getType())%></tD>
        <td><%=ho.getName()%></td>
        <td align=middle><%=(u !=null)?u.getUserFullname():""%></td>
        <td align=right>
            <%  
                Vector v=seMap.get(new Integer(ho.getId()));

                if(v !=null && v.size()>0){
            %>
                <%=v.size()%>筆&nbsp;<a href="javascript:openwindow_phm('modifyHoliday.jsp?id=<%=ho.getId()%>','修改假期',800,550,true);">詳細名單</a>
            <%
                }
            %>
        </tD>
        <td align=middle><a href="javascript:openwindow_phm('modifyHoliday.jsp?id=<%=ho.getId()%>','修改假期',800,550,true);">修改</a></td>
    </tr>
<%
    }
%>
</table>
    </td>
    </tr>
    </table>
</blockquote>

<%@ include file="bottom.jsp"%>