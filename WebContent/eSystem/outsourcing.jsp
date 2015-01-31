<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,java.io.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=13;
    int leftMenu=1;
    boolean showall = false;
%>
<%@ include file="topMenuAdvanced.jsp"%>
<%@ include file="leftMenu13.jsp"%>
<%
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
    String q = "occurDate>='" + sdf1.format(d1) + "' and occurDate<'" + sdf1.format(nextEndDay) + "'";

    MembrUser mu =  MembrUserMgr.getInstance().find("userId=" + ud2.getId()); 
    q += " and executeMembrId=" + mu.getMembrId();

    int sortby = 0;
    try { sortby = Integer.parseInt(request.getParameter("sortby")); } catch (Exception e) {};
    String orderby = "";
    String url = "outsourcing.jsp?sDate=" + java.net.URLEncoder.encode(sdf.format(d1)) + "&eDate=" + 
        java.net.URLEncoder.encode(sdf.format(d2));
    switch (sortby) {
        case 0: orderby = "order by occurDate asc"; break;
        case 1: orderby = "order by recordTime asc, occurDate asc"; break;
        case 2: orderby = "order by clientMembrId asc, occurDate asc"; break;
        case 3: orderby = "order by executeMembrId asc, occurDate asc"; break;
    }
    
    ArrayList<ManHour> manhours = ManHourMgr.getInstance().retrieveList(q, orderby);
%>

<br>
<b>&nbsp;&nbsp;&nbsp;派遣記錄</b>
 
<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK><SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>

<div class=es02>
<form name="f1" action="outsourcing.jsp" method="get">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href="#" onclick="displayCalendar(document.f1.sDate,'yyyy/mm/dd',this);return false">起始日期</a>:<input type=text name="sDate" value="<%=sdf.format(d1)%>" size=8> &nbsp;&nbsp;
<a href="#" onclick="displayCalendar(document.f1.eDate,'yyyy/mm/dd',this);return false">至</a>:<input type=text name="eDate" value="<%=sdf.format(d2)%>" size=8>
    &nbsp;&nbsp;
    <input type=submit value="查詢">
</form>
</div>

<%@ include file="outsourcing_list.jsp"%>