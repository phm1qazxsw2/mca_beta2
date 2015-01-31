<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdffull = new SimpleDateFormat("yyyy/MM/dd HH:mm");
    SimpleDateFormat sdftime = new SimpleDateFormat("HH:mm");
    int boundType = Integer.parseInt(request.getParameter("boundType"));
    Date date = sdf.parse(request.getParameter("date"));
    int mid = Integer.parseInt(request.getParameter("mid"));
System.out.println("## boundType=" + boundType);
    Calendar c = Calendar.getInstance();
    c.setTime(date);
    c.add(Calendar.DATE, 1);
    Date d2 = c.getTime();
    Membr membr = MembrMgr.getInstance().find("id=" + mid);
    SchInfo info = SchInfo.getSchInfo(membr, date, d2);
    Map<Date, SchDef> boundMap = info.getBoundary(boundType, date);
    Iterator<Date> iter = boundMap.keySet().iterator();
    while (iter.hasNext()) {
        Date d = iter.next();
        SchDef sd = boundMap.get(d);
        out.println(sdffull.format(d)+","+sdftime.format(d)+","+sd.getName()+","+sd.getId());
    }
%>
