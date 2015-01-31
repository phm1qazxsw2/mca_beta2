<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,mca.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="justHeader.jsp"%>
<%
try {
    int mpId = Integer.parseInt(request.getParameter("id"));
    McaProrateMgr mpmgr = McaProrateMgr.getInstance();
    McaProrate mp = mpmgr.find("id=" + mpId);
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    Date d = sdf.parse(request.getParameter("d"));
    mp.setProrateDate(d);
    mpmgr.save(mp);
} 
catch (Exception e) {
  %>@@error occurs, nothing changed<%
}
%>
