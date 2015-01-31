package mca;

import java.text.*;
import java.util.*;
import java.io.*;
import com.lowagie.text.*;
import com.lowagie.text.pdf.*;
import jsf.*;
import java.awt.Color;
import mca.*;

public class McaReceiptPrinter
{
    int type;
    Document document;
    String fname;
    Font[] f_chinese;
    Font[] f_chinese_b;
    Font[] f_times;
    Font[] f_times_b;
    Font[] f_underline;

    static SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM");
    static SimpleDateFormat sdf2=new SimpleDateFormat("yyyy-MM-dd");
    static SimpleDateFormat sdf3=new SimpleDateFormat("yyyy-MM-dd HH:mm");
    static SimpleDateFormat sdf4=new SimpleDateFormat("yyyy/MM/dd");

    int num = 0;

    PdfPTable tableAll;
    
    public McaReceiptPrinter(int type, String rootpath)
        throws Exception
    {
        this.type = type;
        File toolDir = new File(rootpath, "/eSystem/pdf_example");
        document = new Document(PageSize.A4.rotate(),15,15,10,10); // new Document(PageSize.A5,15,15,10,10); // new Document(PageSize.A5.rotate(),15,15,10,10);
        fname = new Date().getTime() + ".pdf";
        File outdir = new File(rootpath, "pdf_output");
        if (!outdir.exists()) {
            outdir.mkdir();
        }
        String fontPath=toolDir+"/font/dffn_m5.ttc,0";
        String fontPathName =toolDir+"/font/mingliu.ttc,0";

        BaseFont bfComic = BaseFont.createFont(fontPath,BaseFont.IDENTITY_H,BaseFont.NOT_EMBEDDED);
        f_chinese = new Font[5];
        f_chinese[0] = new Font(bfComic, 16,Font.NORMAL);
        f_chinese[1] = new Font(bfComic, 14,Font.NORMAL);
        f_chinese[2] = new Font(bfComic, 12,Font.NORMAL);
        f_chinese[3] = new Font(bfComic, 10,Font.NORMAL);
        f_chinese[4] = new Font(bfComic, 8,Font.NORMAL);

        f_chinese_b = new Font[5];
        f_chinese_b[0] = new Font(bfComic, 16,Font.BOLD);
        f_chinese_b[1] = new Font(bfComic, 14,Font.BOLD);
        f_chinese_b[2] = new Font(bfComic, 12,Font.BOLD);
        f_chinese_b[3] = new Font(bfComic, 10,Font.BOLD);
        f_chinese_b[4] = new Font(bfComic, 8,Font.BOLD);

        f_times = new Font[5];
        f_times[0] =new Font(Font.TIMES_ROMAN,16, Font.NORMAL);
        f_times[1] =new Font(Font.TIMES_ROMAN,14, Font.NORMAL);
        f_times[2] =new Font(Font.TIMES_ROMAN,12, Font.NORMAL);
        f_times[3] =new Font(Font.TIMES_ROMAN,10, Font.NORMAL);
        f_times[4] =new Font(Font.TIMES_ROMAN,8, Font.NORMAL);

        f_times_b = new Font[5];
        f_times_b[0] =new Font(Font.TIMES_ROMAN,16, Font.BOLD);
        f_times_b[1] =new Font(Font.TIMES_ROMAN,14, Font.BOLD);
        f_times_b[2] =new Font(Font.TIMES_ROMAN,12, Font.BOLD);
        f_times_b[3] =new Font(Font.TIMES_ROMAN,10, Font.BOLD);
        f_times_b[4] =new Font(Font.TIMES_ROMAN,8, Font.BOLD);

        f_underline = new Font[3];
        f_underline[0] =new Font(Font.TIMES_ROMAN,14, Font.UNDERLINE);
        f_underline[1] =new Font(Font.TIMES_ROMAN,12, Font.UNDERLINE);
        f_underline[2] =new Font(bfComic,14, Font.UNDERLINE);

        File testout = new File(outdir, fname);
        PdfWriter pdfwriter = PdfWriter.getInstance(document, new FileOutputStream(testout));
        pdfwriter.setViewerPreferences(PdfWriter.PageModeUseOutlines);
        document.open();

        float[] widths = {0.48f,0.04F,0.48f};
        // float[] widths = {1.0f};
        tableAll = new PdfPTable(widths);
        tableAll.getDefaultCell().setBorderWidth((float)0.0);    

        Paragraph px=new Paragraph();
        px.add(new Chunk("",f_times[0]));
        
        PdfPCell cell = new PdfPCell(new Paragraph("",f_times[0]));
        cell.setBorderColor(new Color(255, 255, 255));
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        tableAll.addCell(cell);

        // 一張 A4 的右邊空白
        px=new Paragraph();
        px.add(new Chunk("",f_times[0]));
        
        cell = new PdfPCell(new Paragraph("",f_times[0]));
        cell.setBorderColor(new Color(255, 255, 255));
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        tableAll.addCell(cell);
    }
    
    public void addReceipt(String line1, String line2, String line3, String line4,
        String addr1, String addr2, Date recordTime, String receivedFrom,
        ArrayList<String> acctcodes, ArrayList<String> descriptions, ArrayList<String> amounts,
        String receivedBy, String receiptNo, String totalStr, String totalAmt, boolean printCorner)
        throws Exception
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
        for(int i=0;i<7;i++){
            String acct = "";
            String desc = "";
            String amount = "";
            try { acct = acctcodes.get(i); } catch (Exception e) {}
            try { desc = descriptions.get(i); } catch (Exception e) {}
            try { amount = amounts.get(i); } catch (Exception e) {}

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

        cell = new PdfPCell(new Paragraph(totalAmt, f_times_b[1]));
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
        
        tableAll.addCell(tableItem);
    }

    public String getOutputFileName()
    {
        return fname;
    }

    public void close()
        throws Exception
    {
        if (this.document!=null)
        {
            tableAll.setWidthPercentage(100);
            document.add(tableAll);
            this.document.close();
        }
    }
}
