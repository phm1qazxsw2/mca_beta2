<%@ page language="java"  
    import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,com.lowagie.text.*,com.lowagie.text.pdf.PdfPCell,com.lowagie.text.pdf.PdfPTable,com.lowagie.text.pdf.PdfWriter,com.lowagie.text.pdf.*,java.io.*,java.awt.Color,mca.*" 
    contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%@ include file="jumpTop.jsp"%>
<%
VPaid vp = VPaidMgr.getInstance().find("vitemId=" + request.getParameter("id"));
McaReceipt mpt = McaService.getReceipt(vp);

McaReceiptPrinter mr = null;
String fname = null;
try {
    ArrayList<String> tmp = new ArrayList<String>();
    tmp.add("123");

    mr = new McaReceiptPrinter(1, request.getRealPath("/"));
    mr.addReceipt(
        "RECEIPT",
        null,
        "MORRISON CHRISTIAN ASSOCIATION",
        null,
        "Box 3000, Haddonfield, New Jersey 08300-0968",
        "Federal Tax ID# 510194177",
        new Date(),
        "Peter Lin",
        tmp,
        tmp,
        tmp,
        "Jiunhau Lin",
        "BK12345",
        "Total:US$ ",
        false
        );
    
    mr.addReceipt(
        "NT. RECEIPT 收據",
        null,
        "MORRISON ACADEMY-BETHANY CAMPUS",
        "台北伯大尼美國學校",
        "地址: 臺北市汀州路3段97號",
        "TEL: (02)2365-9691  FAX:(02)2365-9696", 
        new Date(),
        "Peter Lin",
        tmp,
        tmp,
        tmp,
        "Jiunhau Lin",
        "BK12345",
        "Total:NT$ ",
        false
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