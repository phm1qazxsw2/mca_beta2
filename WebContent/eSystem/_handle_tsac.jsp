<%@ page language="java" 
    import="web.*,jsf.*,java.util.*,incoming.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%><%
try
{
    String content = request.getParameter("content");
    if (content==null)
        return;
    // String exampleLine="00002068010002830620080312000009A183419ATM 95000       +C9548197030017100          009                    691883            W";		
    PaySystem2 ps = PaySystem2Mgr.getInstance().find("id=1");
    EzCountingService ezsvc = EzCountingService.getInstance();
    String[] lines = content.split("\n");
    for (int i=0; i<lines.length; i++) {
        if (lines[i].trim().length()==0)
            continue;
        String vAcctId = lines[i].substring(57,62).trim();  // 95681
        BunitHelper bh = new BunitHelper();
        Bunit bu = bh.getBunitFromVirtual(vAcctId);

        if (lines[i].indexOf(bh.getVirtualID(bu.getId()))<0)
        {
            ezsvc.sendWarningMessage("虛擬帳號前五碼 [" + vAcctId + "] 和server[" + bh.getVirtualID(bu.getId()) + "]不同，沒有入帳\n" + lines[i] );
            continue;
        }

        ArrayList<MembrInfoBillRecord> fully_paid = new ArrayList<MembrInfoBillRecord>();
        BillPay bpay = ezsvc.doATMBalance(lines[i], fully_paid);
        if (bpay==null) {
            out.println("skip_atm: " + lines[i]);
            continue;
        }
        if (ps.getPaySystemMessageActive()==1 && bpay!=null) {
            ezsvc.sendSmsNotifications(ps, bpay, fully_paid);
        }
        out.println("done_atm: " + lines[i]);
    }
}
catch(Exception e)
{
    e.printStackTrace();
}
%>