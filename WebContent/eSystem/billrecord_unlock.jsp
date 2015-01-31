<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    if(!checkAuth(ud2,authHa,102))
    {
        response.sendRedirect("authIndex.jsp?code=102");
    }
    int rid = Integer.parseInt(request.getParameter("rid"));
    MembrBillRecordMgr mbrmgr = MembrBillRecordMgr.getInstance();
    mbrmgr.executeSQL("update membrbillrecord set printDate=0 where billRecordId=" + rid);
    response.sendRedirect(request.getParameter("backurl"));
%>
