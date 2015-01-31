<%@ page language="java" 
    import="dbo.*,phm.ezcounting.*,literalstore.*,java.util.*,phm.accounting.*,java.text.*"
    contentType="text/html;charset=UTF-8"%>
<%@ include file="../justHeader.jsp"%>
<%
    int threadId = Integer.parseInt(request.getParameter("thread"));
    VchrThread t = VchrThreadMgr.getInstance().find("id=" + threadId);
    
    if (t.getSrcType()==VchrThread.SRC_TYPE_BILL) {
System.out.println("## 1");
        String ticketId = t.getSrcInfo();
        MembrBillRecord bill = MembrBillRecordMgr.getInstance().find("ticketId='" + ticketId + "'");
        if (bill==null) {
          %><script>alert("找不到帳單，可能已被刪除");history.go(-1);</script><%
              return;
        }
        response.sendRedirect("../bill_detail.jsp?sid="+bill.getMembrId()+"&rid="+bill.getBillRecordId()+"&backurl=1");
    }
    else if (t.getSrcType()==VchrThread.SRC_TYPE_BILLPAY) {
System.out.println("## 2");
        ArrayList<BillPaid> paids = BillPaidMgr.getInstance().retrieveList("billPayId=" + t.getSrcInfo(), "");
        MembrBillRecord bill = MembrBillRecordMgr.getInstance().find("ticketId='" + paids.get(paids.size()-1).getTicketId() + "'");
        response.sendRedirect("../bill_detail.jsp?sid="+bill.getMembrId()+"&rid="+bill.getBillRecordId()+"&backurl=1");
    }
    else if (t.getSrcType()==VchrThread.SRC_TYPE_BILLPAID) {
System.out.println("## 3");
        String[] tokens = t.getSrcInfo().split("#");
        String ticketId = tokens[1];
        MembrBillRecord bill = MembrBillRecordMgr.getInstance().find("ticketId='" + ticketId + "'");
        response.sendRedirect("../bill_detail_express.jsp?sid="+bill.getMembrId()+"&rid="+bill.getBillRecordId()+"&backurl=1");
    }
%>