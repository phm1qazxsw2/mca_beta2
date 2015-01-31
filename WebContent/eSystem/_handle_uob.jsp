<%@ page language="java" 
    import="web.*,jsf.*,java.util.*,incoming.*,phm.ezcounting.*,java.text.*,java.security.*,com.meterware.httpunit.*;
" 
    contentType="text/html;charset=UTF-8"%><%
try {
    System.setProperty("java.protocol.handler.pkgs",
       "com.sun.net.ssl.internal.www.protocol");
    Security.addProvider(new com.sun.net.ssl.internal.ssl.Provider());

    EzCountingService ezsvc = EzCountingService.getInstance();
    PaySystem2 ps = PaySystem2Mgr.getInstance().find("id=1");

    String vprefix = request.getParameter("v");

    WebConversation wc = new WebConversation();
    ClientProperties prop = wc.getClientProperties();
    prop.setUserAgent("Mozilla/4.0");
    WebRequest req = new PostMethodWebRequest("https://www.ubot.com.tw/va/System_va/Client_VA.asp?mode=1");
    req.setParameter("Power_Id", "33" + vprefix); 
    req.setParameter("Power_PWD", "693569");

    WebResponse resp = wc.getResponse(req);
    System.out.println(resp.getText());
    if (resp.getText().indexOf("vaindex.asp")<0) {
        ezsvc.sendWarningMessage("UOB登入有誤: http://" + request.getServerName() + request.getRequestURI());        
        return;
    }
    req = new PostMethodWebRequest("https://www.ubot.com.tw/va/System_va/VA_Company_SearchTxt.asp");
    req.setParameter("Se_ClassCode_1", "true");
    req.setParameter("Se_ClassCode_2", "true");
    req.setParameter("Se_ClassCode_3", "true");
    req.setParameter("Se_ClassCode_4", "true");
    req.setParameter("Se_ClassCode_6", "true");
    req.setParameter("Se_ClassCode_7", "true");
    Calendar c = Calendar.getInstance();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
    req.setParameter("Se_DateDown", sdf.format(c.getTime()));
    c.add(Calendar.DATE, -20); // 放假聯邦不處理，寧願多取一點
    req.setParameter("Se_DateUp", sdf.format(c.getTime()));
    resp = wc.getResponse(req);
    String content = resp.getText();
    if (content.indexOf("系統錯")>=0) {
        ezsvc.sendWarningMessage("UOB抓資料有誤: http://" + request.getServerName() + request.getRequestURI());
        return;
    }

    String[] lines = content.split("\n");
    // 聯邦的第一行永遠是 欄位名，跳過
    for (int i=1; lines!=null&&i<lines.length; i++) {
        if (lines[i].trim().length()==0)
            continue;
        ArrayList<MembrInfoBillRecord> fully_paid = new ArrayList<MembrInfoBillRecord>();
        BillPay bpay = ezsvc.doUOBBalance(lines[i], fully_paid);
        if (bpay==null) {
            out.println("skip_atm: " + lines[i]);
            continue;
        }
        out.println("done_atm: " + lines[i]);
        if (ps.getPaySystemMessageActive()==1 && bpay!=null) {
            ezsvc.sendSmsNotifications(ps, bpay, fully_paid);
        }
    }
}
catch (Exception e) {
    e.printStackTrace();
}
%>