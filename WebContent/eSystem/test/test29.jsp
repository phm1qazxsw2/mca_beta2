<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,phm.accounting.*,literalstore.*,mca.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="../justHeader.jsp"%>
<%
    boolean commit = false;
    int tran_id = 0;
    try {           
        tran_id = dbo.Manager.startTransaction();

        ArrayList<MembrBillRecord> bills = new MembrBillRecordMgr(tran_id).retrieveList("receivable=0","");

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }    
%>done!