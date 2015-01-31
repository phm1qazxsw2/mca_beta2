<%@ page language="java"  import="phm.ezcounting.*,phm.accounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file='justHeader.jsp'%>
<%
    int bid = Integer.parseInt(request.getParameter("bid"));
    String stuff = request.getParameter("stuff");
    String[] lines = stuff.split("\n");

    boolean commit = false;
    int tran_id = 0;
    try {           
        tran_id = dbo.Manager.startTransaction();
        BillItemMgr bimgr = new BillItemMgr(tran_id);
        BillItem bi = bimgr.find("id=" + bid);

        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
        ArrayList<VchrItem> vitems = vsvc.parse(lines);
        vsvc.saveBillTemplate(bi, vitems, ud2.getId());

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }    
%>