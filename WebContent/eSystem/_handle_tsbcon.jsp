<%@ page language="java" 
    import="web.*,jsf.*,java.util.*,incoming.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%><%
try
{
    String content = request.getParameter("content");
    if (content==null)
        return;        
    PaySystem2 ps = PaySystem2Mgr.getInstance().find("id=1");
    EzCountingService ezsvc = EzCountingService.getInstance();
    String[] lines = content.split("\n");
    for (int i=0; i<lines.length; i++) {
        if (lines[i].trim().length()==0)
            continue;
        String storeId = lines[i].substring(16,22).trim();  // JSM000, PHM001..
        BunitHelper bh = new BunitHelper();
        Bunit bu = bh.getBunitFromStoreID(storeId);

        ArrayList<MembrInfoBillRecord> fully_paid = new ArrayList<MembrInfoBillRecord>();
        if (storeId.indexOf(bh.getStoreID(bu.getId()))<0)
        {
            ezsvc.sendWarningMessage("便利商店銷帳 storenickname [" + storeId + "] 和server["+bh.getStoreID(bu.getId())+"]不同，沒有入帳\n" + lines[i] );
            continue;
        }
        BillPay bpay = ezsvc.doStoreBalance(lines[i], fully_paid);
        if (bpay==null) {
            out.println("skip_store: " + lines[i]);
            continue;
        }
        if (ps.getPaySystemMessageActive()==1 && bpay!=null) {
            ezsvc.sendSmsNotifications(ps, bpay, fully_paid);
        }
        out.println("done_store: " + lines[i]);
    }
}
catch(Exception e)
{
    e.printStackTrace();
}
%>