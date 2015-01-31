package mca;

import phm.accounting.*;
import phm.ezcounting.*;
import literalstore.*;
import java.util.*;
import java.text.*;
import phm.util.*;
import jsf.*;
import com.lowagie.text.*;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import com.lowagie.text.pdf.*;
import java.io.*;
import java.awt.Color;

public class DLetterHelper
{
    int bunitId;
    String rootPath;
    PdfPrinter printer;

    public DLetterHelper(int bunitId, String rootPath)
    {
        this.bunitId = bunitId;
        this.rootPath = rootPath;
    }

    public String getFileName() {
        return printer.getFileName();
    }

    public void printLetters()
        throws Exception
    {
        String space = new BunitHelper().getSpace("bill.bunitId", bunitId);
        // 有 ##interest, 又本金沒繳完的才會要寄 DelinquentLetter      
        String campus = new BunitMgr(0).find("id=" + bunitId).getLabel();
        Bill b = new BillMgr(0).find(new McaService().getBillFindId(campus));
        if (b==null)
            return;
        BillItem bi = new BillItemMgr(0).find("billId=" + b.getId() + 
            " and name='" + McaService.BILL_ITEMS[24] + "' and status=1"); // ## Interest
        if (bi==null)
            return;

        BillItem bi2 = new BillItemMgr(0).find("billId=" + b.getId() + 
            " and name='" + McaService.BILL_ITEMS[23] + "' and status=1"); // ## LateFee

        ArrayList<ChargeItemMembr> cims = new ChargeItemMembrMgr(0).retrieveList(
            "billitem.id=" + bi.getId() + " and membrbillrecord.paidStatus!=2", "");

        ArrayList<ChargeItemMembr> cims2 = new ChargeItemMembrMgr(0).retrieveList(
            "billitem.id=" + bi2.getId() + " and membrbillrecord.paidStatus!=2", "");
        
        Map<String, ChargeItemMembr> cims2Map = new SortingMap(cims2).doSortSingleton("getTicketId");
        
        printer = null;
        try {
            printer = new PdfPrinter(rootPath);

            for (int i=0; i<cims.size(); i++) {
                ChargeItemMembr cim = cims.get(i);
                int interest = cim.getMyAmount();
                int diff = cim.getReceivable() - cim.getReceived();
                ChargeItemMembr cim2 = cims2Map.get(cim.getTicketId());
                int latefee = (cim2!=null)?cim2.getMyAmount():0;
                if (diff>(latefee + interest)) {
                    // 本金的部分還有沒繳的
                    printer.print(new Date(), "Parents Name", (diff - (latefee + interest)),
                        cim.getMembrName(), "Fee Name", "Cashier Name", "04-11111111", "Campus");
                }
            }
        }
        catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
        finally {
            if (printer!=null)
                printer.close();
        }
    }

    class PdfPrinter {
        Document document = null;
        File toolDir = null;
        File outdir = null;
        File logoPath = null;
        String fname = null;

        Font defaultFont = null;
        Font defaultFont2 = null;
        Font defaultFont3 = null;

        PdfWriter pdfwriter = null;

        PdfPrinter(String rootPath) 
            throws Exception
        {
            document = new Document(PageSize.A4,20,20,40,10);
            File root = new File(rootPath);
            toolDir = new File(root + "/eSystem/pdf_example");
            outdir = new File(root, "pdf_output");
            fname = new Date().getTime() + ".pdf";
            File testout = new File(outdir, fname);
            pdfwriter = PdfWriter.getInstance(document, new FileOutputStream(testout));
            document.open();
            logoPath = new File(root, "/eSystem/images/mcalogo.tif");

            defaultFont = new Font(Font.TIMES_ROMAN, 14, Font.NORMAL);
            defaultFont2 = new Font(Font.TIMES_ROMAN, 14, Font.BOLD);
            defaultFont3 = new Font(Font.TIMES_ROMAN, 20, Font.BOLD);
        }

        String getFileName()
        {
            return fname;
        }

        void print(Date printDate, String parentsName, int outstanding, String studentName, 
            String feeName, String cashierName, String cashierPhone, String campus)
            throws Exception
        {     
            document.newPage();
            float[] widths = {0.2f, 0.8f};
            PdfPTable table = new PdfPTable(widths);
            PdfPCell cell =null;
            if (logoPath!=null && logoPath.length()>0) {
                try {
                    Image logoI= Image.getInstance(logoPath.getAbsolutePath());
                    logoI.setAbsolutePosition(10,720);
                    document.add(logoI);
                }
                catch (java.io.IOException e) {}
                cell=new PdfPCell(new Paragraph("",defaultFont));
            }
            
            cell.setFixedHeight(80f);
            cell.setBorderWidth((float)0.0);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            table.addCell(cell);

            Paragraph parag1=new Paragraph("");
            parag1.add(new Chunk("MORRISON ACADEMY – Director of Finance",defaultFont2));
            parag1.add(new Chunk("\n",defaultFont));

            parag1.add(new Chunk("\n",defaultFont));

            parag1.add(new Chunk("Address:	136-1 Shui Nan Road, Taichung 40679, Taiwan",defaultFont));
            parag1.add(new Chunk("\n",defaultFont));

            parag1.add(new Chunk(PaymentPrinter.makePrecise("Tel: (886) 04 2297 3927 Ext. 102",50,true,' ')+"Fax:	(886) 4 2292 1174",defaultFont));
            parag1.add(new Chunk("\n",defaultFont));
            parag1.add(new Chunk(PaymentPrinter.makePrecise("Email: lawm@mca.org.tw",51,true,' ')+"Web:	http://www.mca.org.tw",defaultFont));
        
            cell= new PdfPCell(parag1);
            cell.setBorderWidth((float)0.0);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            table.addCell(cell);
        
            DateFormat sdf5 = DateFormat.getDateInstance(DateFormat.MEDIUM, Locale.US);
            parag1=new Paragraph("");
            parag1.add(new Chunk("\n\n\n\n",defaultFont3));
            parag1.add(new Chunk(sdf5.format(printDate), defaultFont));
            parag1.add(new Chunk("\n\n\n",defaultFont3));
            parag1.add(new Chunk("Dear "+ parentsName + ":",defaultFont));
            parag1.add(new Chunk("\n\n\n",defaultFont3));
            parag1.add(new Chunk("The record indicates that there is still an outstanding balance of $" + outstanding + " in "+  studentName+ "’s "+  feeName  + " tuition and fees account.  Pleased be reminded that  if the balance is not paid by the first day of next month, a 1% per month interest of the balance due, calculated from the due date to the payment date, will be added to outstanding amount.",defaultFont));
            parag1.add(new Chunk("\n\n",defaultFont));
            parag1.add(new Chunk("If you have any questions, please contact cashier "+ cashierName +" " + cashierPhone+ "  in "+campus+" campus.", defaultFont));


            parag1.add(new Chunk("\n\n",defaultFont3));
            parag1.add(new Chunk("Sincerely,",defaultFont));

            String spaceX="";
            parag1.add(new Chunk("\n\n\n\n",defaultFont3));
            parag1.add(new Chunk(spaceX+"Michele Law ",defaultFont));
            parag1.add(new Chunk("\n",defaultFont));
            parag1.add(new Chunk(spaceX+"Director of Finance",defaultFont));


            parag1.add(new Chunk("\n\n",defaultFont));
            parag1.add(new Chunk(spaceX+"Cc: "+ cashierName, defaultFont));

            cell= new PdfPCell(parag1);
            cell.setColspan(2);
            cell.setBorderWidth((float)0.0);
            cell.setFixedHeight(650f);
            cell.setVerticalAlignment(Element.ALIGN_TOP);
            table.addCell(cell);
                
            table.setWidthPercentage(100);
            document.add(table);

            PdfContentByte cb = pdfwriter.getDirectContent();
            cb.setLineWidth(2.0f);	 // Make a bit thicker than 1.0 default
            cb.setGrayStroke(0.0f);  // 0 is black 1 is white 
            cb.moveTo(132,772);
            cb.lineTo(550,772);
            cb.stroke();
        }

        void close() {
            document.close();
        }
    }
}
