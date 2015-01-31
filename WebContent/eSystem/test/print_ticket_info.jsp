<%@ page language="java" 
    import="jsf.*,dbo.*,phm.ezcounting.*,java.util.*,phm.importing.*,java.text.*,java.lang.reflect.*"
    contentType="text/html;charset=UTF-8"%>
<%
    String monstr = request.getParameter("month");
    if (monstr==null) {
        out.println("沒有指定帳單月份 例如 month=2008-10-01");
        return;
    }

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    Date mon = sdf.parse(monstr);
    MembrInfoBillRecordMgr mbrmgr = MembrInfoBillRecordMgr.getInstance();
    ArrayList<MembrInfoBillRecord> bills = mbrmgr.retrieveList("billrecord.month='" + sdf.format(mon) + "'", "");
    if (bills.size()==0) {
        out.println("沒有任何帳單");
        return;
    }

    Iterator<MembrInfoBillRecord> iter = bills.iterator();
    PaySystem pSystem = (PaySystem) PaySystemMgr.getInstance().find(1);
    out.println("<pre>");
    out.println("姓名,金額,銷帳編號");
    while (iter.hasNext()) {
        MembrInfoBillRecord bill = iter.next();
        String floatingAccount = pSystem.getPaySystemFirst5().trim() + bill.getTicketId();
        out.println(bill.getMembrName() + "," + bill.getFinalAmount() + "," +
            PaymentPrinter.getVirtualAccountId(floatingAccount, bill.getFinalAmount(), pSystem));
    }
    out.println("</pre>");
%> 




