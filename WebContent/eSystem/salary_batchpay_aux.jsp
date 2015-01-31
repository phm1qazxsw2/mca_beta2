<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*,java.util.*" contentType="text/html;charset=UTF-8"%>
<%
    //##v2
    request.setCharacterEncoding("UTF-8");
    int rid = Integer.parseInt(request.getParameter("rid"));
    String t = request.getParameter("t");

    ArrayList<MembrBillRecord> bills = MembrBillRecordMgr.getInstance().
        retrieveList("billRecordId=" + rid + " and paidStatus="+MembrBillRecord.STATUS_NOT_PAID, "");
    Iterator<MembrBillRecord> iter = bills.iterator();
    StringBuffer sb = new StringBuffer();
    while (iter.hasNext()) {
        MembrBillRecord r = iter.next();
        if (sb.length()>0) sb.append(',');
        sb.append(r.getMembrId() + "#" + r.getBillRecordId());
    }
%>

<form name=f1 action="salary_batchpay.jsp" method=post>
<input type=hidden name=backurl value="salaryoverview.jsp">
<input type=hidden name=o value="<%=sb.toString()%>">
<% if (t!=null) { %>
<input type=hidden name=t value="<%=t%>">
<% } %>
</form>
