<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,phm.accounting.*,literalstore.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="../justHeader.jsp"%>
<%
    boolean commit = false;
    int tran_id = 0;
    try {           
        tran_id = dbo.Manager.startTransaction();

        ArrayList<MembrInfoBillRecord> bills = new MembrInfoBillRecordMgr(tran_id).retrieveList("ticketId='98065324'", "");

        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
        vsvc.genVoucherForBills(bills, 0, "");

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }    
%>done!