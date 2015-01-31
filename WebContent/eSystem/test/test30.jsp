<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,phm.accounting.*,literalstore.*,mca.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="../justHeader.jsp"%>
<%
    boolean commit = false;
    int tran_id = 0;
    try {           
        tran_id = dbo.Manager.startTransaction();

        McaInterest mi = new McaInterest(tran_id);
        ArrayList<MembrInfoBillRecord> bills = new MembrInfoBillRecordMgr(tran_id).retrieveList("ticketId='" +
            request.getParameter("tid") + "'", "");
        mi.setup(bills);
        ArrayList<Delta> deltas = mi.fixDeltas(bills.get(0));

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        out.println(bills.get(0).getTicketId() + "<br>");
        for (int i=0;i<deltas.size(); i++) {
            Delta dt = deltas.get(i);
            out.println(sdf.format(dt.date) + " type=" + dt.type + " amount=" + dt.amount + "<br>");
        }
        out.println("------------------<br>");

        StringBuffer sb = new StringBuffer();
        mi.calcLatefeeInterest(bills.get(0), new Date(), sb, ud2);
        out.println(sb.toString().replace("\n","<br>"));

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }    
%>done!