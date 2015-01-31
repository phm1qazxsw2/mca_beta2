<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,phm.accounting.*,literalstore.*" contentType="text/html;charset=UTF-8"%>
<%
    boolean commit = false;
    int tran_id = 0;
    try {           
        tran_id = dbo.Manager.startTransaction();

        VoucherService vsvc = new VoucherService(tran_id);
        VchrHolder salary_default = vsvc.getBillItemVoucher(VchrHolder.SALARY_BILLITEM_DEFAULT); // default
        VchrItemMgr vimgr = new VchrItemMgr(tran_id);
        vimgr.executeSQL("delete from vchr_item where vchrId=" + salary_default.getId());

        //現金
        boolean isSystem = true;
        // 薪資支出
        Acode a9 = vsvc.getAcode(VoucherService.SALARY_EXPENSE, null, "薪資支出", isSystem);
        // 應付費用
        Acode a8 = vsvc.getAcode("2147", null, "應付費用", isSystem);

        vsvc.addItem(0, salary_default, 0, a8.getId(), VchrItem.FLAG_CREDIT, -1, 0, 1, 0);
        vsvc.addItem(1, salary_default, 0, a9.getId(), VchrItem.FLAG_DEBIT, -1, 1, 0, 0);


        dbo.Manager.commit(tran_id);
        commit = true;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }    
%>done!