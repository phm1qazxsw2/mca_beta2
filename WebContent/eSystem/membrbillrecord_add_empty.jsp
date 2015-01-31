<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    int brid = Integer.parseInt(request.getParameter("brId"));
    int mid =  Integer.parseInt(request.getParameter("membrId"));

    boolean commit = false;
    int tran_id = 0;
    try {           
        tran_id = dbo.Manager.startTransaction();

        BillRecord br = new BillRecordMgr(tran_id).find("id=" + brid);
        EzCountingService ezsvc = EzCountingService.getInstance();
        MembrBillRecordMgr mbrmgr = new MembrBillRecordMgr(tran_id);
        ezsvc.makeMembrBillRecord(mbrmgr, mid, br);


        dbo.Manager.commit(tran_id);
        commit = true;

        MembrInfoBillRecord sinfo = MembrInfoBillRecordMgr.getInstance().find("membrId=" + mid + " and billRecordId=" + 
        brid + " and billType=" + Bill.TYPE_BILLING);

System.out.println("## sinfo=" + sinfo.getTicketId() + " membrId=" + mid + " and billRecordId=" + 
        brid + " and billType=" + Bill.TYPE_BILLING);
        
        response.sendRedirect("bill_detail_express.jsp?rid=" + brid + "&sid=" + mid + "&backurl=1");
    }
    catch (Exception e) {
        if (e.getMessage()!=null && e.getMessage().indexOf("Duplicate")>=0) {
          %><script>alert('已有帳單，請重新整理網頁就會看到');history.go(-1);</script><%
        }
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
%>
