<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%

    String ticketId = request.getParameter("tid");
    int payId = Integer.parseInt(request.getParameter("pid"));
    int refund = Integer.parseInt(request.getParameter("refund"));
    String backurl = request.getParameter("backurl");

    int tran_id = 0;
    boolean commit = false;
    try { 
        tran_id = Manager.startTransaction();
        BillPaidMgr paidmgr = new BillPaidMgr(tran_id);
        BillPayMgr paymgr = new BillPayMgr(tran_id);
        MembrBillRecordMgr mbrmgr = new MembrBillRecordMgr(tran_id);

        BillPaid paid = paidmgr.find("billPayId=" + payId + " and ticketId='" + ticketId + "'");
        BillPay pay = paymgr.find("id=" + payId);
        MembrBillRecord mbr = mbrmgr.find("ticketId='" + ticketId + "'");

        pay.setRemain(pay.getRemain() + refund);
        paymgr.save(pay);

        int remain = mbr.getReceived() - refund;
        mbr.setReceived(remain);
        if (remain>0)
            mbr.setPaidStatus(MembrBillRecord.STATUS_PARTLY_PAID);
        else if (remain==0)
            mbr.setPaidStatus(MembrBillRecord.STATUS_NOT_PAID);
        mbrmgr.save(mbr);

        if (refund > paid.getAmount())
            throw new Exception("金額大於可轉費用");

        if (refund <= paid.getAmount()) {
            paid.setRecordTime(new Date()); // make sure voucher time is now
            paid.setAmount(paid.getAmount() - refund);
            paidmgr.save(paid);
        }
        /*
        else {
            Object[] to_delete = { paid };
            paidmgr.remove(to_delete);
        }
        */

        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
        vsvc.genVoucherForBillPay(pay, ud2.getId(), "轉至學生帳戶");

        Manager.commit(tran_id);
        commit = true;        
    }
    catch (Exception e) {
        e.printStackTrace();
        if (!commit)
            try { Manager.rollback(tran_id); } catch (Exception ee) {}
        if (e.getMessage()!=null) {
      %><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>');history.go(-1);</script><%
        }
        else {
      %><script>alert("錯誤發生，設定沒有寫入");history.go(-1);</script><%
        }
    }    
%>
<blockquote>
轉帳成功
</blockquote>