<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    float hours=Float.parseFloat(request.getParameter("mins"));
    int mins=(int)(hours*60);

    int yearHolidayId=Integer.parseInt(request.getParameter("yearHolidayId"));
    int membrId=Integer.parseInt(request.getParameter("membrId"));    
    int bunit=Integer.parseInt(request.getParameter("bunit"));    
    int ymId=Integer.parseInt(request.getParameter("ymId"));
    int year=Integer.parseInt(request.getParameter("year"));


    YearMembrMgr ymm=YearMembrMgr.getInstance();
    YearMembr ym=ymm.find("id='"+ymId+"'");
    ym.setCreated   	(new Date());
    ym.setMembrId   	(membrId);
    ym.setYearHolidayId   	(yearHolidayId);

    if(year==1)
        ym.setMins   	(mins);
    else
        ym.setOvertime   	(mins);
        
    ym.setUserId(ud2.getId());   
    ymm.save(ym);

    if(year ==1)
        response.sendRedirect("listYearHoliday.jsp?yearHolidayId="+yearHolidayId+"&bunit="+bunit);
    else    
        response.sendRedirect("listOvertime.jsp?yearHolidayId="+yearHolidayId+"&bunit="+bunit);        
%>