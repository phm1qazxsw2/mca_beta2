<%@ page language="java"  
    import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,com.lowagie.text.*,com.lowagie.text.pdf.PdfPCell,com.lowagie.text.pdf.PdfPTable,com.lowagie.text.pdf.PdfWriter,com.lowagie.text.pdf.*,java.io.*,java.awt.Color,mca.*" 
    contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%@ include file="jumpTop.jsp"%>
<%
BillPay bpay = BillPayMgr.getInstance().find("id=" + request.getParameter("pid"));
String ticketId = request.getParameter("tid");
boolean prepay = false;
try {
    prepay = (Integer.parseInt(request.getParameter("a"))==2);
}
catch (Exception e) {}
McaReceiptHelper mh = new McaReceiptHelper(0, bpay, ticketId, prepay);


McaReceiptPrinter mr = null;
String fname = null;
try {
    ArrayList<String> acodelist = mh.getAcodeList();
    ArrayList<String> desclist = mh.getDescList();
    ArrayList<String> amountlist = mh.getAmountList();
    ArrayList<String> lines = mh.getHeaderLines();

    mr = new McaReceiptPrinter(1, request.getRealPath("/"));
	if ("US$".equals(mh.getCurrency())) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		ArrayList<McaExRate> rates = McaExRateMgr.getInstance().retrieveList("start<='"+
			sdf.format(bpay.getRecordTime())+"'", "order by start desc");
		desclist.add("Exchange rate US:NT = 1:" + rates.get(0).getRate());
	}
    mr.addReceipt(
        lines.get(0),
        lines.get(1),
        lines.get(2),
        lines.get(3),
        lines.get(4),
        lines.get(5),
        mh.getPaidDate(),
        mh.getPayerName(),
        acodelist,
        desclist,
        amountlist,
        mh.getReceiver(),
        mh.getReceiptNo(),
        "Total:" + mh.getCurrency() + ":" ,
        amountlist.get(0),
        mh.printDonationCorner()
        );
    
    fname = mr.getOutputFileName();
    //### end the mess
}
catch (Exception e) {
    e.printStackTrace();
    throw e;
}
finally {
    mr.close();
}
%>
<br>
<div class=es02>
&nbsp;&nbsp;&nbsp;<b>
<a target="_blank" href="../pdf_output/<%=fname%>" onclick="parent.receiptwin.hide();">下載收據</a>
</div>
