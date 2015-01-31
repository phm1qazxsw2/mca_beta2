<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,cardreader.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    String d=request.getParameter("d");
    int bunit=-1;
    String bunitS=request.getParameter("bunit");
    try{
        bunit=Integer.parseInt(bunitS);
    }catch(Exception ex){}
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    Date runDate=sdf.parse(d);

    
    SchEventAuto se=new SchEventAuto(runDate,ud2.getId(),bunit);
    //SchEventAuto se=new SchEventAuto(runDate,ud2.getId());
    if(bunit ==-1)
        response.sendRedirect("schedule_daily.jsp?d="+sdf.format(runDate));
    else
        response.sendRedirect("schedule_daily.jsp?d="+sdf.format(runDate)+"&bunit="+bunitS);
%>
