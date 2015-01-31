<%@ page language="java"  import="phm.ezcounting.*,phm.accounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="justHeader.jsp"%>
<%    
    boolean commit = false;
    int tran_id = 0;
    try {           
        tran_id = dbo.Manager.startTransaction();
        AcodeMgr amgr = new AcodeMgr(tran_id);
        int acodeId = Integer.parseInt(request.getParameter("a"));
        String name = request.getParameter("n");

        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
        Acode a = vsvc.modifyAcode(acodeId, name);
        AcodeInfo ainfo = AcodeInfo.getInstance(a, tran_id);

        out.print(a.getId()+":"+ainfo.getName(a));
        dbo.Manager.commit(tran_id);
        commit = true;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
%>
