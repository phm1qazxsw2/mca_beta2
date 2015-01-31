<%@ page language="java" buffer="32kb"  import="web.*,jsf.*,phm.ezcounting.*,mca.*,java.lang.reflect.*,java.util.*,phm.accounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%@ include file="justHeader.jsp"%>	
<%
boolean commit = false;
int tran_id = 0;
try {           
    tran_id = dbo.Manager.startTransaction();

    McaService svc = new McaService(tran_id);
    McaFee org = svc.getActiveFee();

    McaFeeMgr feemgr = new McaFeeMgr(tran_id);
    McaFee fee = feemgr.find("id=" + request.getParameter("id"));
    // update BillRecord Title, Month and billDate if necessary
    ArrayList<McaRecord> mrs = new McaRecordMgr(tran_id).retrieveList("mcaFeeId=" + fee.getId(), "");

    if (mrs.size()>0) {
        BillRecordMgr brmgr = new BillRecordMgr(tran_id);
        ChargeMgr cmgr = new ChargeMgr(tran_id);
        ChargeItemMgr cimgr = new ChargeItemMgr(tran_id);
        DiscountMgr dmgr = new DiscountMgr(tran_id);
        FeeDetailMgr fmgr = new FeeDetailMgr(tran_id);
        VchrHolderMgr vhmgr = new VchrHolderMgr(tran_id);
        VchrThreadMgr vtmgr = new VchrThreadMgr(tran_id);
        VchrItemMgr vimgr = new VchrItemMgr(tran_id);
        for (int i=0; i<mrs.size(); i++) {
            int brId = mrs.get(i).getBillRecordId();
            MembrBillRecordMgr mbrmgr = new MembrBillRecordMgr(tran_id);
            if (mbrmgr.numOfRows("billRecordId=" + brId + " and paidStatus!=" + MembrBillRecord.STATUS_NOT_PAID)>0)
                throw new Exception("Some bills already paid, cannot delete");
            if (mbrmgr.numOfRows("billRecordId=" + brId + " and printDate>0")>0)
                throw new Exception("Some bills are locked, unlock them before delete");

            ArrayList<ChargeItem> citems = cimgr.retrieveList("billRecordId=" + brId, "");
            String citemIds = new RangeMaker().makeRange(citems, "getId");
            cmgr.executeSQL("delete from charge where chargeItemId in (" + citemIds + ")");
            dmgr.executeSQL("delete from discount where chargeItemId in (" + citemIds + ")");
            fmgr.executeSQL("delete from feedetail where chargeItemId in (" + citemIds + ")");
            cimgr.executeSQL("delete from chargeitem where id in (" + citemIds + ")");
            brmgr.executeSQL("delete from billrecord where id = " + brId);

            ArrayList<MembrBillRecord> bills = mbrmgr.retrieveList("billRecordId=" + brId, "");
            String threadIds = new RangeMaker().makeRange(bills, "getThreadId");
            // ###### 2009/3/12 下面這兩行非常重要， 不然會誤刪 _b_default 等樣板傳票 (因為 threadId=0) 
            ArrayList<VchrThread> threads = new VchrThreadMgr(tran_id).retrieveList("id in (" + threadIds + ")", "");
            if (threads.size()>0) {
                threadIds = new RangeMaker().makeRange(threads, "getId");
                vhmgr.executeSQL("delete from vchr_holder where threadId in (" + threadIds + ")");
                vimgr.executeSQL("delete from vchr_item where threadId in (" + threadIds + ")");
                vtmgr.executeSQL("delete from vchr_thread where id in (" + threadIds + ")");
            }
            mbrmgr.executeSQL("delete from membrbillrecord where billRecordId=" + brId);
        }
    }
    
    fee.setStatus(McaFee.STATUS_DELETED);
    feemgr.save(fee);

    // 要在設 McaFee.STATUS_DELETED 之後
    McaTagHelper th = new McaTagHelper(tran_id);
    th.deleteFeeTags(fee);

    McaFee cur = svc.getActiveFee();
    if (cur.getId()!=org.getId())
        svc.syncupMcaStudentWithTags(cur);

    dbo.Manager.commit(tran_id);
    commit = true;
}
catch (Exception e) {
    e.printStackTrace();
    if (e.getMessage()!=null) {
  %>@@<%=phm.util.TextUtil.escapeJSString(e.getMessage())%><%
    } else {
  %>@@Unknown error<%
    }
}
finally {
    if (!commit)
        dbo.Manager.rollback(tran_id);
}
%>

