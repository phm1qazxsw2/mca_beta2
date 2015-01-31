<%@ page language="java"  
    import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,com.lowagie.text.*,com.lowagie.text.pdf.*,java.io.*" 
    contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    if(!checkAuth(ud2,authHa,300))
    {
        response.sendRedirect("authIndex.jsp?code=300");
    }
%>
<%
    //##v2

    String tid =  request.getParameter("tid");

    MembrInfoBillRecord sinfo = MembrInfoBillRecordMgr.getInstance().find("ticketId='" + tid + "' and billType=" + Bill.TYPE_SALARY + " and privLevel>=" + ud2.getUserRole());

    Document document = null;
    String fname = "";
    try {
        File toolDir = new File(request.getRealPath("/") + "/eSystem/pdf_example");
        ArrayList<ChargeItemMembr> charges = ChargeItemMembrMgr.getInstance().retrieveList
            ("ticketId in (" + sinfo.getTicketId() + ")", "");
        Map<String, Vector<ChargeItemMembr>> chargeMap = new SortingMap(charges).doSort("getTicketId");
        String chargeItemIds = new RangeMaker().makeRange(charges, "getChargeItemId");
        String membrIds = new RangeMaker().makeRange(charges, "getMembrId");
        ArrayList<FeeDetail> fees = FeeDetailMgr.getInstance().retrieveList
            ("chargeItemId in (" + chargeItemIds + ") and membrId in (" + membrIds + ")", "");
        Map<String, Vector<FeeDetail>> feeMap = new SortingMap(fees).doSort("getChargeKey");

        SalarySlipPrinter p = SalarySlipPrinter.getPdfPrinter(toolDir, chargeMap, feeMap);
        document = new Document(PageSize.A4,15,15,10,10);
        fname = new Date().getTime() + ".pdf";
        File outdir = new File(request.getRealPath("/"), "pdf_output");
        if (!outdir.exists()) {
            outdir.mkdir();
        }


        File testout = new File(outdir, fname);
        PdfWriter pdfwriter = PdfWriter.getInstance(document, new FileOutputStream(testout));
        pdfwriter.setViewerPreferences(PdfWriter.PageModeUseOutlines);
        document.open();

        String remark = null;
        BillComment bc = BillCommentMgr.getInstance().find
            ("membrId=" + sinfo.getMembrId() + " and billRecordId=" + sinfo.getBillRecordId());
        if (bc!=null)
            remark = bc.getComment();

        p.printSalarySlip(sinfo, document, pdfwriter, 1, chargeMap, feeMap, remark);
    }
    catch (Exception e) {
        e.printStackTrace();
        throw e;
    }
    finally {
        if (document!=null)
            document.close();
    }
%>
<body>
<br>
<div class=es02>
&nbsp;&nbsp;&nbsp;<b>列印薪資條</b>
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
                <input type=submit value="下載PDF">
                </form>
            
                <br>
                <div class=es02><b>薪資條下載資訊:</b></div>
                <table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
                <tr align=left valign=top>
                <td bgcolor="#e9e3de">
                    <table width="100%" border=0 cellpadding=4 cellspacing=1>
                        <tr bgcolor=#f0f0f0 class=es02>
                        <td>狀態</td>
                        <tD bgcolor=ffffff>
                            已產生薪資條,<a href="../pdf_output/<%=fname%>"><font color=blue>可下載</font></a>.
                        </tD>
                        </tr>

                        <tr bgcolor=#f0f0f0 class=es02>
                        <td>注意事項</td>
                        <tD bgcolor=ffffff>
                            <br>
                            <b>1.&nbsp;請確認你已安裝 Adobe Reader.</b><br>

                                &nbsp;&nbsp;&nbsp;如尚未安裝,請連至<a href="http://www.adobe.com/tw/products/acrobat/readstep2.html" target="_blank">Adobe 官方網站</a><a href="http://www.adobe.com/tw/products/acrobat/readstep2.html" target="_blank"><img src="pic/reader_icon_special.jpg" border=0 width=50></a>下載Adobe Reader.
                            <br><br><br> 
                        </tD>
                        </tr>
                    </table>
                </td>
                </tr>
                </table>
        </td>
        </tr>
    </table>      

<br>
<br>
</body>
