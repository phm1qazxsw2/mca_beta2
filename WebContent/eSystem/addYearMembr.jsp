<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%

    float hours=(float)0.0;

    try{
        hours=Float.parseFloat(request.getParameter("mins"));
    }catch(Exception ex){}

    int yearHolidayId=Integer.parseInt(request.getParameter("yearHolidayId"));
    int membrId=Integer.parseInt(request.getParameter("membrId"));    
    int bunit=Integer.parseInt(request.getParameter("bunit"));    
    int year=Integer.parseInt(request.getParameter("year"));    


    int mins=(int)(hours*60);

    YearMembrMgr ymm=YearMembrMgr.getInstance();
    YearMembr ym=new YearMembr();
    ym.setCreated   	(new Date());
    ym.setMembrId   	(membrId);
    ym.setYearHolidayId   	(yearHolidayId);

    if(year==1)
        ym.setMins   	(mins);
    else
        ym.setOvertime   	(mins);
    ym.setUserId(ud2.getId());   
    ymm.create(ym);

    if(year==1)
        response.sendRedirect("listYearHoliday.jsp?yearHolidayId="+yearHolidayId+"&bunit="+bunit);
    else
        response.sendRedirect("listOvertime.jsp?yearHolidayId="+yearHolidayId+"&bunit="+bunit);    

%>