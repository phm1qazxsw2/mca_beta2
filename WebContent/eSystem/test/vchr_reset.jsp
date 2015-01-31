<%@ page language="java" 
    import="dbo.*,phm.ezcounting.*,java.util.*,phm.accounting.*,java.text.*,literalstore.*"
    contentType="text/html;charset=UTF-8"%>
<%
    boolean commit = false;
    int tran_id = 0;
    try {           
        tran_id = dbo.Manager.startTransaction();

        new VchrThreadMgr(tran_id).executeSQL("delete from vchr_thread");
        ArrayList<VchrHolder> vchrs = new VchrHolderMgr(tran_id).retrieveList("type="+VchrHolder.TYPE_INSTANCE, "");
        String vchrIds = new RangeMaker().makeRange(vchrs, "getId");
        new VchrItemMgr(tran_id).executeSQL("delete from vchr_item where vchrId in (" + vchrIds + ")");
        new VchrHolderMgr(tran_id).executeSQL("delete from vchr_holder where type=" + VchrHolder.TYPE_INSTANCE);
        new MembrBillRecordMgr(tran_id).executeSQL("update membrbillrecord set threadId=0");
        new BillPayMgr(tran_id).executeSQL("update billpay set threadId=0");
        new BillPaidMgr(tran_id).executeSQL("update billpaid set threadId=0");
        new VitemMgr(tran_id).executeSQL("update vitem set threadId=0");
        new Costpay2Mgr(tran_id).executeSQL("update costpay set threadId=0");
        new ChequeMgr(tran_id).executeSQL("update cheque set threadId=0");

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }    
%>
done!