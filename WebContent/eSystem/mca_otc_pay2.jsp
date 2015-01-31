<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,dbo.*,mca.*" contentType="text/html;charset=UTF-8"%>
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
        int currency = Integer.parseInt(request.getParameter("currency"));

        String checkInfo = request.getParameter("checkInfo");
        double amount = Double.parseDouble(request.getParameter("payMoney"));
        double org_amount = amount;
        double exrate = 0;
            
        EzCountingService ezsvc = EzCountingService.getInstance();
        ArrayList<MembrInfoBillRecord> fully_paid = new ArrayList<MembrInfoBillRecord>();

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        BillPay bpay = null;
System.out.println("## 1");
        int payway = Integer.parseInt(request.getParameter("paywayX")); 
        String reason = null;
System.out.println("## 2");
        Date recordTime = sdf.parse(request.getParameter("recordTime"));

        ArrayList<McaExRate> rates = McaExRateMgr.getInstance().retrieveList
            ("start<='" + sdf.format(recordTime) + "'","order by start desc");
        if (currency==1 && rates.size()==0)
            throw new Exception("No exchange rate reference");
        int exRateId = 0;

        if (currency==1) {
            exRateId = rates.get(0).getId();
            exrate = rates.get(0).getRate();
            amount = Math.round(exrate * org_amount);
        }
        else {
            org_amount = 0;
            exRateId = 0;
            exrate = 0;
        }

        int bunitId = 0;
        if (payway==0) { // 沖帳
            bunitId = ud2.getUserBunitAccounting();
            bpay = ezsvc.doManualBalance(tran_id, (int)Math.round(amount), membr, user, bills, BillPay.VIA_INPERSON, recordTime, fully_paid, bunitId);
        }
        else if (payway==1 || payway==2) { 
            int tradeAccountId = Integer.parseInt(request.getParameter("tradeAccount"));
            Tradeaccount ta = (Tradeaccount) ObjectService.find("jsf.Tradeaccount", "id=" + tradeAccountId);
            bunitId = ta.getBunitId();

            int billpayType = 0;
            int acctType = 0;
            int acctId = 0;
            if (payway==1) {
                acctType = (currency==0)?1: Costpay2.ACCOUNT_TYPE_USD_CASH;
                reason = "現金";
                billpayType = BillPay.VIA_INPERSON;
            }
            else if (payway==2) {
                acctType = (currency==0)?3:Costpay2.ACCOUNT_TYPE_USD_CHECK;
                reason = "支票";
                billpayType = BillPay.VIA_CHECK;
            }

            bpay = ezsvc.doManualBalance(tran_id, (int)Math.round(amount), membr, user, bills, billpayType, recordTime, fully_paid, bunitId);            

            ezsvc.updateIncomeCostPay(tran_id, bpay, (int)Math.round(amount), bpay.getRecordTime(), acctType, ta.getId(), 
                payway, user.getId(), membr.getName(), bunitId, org_amount, exRateId, exrate, 
                checkInfo);
        }
        else if (payway==3 || payway==4) { // 匯款
            int bankId = Integer.parseInt(request.getParameter("bankAccount"));
            BankAccount ba = (BankAccount) ObjectService.find("jsf.BankAccount", "id=" + bankId);
            bunitId = ba.getBunitId();
            int billpayType = (payway==3)?BillPay.VIA_WIRE:BillPay.VIA_CREDITCARD;
            bpay = ezsvc.doManualBalance(tran_id, (int)Math.round(amount), membr, user, bills, billpayType, recordTime, fully_paid, bunitId);

            ezsvc.updateIncomeCostPay(tran_id, bpay, (int)Math.round(amount), bpay.getRecordTime(), 2, ba.getId(), 
                payway, user.getId(), membr.getName(), bunitId, org_amount, exRateId, exrate, 
                checkInfo);
            reason = "匯款";
        }       

        if (bpay!=null) {
            // 沖帳在 EzcountingService 里就處理了
            VoucherService vsvc = new VoucherService(tran_id, bunitId);
            vsvc.genVoucherForBillPay(bpay, ud2.getId(), reason);
        }

        String note = request.getParameter("note");
        if (note!=null && note.trim().length()>0) {
            if (bpay!=null) { // 沖賬可能不會有 bpay
                bpay.setNote(note);
                new BillPayMgr(tran_id).save(bpay);
            }
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
