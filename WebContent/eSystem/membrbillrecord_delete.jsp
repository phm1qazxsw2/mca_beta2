<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2


    String ticketId = request.getParameter("tid");
    String backurl = request.getParameter("backurl");

    EzCountingService ezsvc = EzCountingService.getInstance();
    int tran_id = 0;
    boolean commit = false;
    try { 
        tran_id = Manager.startTransaction();
        MembrBillRecordMgr sbrmgr = new MembrBillRecordMgr(tran_id);
        try {        
            Date nextFreezeDay = ezsvc.getFreezeNextDay(_ws2.getBunitSpace("bunitId"));
            ezsvc.deleteMembrBillRecord(tran_id, ticketId, ud2, nextFreezeDay);
            // 如果里面沒項目只是要刪 memmbrbillrecord, 那就會到這
            sbrmgr.executeSQL("delete from membrbillrecord where ticketId='" + ticketId + "'");
        }
        catch (Exception e) {
            if (e.getMessage()!=null&&e.getMessage().equals("z")) {
                MembrInfoBillRecord bill = new MembrInfoBillRecordMgr(tran_id).find("ticketId='" + ticketId + "'");
                VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
                vsvc.genVoucherForBill(bill, ud2.getId(), "刪除" + bill.getTicketId() + bill.getMembrName());
                sbrmgr.executeSQL("delete from membrbillrecord where ticketId='" + ticketId + "'");
            }
            else
                throw e;
        }

        Manager.commit(tran_id);
        commit = true;
      %><script>alert("刪除成功!");location.href='<%=backurl%>';</script><%
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
