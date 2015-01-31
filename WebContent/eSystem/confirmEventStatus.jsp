<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%

    String[] eID=request.getParameterValues("eId");
    SchEventMgr sem=SchEventMgr.getInstance();

    for(int i=0;eID !=null && i<eID.length; i++){
        SchEvent se=sem.find("id='"+eID[i]+"'");
        se.setStatus(SchEvent.STATUS_PERSON_CONFORM);
        se.setVerifyDate(new Date());
        se.setVerifyUserId(ud2.getId());
        sem.save(se);
    }
    String queryString=request.getParameter("queryString");

    response.sendRedirect("schedule_event_membr.jsp?"+queryString);
%>
