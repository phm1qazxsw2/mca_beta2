<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy/MM/dd");
    String hname=request.getParameter("hname");    
    String startDate=request.getParameter("startTime");
    String endTime=request.getParameter("endTime");

    YearHolidayMgr yhm=YearHolidayMgr.getInstance(); 
    
    YearHoliday yh=new YearHoliday();
    yh.setName   	(hname);
    yh.setStartDate   	(sdf1.parse(startDate));
    yh.setEndDate   	(sdf1.parse(endTime));
    yhm.create(yh);

%>
<br>
<div class=es02>
&nbsp;&nbsp;&nbsp;<b>設定年假區間</b>
</div>
<br>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<blockquote>
    <div class=es02>
        新增成功.    
    </div>
</blockquote>
