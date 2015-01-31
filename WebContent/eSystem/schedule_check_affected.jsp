<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    try {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm");
        int mid = Integer.parseInt(request.getParameter("mid"));
        Date d1 = sdf.parse(request.getParameter("d1"));
        Date d2 = sdf.parse(request.getParameter("d2"));
        SchEvent e = new SchEvent();
        e.setMembrId(mid);
        e.setStartTime(d1);
        e.setEndTime(d2);
        ArrayList<SchEvent> tmp = new ArrayList<SchEvent>();
        tmp.add(e);
        SchEventInfo sinfo = new SchEventInfo(tmp);
        out.println(sinfo.getAffectedSchedules(e));
    }
    catch (Exception e) {}
%>
