<%@ page language="java"  import="phm.ezcounting.*,phm.accounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file='justHeader.jsp'%>
<%
    int bid = Integer.parseInt(request.getParameter("bid"));

    boolean commit = false;
    int tran_id = 0;
    try {           
        tran_id = dbo.Manager.startTransaction();
        BillItemMgr bimgr = new BillItemMgr(tran_id);
        BillItem bi = bimgr.find("id=" + bid);

        bi.setTemplateVchrId(0);
        bimgr.save(bi);
        /*
        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
        VchrHolder v = vsvc.getBillItemVoucher(bi);
        if (v!=null) {
            v.setType(VchrHolder.TYPE_OBSOLETE);
            VchrHolderMgr vhmgr = new VchrHolderMgr(tran_id);
            vhmgr.save(v);
        }
        */

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }    
%>