<%@ page language="java"  
    import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,com.lowagie.text.*,com.lowagie.text.pdf.*,java.io.*" 
    contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    if(!AuthAdmin.authPage(ud2,4))
    {
        response.sendRedirect("authIndex.jsp?info=1&page=1");
        return;
    }
    String tid =  request.getParameter("tid");

    MembrInfoBillRecord sinfo = MembrInfoBillRecordMgr.getInstance().findX("ticketId='" + tid + "' and billType=" + Bill.TYPE_BILLING, _ws2.getAcrossBillBunitSpace("bill.bunitId"));

    if (sinfo==null) {
        %><script>alert("資料不存在");history.go(-1)</script><%
        return;
    }

    BillPay bpay = BillPayMgr.getInstance().find("id=" + request.getParameter("pid"));

    Document document = null;
    String fname = "";
    try {
        File toolDir = new File(request.getRealPath("/") + "/eSystem/pdf_example");
        ReceiptPrinter p = ReceiptPrinter.getPdfPrinter(toolDir);

        if(pd2.getPagetype()!=5){   
            document = new Document(PageSize.A4,15,15,10,10);
        }else{

            //道禾的收據
            Rectangle r=new Rectangle((float)610,(float)422);
            document = new Document(r,0,0,0,0);
            //document = new Document(PageSize.A4,15,15,10,10);
        }

        fname = new Date().getTime() + ".pdf";
        File outdir = new File(request.getRealPath("/"), "pdf_output");
        if (!outdir.exists()) {
            outdir.mkdir();
        }

        File testout = new File(outdir, fname);
        PdfWriter pdfwriter = PdfWriter.getInstance(document, new FileOutputStream(testout));
        pdfwriter.setViewerPreferences(PdfWriter.PageModeUseOutlines);
        document.open();
        p.printReceipt(sinfo, document, pdfwriter, 1, bpay);
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
<b>&nbsp;&nbsp;&nbsp;列印帳單</b>
 <table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  

<ul>
    <b>按下面連接下載收據</b>
    <br>
    <a href="../pdf_output/<%=fname%>">下載</a>
</ul>
<br>
<br>

