<%@ page language="java"  
    import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,com.lowagie.text.*,com.lowagie.text.pdf.PdfPCell,com.lowagie.text.pdf.PdfPTable,com.lowagie.text.pdf.PdfWriter,com.lowagie.text.pdf.*,java.io.*,java.awt.Color" 
    contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%@ include file="jumpTop.jsp"%>
<%!
    static SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM");
    static SimpleDateFormat sdf2=new SimpleDateFormat("yyyy-MM-dd");
    static SimpleDateFormat sdf3=new SimpleDateFormat("yyyy-MM-dd HH:mm");
    static SimpleDateFormat sdf4=new SimpleDateFormat("yyyy/MM/dd");

    PdfPTable getOnePTable(Font[] f_chinese,Font[] f_chinese_b,Font[] f_times,Font[] f_times_b,Font[] f_underline,
        String line1, String line2, String line3, String line4,
        String addr1, String addr2, Date recordTime, String receivedFrom,
        ArrayList<String> acctcodes, ArrayList<String> descriptions, ArrayList<String> amounts,
        String receivedBy, String receiptNo, String totalStr, boolean printCorner)
    {
        float[] widths2 = {1.00f};
        PdfPTable tableItem = new PdfPTable(widths2);

        Paragraph px=new Paragraph();
        px.add(new Chunk("\n\n\n",f_times[0]));
        if (line1!=null)
            px.add(new Chunk(line1 + "\n",f_chinese_b[0]));
        if (line2!=null)
            px.add(new Chunk(line2 + "\n",f_chinese_b[0]));

        PdfPCell cell = new PdfPCell(px);
        cell.setBorderColor(new Color(255, 255, 255));
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        tableItem.addCell(cell);

        px=new Paragraph();
        if (line3!=null)
            px.add(new Chunk(line3 + "\n",f_times_b[1]));
        if (line4!=null)
            px.add(new Chunk(line4 + "\n",f_chinese_b[1]));

        cell = new PdfPCell(px);
        cell.setBorderColor(new Color(255, 255, 255));
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        tableItem.addCell(cell);

        String addressSpace="                 ";
        px=new Paragraph();
        if (addr1!=null)
            px.add(new Chunk(addr1 + "\n",f_chinese[2]));
        if (addr2!=null)
            px.add(new Chunk(addr2 + "\n",f_times[2]));
        cell = new PdfPCell(px);
        cell.setBorderColor(new Color(255, 255, 255));
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        tableItem.addCell(cell);
        

        px=new Paragraph();
        px.add(new Chunk("\n",f_times[1]));
        px.add(new Chunk("Date:",f_times[1]));
        px.add(new Chunk(" "+ sdf4.format(recordTime) +" ",f_underline[0]));
        cell = new PdfPCell(px);
        cell.setBorderColor(new Color(255, 255, 255));
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
        tableItem.addCell(cell);

        String timesSpace="              ";
        px=new Paragraph();
        px.add(new Chunk("\n\n",f_times[1]));
        px.add(new Chunk("Received From:  ",f_times[1]));
        px.add(new Chunk(receivedFrom, f_underline[2]));

        px.add(new Chunk("\n\n",f_times[1]));
        cell = new PdfPCell(px);
        cell.setBorderColor(new Color(255, 255, 255));
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        tableItem.addCell(cell);
       

        float[] widths3 = {0.25f,0.50f,0.25f};
        PdfPTable table3 = new PdfPTable(widths3);

        cell = new PdfPCell(new Paragraph("Acct. No.",f_times[1]));
        cell.setFixedHeight(30f);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        table3.addCell(cell);

        cell = new PdfPCell(new Paragraph("Description",f_times[1]));
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        table3.addCell(cell);

        cell = new PdfPCell(new Paragraph("Amount",f_times[1]));
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        table3.addCell(cell);
    
        DecimalFormat mnf = new DecimalFormat("###,###,##0");
        String cellSpace="  ";
        double total = 0.0;
        for(int i=0;i<7;i++){
            String acct = "";
            String desc = "";
            String amount = "";
            try { acct = acctcodes.get(i); } catch (Exception e) {}
            try { desc = descriptions.get(i); } catch (Exception e) {}
            try { amount = amounts.get(i); } catch (Exception e) {}
            try { total += Double.parseDouble(amount); } catch (Exception e) {}

            cell = new PdfPCell(new Paragraph(cellSpace+acct,f_chinese[2]));
            cell.setFixedHeight(20f);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            cell.setHorizontalAlignment(Element.ALIGN_LEFT);
            table3.addCell(cell);

            cell = new PdfPCell(new Paragraph(cellSpace+desc,f_chinese[2]));
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            cell.setHorizontalAlignment(Element.ALIGN_LEFT);
            table3.addCell(cell);

            cell = new PdfPCell(new Paragraph(amount,f_chinese[2]));
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            table3.addCell(cell);
        }

        cell = new PdfPCell(new Paragraph(totalStr,f_times_b[1]));
        cell.setFixedHeight(20f);
        cell.setColspan(2);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        table3.addCell(cell);

        cell = new PdfPCell(new Paragraph(mnf.format(total), f_times_b[1]));
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
        table3.addCell(cell);

        table3.setWidthPercentage(90);
        tableItem.addCell(table3);

        px=new Paragraph();
        px.add(new Chunk("\n",f_times[1]));
        px.add(new Chunk("Recieved By:  ",f_times[1]));
        px.add(new Chunk(receivedBy,f_underline[2]));
        px.add(new Chunk("\n",f_times[1]));
        cell = new PdfPCell(px);
        cell.setBorderColor(new Color(255, 255, 255));
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        tableItem.addCell(cell);

        if (printCorner) {
            px=new Paragraph();
            px.add(new Chunk("\n",f_chinese[2]));
            px.add(new Chunk("法人登記簿第六冊第七頁153號",f_chinese[2]));
            px.add(new Chunk("                   ",f_chinese[2]));
            px.add(new Chunk(receiptNo +" \n", f_times_b[1]));

            px.add(new Chunk("財團法人台灣省基督教馬禮遜協會 \n",f_chinese[2]));
            px.add(new Chunk("統一編號: 52014286",f_chinese[2]));
            px.add(new Chunk("                                Thank You!\n",f_chinese[2]));
            px.add(new Chunk("地址: 台中市水湳路136之1號 \n",f_chinese[2]));
            cell = new PdfPCell(px);
            cell.setBorderColor(new Color(255, 255, 255));
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            cell.setHorizontalAlignment(Element.ALIGN_LEFT);
            tableItem.addCell(cell);
        }
        else {
            px=new Paragraph();
            px.add(new Chunk("\n",f_chinese[2]));
            px.add(new Chunk("    Thank You!                                     ",f_chinese[2]));
            px.add(new Chunk(receiptNo +" \n", f_times_b[1]));
            cell = new PdfPCell(px);
            cell.setBorderColor(new Color(255, 255, 255));
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            cell.setHorizontalAlignment(Element.ALIGN_LEFT);
            tableItem.addCell(cell);
        }

        return tableItem;
    }
%>

<%
    Document document = null;
    String fname = "";
    try {
        File toolDir = new File(request.getRealPath("/") + "/eSystem/pdf_example");
        ReceiptPrinter p = ReceiptPrinter.getPdfPrinter(toolDir);
        

        //document = new Document(PageSize.A5.rotate(),5,5,5,5);
        
        document = new Document(PageSize.A4.rotate(),15,15,10,10);
        fname = new Date().getTime() + ".pdf";
        File outdir = new File(request.getRealPath("/"), "pdf_output");
        if (!outdir.exists()) {
            outdir.mkdir();
        }

        String fontPath=toolDir+"/font/dffn_m5.ttc,0";
        String fontPathName =toolDir+"/font/mingliu.ttc,0";
        BaseFont bfComic = BaseFont.createFont(fontPath,BaseFont.IDENTITY_H,BaseFont.NOT_EMBEDDED);
        Font[] f_chinese=new Font[5];
        f_chinese[0] = new Font(bfComic, 16,Font.NORMAL);
        f_chinese[1] = new Font(bfComic, 14,Font.NORMAL);
        f_chinese[2] = new Font(bfComic, 12,Font.NORMAL);
        f_chinese[3] = new Font(bfComic, 10,Font.NORMAL);
        f_chinese[4] = new Font(bfComic, 8,Font.NORMAL);

        Font[] f_chinese_b=new Font[5];
        f_chinese_b[0] = new Font(bfComic, 16,Font.BOLD);
        f_chinese_b[1] = new Font(bfComic, 14,Font.BOLD);
        f_chinese_b[2] = new Font(bfComic, 12,Font.BOLD);
        f_chinese_b[3] = new Font(bfComic, 10,Font.BOLD);
        f_chinese_b[4] = new Font(bfComic, 8,Font.BOLD);

        Font[] f_times=new Font[5];
        f_times[0] =new Font(Font.TIMES_ROMAN,16, Font.NORMAL);
        f_times[1] =new Font(Font.TIMES_ROMAN,14, Font.NORMAL);
        f_times[2] =new Font(Font.TIMES_ROMAN,12, Font.NORMAL);
        f_times[3] =new Font(Font.TIMES_ROMAN,10, Font.NORMAL);
        f_times[4] =new Font(Font.TIMES_ROMAN,8, Font.NORMAL);

        Font[] f_times_b=new Font[5];
        f_times_b[0] =new Font(Font.TIMES_ROMAN,16, Font.BOLD);
        f_times_b[1] =new Font(Font.TIMES_ROMAN,14, Font.BOLD);
        f_times_b[2] =new Font(Font.TIMES_ROMAN,12, Font.BOLD);
        f_times_b[3] =new Font(Font.TIMES_ROMAN,10, Font.BOLD);
        f_times_b[4] =new Font(Font.TIMES_ROMAN,8, Font.BOLD);

        Font[] f_underline=new Font[3];
        f_underline[0] =new Font(Font.TIMES_ROMAN,14, Font.UNDERLINE);
        f_underline[1] =new Font(Font.TIMES_ROMAN,12, Font.UNDERLINE);
        f_underline[2] =new Font(bfComic,14, Font.UNDERLINE);


        File testout = new File(outdir, fname);
        PdfWriter pdfwriter = PdfWriter.getInstance(document, new FileOutputStream(testout));
        pdfwriter.setViewerPreferences(PdfWriter.PageModeUseOutlines);
        document.open();



        float[] widths = {0.48f,0.04F,0.48f};
        PdfPTable tableAll = new PdfPTable(widths);
        tableAll.getDefaultCell().setBorderWidth((float)0.0);

        ArrayList<String> tmp = new ArrayList<String>();
        tmp.add("123");
        /*
        tableAll.addCell(getOnePTable(f_chinese,f_chinese_b,f_times,f_times_b,f_underline,
            "NT. RECEIPT 收據",
            null,
            "MORRISON ACADEMY",
            " 馬  禮  遜  學  校",
            "TEL: (04)292-1171(-3) FAX:(04)295-6140",
            null,
            new Date(),
            "Peter Lin",
            tmp,
            tmp,
            tmp,
            "Jiunhau Lin",
            "BK12345",
            "Total:NT$ "
            ));
        tableAll.addCell(getOnePTable(f_chinese,f_chinese_b,f_times,f_times_b,f_underline,
            "DONATION RECEIPT",
            "教育/宣教捐贈     收據",
            "MORRISON ACADEMY",
            "高  雄  馬  禮  遜  學  校",
            "地址: 81546 高雄縣大社鄉嘉誠路42號",
            "TEL: 07-3561190",
            new Date(),
            "Peter Lin",
            tmp,
            tmp,
            tmp,
            "Jiunhau Lin",
            "BK12345",
            "Total:NT$ ",
            true
            ));
        */

        tableAll.addCell(getOnePTable(f_chinese,f_chinese_b,f_times,f_times_b,f_underline,
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
            ));
        
        Paragraph px=new Paragraph();
        px.add(new Chunk("",f_times[0]));
        
        PdfPCell cell = new PdfPCell(new Paragraph("",f_times[0]));
        cell.setBorderColor(new Color(255, 255, 255));
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        tableAll.addCell(cell);


        tableAll.addCell(getOnePTable(f_chinese,f_chinese_b,f_times,f_times_b,f_underline,
            "NT. RECEIPT 收據", /* line1 */
            null, /* line2 */
            "MORRISON ACADEMY-BETHANY CAMPUS", /* line3 */
            "台北伯大尼美國學校", /* line4 */
            "地址: 臺北市汀州路3段97號", /* addr1 */
            "TEL: (02)2365-9691  FAX:(02)2365-9696", /* addr2 */
            new Date(),
            "Peter Lin",
            tmp,
            tmp,
            tmp,
            "Jiunhau Lin",
            "BK12345",
            "Total:NT$ ",
            false
            ));


        tableAll.setWidthPercentage(100);
        document.add(tableAll);

    //### end the mess
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
                <div class=es02><b>損益表下載資訊:</b></div>
                <table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
                <tr align=left valign=top>
                <td bgcolor="#e9e3de">
                    <table width="100%" border=0 cellpadding=4 cellspacing=1>
                        <tr bgcolor=#f0f0f0 class=es02>
                        <td>狀態</td>
                        <tD bgcolor=ffffff>
                            已產生損益表,<a target="_blank" href="../pdf_output/<%=fname%>"><font color=blue>可下載</font></a>.
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