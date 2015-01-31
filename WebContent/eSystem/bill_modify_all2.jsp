<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    if(!checkAuth(ud2,authHa,102))
    {
        response.sendRedirect("authIndex.jsp?code=102");
    }
    
    String ticketIds = request.getParameter("ticketIds");
    String comment = request.getParameter("comment").trim();
    Date billDate = sdf.parse(request.getParameter("billDate"));
    boolean overwrite = false;
    try { overwrite = request.getParameter("overwrite").equals("true"); } catch (Exception e) {}

    ArrayList<MembrInfoBillRecord> bills = MembrInfoBillRecordMgr.getInstance().
        retrieveList("ticketId in (" + ticketIds + ")", "");
    boolean commit = false;
    int tran_id = 0;
    try {           
        tran_id = dbo.Manager.startTransaction();
        BillCommentMgr bmgr = new BillCommentMgr(tran_id);
        MembrBillRecordMgr mbrmgr = new MembrBillRecordMgr(tran_id);

        for (int i=0; i<bills.size(); i++) {
            MembrInfoBillRecord r = bills.get(i);
            if (!r.getMyBillDate().equals(billDate)) {
                r.setBillDate(billDate);
                mbrmgr.save(r);
            }
            BillComment bc = bmgr.find("membrId=" + r.getMembrId() + " and billRecordId=" + r.getBillRecordId());
            if (bc!=null) {
                String orgcomment = bc.getComment();
                if (!orgcomment.equals(comment)) {
                    String newcomment = (overwrite)?comment:(orgcomment + "　" + comment);
                    bc.setComment(newcomment);
                    bmgr.save(bc);
                }
            }
            else {
                bc = new BillComment();
                bc.setMembrId(r.getMembrId());
                bc.setBillRecordId(r.getBillRecordId());
                bc.setComment(comment);
                bmgr.create(bc);
            }         
        }
        dbo.Manager.commit(tran_id);
        commit = true;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
%>
