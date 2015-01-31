<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2

    
    int rid = Integer.parseInt(request.getParameter("rid"));
    int sid = Integer.parseInt(request.getParameter("sid"));
    String backurl = request.getParameter("backurl");

    MembrBillRecordMgr mbrmgr = MembrBillRecordMgr.getInstance();
    MembrBillRecord mbr = mbrmgr.find("billRecordId=" + rid + " and membrId=" + sid);
    if (mbr!=null && (mbr.getReceivable()-mbr.getReceived()==0) && mbr.getPaidStatus()!=MembrBillRecord.STATUS_FULLY_PAID)
    {
        mbr.setPaidStatus(MembrBillRecord.STATUS_FULLY_PAID);
        mbrmgr.save(mbr);
    }
    response.sendRedirect(backurl);
%>
