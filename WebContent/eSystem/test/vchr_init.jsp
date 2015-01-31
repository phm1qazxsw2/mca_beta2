<%@ page language="java" 
    import="dbo.*,phm.ezcounting.*,java.util.*,phm.accounting.*,java.text.*"
    contentType="text/html;charset=UTF-8"%>
<%
    boolean commit = false;
    int tran_id = 0;
    try {           
        tran_id = dbo.Manager.startTransaction();

        VoucherService vsvc = new VoucherService(tran_id);
        vsvc.init();

        //現金
        boolean isSystem = true;
        Acode c1 = vsvc.getAcode(VoucherService.CASH, null, "現金", isSystem);
        //支票
        Acode c2 = vsvc.getAcode(VoucherService.CHEQUE_RECEIVABLE, null, "應收票據", isSystem);
        //支票
        Acode c3 = vsvc.getAcode(VoucherService.CHEQUE_PAYABLE, null, "應付票據", isSystem);
        //學生帳戶
        Acode sa = vsvc.getAcode(VoucherService.STUDENT_ACCOUNT, null, "學生帳戶餘額", isSystem);
        //薪資帳戶
        Acode pa = vsvc.getAcode(VoucherService.PAYROLL_ACCOUNT, null, "薪資帳戶", isSystem);
        //其他應收
        Acode x1 = vsvc.getAcode(VoucherService.OTHER_ACCOUNT_RECEIVABLE, null, "其他應收", isSystem);
        //其他應付
        Acode x2 = vsvc.getAcode(VoucherService.OTHER_EXPENSE_PAYABLE, null, "其他應付", isSystem);
        //折扣
        Acode d = vsvc.getAcode(VoucherService.DISCOUNT, null, "折扣", isSystem);
        // "學費收入"
        Acode r1 = vsvc.getAcode(VoucherService.REVENUE, null, "學費收入", isSystem);
        // 應收帳款
        Acode a1 = vsvc.getAcode(VoucherService.INCOME_RECEIVABLE, null, "應收帳款", isSystem);
        // "代收款"
        Acode r6 = vsvc.getAcode(VoucherService.RECEIPTS_UNDER_CUSTODY, null, "補助款", isSystem);
        // 管理及總務費用
        Acode a7 = vsvc.getAcode("6200", null, "管理及總務費用", isSystem);
        // 應付費用
        Acode a8 = vsvc.getAcode("2147", null, "應付費用", isSystem);
        // 薪資支出
        Acode a9 = vsvc.getAcode(VoucherService.SALARY_EXPENSE, null, "薪資支出", isSystem);

        

        // billitem default 傳票
        VchrHolderMgr vhmgr = new VchrHolderMgr(tran_id);

        if (vsvc.getBillItemVoucher(VchrHolder.BILLITEM_DEFAULT)==null) {                    
            VchrHolder vdefault = vsvc.createBillItemVoucher(VchrHolder.BILLITEM_DEFAULT, 0);
            vsvc.addItem(0, vdefault, 0, r1.getId(), VchrItem.FLAG_CREDIT, -1, 0, 1, 0);  // 學費收入, 貸, 1
            vsvc.addItem(1, vdefault, 0, a1.getId(), VchrItem.FLAG_DEBIT, -1, 1, 0, 0);  // 學費應收, 借, 1
        }

        if (vsvc.getBillItemVoucher(VchrHolder.BILLITEM_TEMPRECEIPT)==null) {            
                // 學用品傳票 template
            VchrHolder v0 = vsvc.createBillItemVoucher(VchrHolder.BILLITEM_TEMPRECEIPT, 0);
            vsvc.addItem(0, v0, 0, r6.getId(), VchrItem.FLAG_CREDIT, -1, 0, 1, 0);  // 代收款, 貸, 1
            vsvc.addItem(1, v0, 0, a1.getId(), VchrItem.FLAG_DEBIT, -1, 1, 0, 0);  // 學費應收, 借, 1
        }

        if (vsvc.getBillItemVoucher(VchrHolder.SALARY_BILLITEM_DEFAULT)==null) {
            VchrHolder v = vsvc.createBillItemVoucher(VchrHolder.SALARY_BILLITEM_DEFAULT, 0);
            vsvc.addItem(0, v, 0, a8.getId(), VchrItem.FLAG_CREDIT, -1, 0, 1, 0);
            vsvc.addItem(1, v, 0, a9.getId(), VchrItem.FLAG_DEBIT, -1, 1, 0, 0);
        }

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }    
%>
<br>ok