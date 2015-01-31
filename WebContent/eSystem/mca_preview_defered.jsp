<%@ page language="java"  
    import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,com.lowagie.text.*,com.lowagie.text.pdf.*,java.io.*,mca.*" 
    contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    if(!checkAuth(ud2,authHa,102))
    {
        response.sendRedirect("authIndex.jsp?code=102");
    }

    //##v2
    String ticketId = request.getParameter("tid");

    PaySystem2 pSystem= PaySystem2Mgr.getInstance().find("id=1");

    PaymentPrinter p = null;

    boolean commit = false;
    int tran_id = 0;
    try {           
        // tran_id = dbo.Manager.startTransaction(); 這里不能 run transaction, PaymentPrinter 里不用 會 Deadlock

        ChargeItemMembrMgr cismgr = new ChargeItemMembrMgr(tran_id);
        MembrInfoBillRecordMgr snbrmgr = new MembrInfoBillRecordMgr(tran_id);
        MembrBillRecordMgr mbrmgr = new MembrBillRecordMgr(tran_id);

        MembrBillRecord tmpbill = mbrmgr.find("ticketId='" + ticketId + "'");
        EzCountingService ezsvc = EzCountingService.getInstance();
        tmpbill.setForcemodify(new Date().getTime());
        mbrmgr.save(tmpbill);
        MembrInfoBillRecord bill = snbrmgr.findX("ticketId='" + ticketId + "'",_ws2.getBunitSpace("bill.bunitId"));
        int regDeferred = new McaService(tran_id).setupDeferred(bill, 1, ud2.getId(), false);

        bill = snbrmgr.findX("ticketId='" + ticketId + "'", _ws2.getBunitSpace("bill.bunitId")); // 重讀一次

        ArrayList<ChargeItemMembr> charges = new ChargeItemMembrMgr(tran_id).retrieveList
            ("ticketId='" + ticketId + "'", "order by pos asc");
        Map<String, ArrayList<ChargeItemMembr>> chargeMap = new SortingMap(charges).doSortA("getTicketId");
        String chargeItemIds = new RangeMaker().makeRange(charges, "getChargeItemId");
        String membrIds = new RangeMaker().makeRange(charges, "getMembrId");
        ArrayList<Discount> discounts = new DiscountMgr(tran_id).retrieveList
            ("chargeItemId in (" + chargeItemIds + ") and membrId in (" + membrIds + ")", "");
        Map<String, ArrayList<Discount>> discountMap = new SortingMap(discounts).doSortA("getChargeKey");
        ArrayList<BillComment> comments = new BillCommentMgr(tran_id).retrieveList
            ("membrId="+bill.getMembrId()+" and billRecordId="+bill.getBillRecordId(), "");
        Map<String, ArrayList<BillComment>> commentMap = new SortingMap(comments).doSortA("getBillKey");
        BillRecord br = new BillRecordMgr(tran_id).find("id=" + bill.getBillRecordId());
        ArrayList<FeeDetail> fees = new FeeDetailMgr(tran_id).retrieveList
            ("chargeItemId in (" + chargeItemIds + ") and membrId=" + bill.getMembrId(), "");

        Map<String, ArrayList<FeeDetail>> feeMap = new SortingMap(fees).doSortA("getChargeKey");

        ArrayList<MembrInfoBillRecord> all_unpaid = snbrmgr.retrieveListX
            ("paidStatus in (0,1)", "", _ws2.getAcrossBillBunitSpace("bill.bunitId"));

        Map<String/*membrId#billId*/, ArrayList<MembrInfoBillRecord>> unpaidMap = 
            new SortingMap(all_unpaid).doSortA("getMembrId"); // 去掉 BillId 在 paymentprinter 內判斷, 和賬單同BillId
                                                       // 會算在 unpaidTotal, 不同的會放在 remark 內


        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        SimpleDateFormat sdf2 = new SimpleDateFormat("HHmmss");
        SimpleDateFormat sdf3 = new SimpleDateFormat("yyMM");

        boolean inSeparatePage = false;
        Bunit bunit = _ws2.getSessionBunit();
        p = PaymentPrinter.getPdfPrinter(br, chargeMap, discountMap, commentMap, feeMap, unpaidMap, 
            pSystem, bunit, inSeparatePage, request.getRealPath("/"));

        McaRecord mr = new McaRecordInfoMgr(tran_id).find("billRecordId=" + bill.getBillRecordId() 
            + " and mca_fee.status!=-1");
        McaFee fee = new McaFeeMgr(tran_id).find("id=" + mr.getMcaFeeId());
        ArrayList<MembrInfoBillRecord> tmp = new ArrayList<MembrInfoBillRecord>();
        tmp.add(bill);
        p.setupMcaStudent(fee, tmp);

        p.printPayment(bill, 1 , 1, ezsvc.getUserName(ud2.getId()));

        new McaService(tran_id).setupDeferred(bill, regDeferred, ud2.getId(), false);

        // dbo.Manager.commit(tran_id);
        commit = true;
    }
    catch (Exception e) {
        e.printStackTrace();
        throw e;
    }
    finally {
        //if (!commit)
        //    dbo.Manager.rollback(tran_id);
        if (p!=null) 
            p.close();
    }
%>
<body>
<% 
    String fname = p.getOutputFileName();
%>

<div class=es02>
&nbsp;&nbsp;&nbsp;<b>列印(下載PDF檔)</b>
<a href="javascript:history.go(-1)"><img src="pic/last.gif" border=0>&nbsp;回上一頁 </a> 
</div>

 <table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  

<br>
    <table width=100%>
        <tr>
            <td width=350 align=middle valign=top class=es02>
                <br>
                <br>
                <br>
                <img src="pic/printShow.png" border=0><br><br>
            </td>
            <td valign=top>
                <form action="../pdf_output/<%=fname%>">
                <input type=submit value="3 下載PDF">
                </form>
            
                <br>
                <div class=es02><b>帳單下載資訊:</b></div>
                <table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
                <tr align=left valign=top>
                <td bgcolor="#e9e3de">
                    <table width="100%" border=0 cellpadding=4 cellspacing=1>
                        <tr bgcolor=#f0f0f0 class=es02>
                        <td>狀態</td>
                        <tD bgcolor=ffffff>
                            已產生帳單,<a target="_blank" href="../pdf_output/<%=fname%>"><font color=blue>可下載</font></a>.
                        </tD>
                        </tr>

                        <tr bgcolor=#f0f0f0 class=es02>
                        <td>注意事項</td>
                        <tD bgcolor=ffffff>
                            <br>
                            <b>1.&nbsp;請確認你已安裝 Adobe Reader.</b><br>

                                &nbsp;&nbsp;&nbsp;如尚未安裝,請連至<a href="http://www.adobe.com/tw/products/acrobat/readstep2.html" target="_blank">Adobe 官方網站</a><a href="http://www.adobe.com/tw/products/acrobat/readstep2.html" target="_blank"><img src="pic/reader_icon_special.jpg" border=0 width=50></a>下載Adobe Reader.

                            <br><br><br>
                            <b>2.&nbsp;本批帳單已被鎖定<img src="pic/lockno2.png" border=0>.</b><br><br>
                            
                                &nbsp;&nbsp;&nbsp;為了確保你所發佈的帳單與系統的資料同步,系統已將此批帳單鎖定.
                                <br><br>
                                &nbsp;&nbsp;&nbsp;被鎖定的帳單將無法被編輯,如需修改,可經由帳單的主頁將鎖定解除.
                        </tD>
                        </tr>
                    </table>
                </td>
                </tr>
                </table>
        </td>
        </tr>
    </table>      
