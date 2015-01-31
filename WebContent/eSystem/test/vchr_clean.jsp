<%@ page language="java" 
    import="dbo.*,phm.ezcounting.*,java.util.*,phm.accounting.*,java.text.*,literalstore.*"
    contentType="text/html;charset=UTF-8"%>
<%
    boolean commit = false;
    int tran_id = 0;
    try {           
        tran_id = dbo.Manager.startTransaction();

        ArrayList<VchrItem> items = new VchrItemMgr(tran_id).retrieveList("", "");
        String threadIds = new RangeMaker().makeRange(items, "getThreadId");
        MembrBillRecordMgr mgrmgr = new MembrBillRecordMgr(tran_id);
        ArrayList<MembrBillRecord> mbrs = mgrmgr.retrieveList("threadId in (" + threadIds + ")", "");
        String membrIds = new RangeMaker().makeRange(mbrs, "getMembrId");
        String billRecordIds = new RangeMaker().makeRange(mbrs, "getBillRecordId");
        ArrayList<ChargeItem> chargeitems = new ChargeItemMgr(tran_id).retrieveList("billRecordId in (" + billRecordIds + ")", "");
        String chargeitemIds = new RangeMaker().makeRange(chargeitems, "getId");
        new ChargeMgr(tran_id).executeSQL("delete from charge where membrId in (" + membrIds + 
            ") and chargeItemId in (" + chargeitemIds + ")");
        new DiscountMgr(tran_id).executeSQL("delete from discount where membrId in (" + membrIds + 
            ") and chargeItemId in (" + chargeitemIds + ")");
        new FeeDetailMgr(tran_id).executeSQL("delete from feedetail where membrId in (" + membrIds + 
            ") and chargeItemId in (" + chargeitemIds + ")");        
        mgrmgr.executeSQL("delete from membrbillrecord where threadId in (" + threadIds + ")");
        new BillPayMgr(tran_id).executeSQL("delete from membrbillrecord where threadId in (" + threadIds + ")");
        new BillPaidMgr(tran_id).executeSQL("delete from membrbillrecord where threadId in (" + threadIds + ")");
        new BunitMgr(tran_id).executeSQL("delete from bunit");
        new VchrHolderMgr(tran_id).executeSQL("delete from vchr_holder");
        new VchrItemMgr(tran_id).executeSQL("delete from vchr_item");
        new AcodeMgr(tran_id).executeSQL("delete from acode");
        new LiteralMgr(tran_id).executeSQL("delete from literal");
        new VchrThreadMgr(tran_id).executeSQL("delete from vchr_thread");

        VoucherService.initialized = 0;
        dbo.Manager.commit(tran_id);
        commit = true;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }    
%>
<br>ok