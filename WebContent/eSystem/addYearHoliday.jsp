<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy/MM/dd");
%>

<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>

<div class=es02>
&nbsp;&nbsp;&nbsp;<b>設定年假區間</b>
</div>
<br>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
    <%
        int thisYear=new Date().getYear()+1900;
    %>

    <form action="addYearHoliday2.jsp" method="post" name="f1" id="f1">
    <center>
    <table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
    <tr align=left valign=top>
    <td bgcolor="#e9e3de">
        <table width="100%" border=0 cellpadding=4 cellspacing=1>
        <tr bgcolor=#ffffff class=es02 align=left valign=middle>
            <td bgcolor=#f0f0f0>
                年假名稱
            </tD>
            <tD><input type=text name="hname" value="<%=thisYear%>年假"></tD>
        </tr>
        <tr class=es02>
            <td bgcolor=#f0f0f0>開始日期</td>
            <td bgcolor=#ffffff>
            <%
                String start=String.valueOf(thisYear)+"/01/01";
                String end=String.valueOf(thisYear)+"/12/31";
            %>
            <input type=text name="startTime" value="<%=start%>" size=8 onChange="checkScheduleBoundary();">
            <a href="#" onclick="displayCalendar(document.f1.startTime,'yyyy/mm/dd',this);return false"><img src="pic/blog4.gif" border=0></a>
            </td>
        </tr>
        <tr class=es02>
            <td bgcolor=#f0f0f0>結束日期</td>
            <td bgcolor=#ffffff>
            <input type=text name="endTime" value="<%=end%>" size=8 onChange="checkScheduleBoundary();">
            <a href="#" onclick="displayCalendar(document.f1.endTime,'yyyy/mm/dd',this);return false"><img src="pic/blog4.gif" border=0></a>
            </td>
        </tr>
        <tr>
            <tD colspan=2 align=middle bgcolor="ffffff">
                <input type=submit value="確認新增">
            </td>
        </tr>
    </table>

    </td>
    </tr>
    </table>
    </center>
</form>