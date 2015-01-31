<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,cardreader.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=6;
    int leftMenu=4;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu6_sch.jsp"%>
<br>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;<img src="images/rfidx.png" border=0>&nbsp;刷卡資料補登</b>
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

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  

<br>
<br>
<center>
    <form action="entryGroupAdd2.jsp" method="post">
        <textarea name="list" rows=20 cols=107></textarea>
        <br>
        <input type=submit value="新增">
    </form>
</center>
<%
/*
EntryMgr emgr = EntryMgr.getInstance();
Entry en = new Entry();
en.setCreated(sdf.parse(bString.substring(18,32)));
en.setMachineId(Integer.parseInt(bString.substring(2,4)));
en.setCardId(bString.substring(8,18));
en.setDatatype(0);
en.setDatauser(0);
en.setNumber(Integer.parseInt(bString.substring(32,36)));
emgr.create(en);
*/
%>


<%@ include file="bottom.jsp"%>