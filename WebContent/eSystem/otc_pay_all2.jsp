<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    int sid = Integer.parseInt(request.getParameter("sid"));
    String[] rid_values = request.getParameterValues("rid");
    StringBuffer sb = new StringBuffer();
    for (int i=0; i<rid_values.length; i++) {
        if (sb.length()>0) sb.append(",");
        sb.append(rid_values[i]);
    }    

    int tran_id = 0;
    boolean commit = false;
    try{	
        tran_id = Manager.startTransaction();

        MembrInfoBillRecordMgr simgr = new MembrInfoBillRecordMgr(tran_id);
        MembrMgr mmgr = new MembrMgr(tran_id);

        ArrayList<MembrInfoBillRecord> bills = simgr.
            retrieveListX("membrId=" + sid + " and billRecordId in (" + sb.toString() + ") and billType=" + Bill.TYPE_BILLING, "", _ws2.getAcrossBillBunitSpace("bill.bunitId"));
        // 要能付 cover 單位的帳單

        Membr membr = mmgr.find("id=" + sid);
        User user = WebSecurity.getInstance(pageContext).getCurrentUser();
        int via = 0;
        int amount = Integer.parseInt(request.getParameter("payMoney"));
            
        EzCountingService ezsvc = EzCountingService.getInstance();
        ArrayList<MembrInfoBillRecord> fully_paid = new ArrayList<MembrInfoBillRecord>();

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        BillPay bpay = null;
        int payway = Integer.parseInt(request.getParameter("paywayX")); 
        String reason = null;
        Date recordTime = sdf.parse(request.getParameter("recordTime"));

        int bunitId = 0;
        if (payway==0) { // 沖帳
            bunitId = ud2.getUserBunitAccounting();
            bpay = ezsvc.doManualBalance(tran_id, amount, membr, user, bills, BillPay.VIA_INPERSON, recordTime, fully_paid, bunitId);
        }
        else if (payway==1) { // 現金 
            int tradeAccountId = Integer.parseInt(request.getParameter("tradeAccount"));
            Tradeaccount ta = (Tradeaccount) ObjectService.find("jsf.Tradeaccount", "id=" + tradeAccountId);
            bunitId = ta.getBunitId();
            bpay = ezsvc.doManualBalance(tran_id, amount, membr, user, bills, BillPay.VIA_INPERSON, recordTime, fully_paid, bunitId);
            ezsvc.updateIncomeCostPay(tran_id, bpay, (int)amount, bpay.getRecordTime(), 1, ta.getId(), 
                payway, user.getId(), membr.getName(), bunitId);
            reason = "現金";
        }
        else if (payway==2) { // 支票
            String chequeId = request.getParameter("chequeId");
            Date cashDate = sdf.parse(request.getParameter("cashDate"));
            String issueBank = request.getParameter("issueBank");
            bunitId = ud2.getUserBunitAccounting(); //## 對管理多單位的行政來講，這張支票還是算在原單位
            bpay = ezsvc.doManualBalance(tran_id, amount, membr, user, bills, BillPay.VIA_CHECK, recordTime, fully_paid, bunitId);

            // 2009/1/13 peter, 道禾不想特別兌現 cheque 而要用傳票做
            boolean chequeNotSignificant = (pd2.getWorkflow()==4);

            // defer costpay, create a cheque record
            ChequeMgr cqmgr = new ChequeMgr(tran_id);
            Cheque cq = new Cheque();
            cq.setInAmount(amount);
            cq.setChequeId(chequeId);
            cq.setCashDate(cashDate);

            if (chequeNotSignificant) {
                cq.setCashed(cashDate);
            }

            cq.setType(Cheque.TYPE_INCOME_TUITION);
            cq.setTitle(membr.getName() + " 學費支票");
            cq.setRecordTime(recordTime);
            cq.setIssueBank(issueBank);
            cq.setBunitId(bunitId);
            cqmgr.create(cq);
            
            if (!chequeNotSignificant)
                bpay.setPending(1);

            bpay.setChequeId(cq.getId());
            BillPayMgr bpmgr = new BillPayMgr(tran_id);
            bpmgr.save(bpay);

            if (!chequeNotSignificant) {
                // bills that are paid by this check should set cashed to 0            
                boolean pending_cheque = true;
                ezsvc.updateBillPendingCheque(tran_id, bpay, pending_cheque);
            }
            reason = "支票";
        }
        else if (payway==3) { // 匯款
            int bankId = Integer.parseInt(request.getParameter("bankAccount"));
            BankAccount ba = (BankAccount) ObjectService.find("jsf.BankAccount", "id=" + bankId);
            bunitId = ba.getBunitId();
            bpay = ezsvc.doManualBalance(tran_id, amount, membr, user, bills, BillPay.VIA_WIRE, recordTime, fully_paid, bunitId);
            ezsvc.updateIncomeCostPay(tran_id, bpay, (int)amount, bpay.getRecordTime(), 2, ba.getId(), 
                payway, user.getId(), membr.getName(), bunitId);
            reason = "匯款";
        }
        else if (payway==4) { // 信用卡, 還沒寫 delay 進來。。現在馬上進銀行戶頭
            int bankId = Integer.parseInt(request.getParameter("bankAccount"));
            BankAccount ba = (BankAccount) ObjectService.find("jsf.BankAccount", "id=" + bankId);
            bunitId = ba.getBunitId();
            bpay = ezsvc.doManualBalance(tran_id, amount, membr, user, bills, BillPay.VIA_CREDITCARD, recordTime, fully_paid, bunitId);
            ezsvc.updateIncomeCostPay(tran_id, bpay, (int)amount, bpay.getRecordTime(), 2, ba.getId(), 
                payway, user.getId(), membr.getName(), bunitId);
            reason = "信用卡";
        }

        if (bpay!=null) {
            // 沖帳在 EzcountingService 里就處理了
System.out.println("## bunitId here = " + bunitId);
            VoucherService vsvc = new VoucherService(tran_id, bunitId);
            vsvc.genVoucherForBillPay(bpay, ud2.getId(), reason);
        }

        String note = request.getParameter("note");
        if (note!=null && note.trim().length()>0) {
            bpay.setNote(note);
            new BillPayMgr(tran_id).save(bpay);
        }

        Manager.commit(tran_id);
        commit = true;

        try {
            PaySystem2 ps = PaySystem2Mgr.getInstance().find("id=1");
            if (ps.getPaySystemMessageActive()==1 && bpay!=null) {
                ezsvc.sendSmsNotifications(ps, bpay, fully_paid);
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }

        if (bpay!=null && bpay.getRemain()>0) {
            ezsvc.sendWarningMessage("in person abnormal: 銷帳餘額：" + bpay.getRemain() + " billpay id=" + bpay.getId() + " uri=" + request.getRequestURI());
        }
%>
    <blockquote>
    <div class=es02>
    <font color=blue>        
        入帳成功
    </font>
    </div>
    </blockquote>
<% 
   }
    catch (Exception e) {
        e.printStackTrace();
      %><script>alert("有問題，銷帳不成功");history.go(-1);</script><%
    }
    finally {
        if (!commit)
            try { Manager.rollback(tran_id); } catch (Exception e2) {}  
    }
%>
