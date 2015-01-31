<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    if(!checkAuth(ud2,authHa,302))
    {
        response.sendRedirect("authIndex.jsp?code=302");
    }

    int tran_id = 0;
    boolean commit = false;
    try { 
        tran_id = Manager.startTransaction();
        Integer pid = Integer.parseInt(request.getParameter("pid"));
        BillPayMgr paymgr = new BillPayMgr(tran_id);
        Costpay2Mgr cpmgr = new Costpay2Mgr(tran_id);
        MembrBillRecordMgr mbrmgr = new MembrBillRecordMgr(tran_id);
        MembrInfoBillRecordMgr sinfomgr = new MembrInfoBillRecordMgr(tran_id);
        BillPaidMgr paidmgr = new BillPaidMgr(tran_id);

        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());

        BillPay pay = paymgr.find("id=" + pid);
        ArrayList<BillPaid> paids = paidmgr.retrieveList("billPayId=" + pay.getId(), "");
        Iterator<BillPaid> iter = paids.iterator();
        while (iter.hasNext()) {
            BillPaid paid = iter.next();
            MembrInfoBillRecord salary = sinfomgr.find("ticketId='" + paid.getTicketId() + "'");
            salary.setReceived(salary.getReceived() - paid.getAmount());
            if (salary.getReceived()>0)
                salary.setPaidStatus(MembrBillRecord.STATUS_PARTLY_PAID);
            else
                salary.setPaidStatus(MembrBillRecord.STATUS_NOT_PAID);
            mbrmgr.save(salary);
            // 傳票
            vsvc.genVoucherForSalary(salary, ud2.getId(), "刪除付薪");
            paid.setAmount(0); // 不刪了，設成0，傳票才會真確產生， __doBalanceSingle 會判斷有殼的話會先用
            paidmgr.save(paid);
        }
        // ## step2: delete all billpaid associated with this billpay
        //paidmgr.executeSQL("delete from billpaid where billPayId=" + pay.getId());

        // ## step3: 先產生 voucher, 不然等會 costpay 刪了產生 voucher 時就會出錯
        pay.setAmount(0);
        pay.setRemain(0);
        vsvc.genVoucherForSalaryPay(pay, ud2.getId(), "刪除付薪");
        paymgr.save(pay);
        
        Costpay2 cp = cpmgr.find("costpayStudentAccountId=" + pay.getId());
        if (cp==null)
            throw new Exception("舊系統資料不可刪");
        else if (cp.getCostpayVerifyStatus()!=Costpay2.VERIFIED_NO)
            throw new Exception("此筆記錄對應的現金帳戶狀態為已確認，不可刪");

        Object[] objs = { cp };
        cpmgr.remove(objs);
        //Object[] objs2 = { pay };
        //paymgr.remove(objs2);
        
        Manager.commit(tran_id);
        commit = true;
      %><script>alert("刪除成功!");location.href='salary_payinfo.jsp';</script><%
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
