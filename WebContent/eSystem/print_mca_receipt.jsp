<%@ page language="java"  
    import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,com.lowagie.text.*,com.lowagie.text.pdf.PdfPCell,com.lowagie.text.pdf.PdfPTable,com.lowagie.text.pdf.PdfWriter,com.lowagie.text.pdf.*,java.io.*,java.awt.Color,mca.*" 
    contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%@ include file="jumpTop.jsp"%>
<%
VPaid vp = VPaidMgr.getInstance().findX("vitemId=" + request.getParameter("id"), _ws2.getBunitSpace("bunitId"));
McaReceiptHelper mh = new McaReceiptHelper(0, vp);


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
		VPaidItem vi = VPaidItemMgr.getInstance().find("vitem.id=" + vp.getVitemId());
		ArrayList<McaExRate> rates = McaExRateMgr.getInstance().retrieveList("start<='"+
			sdf.format(vi.getRecordTime())+"'", "order by start desc");
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
下載收據</b>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:history.go(-1)"><img src="pic/last.gif" border=0>&nbsp;回上一頁 </a>
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
                <div class=es02><b>收據下載資訊:</b></div>
                <table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
                <tr align=left valign=top>
                <td bgcolor="#e9e3de">
                    <table width="100%" border=0 cellpadding=4 cellspacing=1>
                        <tr bgcolor=#f0f0f0 class=es02>
                        <td>狀態</td>
                        <tD bgcolor=ffffff>
                            已產生收據,<a target="_blank" href="../pdf_output/<%=fname%>"><font color=blue>可下載</font></a>.
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