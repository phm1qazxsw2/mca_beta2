<%@ page language="java" 
    import="com.axiom.mgr.*,jsf.*,phm.ezcounting.*,dbo.*,java.util.*"
    contentType="text/html;charset=UTF-8"%>
<%

int i = 0;
int tran_id2 = 0;
try {
    tran_id2 = dbo.Manager.startTransaction();
    JsfTool jt = JsfTool.getInstance();
    ArrayList<MembrInfoBillRecord> bills = new MembrInfoBillRecordMgr(tran_id2).
        retrieveList("billType=" + Bill.TYPE_BILLING + " and printDate=0 and paidStatus=0", ""); // not yet printed
    Iterator<MembrInfoBillRecord> iter = bills.iterator();
    MembrBillRecordMgr mbrmgr = new MembrBillRecordMgr(tran_id2);
    while (iter.hasNext()) {
        MembrInfoBillRecord b = iter.next();
        String oldTicketId = b.getTicketId();
        i ++;
        if (oldTicketId.length()==9) {
            String newTicketId = jt.generateFeenumber(b.getMyBillDate());
            b.setTicketId(newTicketId);
            out.println(oldTicketId + " -> " + newTicketId + "<br>");
            mbrmgr.save(b);
        }
        else {
            out.println(oldTicketId + " already 8 <br>");
        }
    }
    dbo.Manager.commit(tran_id2);
}
finally {
    try { dbo.Manager.rollback(tran_id2); } catch (Exception ee) {}
}
%> 
<%=i%>




