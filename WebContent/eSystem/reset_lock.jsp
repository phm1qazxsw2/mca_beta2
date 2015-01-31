<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%@ include file='/WEB-INF/jsp/security.jsp'%>
<%
    //##v2
    int brid=0, mid=0;
    try { brid = Integer.parseInt(request.getParameter("brid")); } catch (Exception e) {}
    try { mid = Integer.parseInt(request.getParameter("mid")); } catch (Exception e) {}

    MembrBillRecord mbr = MembrBillRecordMgr.getInstance().
        find("membrId=" + mid + " and billRecordId=" + brid);

    if (mbr.getPaidStatus()!=MembrBillRecord.STATUS_NOT_PAID)
        throw new Exception("帳單已繳費，不能解鎖");

    boolean commit = false;
    int tran_id = 0;
    try { 
        tran_id = Manager.startTransaction();
        MembrBillRecordMgr mbrmgr = new MembrBillRecordMgr(tran_id);
        mbr.setPrintDate(0);
        mbrmgr.save(mbr);
        commit = true;
        Manager.commit(tran_id);
    }
    finally {
        if (!commit)
            try { Manager.rollback(tran_id); } catch (Exception e2) {}  
    }

%>