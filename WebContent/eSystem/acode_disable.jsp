<%@ page language="java" import="phm.ezcounting.*,phm.accounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    boolean commit = false;
    int tran_id = 0;
    try {           
        tran_id = dbo.Manager.startTransaction();
        int aid = Integer.parseInt(request.getParameter("a"));

        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
        vsvc.disableAcode(aid);

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    catch (Exception e) {
        e.printStackTrace();
      %><script>alert("錯誤發生，設定沒有寫入");history.go(-1);</script><%
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
%>
