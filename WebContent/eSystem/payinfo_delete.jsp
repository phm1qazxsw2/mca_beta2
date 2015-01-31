<%@ page language="java"  import="phm.ezcounting.*,mca.*,jsf.*,java.util.*,java.text.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2

    int tran_id = 0;
    boolean commit = false;
    try { 
        tran_id = Manager.startTransaction();
        Integer pid = Integer.parseInt(request.getParameter("pid"));
        BillPayMgr paymgr = new BillPayMgr(tran_id);
        Costpay2Mgr cpmgr = new Costpay2Mgr(tran_id);
        MembrInfoBillRecordMgr billmgr = new MembrInfoBillRecordMgr(tran_id);
        MembrBillRecordMgr mbrmgr = new MembrBillRecordMgr(tran_id);
        BillPaidMgr paidmgr = new BillPaidMgr(tran_id);

        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());

        // ## step1: update MembrBillRecord's paidStatus and received and possiblely pending
        BillPay pay = paymgr.find("id=" + pid);
        ArrayList<BillPaid> paids = paidmgr.retrieveList("billPayId=" + pay.getId(), "");
        Iterator<BillPaid> iter = paids.iterator();
        while (iter.hasNext()) {
            BillPaid paid = iter.next();
            MembrInfoBillRecord bill = billmgr.find("ticketId='" + paid.getTicketId() + "'");
            if (bill!=null) { // 有可能帳單被刪了
                bill.setReceived(bill.getReceived() - paid.getAmount());
                if (bill.getReceived()>0)
                    bill.setPaidStatus(MembrBillRecord.STATUS_PARTLY_PAID);
                else
                    bill.setPaidStatus(MembrBillRecord.STATUS_NOT_PAID);
                
                if (pay.getPending()==1) // 刪了就沒 pending 了
                    bill.setPending_cheque(0);
                mbrmgr.save(bill);
                // 傳票
                vsvc.genVoucherForBill(bill, ud2.getId(), "刪除繳費");
            }
            paid.setAmount(0); // 不刪了，設成0，傳票才會真確產生， __doBalanceSingle 會判斷有殼的話會先用
            paidmgr.save(paid);
        }
        // ## step2: delete all billpaid associated with this billpay
        // paidmgr.executeSQL("delete from billpaid where billPayId=" + pay.getId());

        // ## step3: if billpay has costpay (this is most cases except its cheque is not realized)
        
        boolean chequeNotSignificant = (pd2.getWorkflow()==4);
        if (pay.getPending()==0)
        {
            Costpay2 cp = cpmgr.find("costpayStudentAccountId=" + pay.getId());        
            if (cp==null) {  
                // 這里有可能是道禾支票的
                // 2009/1/13 peter, 道禾支票有可能沒有 costpay, 不要 throw exception
                if (!chequeNotSignificant)
                    throw new Exception("舊系統資料不可刪");
            }
            else {
                if (cp.getCostpayVerifyStatus()!=Costpay2.VERIFIED_NO)
                    throw new Exception("此筆記錄對應的現金帳戶狀態為已確認，不可刪");
                if (pay.getRefundCostPayId()>0) {
                    Costpay2 cp2 = cpmgr.find("id=" +  pay.getRefundCostPayId());
                    if (cp2.getCostpayVerifyStatus()!=Costpay2.VERIFIED_NO)
                        throw new Exception("此筆記錄對應的現金帳戶狀態為已確認，不可刪");
                    Object[] objs = { cp, cp2 }; // 收費和退費一起刪
SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
System.out.println("["+sdf.format(new Date())+"] #1# deleting costpay " + cp.getId() + "," + cp2.getId() + " by " + ud2.getUserLoginId());
                    cpmgr.remove(objs);
                    pay.setRefundCostPayId(0);
                }
                else {
                    Object[] objs = { cp };
SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
System.out.println("["+sdf.format(new Date())+"] #2# deleting costpay " + cp.getId() + " by " + ud2.getUserLoginId());
                    cpmgr.remove(objs);
                }
            }
            McaReceipt mr = new McaReceiptMgr(tran_id).find("costpayId=" + cp.getId());
            if (mr!=null) {
                Object[] objs = { mr };
                new McaReceiptMgr(tran_id).remove(objs);
            }            
        }

        // ## step4: 先產生 voucher, 不然等會 costpay 刪了產生 voucher 時就會出錯
        pay.setAmount(0);
        pay.setRemain(0);
        // ## 2009/3/2 刪除入帳日要和產生日一樣不然資產負債表怪怪
        // pay.setRecordTime(new Date()); // 傳票入帳日
        vsvc.genVoucherForBillPay(pay, ud2.getId(), "刪除付款");
        paymgr.save(pay);

        // 馬禮遜要連 billsource 一起刪
        BillSourceMgr bsrcmgr = new BillSourceMgr(tran_id);
        bsrcmgr.executeSQL("delete from billsource where id=" + pay.getBillSourceId());

        // ## step4: if billpay has check, delete it
        if (pay.getChequeId()>0) {
            new ChequeMgr(tran_id).executeSQL("delete from cheque where id=" + pay.getChequeId());
        }

        /*
        Object[] objs2 = { pay };
        paymgr.remove(objs2);
        */

        Manager.commit(tran_id);
        commit = true;

      %><script>alert("刪除成功!");window.location='<%=request.getParameter("backurl")%>';</script><%
    }
    catch (Exception e) {
        e.printStackTrace();
        if (!commit)
            try { Manager.rollback(tran_id); } catch (Exception ee) {}
        if (e.getMessage()!=null) {
      %><script>alert("<%=e.getMessage()%>");history.go(-1);</script><%
        }
    }    
%>
