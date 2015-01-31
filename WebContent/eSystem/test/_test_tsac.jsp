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
        ArrayList<MembrInfoBillRecord> fully_paid = new ArrayList<MembrInfoBillRecord>();
        if (lines[i].indexOf(ps.getPaySystemFirst5())<0)
        {
            ezsvc.sendWarningMessage("ATM銷帳 getPaySystemFirst5 [" + lines[i].substring(57,62).trim() + "] 和server["+ps.getPaySystemFirst5()+"]不同，沒有入帳\n" + lines[i] );
            continue;
        }
        BillPay bpay = ezsvc.doATMBalance(lines[i], fully_paid);
        if (bpay==null) {
            out.println("skip_atm: " + lines[i]);
            continue;
        }
        out.println("done_atm: " + lines[i]);
    }
}
catch(Exception e)
{
    e.printStackTrace();
}
%>