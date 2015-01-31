<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    int sid = Integer.parseInt(request.getParameter("sid"));

    int tran_id = 0;
    boolean commit = false;
    try{	
        tran_id = Manager.startTransaction();

        Membr membr = new MembrMgr(tran_id).findX("id=" + sid, _ws2.getStudentBunitSpace("bunitId"));

        User user = _ws2.getCurrentUser();
        int via = 0;
        int amount = Integer.parseInt(request.getParameter("payMoney"));
            
        EzCountingService ezsvc = EzCountingService.getInstance();

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        BillPay bpay = null;
        int payway = Integer.parseInt(request.getParameter("paywayX")); 
        String reason = null;
        Date recordTime = sdf.parse(request.getParameter("recordTime"));

        BillPayMgr bpmgr = new BillPayMgr(tran_id);
        bpay = new BillPay();
        bpay.setRecordTime(recordTime);
        bpay.setCreateTime(new Date());
        bpay.setAmount(amount);
        bpay.setUserId(user.getId()); // ftp done by system
        bpay.setBillSourceId(0);
        bpay.setMembrId(membr.getId());
        bpay.setRemain(amount);
        bpmgr.create(bpay);

        int bunitId = 0;
        if (payway==1) { // 現金 
            int tradeAccountId = Integer.parseInt(request.getParameter("tradeAccount"));
            Tradeaccount ta = (Tradeaccount) ObjectService.find("jsf.Tradeaccount", "id=" + tradeAccountId);
            bunitId = ta.getBunitId();
            bpay.setVia(BillPay.VIA_INPERSON); 
            ezsvc.updateIncomeCostPay(tran_id, bpay, (int)amount, bpay.getRecordTime(), 1, ta.getId(), 
                payway, user.getId(), membr.getName(), bunitId);
            reason = "現金";
        }
        else if (payway==2) { // 支票
            String chequeId = request.getParameter("chequeId");
            bunitId = ud2.getUserBunitAccounting();
            Date cashDate = sdf.parse(request.getParameter("cashDate"));
            String issueBank = request.getParameter("issueBank");
            bpay.setVia(BillPay.VIA_CHECK); 

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
            bunitId = ba.getBunitId(); // 帳戶 bunitId 有時和 user 有關 和現在使用誰的較無關
            bpay.setVia(BillPay.VIA_WIRE); 
            ezsvc.updateIncomeCostPay(tran_id, bpay, (int)amount, bpay.getRecordTime(), 2, ba.getId(), 
                payway, user.getId(), membr.getName(), bunitId);
            reason = "匯款";
        }
        else if (payway==4) { // 信用卡, 還沒寫 delay 進來。。現在馬上進銀行戶頭
            int bankId = Integer.parseInt(request.getParameter("bankAccount"));
            BankAccount ba = (BankAccount) ObjectService.find("jsf.BankAccount", "id=" + bankId);
            bunitId = ba.getBunitId(); // 帳戶 bunitId 有時和 user 有關 和現在使用誰的較無關
            bpay.setVia(BillPay.VIA_CREDITCARD); 
            ezsvc.updateIncomeCostPay(tran_id, bpay, (int)amount, bpay.getRecordTime(), 2, ba.getId(), 
                payway, user.getId(), membr.getName(), bunitId);
            reason = "信用卡";
        }

        String note = request.getParameter("note");
        if (note==null) {
            note = "";
        }

        bpay.setNote("(預收)" + note);
        bpay.setBunitId(bunitId);
        bpmgr.save(bpay);

        if (bpay!=null) {
            // 沖帳在 EzcountingService 里就處理了
            VoucherService vsvc = new VoucherService(tran_id, bunitId);
            vsvc.genVoucherForBillPay(bpay, ud2.getId(), reason);
        }

        Manager.commit(tran_id);
        commit = true;

        try {
            PaySystem2 ps = PaySystem2Mgr.getInstance().find("id=1");
            if (ps.getPaySystemMessageActive()==1 && bpay!=null) {
                ArrayList<MembrInfoBillRecord> fully_paid = new ArrayList<MembrInfoBillRecord>();
                ezsvc.sendSmsNotifications(ps, bpay, fully_paid);
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }

%>
    <blockquote>
    <div class=es02>
    <font color=blue>        
        入帳成功
    </font>
    </div>
    </blockquote>
    <script>
        parent.do_reload = true;
    </script>

<% 
   }
    catch (Exception e) {
        e.printStackTrace();
      %><script>alert("有問題，繳款不成功");history.go(-1);</script><%
    }
    finally {
        if (!commit)
            try { Manager.rollback(tran_id); } catch (Exception e2) {}  
    }
%>
