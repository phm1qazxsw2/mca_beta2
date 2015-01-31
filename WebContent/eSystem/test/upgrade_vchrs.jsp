<%@ page language="java" 
    import="dbo.*,phm.ezcounting.*,java.util.*,phm.accounting.*,java.text.*,jsf.*"
    contentType="text/html;charset=UTF-8"%>
<%
    boolean commit = false;
    int tran_id = 0;
    try {           
        tran_id = dbo.Manager.startTransaction();
        VoucherService vsvc = new VoucherService(tran_id);

System.out.println("## 1");        
        //## 產生學費帳單傳票
        ArrayList<MembrInfoBillRecord> bills = new MembrInfoBillRecordMgr(tran_id).retrieveList("billType="+Bill.TYPE_BILLING, "");
        vsvc.genVoucherForBills(bills, 0, null);

System.out.println("## 2");        
        //## 產生學費繳費傳票
        ArrayList<BillPay> billpays = new BillPayMgr(tran_id).retrieveList("via<10", ""); // 學費付款
System.out.println("## billpays.size=" + billpays.size());
        vsvc.genVoucherForBillPays(billpays, 0, "繳費");
System.out.println("## 3");        
        //## 產生薪資單傳票
        ArrayList<MembrInfoBillRecord> salaries = new MembrInfoBillRecordMgr(tran_id).retrieveList("billType="+Bill.TYPE_SALARY, "");
        vsvc.genVoucherForSalaries(salaries, 0, null);
System.out.println("## 4");        

        //## 產生薪資單付款傳票
        ArrayList<BillPay> salarypays = new BillPayMgr(tran_id).retrieveList("via in (100,101,102)", ""); // 薪資付款
        vsvc.genVoucherForSalaryPays(salarypays, 0, null);

System.out.println("## 5");        

        //## 產生雜費和學用品傳票
        ArrayList<Vitem> vitems = new VitemMgr(tran_id).retrieveList("", "");
System.out.println("## vitems.size=" + vitems.size());
        for (int i=0; i<vitems.size(); i++) {
            vsvc.genVoucherForVitem(vitems.get(i), 0, "");
        }

        ArrayList<VPaid> paids = new VPaidMgr(tran_id).retrieveList("", "");
        String costpay_ids = new RangeMaker().makeRange(paids, "getCostpayId");
        ArrayList<Costpay2> costpays = new Costpay2Mgr(tran_id).retrieveList("id in (" + costpay_ids + ")", "");
System.out.println("## size=" + costpays.size());
        for (int i=0; i<costpays.size(); i++)
            vsvc.genVoucherForVitemPay(costpays.get(i), 0, costpays.get(i).getCostpayLogPs());

        //## 產生內部轉帳傳票
        Object[] objs = jsf.InsidetradeMgr.getInstance().retrieve("", "");
        jsf.InsidetradeMgr imgr = jsf.InsidetradeMgr.getInstance();
        for (int i=0; objs!=null&&i<objs.length; i++)
            vsvc.genVoucherForInsideTransfer((jsf.Insidetrade)objs[i], imgr, 0);
       
        //## 產生支票傳票
        ArrayList<Cheque> cheques = new ChequeMgr(tran_id).retrieveList("", "");
        for (int i=0; i<cheques.size(); i++)
            vsvc.genVoucherForCheque(cheques.get(i), 0, cheques.get(i).getTitle());
    

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }    
%>
<br>done