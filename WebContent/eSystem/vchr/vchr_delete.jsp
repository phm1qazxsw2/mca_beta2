<%@ page language="java"  import="phm.ezcounting.*,phm.accounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="../justHeader.jsp"%>
<%
    boolean commit = false;
    int tran_id = 0;
    try {           
        tran_id = dbo.Manager.startTransaction();
        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());

        int id = Integer.parseInt(request.getParameter("id"));
        vsvc.deleteManualVoucher(id, ud2.getId());

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    catch (Exception e) {
        e.printStackTrace();
      %>@@錯誤發生資料沒有寫入<%
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
%>