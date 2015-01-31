package phm.ezcounting;

import java.text.*;
import java.util.*;
import java.io.*;
import com.lowagie.text.*;
import com.lowagie.text.pdf.*;
import jsf.*;
import java.awt.Color;
import mca.*;

public class PaymentPrinter
{
    String fontPath = null;
    protected String fontPathName = null;
    String fontPath2 = null;
    String fontPath3 = null;

    String menuPath = null;
    String menu2Path = null;

    // #### 畫帳單的資訊 ####
    BillRecord br = null;
       // ticketId
    Map<String, ArrayList<ChargeItemMembr>> chargeMap = null;
       // chargeKey
    Map<String, ArrayList<Discount>> discountMap = null;
       // billKey (membrId#billRecordId)
    Map<String, ArrayList<BillComment>> commentMap = null;
       // chargeKey
    Map<String, ArrayList<FeeDetail>> feeMap = null;
       // membrId#billId
    Map<String, ArrayList<MembrInfoBillRecord>> unpaidMap = null;
       // billMap
    Map<Integer, Bill> billMap = null;

    // ### pdf 資訊 #####
    File toolDir = null;
    protected PaySystem2 paySystem = null;
    Bunit bunit = null;
    protected String rootPath = null;
    boolean inSeparatePage = false;
    Document document = null;
    protected PdfWriter pdfwriter = null;
    String outputName = null;
    String currentTicketId = null;

    McaService mcasvc = null;
    
    // ######################
    // ## 以下是班級資訊 ##
    // membrId, ArrayList 里面的是 main type 的 tag
    Map<Integer, ArrayList<TagMembrStudent>> tagmembrMap = null;
    // ######################

    private static SimpleDateFormat sdf =  new SimpleDateFormat("yy/MM/dd");
    private static DecimalFormat mnf = new DecimalFormat("###,###,##0");

    public static PaymentPrinter getPdfPrinter(
        BillRecord br,
           // ticketId
        Map<String, ArrayList<ChargeItemMembr>> chargeMap, 
           // chargeKey
        Map<String, ArrayList<Discount>> discountMap,
           // billKey (membrId#billRecordId)
        Map<String, ArrayList<BillComment>> commentMap,
           // chargeKey
        Map<String, ArrayList<FeeDetail>> feeMap,
           // membrId#billId
        Map<String, ArrayList<MembrInfoBillRecord>> unpaidMap,
        PaySystem2 paySystem, 
        Bunit bunit,
        boolean inSeparatePage,
        String rootPath)
        throws Exception
    {
        PaymentPrinter p = new PaymentPrinter();
        p.toolDir = new File(rootPath + "/eSystem/pdf_example");
        if (!p.toolDir.exists())
            throw new Exception("pdf tool directory not exists!");

        p.paySystem = paySystem;
        p.bunit = bunit;
        p.rootPath = rootPath;
        p.inSeparatePage = inSeparatePage;

        //dffn_m5.ttc  原來用的細明體
        p.fontPath = new File(p.toolDir, "font/simsun.ttc,0").getAbsolutePath();
        p.fontPathName = new File(p.toolDir, "font/mingliu.ttc,0").getAbsolutePath();

        //msgothic.ttc 正黑體
        //gulim.ttc  正黑體
        p.fontPath2 = new File(p.toolDir, "font/DFFN_F4.TTC,0").getAbsolutePath();
        p.fontPath3 = new File(p.toolDir, "font/DFWKTB4.TTC,0").getAbsolutePath();
        p.menuPath = new File(p.toolDir, "font/menu.tif").getAbsolutePath();
        p.menu2Path = new File(p.toolDir, "font/menu2.tif").getAbsolutePath();

        p.br = br;
        p.chargeMap = chargeMap;
        p.discountMap = discountMap;
        p.commentMap = commentMap;
        p.feeMap = feeMap;
        p.unpaidMap = unpaidMap;

        BunitHelper bh = new BunitHelper();
        TagType tt = TagTypeMgr.getInstance().findX("main=1", bh.getStudentSpace("bunitId",bunit.getId()));
        if (tt!=null) {
            ArrayList<TagMembrStudent> tmstudents = TagMembrStudentMgr.getInstance().retrieveList("typeId=" + tt.getId(), "");
            p.tagmembrMap = new SortingMap(tmstudents).doSort("getMembrId");
        }

        ArrayList<Bill> blist = BillMgr.getInstance().retrieveList("", "");
        p.billMap = new SortingMap(blist).doSortSingleton("getId");

        /*
        p.document = getDocument();
        File outputPdf = getOutputFile();

        p.pdfwriter = PdfWriter.getInstance(p.document, new FileOutputStream(outputPdf));
        p.pdfwriter.setViewerPreferences(PdfWriter.PageModeUseOutlines);
        p.document.open();
        */

        p.mcasvc = new McaService();
        return p;
    }

    protected Document getDocument()
        throws Exception
    {
        if (this.document==null) {

            if(paySystem.getPagetype() == 2)
                this.document = new Document(PageSize.A4.rotate(),15,15,10,10);
            else if(paySystem.getPagetype() == 5)
                this.document = new Document(PageSize.A4,15,15,5,0);
            else
                this.document = new Document(PageSize.A4,15,15,10,10);

            File outputPdf = getOutputFile();
            this.pdfwriter = PdfWriter.getInstance(this.document, new FileOutputStream(outputPdf));
            this.pdfwriter.setViewerPreferences(PdfWriter.PageModeUseOutlines);
            this.document.open();
        }
        else if (this.inSeparatePage) {
            this.document.close();
            this.document = null;
            return this.getDocument();
        }
        return this.document;
    }

    public String getOutputFileName()
    {
        return this.outputName;
    }

    protected File getOutputFile() 
        throws Exception
    {
        if (!this.inSeparatePage)
            this.outputName = new Date().getTime() + ".pdf";
        else {
            this.outputName = currentTicketId + new Date().getTime() + ".pdf";
        }

        File outdir = new File(this.rootPath, "pdf_output");
        if (!outdir.exists()) {
            outdir.mkdir();
        }
        File testout = new File(outdir, this.outputName);
        if (testout.exists())
            testout.delete();
        if (testout.exists()) {
            throw new Exception("File " + testout.getAbsolutePath() + " is being used, cannot overwrite it now");
        }
        return testout;
    }

    public void close()
        throws Exception
    {
        if (this.document!=null)
        {
System.out.println("## here in close");
            this.document.close();
        }
    }

    public void printPdf(
        Document document,
        String subject,
        String title,  // *must*
        int nowPage,
        String logoPath, 
        String backimgPath, 
        String payeeName1,  // *must*
        String payeeName2,  
        String payeeName3,  
        String companyName, // *must*
        String companyAddress, // *must*
        String companyPhone, //*must*
        String website, 
        String ticketId, // *must*
        int amount1,
        int amount2,
        int amount3,  
        int amount4,  // *must*
        Date   billEndDate, // *must*
        String greeting,
        String greetingImgPath,
        String warning,
        String contentTableTitle, // *must*
        String blockLeft,  // *must* 
        String blockRight, // *must*
        String remark, // *must*
		String atmTitle, // *must*
		String atmContent, // *must*
		String acceptString, // *must*
        String payReminder,
        String bottomLeftBoxTitle,  // *must* "櫃臺繳款收訖戳記" or “便利商店櫃臺繳款收訖戳記”
        String bottomMiddleBoxTitle,
        String barcode1,  // *must*
        String barcode2,
        String barcode3,
        String[] bottomRightLines, String path711,int storeActive,String billGot) throws Exception
    {
        PdfContentByte cb = this.pdfwriter.getDirectContent();

        float barcodeN=(float)1.7;
        float barcodeFontSize=(float)10.0;
        float barcodeHieght=(float)30.0;
        float barcodeHieght2=(float)24.0;
        float barcodeN2=(float)1.7;
        float barcodeN3=(float)2.0;

        BaseFont bfComic = BaseFont.createFont(fontPath,BaseFont.IDENTITY_H,BaseFont.NOT_EMBEDDED);
        Font font14b = new Font(bfComic, 14,Font.BOLD);
        Font font14 = new Font(bfComic, 14,Font.NORMAL);
        Font font12 = new Font(bfComic, 12,Font.NORMAL);
        Font font10 = new Font(bfComic, 10,Font.NORMAL);
        Font font10b = new Font(bfComic, 10,Font.BOLD);
        Font font8 = new Font(bfComic, 8,Font.NORMAL);
        Font font1 = new Font(bfComic,1,Font.NORMAL);
    
        BaseFont bfComic2 = BaseFont.createFont(fontPathName,BaseFont.IDENTITY_H,BaseFont.NOT_EMBEDDED);
        Font font12Name = new Font(bfComic2, 12,Font.NORMAL);
        Font font10Name = new Font(bfComic2, 10,Font.NORMAL);

        Paragraph cTitle = new Paragraph(subject,font1);
        cTitle.setAlignment(Element.ALIGN_RIGHT);
        Chapter chapter = new Chapter(cTitle,nowPage);
        document.add(chapter);
    
        String strTitle=title;
        Paragraph parag1=new Paragraph(strTitle,font14b);
        parag1.setAlignment(Element.ALIGN_CENTER);
        document.add(parag1);

    if(storeActive ==1){  //便利商店開通時
        if (path711!=null && path711.length()>0) {
            try {
                Image  I711= Image.getInstance(path711);
                I711.setAbsolutePosition(70,135);
                document.add(I711);
            }
            catch (java.io.IOException e) {}
        }
    }            

        if (logoPath!=null && logoPath.length()>0) {
            try {
                Image  logoI= Image.getInstance(logoPath);
                logoI.setAbsolutePosition(10,770);
                document.add(logoI);
            }
            catch (java.io.IOException e) {}
        }

        if (backimgPath!=null && backimgPath.length()>0) {
            try {
                String backImge=backimgPath;
                Image backI=Image.getInstance(backImge);
                backI.setAbsolutePosition(200,400);
                document.add(backI);
            }
            catch (java.io.IOException e) {}
        }

        Paragraph paragX=new Paragraph("\n\n",font12);
        paragX.setAlignment(Element.ALIGN_LEFT);
        document.add(paragX);	

        String space="     ";
        String space2="                       ";
        String space3="                                                      ";
        String space4="                                      ";

        String outName= payeeName1 + " " + ((payeeName2!=null)?payeeName2:"") + " " + ((payeeName3!=null)?payeeName3:"")+billGot;
        String needSpace="";		
    
        int xLoop=49-countStringBytes(outName);
        for(int lp=0;lp<xLoop;lp++)
            needSpace+=" ";
    
        String showWord=space+outName+needSpace+companyName; 
        if (website!=null && website.trim().length()>0)
            showWord += " (" + companyPhone + ")";

        showWord += "\n"+space3+"地址: "+ companyAddress +"\n"+space3;

        if (website==null || website.trim().length()==0)
            showWord += ("電話: "+ companyPhone);
        else
            showWord += website;

        Paragraph parag6=new Paragraph(showWord,font12Name);
        parag6.setAlignment(Element.ALIGN_LEFT);
        document.add(parag6);	
    
        Barcode39 codeFeeticketId = new Barcode39();
        codeFeeticketId.setCode(ticketId);
        codeFeeticketId.setStartStopText(true);
        codeFeeticketId.setSize(barcodeFontSize);
        codeFeeticketId.setN(barcodeN);
        codeFeeticketId.setBarHeight(barcodeHieght2);

        Image imageFtId = codeFeeticketId.createImageWithBarcode(cb, null, null);
        //imageFtId.setAlignment(Element.ALIGN_CENTER);
        imageFtId.setAbsolutePosition(45,718);
        document.add(imageFtId);

        parag6=new Paragraph("\n",font12);
        parag6.setAlignment(Element.ALIGN_LEFT);
        document.add(parag6);
    
        if(amount2==(int)0 && amount3==(int)0)
        {
            parag6=new Paragraph(space+"                                  本期應繳金額         繳款截止日",font10b);
            parag6.setAlignment(Element.ALIGN_LEFT);
            document.add(parag6);                
            
            parag6=new Paragraph("\n",font8);
            parag6.setAlignment(Element.ALIGN_LEFT);
            document.add(parag6);
            
            parag6=new Paragraph(space+"                               " + mnf.format(amount4) + "          " + sdf.format(billEndDate)+"\n",font12);
            parag6.setAlignment(Element.ALIGN_LEFT);
            document.add(parag6);
            
            parag6=new Paragraph("\n",font8);
            parag6.setAlignment(Element.ALIGN_LEFT);
            document.add(parag6);
            
            String menuImge = menu2Path;
            Image  menuI= Image.getInstance(menuImge);
            //logoI.setAlignment(Image.LEFT | Image.UNDERLYING);
            menuI.setAbsolutePosition(200,644);
            document.add(menuI);    
        }
        else{
//System.out.println("## amount1=" + amount1 + " amount2=" + amount2 + " amount3=" + amount3 + " amount4=" + amount4);            
            parag6=new Paragraph(space+"    本期新增金額         前期未繳金額        本期已繳金額           本期應繳金額         繳款截止日",font10);
            parag6.setAlignment(Element.ALIGN_LEFT);
            document.add(parag6);
                            
            parag6=new Paragraph("\n",font8);
            parag6.setAlignment(Element.ALIGN_LEFT);
            document.add(parag6);
            
            String x="";
            int padding = 17-mnf.format(amount1).length();
            for(int i=0; i<padding; i++)
                x += " ";
            
            String y="";			
            padding = 15-mnf.format(amount2).length();
            for(int i=0; i<padding; i++)
                y += " ";
        
            String z="";
            padding = 19 - mnf.format(amount3).length();
            for(int i=0; i<padding; i++)
                z += " ";

            String line = mnf.format(amount1) + x + mnf.format(amount2)+ y + 
                mnf.format(amount3) + z + mnf.format(amount4);

            parag6=new Paragraph(space + "     " + line+ "          " + sdf.format(billEndDate) + "\n" ,font12);
            parag6.setAlignment(Element.ALIGN_LEFT);
            document.add(parag6);
            
            parag6=new Paragraph("\n",font8);
            parag6.setAlignment(Element.ALIGN_LEFT);
            document.add(parag6);
            
            String menuImge=menuPath;
            Image  menuI= Image.getInstance(menuImge);
            //logoI.setAlignment(Image.LEFT | Image.UNDERLYING);
            menuI.setAbsolutePosition(50,644);
            document.add(menuI);		
        }

        if (greeting!=null)
            document.add(new Paragraph("        "+greeting,font10b)); 

        if (greetingImgPath!=null) {
            Image  greetingI = Image.getInstance(greetingImgPath);
            greetingI.setAbsolutePosition(220,710);
            document.add(greetingI);	
        }	

        if (warning == null)
            warning = " ";
        parag6=new Paragraph(space + warning ,font8);
        parag6.setAlignment(Element.ALIGN_LEFT);
        document.add(parag6);

        parag6=new Paragraph("\n",font8);
        parag6.setAlignment(Element.ALIGN_LEFT);
        document.add(parag6);
    
        float[] widths = {0.12f, 0.38f, 0.15f, 0.35f};
        PdfPTable table = new PdfPTable(widths);

        PdfPCell cell = new PdfPCell(new Paragraph(contentTableTitle,font12));
        cell.setColspan(4);
        cell.setFixedHeight(20f);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table.addCell(cell);
    
        cell= new PdfPCell(new Paragraph("項目                     應收      折扣     小計",font10));
        cell.setColspan(2);
        cell.setFixedHeight(20f);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table.addCell(cell);

        cell= new PdfPCell(new Paragraph("項目                     應收      折扣     小計",font10));
        cell.setColspan(2);
        cell.setFixedHeight(20f);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table.addCell(cell);
            
        cell = new PdfPCell(new Paragraph(blockLeft,font12));
        cell.setColspan(2);
        cell.setFixedHeight(118f);
        table.addCell(cell);
    
        cell = new PdfPCell(new Paragraph(blockRight,font12));
        cell.setColspan(2);
        cell.setFixedHeight(118f);
        table.addCell(cell);
        table.setWidthPercentage(90);
        document.add(table);

        document.add(new Paragraph("      " + remark, font10));  //ps

        parag6=new Paragraph("\n",font10);
        parag6.setAlignment(Element.ALIGN_LEFT);
        document.add(parag6);				

        float[] widths2 = {0.05f, 0.60f, 0.35f};
        PdfPTable table2 = new PdfPTable(widths2);
        PdfPCell cell2 = new PdfPCell(new Paragraph(atmTitle,font12));
        cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell2.setFixedHeight(110f);				
        table2.addCell(cell2);
    
        cell2= new PdfPCell(new Paragraph(atmContent,font10));
        table2.addCell(cell2);
        
        PdfPTable nested2 = new PdfPTable(1);
        cell2= new PdfPCell(new Paragraph(acceptString,font10));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nested2.addCell(cell2);
        cell2= new PdfPCell(new Paragraph("",font12));
        nested2.addCell(cell2);

        nested2.setWidthPercentage(100);
        table2.addCell(nested2);
        table2.setWidthPercentage(90);
        document.add(table2);
    
    if(storeActive ==1) {  //便利代收開通時

        Paragraph parag10=new Paragraph("\n.....................................................................................................................裁切線",font8);
        parag10.setAlignment(Element.ALIGN_CENTER);
        document.add(parag10);	


        Barcode39 code1 = new Barcode39();
        code1.setCode(barcode1);
        code1.setStartStopText(true);
        code1.setSize(barcodeFontSize);
        code1.setN(barcodeN);
        code1.setBarHeight(barcodeHieght);
        Image imageCode1 = code1.createImageWithBarcode(cb, null, null);
        imageCode1.setAbsolutePosition(210,180);
        document.add(imageCode1);

        if (barcode2!=null) {
            Barcode39 code2 = new Barcode39();
            code2.setCode(barcode2);
            code2.setStartStopText(true);
            code2.setSize(barcodeFontSize);
            code2.setN(barcodeN);
            code2.setBarHeight(barcodeHieght);
            Image imageCode2 = code2.createImageWithBarcode(cb, null, null);
            imageCode2.setAbsolutePosition(210,130);
            document.add(imageCode2);
        }

        if (barcode3!=null) {
            Barcode39 code3 = new Barcode39();
            code3.setCode(barcode3);
            code3.setStartStopText(true);
            code3.setSize(barcodeFontSize);
            code3.setN(barcodeN);
            code3.setBarHeight(barcodeHieght);
            Image imageCode3 = code3.createImageWithBarcode(cb, null, null);
            imageCode3.setAbsolutePosition(210,80);
            document.add(imageCode3);
        }

        if (payReminder!=null)
            document.add(new Paragraph("     " + payReminder,font10));
        document.add(new Paragraph("\n",font8));

        float[] widths3 = {0.3f,0.4f, 0.3f};
        table2 = new PdfPTable(widths3);


        Paragraph px=new Paragraph();

        px.add(new Chunk(bottomLeftBoxTitle,font10));
        px.add(new Chunk("\n\n\n\n\n\n\n\n\n\n\n\n\n\n至便利商店繳款，請保留超商所發之憑證以茲證明。",font10));


        cell2 = new PdfPCell(px);
        cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell2.setFixedHeight(200f);
        table2.addCell(cell2);
        
        cell2= new PdfPCell(new Paragraph(bottomMiddleBoxTitle,font10));
        cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
        table2.addCell(cell2);
    
        StringBuffer sContent4_1 = new StringBuffer();
        StringBuffer sCOntent4_2 = new StringBuffer();
        StringBuffer sb = sContent4_1;
        if (bottomRightLines!=null) {
            for (int i=0; i<bottomRightLines.length; i++)
            {
                sb.append(bottomRightLines[i] + "\n");
                if (bottomRightLines[i].indexOf("繳款人")>=0)
                    sb = sCOntent4_2;
            }
        } 
        
        // sContent4_1, payeeName1, sCOntent4_2 

        float[] widths4 = {1f};
        PdfPTable table3 = new PdfPTable(widths4);
        table3.getDefaultCell().setBorderWidth((float)0.0);

        cell2 = new PdfPCell(new Paragraph(sContent4_1.toString(),font10));
        cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell2.setBorderWidth((float)0.0);
        table3.addCell(cell2);
        

        cell2 = new PdfPCell(new Paragraph("        "+payeeName1 + billGot, font10Name));
        cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell2.setBorderWidth((float)0.0);
        table3.addCell(cell2);


        cell2 = new PdfPCell(new Paragraph(sCOntent4_2.toString(),font10));
        cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell2.setBorderWidth((float)0.0);
        table3.addCell(cell2);


       // cell2= new PdfPCell(new Paragraph(sContent4,font12Name));
        cell2= new PdfPCell(table3);
        table2.addCell(cell2);		
        table2.setWidthPercentage(90);
        document.add(table2);    
        
        parag6=new Paragraph("本帳單列印由必亨商業軟體股份有限公司技術支援，02-23693566，http://www.phm.com.tw",font8);
        parag6.setAlignment(Element.ALIGN_CENTER);
        document.add(parag6);    

    
    }   //end storeActive
    
    }	

    public void printPdf7(
        Document document,
        String billHeader,
        String billSubHeader,
        String studentName,
        String grade,
        String parents,
        String bankName,
        String accountName,
        String schoolNo,
        String studentAccountNumber,
        String dueDate,
        String amountStr,
        ArrayList<ChargeItemMembr> charges,
        Map<String, ArrayList<Discount>> discountMap,
        int unpaidAmount,
        String username,
        int receivable,
        int received,
        String payAcctStr
        ) throws Exception
    {

        document.newPage();

        PdfContentByte cb = this.pdfwriter.getDirectContent();
        BaseFont bfComic = BaseFont.createFont(fontPath,BaseFont.IDENTITY_H,BaseFont.NOT_EMBEDDED);
        Font font14b = new Font(bfComic, 14,Font.BOLD);
        Font font14 = new Font(bfComic, 14,Font.NORMAL);
        Font font12 = new Font(bfComic, 12,Font.NORMAL);
        Font font10 = new Font(bfComic, 10,Font.NORMAL);
        Font font10b = new Font(bfComic, 10,Font.BOLD);
        Font font8 = new Font(bfComic, 8,Font.NORMAL);
        Font font1 = new Font(bfComic,1,Font.NORMAL);
    
        BaseFont bfComic2 = BaseFont.createFont(fontPathName,BaseFont.IDENTITY_H,BaseFont.NOT_EMBEDDED);
        Font font18ITALIC = new Font(bfComic2, 18,Font.ITALIC);
        Font font16ITALIC = new Font(bfComic2, 16,Font.ITALIC);
        Font font13ITALIC = new Font(bfComic2, 13,Font.ITALIC);
        Font font12ITALIC = new Font(bfComic2, 12,Font.ITALIC);
        Font font12BOLD = new Font(bfComic, 12,Font.BOLD);
        Font font10ITALIC = new Font(bfComic2, 10,Font.ITALIC);
        Font font8ITALIC = new Font(bfComic2, 8,Font.ITALIC);    
        Font font4ITALIC = new Font(bfComic2, 4,Font.ITALIC);

        Font font16NORMAL = new Font(bfComic2, 16,Font.NORMAL);
        Font font12NORMAL = new Font(bfComic2, 12,Font.NORMAL);
        Font font10NORMAL = new Font(bfComic2, 10,Font.NORMAL);
        Font font9NORMAL = new Font(bfComic2, 9,Font.NORMAL);    
        Font font8NORMAL = new Font(bfComic2, 8,Font.NORMAL);    
        Font font6NORMAL = new Font(bfComic2, 6,Font.NORMAL);
        Font font4NORMAL = new Font(bfComic2, 4,Font.NORMAL);
        Font font2NORMAL = new Font(bfComic2, 2,Font.NORMAL);


        Font f_times=new Font(Font.TIMES_ROMAN, 14, Font.BOLD);
        Font f_times2=new Font(Font.TIMES_ROMAN, 12, Font.NORMAL);


        Rectangle border = new Rectangle(0f, 0f);

        float[] widths = {0.05f, 0.90f, 0.05f};
        PdfPTable table = new PdfPTable(widths);

        PdfPCell cell = new PdfPCell(new Paragraph("1",font18ITALIC));
        cell.setFixedHeight(35f);
        cell.setBorderColor(new Color(255, 255, 255));
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table.addCell(cell);
        
        Paragraph parag1=new Paragraph("");
        parag1.add(new Chunk(billHeader,font13ITALIC));
        parag1.add(new Chunk("\n",font4ITALIC));
        parag1.add(new Chunk(billSubHeader,font13ITALIC));
        parag1.add(new Chunk("    日期(Date):     年    月    日",font10ITALIC));
        parag1.add(new Chunk("\n",font4ITALIC));


        cell = new PdfPCell(parag1);
        cell.setBorderColor(new Color(255, 255, 255));
        //cell.setColspan(2);
        //cell.setFixedHeight(118f);
        table.addCell(cell);

        cell = new PdfPCell(new Paragraph("",font16ITALIC));
        cell.setBorderColor(new Color(255, 255, 255));
        //cell.setColspan(2);
        //cell.setFixedHeight(118f);
        table.addCell(cell);


        parag1=new Paragraph("");
        parag1.add(new Chunk("姓名 NAME      ",font10ITALIC));
        parag1.add(new Chunk(studentName, font10NORMAL));
        parag1.add(new Chunk("               ",font10ITALIC));
        parag1.add(new Chunk("Grade   ",font10ITALIC));
        parag1.add(new Chunk(grade, font10NORMAL));
        parag1.add(new Chunk("   ",font10ITALIC));
        parag1.add(new Chunk("Parent   ",font10ITALIC));
        parag1.add(new Chunk(" "+parents+" ",font10NORMAL));

        cell = new PdfPCell(parag1);
        cell.setColspan(2);
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBorderColor(new Color(255, 255, 255));
        cell.setFixedHeight(30f);
        table.addCell(cell);

        cell = new PdfPCell(new Paragraph("",font12ITALIC));
        cell.setBorderColor(new Color(255, 255, 255));
        table.addCell(cell);


        float[] widths2 = {0.12f,0.12f,0.14f,0.14f,0.22f,0.06f,0.2f};
        PdfPTable nest = new PdfPTable(widths2);

        parag1=new Paragraph("");
        parag1.add(new Chunk("企業戶代碼 \nSCHOOL NO.",font9NORMAL));

        cell = new PdfPCell(parag1);
        cell.setFixedHeight(25f);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nest.addCell(cell);

        cell = new PdfPCell(new Paragraph(schoolNo, font10NORMAL));
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nest.addCell(cell);

        parag1=new Paragraph("");
        parag1.add(new Chunk("經銷商代號 \nSTUDENT NO.",font9NORMAL));


        cell = new PdfPCell(parag1);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nest.addCell(cell);

        cell = new PdfPCell(new Paragraph(studentAccountNumber, font10NORMAL));
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nest.addCell(cell);

        parag1=new Paragraph("");
        parag1.add(new Chunk(bankName, font12NORMAL));
        cell = new PdfPCell(parag1);
        cell.setColspan(2);

        border=new Rectangle(0f, 0f);
        border.setBorderWidthBottom(0f);
        border.setBorderColorBottom(Color.WHITE);
        border.setBorderWidthRight(0.5f);
        border.setBorderColorRight(Color.BLACK);

        cell.cloneNonPositionParameters(border);

        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nest.addCell(cell);

        cell = new PdfPCell(new Paragraph(" ",font8NORMAL));

        border=new Rectangle(0f, 0f);
        border.setBorderWidthBottom(0f);
        border.setBorderColorBottom(Color.WHITE);
        cell.cloneNonPositionParameters(border);

        nest.addCell(cell);


        parag1=new Paragraph("");
        parag1.add(new Chunk("戶名 ACCT. NAME",font9NORMAL));
        cell = new PdfPCell(parag1);
        cell.setColspan(2);
        cell.setFixedHeight(25f);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nest.addCell(cell);

        parag1=new Paragraph(" ");
        parag1.add(new Chunk(accountName, font10ITALIC));
        cell = new PdfPCell(parag1);
        cell.setColspan(2);
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nest.addCell(cell);


        parag1=new Paragraph("");
        parag1.add(new Chunk("  限繳期限",font9NORMAL));
        cell = new PdfPCell(parag1);
        cell.setColspan(2);

        border=new Rectangle(0f, 0f);
        border.setBorderWidthTop(0f);
        border.setBorderColorTop(Color.WHITE);

        border.setBorderWidthRight(0.5f);
        border.setBorderColorRight(Color.BLACK);
        cell.cloneNonPositionParameters(border);

        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
        nest.addCell(cell);


        cell = new PdfPCell(new Paragraph("  ",font8NORMAL));

        border=new Rectangle(0f, 0f);
        border.setBorderWidthTop(0f);
        border.setBorderColorTop(Color.WHITE);
        cell.cloneNonPositionParameters(border);
  
        nest.addCell(cell);


        parag1=new Paragraph("");
        parag1.add(new Chunk("應納金額 AMOUNT",font9NORMAL));
        cell = new PdfPCell(parag1);
        cell.setFixedHeight(25f);
        cell.setColspan(2);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nest.addCell(cell);

        parag1=new Paragraph(" ");
        Chunk underlined = new Chunk("NT$ " + amountStr, f_times);
        underlined.setUnderline(0.2f, -2f);
        parag1.add(underlined);

        cell = new PdfPCell(parag1);
        cell.setColspan(2);
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nest.addCell(cell);


        parag1=new Paragraph("");
        parag1.add(new Chunk("  DUE DATE     ",font8ITALIC));
        parag1.add(new Chunk(dueDate, font12ITALIC));
        cell = new PdfPCell(parag1);

        border=new Rectangle(0f, 0f);
        border.setBorderWidthTop(0f);
        border.setBorderColorTop(Color.WHITE);
        border.setBorderWidthRight(0.5f);
        border.setBorderColorRight(Color.BLACK);
        cell.cloneNonPositionParameters(border);
        cell.setColspan(2);

        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_TOP);
        nest.addCell(cell);

        cell = new PdfPCell(new Paragraph("",font8NORMAL));
        border=new Rectangle(0f, 0f);
        border.setBorderWidthTop(0f);
        border.setBorderColorTop(Color.WHITE);
        cell.cloneNonPositionParameters(border);
        nest.addCell(cell);


        parag1=new Paragraph("");
        parag1.add(new Chunk("",font12NORMAL));
        cell = new PdfPCell(parag1);
        cell.setColspan(5);
        cell.setFixedHeight(40f);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nest.addCell(cell);


        parag1=new Paragraph("");
        parag1.add(new Chunk("驗\n\n證\n\n欄",font8NORMAL));
        cell = new PdfPCell(parag1);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nest.addCell(cell);

        parag1=new Paragraph("");
        parag1.add(new Chunk("(蓋收付款章欄)\n\n",font8NORMAL));
        cell = new PdfPCell(parag1);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_BOTTOM);

        border=new Rectangle(0f, 0f);
        border.setBorderWidthTop(0f);
        border.setBorderColorTop(Color.WHITE);
        cell.cloneNonPositionParameters(border);

        nest.addCell(cell);
        nest.setWidthPercentage(100);


        cell = new PdfPCell(nest);
        cell.setColspan(2);
        cell.setFixedHeight(120f);
        table.addCell(cell);

        cell = new PdfPCell(new Paragraph("",font16ITALIC));
        border=new Rectangle(0f, 0f);
        border.setBorderWidthTop(0f);
        border.setBorderColorTop(Color.WHITE);
        border.setBorderWidthRight(1f);
        border.setBorderColorRight(Color.WHITE);
        border.setBorderWidthBottom(1f);
        border.setBorderColorBottom(Color.WHITE);
        cell.cloneNonPositionParameters(border);
        table.addCell(cell);
        table.setWidthPercentage(100);
        document.add(table);


        parag1=new Paragraph("核                        會                        出                        記                        櫃\n章                        計                        納                        帳                        員",font8NORMAL);
        document.add(parag1);

      
        cb.setLineWidth(1.5f);
        cb.rectangle(10, 595, 560,0);
        cb.stroke();


        parag1=new Paragraph("\n\n",font12NORMAL);
        document.add(parag1);

        //float[] widths = {0.05f, 0.90f, 0.05f};
        table = new PdfPTable(widths);

        cell = new PdfPCell(new Paragraph("2",font18ITALIC));
        cell.setFixedHeight(35f);
        cell.setBorderColor(new Color(255, 255, 255));
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table.addCell(cell);
        
        parag1=new Paragraph("");
        parag1.add(new Chunk(billHeader, font13ITALIC));
        parag1.add(new Chunk("\n",font4ITALIC));
        parag1.add(new Chunk(billSubHeader ,font13ITALIC));
        parag1.add(new Chunk("    日期(Date):     年    月    日",font10ITALIC));
        parag1.add(new Chunk("\n",font4ITALIC));


        cell = new PdfPCell(parag1);
        cell.setBorderColor(new Color(255, 255, 255));
        //cell.setColspan(2);
        //cell.setFixedHeight(118f);
        table.addCell(cell);

        cell = new PdfPCell(new Paragraph("",font16ITALIC));
        cell.setBorderColor(new Color(255, 255, 255));
        //cell.setColspan(2);
        //cell.setFixedHeight(118f);
        table.addCell(cell);


        parag1=new Paragraph("");
        parag1.add(new Chunk("姓名 NAME      ",font10ITALIC));
        parag1.add(new Chunk(studentName, font10NORMAL));
        parag1.add(new Chunk("               ",font10ITALIC));
        parag1.add(new Chunk("Grade   ",font10ITALIC));
        parag1.add(new Chunk(grade, font10NORMAL));
        parag1.add(new Chunk("   ",font10ITALIC));
        parag1.add(new Chunk("Parent   ",font10ITALIC));
        parag1.add(new Chunk(" "+parents+" ",font10NORMAL));

        cell = new PdfPCell(parag1);
        cell.setColspan(2);
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBorderColor(new Color(255, 255, 255));
        cell.setFixedHeight(30f);
        table.addCell(cell);

        cell = new PdfPCell(new Paragraph("",font12ITALIC));
        cell.setBorderColor(new Color(255, 255, 255));
        table.addCell(cell);


        float[] widths3 = {0.35f,0.35f,0.30f};
        nest = new PdfPTable(widths3);

        parag1=new Paragraph("");
        int lineNo = 0;
        for (; charges!=null&&lineNo<charges.size() && lineNo<12; lineNo++) {
            ChargeItemMembr ci = charges.get(lineNo);
            String cname = makePrecise(ci.getChargeName(), 24, true, ' ');
            ArrayList<Discount> dv = discountMap.get(ci.getChargeKey());
            int discount = 0;
            for (int j=0; dv!=null && j<dv.size(); j++) {
                Discount d = dv.get(j);
                discount += d.getAmount();
            }
            String cvalue = makePrecise(mnf.format(ci.getMyAmount()-discount), 13, false, ' ');
            parag1.add(new Chunk("  " + cname + cvalue + "\n",font9NORMAL));
        }

        if (received>0) {
            parag1.add(new Chunk("  應收:" + receivable + " 已收:" + received + "\n",font9NORMAL));
        }

        cell = new PdfPCell(parag1);
        cell.setFixedHeight(120f);

        border=new Rectangle(0f, 0f);
        border.setBorderWidthRight(0f);
        border.setBorderColorRight(Color.WHITE);
        cell.cloneNonPositionParameters(border);


        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_TOP);
        nest.addCell(cell);

        parag1=new Paragraph("");
        for (; charges!=null&&lineNo<charges.size() && lineNo<24; lineNo++) {
            ChargeItemMembr ci = charges.get(lineNo);
            String cname = makePrecise(ci.getChargeName(), 24, true, ' ');
            ArrayList<Discount> dv = discountMap.get(ci.getChargeKey());
            int discount = 0;
            for (int j=0; dv!=null && j<dv.size(); j++) {
                Discount d = dv.get(j);
                discount += d.getAmount();
            }
            String cvalue = makePrecise(mnf.format(ci.getMyAmount()-discount), 13, false, ' ');
            parag1.add(new Chunk("  " + cname + cvalue + "\n",font9NORMAL));
        }

        cell = new PdfPCell(parag1);

        border=new Rectangle(0f, 0f);
        border.setBorderWidthLeft(0f);
        border.setBorderColorLeft(Color.WHITE);
        cell.cloneNonPositionParameters(border);

        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_TOP);
        nest.addCell(cell);


        parag1=new Paragraph("");
        parag1.add(new Chunk("     帳號  ACCT.NO\n",font9NORMAL));
        parag1.add(new Chunk("     " + schoolNo +" "+studentAccountNumber+"\n\n",font9NORMAL));
        parag1.add(new Chunk("   " + bankName, font12NORMAL));
        cell = new PdfPCell(parag1);

        border=new Rectangle(0f, 0f);
        border.setBorderWidthBottom(0f);
        border.setBorderColorBottom(Color.WHITE);
        border.setBorderWidthLeft(0.5f);
        border.setBorderColorLeft(Color.BLACK);
        cell.cloneNonPositionParameters(border);

        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_TOP);
        nest.addCell(cell);


        parag1=new Paragraph("");
        parag1.add(new Chunk("應納金額 AMOUNT      ",font9NORMAL));
        parag1.add(new Chunk("NT$ " + amountStr,font12NORMAL));
        parag1.add(new Chunk("        NO.",font9NORMAL));
        cell = new PdfPCell(parag1);
        cell.setColspan(2);
        cell.setFixedHeight(25f);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nest.addCell(cell);


        parag1=new Paragraph("");
        parag1.add(new Chunk("(蓋收付款章欄)\n",font9NORMAL));
        cell = new PdfPCell(parag1);
        border=new Rectangle(0f, 0f);
        border.setBorderWidthTop(0f);
        border.setBorderColorTop(Color.WHITE);
        cell.cloneNonPositionParameters(border);

        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
        nest.addCell(cell);


        cell = new PdfPCell(nest);
        cell.setColspan(2);
        cell.setFixedHeight(150f);
        table.addCell(cell);

        cell = new PdfPCell(new Paragraph("",font16ITALIC));
        border=new Rectangle(0f, 0f);
        border.setBorderWidthTop(0f);
        border.setBorderColorTop(Color.WHITE);
        border.setBorderWidthRight(1f);
        border.setBorderColorRight(Color.WHITE);
        border.setBorderWidthBottom(1f);
        border.setBorderColorBottom(Color.WHITE);
        cell.cloneNonPositionParameters(border);
        table.addCell(cell);

        
        table.setWidthPercentage(100);
        document.add(table);


        cb.setLineWidth(1.5f);
        cb.rectangle(10, 340, 560,0);
        cb.stroke();

        parag1=new Paragraph("\n\n",font10NORMAL);
        document.add(parag1);
        
       table = new PdfPTable(widths);

        cell = new PdfPCell(new Paragraph("3",font18ITALIC));
        cell.setFixedHeight(35f);
        cell.setBorderColor(new Color(255, 255, 255));
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table.addCell(cell);
        
        parag1=new Paragraph("");
        parag1.add(new Chunk(billHeader, font13ITALIC));
        parag1.add(new Chunk("\n", font4ITALIC));
        parag1.add(new Chunk(billSubHeader, font13ITALIC));
        parag1.add(new Chunk("    日期(Date):     年    月    日",font10ITALIC));
        parag1.add(new Chunk("\n",font4ITALIC));


        cell = new PdfPCell(parag1);
        cell.setBorderColor(new Color(255, 255, 255));
        //cell.setColspan(2);
        //cell.setFixedHeight(118f);
        table.addCell(cell);

        cell = new PdfPCell(new Paragraph("",font16ITALIC));
        cell.setBorderColor(new Color(255, 255, 255));
        //cell.setColspan(2);
        //cell.setFixedHeight(118f);
        table.addCell(cell);


        parag1=new Paragraph("");
        parag1.add(new Chunk("姓名 NAME      ",font10ITALIC));
        parag1.add(new Chunk(studentName, font10NORMAL));
        parag1.add(new Chunk("               ",font10ITALIC));
        parag1.add(new Chunk("Grade   ",font10ITALIC));
        parag1.add(new Chunk(grade, font10NORMAL));
        parag1.add(new Chunk("   ",font10ITALIC));
        parag1.add(new Chunk("Parent   ",font10ITALIC));
        parag1.add(new Chunk(" "+parents+" ",font10NORMAL));

        cell = new PdfPCell(parag1);
        cell.setColspan(2);
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBorderColor(new Color(255, 255, 255));
        cell.setFixedHeight(30f);
        table.addCell(cell);

        cell = new PdfPCell(new Paragraph("",font12ITALIC));
        cell.setBorderColor(new Color(255, 255, 255));
        table.addCell(cell);

        nest = new PdfPTable(widths3);

        parag1=new Paragraph("");
        lineNo = 0;
        for (; charges!=null&&lineNo<charges.size() && lineNo<12; lineNo++) {
            ChargeItemMembr ci = charges.get(lineNo);
            String cname = makePrecise(ci.getChargeName(), 24, true, ' ');
            ArrayList<Discount> dv = discountMap.get(ci.getChargeKey());
            int discount = 0;
            for (int j=0; dv!=null && j<dv.size(); j++) {
                Discount d = dv.get(j);
                discount += d.getAmount();
            }
            String cvalue = makePrecise(mnf.format(ci.getMyAmount()-discount), 13, false, ' ');
            parag1.add(new Chunk("  " + cname + cvalue + "\n",font9NORMAL));
        }

        if (received>0) {
            parag1.add(new Chunk("  應收:" + receivable + " 已收:" + received + "\n",font9NORMAL));
        }

        cell = new PdfPCell(parag1);
        cell.setFixedHeight(120f);

        border=new Rectangle(0f, 0f);
        border.setBorderWidthRight(0f);
        border.setBorderColorRight(Color.WHITE);
        cell.cloneNonPositionParameters(border);


        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_TOP);
        nest.addCell(cell);

        parag1=new Paragraph("");
        for (; charges!=null&&lineNo<charges.size() && lineNo<24; lineNo++) {
            ChargeItemMembr ci = charges.get(lineNo);
            String cname = makePrecise(ci.getChargeName(), 24, true, ' ');
            ArrayList<Discount> dv = discountMap.get(ci.getChargeKey());
            int discount = 0;
            for (int j=0; dv!=null && j<dv.size(); j++) {
                Discount d = dv.get(j);
                discount += d.getAmount();
            }
            String cvalue = makePrecise(mnf.format(ci.getMyAmount()-discount), 13, false, ' ');
            parag1.add(new Chunk("  " + cname + cvalue + "\n",font9NORMAL));
        }

        cell = new PdfPCell(parag1);

        border=new Rectangle(0f, 0f);
        border.setBorderWidthLeft(0f);
        border.setBorderColorLeft(Color.WHITE);
        cell.cloneNonPositionParameters(border);

        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_TOP);
        nest.addCell(cell);


        parag1=new Paragraph("");
        parag1.add(new Chunk("     帳號  ACCT.NO\n",font9NORMAL));
        parag1.add(new Chunk("     " + schoolNo +" "+studentAccountNumber+"\n\n",font9NORMAL));
        parag1.add(new Chunk("   " + bankName, font12NORMAL));
        cell = new PdfPCell(parag1);

        border=new Rectangle(0f, 0f);
        border.setBorderWidthBottom(0f);
        border.setBorderColorBottom(Color.WHITE);
        border.setBorderWidthLeft(0.5f);
        border.setBorderColorLeft(Color.BLACK);
        cell.cloneNonPositionParameters(border);

        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_TOP);
        nest.addCell(cell);


        parag1=new Paragraph("");
        parag1.add(new Chunk("應納金額 AMOUNT      ",font9NORMAL));
        parag1.add(new Chunk("NT$ " + amountStr,font12NORMAL));
        parag1.add(new Chunk("        NO.",font9NORMAL));
        cell = new PdfPCell(parag1);
        cell.setColspan(2);
        cell.setFixedHeight(25f);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nest.addCell(cell);


        parag1=new Paragraph("");
        parag1.add(new Chunk("(蓋收付款章欄)\n",font9NORMAL));
        cell = new PdfPCell(parag1);
        border=new Rectangle(0f, 0f);
        border.setBorderWidthTop(0f);
        border.setBorderColorTop(Color.WHITE);
        cell.cloneNonPositionParameters(border);

        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
        nest.addCell(cell);


        cell = new PdfPCell(nest);
        cell.setColspan(2);
        cell.setFixedHeight(150f);
        table.addCell(cell);

        cell = new PdfPCell(new Paragraph("",font16ITALIC));
        border=new Rectangle(0f, 0f);
        border.setBorderWidthTop(0f);
        border.setBorderColorTop(Color.WHITE);
        border.setBorderWidthRight(1f);
        border.setBorderColorRight(Color.WHITE);
        border.setBorderWidthBottom(1f);
        border.setBorderColorBottom(Color.WHITE);
        cell.cloneNonPositionParameters(border);
        table.addCell(cell);

        
        table.setWidthPercentage(100);
        document.add(table);
        cb.beginText();
        cb.setFontAndSize(bfComic2, 12);
        cb.setTextMatrix(560, 800);
        cb.showText("第");
        
        cb.setTextMatrix(560, 785);
        cb.showText("一");

        cb.setTextMatrix(560, 770);
        cb.showText("聯");
        
        cb.setTextMatrix(560, 755);
        cb.showText(":");

        cb.setTextMatrix(560, 740);
        cb.showText("代");

        cb.setTextMatrix(560, 725);
        cb.showText("收");

        cb.setTextMatrix(560, 710);
        cb.showText("單");

        cb.setTextMatrix(560, 695);
        cb.showText("位");

        cb.setTextMatrix(560, 680);
        cb.showText("留");

        cb.setTextMatrix(560, 665);
        cb.showText("存");


        cb.setTextMatrix(555, 555);
        cb.showText("第");
        
        cb.setTextMatrix(555, 540);
        cb.showText("二");

        cb.setTextMatrix(555, 525);
        cb.showText("聯");
        
        cb.setTextMatrix(555, 510);
        cb.showText(":");

        cb.setTextMatrix(555, 495);
        cb.showText("此");

        cb.setTextMatrix(555, 480);
        cb.showText("聯");

        cb.setTextMatrix(555, 465);
        cb.showText("作");

        cb.setTextMatrix(555, 450);
        cb.showText("廢");

        //cb.setTextMatrix(555, 435);
        //cb.showText("收");

        //cb.setTextMatrix(555, 420);
        //cb.showText("妥");

        //cb.setTextMatrix(555, 405);
        //cb.showText("後");

        //cb.setTextMatrix(570, 460);
        //cb.showText("寄");

        //cb.setTextMatrix(570, 445);
        //cb.showText("送");

        //cb.setTextMatrix(570, 430);
        //cb.showText("中");

        //cb.setTextMatrix(570, 415);
        //cb.showText("清");

        //cb.setTextMatrix(570, 400);
        //cb.showText("分");

        //cb.setTextMatrix(570, 385);
        //cb.showText("行");

        cb.setTextMatrix(560, 290);
        cb.showText("第");
        
        cb.setTextMatrix(560, 275);
        cb.showText("三");

        cb.setTextMatrix(560, 260);
        cb.showText("聯");
        
        cb.setTextMatrix(560, 245);
        cb.showText(":");

        cb.setTextMatrix(560, 230);
        cb.showText("學");

        cb.setTextMatrix(560, 215);
        cb.showText("生");

        cb.setTextMatrix(560, 200);
        cb.showText("存");

        cb.setTextMatrix(560, 185);
        cb.showText("查");

        cb.endText();

        float superscript = 9.2f;
        parag1=new Paragraph("1. 本收據請勿塗改，塗改無效，如變更金額請與學校助理"+username+"聯絡。 \n"+
                            "2.	請於限繳日前持本收據至合庫各分行繳納。 \n"+
                            "3.	亦可至其他銀行用匯款(合作金庫銀行中清分行,戶名「馬禮遜學校) 或ATM方式轉帳 (銀行代號: 006)。\n"+
                            "4.	若要開立支票，支票抬頭請寫「"+payAcctStr+"」。",font8NORMAL);
        parag1.setLeading(superscript);
        document.add(parag1);

        Font f_time =new Font(Font.TIMES_ROMAN, 8, Font.NORMAL);
        parag1=new Paragraph("1.	The receipt is not valid if the amount is changed. If you want to make changes, please contact the School assistant ("+username+") for a new receipt. \n"+
                            "2.	Please take this receipt and pay tuition/fees at any branch of Cooperation Bank. \n"+
                            "3.	You can also pay the amount through bank/postal/ATM transfer. (Bank Code: 006)\n"+
                            "4.	If you like to write a check, please make the check payable to \"Morrison Academy\"",f_time);

        parag1.setLeading(superscript);
        document.add(parag1);
    }	


    public void printMCADeferred(
        Document document,String mcalogo,
        String surname, String firstname, Date printDate, String grade, 
        String semester, String campus,
        int tuition, int latefee, int interest,
        Map<Date, String> standardMap, Map<Date, String> monthlyMap,
        int totalamount)
        throws Exception
    {
        document.newPage();

        PdfContentByte cb = this.pdfwriter.getDirectContent();
        BaseFont bfComic2 = BaseFont.createFont(fontPathName,BaseFont.IDENTITY_H,BaseFont.NOT_EMBEDDED);
        Font font16NORMAL = new Font(bfComic2, 16,Font.NORMAL);
        Font font16BOLD = new Font(bfComic2, 16,Font.BOLD);
        Font font12NORMAL = new Font(bfComic2, 12,Font.NORMAL);
        Font font10NORMAL = new Font(bfComic2, 10,Font.NORMAL);
        Font font9NORMAL = new Font(bfComic2, 9,Font.NORMAL);    
        Font font8NORMAL = new Font(bfComic2, 8,Font.NORMAL);    
        Font font6NORMAL = new Font(bfComic2, 6,Font.NORMAL);
        Font font4NORMAL = new Font(bfComic2, 4,Font.NORMAL);
        Font font2NORMAL = new Font(bfComic2, 2,Font.NORMAL);

        Font[] f_times=new Font[6];
        f_times[0] =new Font(Font.TIMES_ROMAN, 20, Font.NORMAL);
        f_times[1] =new Font(Font.TIMES_ROMAN, 16, Font.NORMAL);
        f_times[2] =new Font(Font.TIMES_ROMAN, 14, Font.NORMAL);
        f_times[3] =new Font(Font.TIMES_ROMAN, 10, Font.NORMAL);
        f_times[4] =new Font(Font.TIMES_ROMAN, 8, Font.NORMAL);
        f_times[5] =new Font(Font.TIMES_ROMAN, 5, Font.NORMAL);

        Font f_times_bold =new Font(Font.TIMES_ROMAN, 9, Font.BOLD);

        Font[] f_underline=new Font[5];
        f_underline[0] =new Font(Font.TIMES_ROMAN, 10, Font.UNDERLINE);
        f_underline[1] =new Font(bfComic2, 10,Font.UNDERLINE);
        f_underline[2] =new Font(Font.TIMES_ROMAN, 9, Font.UNDERLINE);
        f_underline[3] =new Font(bfComic2, 9,Font.UNDERLINE);
        f_underline[4] =new Font(Font.COURIER,14,Font.UNDERLINE);  //answer

        float superscript = 9.2f;

//        Font underLine= FontFactory.getFont(FontFactory.TIMES_ROMAN, Font.DEFAULTSIZE, Font.UNDERLINE);


        try {
            Image  logo= Image.getInstance(mcalogo);
            logo.setAbsolutePosition(80,730);
            document.add(logo);
        }
        catch (java.io.IOException e) {}

        Paragraph parag1=new Paragraph("");
        parag1.add(new Chunk("\n\n",f_times[0]));
        parag1.add(new Chunk("                                      MORRISON ACADEMY  \n",f_times[0]));
        parag1.add(new Chunk("                                                DEFERRED PAYMENT PLAN \n\n\n", f_times[1]));
        document.add(parag1);


        parag1=new Paragraph("");
        parag1.add(new Chunk("     "+makePrecise("Family Name:", 21, true, ' '),f_times[2]));
        parag1.add(new Chunk(makePrecise(surname,25, true, ' '),f_underline[3]));
        parag1.add(new Chunk("      ",f_times[2]));
        parag1.add(new Chunk(makePrecise("Date:", 25, true, ' '),f_times[2]));
        DateFormat sdf5 = DateFormat.getDateInstance(DateFormat.MEDIUM, Locale.US);
        parag1.add(new Chunk(makePrecise(sdf5.format(printDate), 25, true, ' '),f_underline[3]));
        document.add(parag1);

        parag1=new Paragraph("");
        parag1.add(new Chunk("     "+makePrecise("Student(s):", 25, true, ' '),f_times[2]));
        parag1.add(new Chunk(makePrecise(firstname,25, true, ' '),f_underline[3]));
        parag1.add(new Chunk("      ",f_times[2]));
        parag1.add(new Chunk(makePrecise("Grade(s):", 23, true, ' '),f_times[2]));
        parag1.add(new Chunk(makePrecise(grade,25, true, ' '),f_underline[3]));
        document.add(parag1);
       
        parag1=new Paragraph("");
        parag1.add(new Chunk("     "+makePrecise("Semester:", 25, true, ' '),f_times[2]));
        parag1.add(new Chunk(makePrecise(semester, 25, true, ' '),f_underline[3]));
        parag1.add(new Chunk("      ",f_times[2]));
        parag1.add(new Chunk(makePrecise("Campus:", 22, true, ' '),f_times[2]));
        parag1.add(new Chunk(makePrecise(campus, 25, true, ' '),f_underline[3]));
        document.add(parag1);

        parag1=new Paragraph("");
        parag1.add(new Chunk("\n",f_times[2]));
        document.add(parag1);

        parag1=new Paragraph("");
        parag1.add(new Chunk("This agreement is made to assure full payment of my account with Morrison Academy and is accepted in lieu of full payment which is normally due on the due day of each semester.   I understand that delayed payment could result in discontinued enrollment. \n\n",f_times[2]));
        document.add(parag1);

        parag1=new Paragraph("");
        parag1.add(new Chunk("School bills not paid by the due day of the semester are subject to a Late Fee of NT$1,000.  Deferred payments following the \"Standard Payment Plan \" are not assessed interest charges.  Deferred payments following the “Monthly Payment Plan” include monthly interest charge of 1% of the unpaid balance, in addition to the late fee.\n",f_times[2]));
        document.add(parag1);

        parag1=new Paragraph("");
        parag1.add(new Chunk("Any payment made after the deadline will be assessed an additional $1,000 late fee.  All tuition and fee are calculated in NT dollars.",f_times[2]));
        document.add(parag1);

        parag1=new Paragraph("");
        parag1.add(new Chunk("\n",f_times[2]));
        document.add(parag1);

        Font f_fixed = new Font(Font.COURIER, 12,Font.NORMAL);  //answer
        String spaceX="                  ";
        parag1=new Paragraph("");
        parag1.add(new Chunk(spaceX+makePrecise("Tuition & fees:", 20, true, ' '),f_fixed));
        parag1.add(new Chunk(makePrecise(mnf.format(tuition), 15, false, ' ') + "\n",f_fixed));
        parag1.add(new Chunk(spaceX+makePrecise("Late Fee & Interest:", 20, true, ' '),f_fixed));
        parag1.add(new Chunk(makePrecise(mnf.format(latefee+interest), 15, false, ' ') + "\n",f_fixed));
        int onetime = (totalamount - (tuition+latefee+interest));
        parag1.add(new Chunk(spaceX+makePrecise("One Time Fee:", 20, true, ' '),f_fixed));
        parag1.add(new Chunk(makePrecise(mnf.format(onetime), 15, false, ' ') + "\n",f_fixed));
        parag1.add(new Chunk(spaceX+makePrecise("Total Due:", 20, true, ' '),f_fixed));
        // parag1.add(new Chunk(makePrecise(mnf.format(tuition+latefee), 15, false, ' ') + "\n",f_fixed));
        parag1.add(new Chunk(makePrecise(mnf.format(totalamount), 15, false, ' ') + "\n",f_fixed));
        document.add(parag1);


        parag1=new Paragraph("");
        parag1.add(new Chunk("\n",f_times[2]));
        document.add(parag1);


        float[] widths3 = {0.30f,0.35f,0.35f};

        PdfPTable nest = new PdfPTable(widths3);
    
    //table title
        parag1=new Paragraph("");
        parag1.add(new Chunk("",f_times[4]));

        PdfPCell cell = new PdfPCell(parag1);
        cell.setFixedHeight(20f);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nest.addCell(cell);


        parag1=new Paragraph("");
        parag1.add(new Chunk("Standard",f_times[2]));
        cell = new PdfPCell(parag1);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nest.addCell(cell);

        parag1=new Paragraph("");
        parag1.add(new Chunk("Monthly",f_times[2]));
        cell = new PdfPCell(parag1);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nest.addCell(cell);

        parag1=new Paragraph("");
        parag1.add(new Chunk("Payment Deadlines",f_underline[0]));
        cell = new PdfPCell(parag1);
        cell.setFixedHeight(25f);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nest.addCell(cell);


        parag1=new Paragraph("");
        parag1.add(new Chunk("Payment Plan",f_underline[0]));
        cell = new PdfPCell(parag1);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nest.addCell(cell);

        parag1=new Paragraph("");
        parag1.add(new Chunk("Payment Plan",f_underline[0]));
        cell = new PdfPCell(parag1);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nest.addCell(cell);


        Iterator<Date> diter = monthlyMap.keySet().iterator();
        boolean first_standard = true;
        boolean first_monthly = true;
        while (diter.hasNext()) {
            Date d = diter.next();
            parag1=new Paragraph("");
            parag1.add(new Chunk(sdf5.format(d),f_times[2]));
            cell = new PdfPCell(parag1);
            cell.setFixedHeight(20f);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            nest.addCell(cell);

            String sv = standardMap.get(d);
            parag1=new Paragraph("");
            if (sv.length()>0 && first_standard) {
                int amt = Integer.parseInt(sv.replace(",", ""));
                amt += onetime;
                sv = mnf.format(amt);
                first_standard = false;
            }
            parag1.add(new Chunk(sv, f_fixed));
            cell = new PdfPCell(parag1);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            nest.addCell(cell);

            String mv = monthlyMap.get(d);
            if (mv.length()>0 && first_monthly) {
                int amt = Integer.parseInt(mv.replace(",", ""));
                amt += onetime;
                mv = mnf.format(amt);
                first_monthly = false;
            }
            parag1=new Paragraph("");
            parag1.add(new Chunk(mv, f_fixed));
            cell = new PdfPCell(parag1);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            nest.addCell(cell);

        }        

        nest.setWidthPercentage(90);
        document.add(nest);


        parag1=new Paragraph("");
        parag1.add(new Chunk("\n",f_times[2]));
        parag1.add(new Chunk("By signing this agreement I consent to the payment plan circled above. \n",f_times[2]));
        parag1.add(new Chunk("Late payments will be assessed an additional late fee.  \n\n\n",f_times[2]));

        parag1.add(new Chunk("            ",f_times[0]));
        parag1.add(new Chunk("                "+makePrecise(" ", 50, true, ' '),f_underline[0]));
        parag1.add(new Chunk("           ",f_times[0]));
        parag1.add(new Chunk("              "+makePrecise(" ", 50, true, ' ')+"\n",f_underline[0]));

        parag1.add(new Chunk("            ",f_times[0]));
        parag1.add(new Chunk("Parent Signature",f_times[2]));
        parag1.add(new Chunk("                         ",f_times[0]));
        parag1.add(new Chunk("Morrison Administrator Signature \n\n\n",f_times[2]));
        parag1.add(new Chunk("                                                                                 Distribution:  Bookkeeper, Parent ",f_times[3]));
        document.add(parag1);
    }



    public PdfPTable printPdf5(
        String subject,
        String title,  // *must*
        int nowPage,
        String logoPath, 
        String backimgPath, 
        String payeeName1,  // *must*
        String payeeName2,  
        String payeeName3,  
        String companyName, // *must*
        String companyAddress, // *must*
        String companyPhone, //*must*
        String website, 
        String ticketId, // *must*
        int amount1,
        int amount2,
        int amount3,  
        int amount4,  // *must*
        Date   billEndDate, // *must*
        String greeting,
        String greetingImgPath,
        String warning,
        String contentTableTitle, // *must*
        String blockLeft,  // *must* 
        String blockRight, // *must*
        String remark, // *must*
		String atmTitle, // *must*
		String atmContent, // *must*
		String acceptString, // *must*
        String payReminder,
        String bottomLeftBoxTitle,  // *must* "櫃臺繳款收訖戳記" or “便利商店櫃臺繳款收訖戳記”
        String bottomMiddleBoxTitle,
        String barcode1,  // *must*
        String barcode2,
        String barcode3,
        String[] bottomRightLines, String path711,int storeActive,int pageNum,int pageTotal) throws Exception
    {

        //PdfContentByte cb = this.pdfwriter.getDirectContent();

        float barcodeN=(float)2.0;
        float barcodeFontSize=(float)8.0;
        float barcodeHieght=(float)30.0;
        float barcodeHieght2=(float)10.0;
        float barcodeN2=(float)1.7;
        float barcodeN3=(float)2.0;

        BaseFont bfComic = BaseFont.createFont(fontPath,BaseFont.IDENTITY_H,BaseFont.NOT_EMBEDDED);
        Font font14b = new Font(bfComic, 14,Font.BOLD);
        Font font14 = new Font(bfComic, 14,Font.NORMAL);
        Font font12 = new Font(bfComic, 12,Font.NORMAL);
        Font font12b = new Font(bfComic, 12,Font.BOLD);
        Font font10 = new Font(bfComic, 10,Font.NORMAL);
        Font font10b = new Font(bfComic, 10,Font.BOLD);
        Font font8 = new Font(bfComic, 8,Font.NORMAL);
        Font font1 = new Font(bfComic,1,Font.NORMAL);
    
        BaseFont bfComic2 = BaseFont.createFont(fontPathName,BaseFont.IDENTITY_H,BaseFont.NOT_EMBEDDED);
        Font font12Name = new Font(bfComic2, 12,Font.NORMAL);
        Font font10Name = new Font(bfComic2, 10,Font.NORMAL);

        float[] widths = {0.49999f,0.002f, 0.49999f};
        PdfPTable table = new PdfPTable(widths);

        float[] widths2 = {1.00f};
        PdfPTable table2 = new PdfPTable(widths2);

        PdfPCell cell= new PdfPCell(new Paragraph(title,font10));
        cell.setFixedHeight(20f);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        table2.addCell(cell);

        cell= new PdfPCell(new Paragraph("項目                應收    折扣    小計",font10));
        cell.setFixedHeight(20f);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell);
        

       String outPs="  ";
        if(greeting !=null){
            if(warning !=null)
                outPs+="\n  ";
            outPs +=greeting;
        }

        if(remark !=null){
            if(greeting !=null || warning !=null)
                outPs+="\n  ";
            outPs +=remark;
        }


        cell = new PdfPCell(new Paragraph(blockLeft+blockRight+"\n\n"+outPs,font10));
        cell.setFixedHeight(205f);
        table2.addCell(cell);
        table2.setWidthPercentage(100);

        cell= new PdfPCell(table2);
        cell.setFixedHeight(245f);
        cell.setBorderColor(new Color(255, 255, 255));
        cell.setVerticalAlignment(Element.ALIGN_TOP);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        table.addCell(cell);

        cell= new PdfPCell(new Paragraph("",font10));
        table.addCell(cell);


        //右邊開始
        float[] widths3 = {1.00f};
        PdfPTable table3 = new PdfPTable(widths3);
        
        String xspace="                      ";    
        String showWord=xspace+companyName; 
        //if (website!=null && website.trim().length()>0)
        //    showWord += " (" + companyPhone + ")";

        showWord += "\n"+xspace+"地址: "+ companyAddress +"\n"+xspace;

        if (website==null || website.trim().length()==0)
            showWord += ("電話: "+ companyPhone);
        else
            showWord += website;

        cell= new PdfPCell(new Paragraph(showWord,font10));               
        cell.setFixedHeight(50f);
        cell.setBorderColor(new Color(255, 255, 255));
        table3.addCell(cell);

        String outName="\n         "+((payeeName2!=null)?payeeName2:"") +" "+payeeName1+"  家長 收";
        cell= new PdfPCell(new Paragraph(outName,font12b));               
        cell.setFixedHeight(55f);
        cell.setBorderColor(new Color(255, 255, 255));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        table3.addCell(cell);
            
        String titleSpace="             ";
        String nowTitle2=titleSpace+"本期應繳金額         繳款截止日 \n\n\n"+titleSpace+"     "+mnf.format(amount4) + "            " + sdf.format(billEndDate);
        cell= new PdfPCell(new Paragraph(nowTitle2,font10));               
        cell.setFixedHeight(55f);
        cell.setBorderColor(new Color(255, 255, 255));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        table3.addCell(cell);

/*
        String xxAmount="";
        if(amount2==(int)0 && amount3==(int)0)
            xxAmount="";
        else
            xxAmount="本期新增("+amount1+") + 前期未繳("+amount2+") - 本期已繳("+amount3+") = 本期應繳("+amount4+")";

        cell= new PdfPCell(new Paragraph("\n"+xxAmount,font8));               
        cell.setFixedHeight(20f);
        cell.setBorderColor(new Color(255, 255, 255));
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_TOP);
        table3.addCell(cell);
        table3.setWidthPercentage(100);
*/


        outPs="";
        if (warning != null)
            outPs=warning;

        cell= new PdfPCell(new Paragraph(outPs+"\n\n\n",font8));               
        cell.setBorderColor(new Color(255, 255, 255));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
        table3.addCell(cell);


        table3.setWidthPercentage(100);
        cell= new PdfPCell(table3);
        cell.setBorderColor(new Color(255, 255, 255));
        cell.setVerticalAlignment(Element.ALIGN_TOP);
        table.addCell(cell);
        table.setWidthPercentage(100);
        //document.add(table);

        return table;    
    }	


    public void printPdf5Ube(
        Document document,
        String subject,
        String title,  // *must*
        int nowPage,
        String logoPath, 
        String backimgPath, 
        String payeeName1,  // *must*
        String payeeName2,  
        String payeeName3,  
        String companyName, // *must*
        String companyAddress, // *must*
        String companyPhone, //*must*
        String website, 
        String ticketId, // *must*
        int amount1,
        int amount2,
        int amount3,  
        int amount4,  // *must*
        Date   billEndDate, // *must*
        String greeting,
        String greetingImgPath,
        String warning,
        String contentTableTitle, // *must*
        String blockLeft,  // *must* 
        String blockRight, // *must*
        String remark, // *must*
		String atmTitle, // *must*
		String atmContent, // *must*
		String acceptString, // *must*
        String payReminder,
        String bottomLeftBoxTitle,  // *must* "櫃臺繳款收訖戳記" or “便利商店櫃臺繳款收訖戳記”
        String bottomMiddleBoxTitle,
        String barcode1,  // *must*
        String barcode2,
        String barcode3,
        String[] bottomRightLines, String path711,int storeActive,int pageNum,int pageTotal) throws Exception
    {
        PdfContentByte cb = this.pdfwriter.getDirectContent();

        float barcodeN=(float)2.0;
        float barcodeFontSize=(float)8.0;
        float barcodeHieght=(float)30.0;
        float barcodeHieght2=(float)10.0;
        float barcodeN2=(float)1.7;
        float barcodeN3=(float)2.0;

        BaseFont bfComic = BaseFont.createFont(fontPath,BaseFont.IDENTITY_H,BaseFont.NOT_EMBEDDED);
        Font font14b = new Font(bfComic, 14,Font.BOLD);
        Font font14 = new Font(bfComic, 14,Font.NORMAL);
        Font font12 = new Font(bfComic, 12,Font.NORMAL);
        Font font12b = new Font(bfComic, 12,Font.BOLD);
        Font font10 = new Font(bfComic, 10,Font.NORMAL);
        Font font10b = new Font(bfComic, 10,Font.BOLD);
        Font font8 = new Font(bfComic, 8,Font.NORMAL);
        Font font1 = new Font(bfComic,1,Font.NORMAL);
    
        BaseFont bfComic2 = BaseFont.createFont(fontPathName,BaseFont.IDENTITY_H,BaseFont.NOT_EMBEDDED);
        Font font12Name = new Font(bfComic2, 12,Font.NORMAL);
        Font font10Name = new Font(bfComic2, 10,Font.NORMAL);

        if (logoPath!=null && logoPath.length()>0) {
            try {
                Image  logoI= Image.getInstance(logoPath);

                if(pageNum==1 || (pageNum%3==1))
                    logoI.setAbsolutePosition(395,805);
                else if(pageNum==2 || (pageNum%3==2))                    
                    logoI.setAbsolutePosition(395,530);
                else
                    logoI.setAbsolutePosition(395,255);
                document.add(logoI);
            }
            catch (java.io.IOException e) {}
        }

        Barcode39 codeFeeticketId = new Barcode39();
        codeFeeticketId.setCode(ticketId);
        codeFeeticketId.setStartStopText(true);
        codeFeeticketId.setSize(barcodeFontSize);
        codeFeeticketId.setN(barcodeN);
        codeFeeticketId.setBarHeight(barcodeHieght2);

        Image imageFtId = codeFeeticketId.createImageWithBarcode(cb, null, null);

        if(pageNum==1 || (pageNum%3==1))
            imageFtId.setAbsolutePosition(355,733);
        else if(pageNum==2 || (pageNum%3==2))                    
            imageFtId.setAbsolutePosition(355,458);
        else
            imageFtId.setAbsolutePosition(355,183);

        document.add(imageFtId);


        String menuImge = menu2Path;
        Image  menuI= Image.getInstance(menuImge);

        if(pageNum==1 || (pageNum%3==1))
            menuI.setAbsolutePosition(355,673);
        else if(pageNum==2 || (pageNum%3==2))                    
            menuI.setAbsolutePosition(355,398);
        else
            menuI.setAbsolutePosition(355,123);

        document.add(menuI);
    

        float[] widths = {0.49999f,0.002f, 0.49999f};
        PdfPTable table = new PdfPTable(widths);

        float[] widths2 = {1.00f};
        PdfPTable table2 = new PdfPTable(widths2);

        PdfPCell cell= new PdfPCell(new Paragraph(ticketId+","+title,font10));
        cell.setFixedHeight(20f);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        table2.addCell(cell);

        cell= new PdfPCell(new Paragraph("項目                應收    折扣    小計",font10));
        cell.setFixedHeight(20f);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell);
            
        cell = new PdfPCell(new Paragraph(blockLeft+blockRight,font10));
        cell.setFixedHeight(205f);
        table2.addCell(cell);
        table2.setWidthPercentage(100);

        cell= new PdfPCell(table2);
        cell.setFixedHeight(245f);
        cell.setBorderColor(new Color(255, 255, 255));
        cell.setVerticalAlignment(Element.ALIGN_TOP);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        table.addCell(cell);

        cell= new PdfPCell(new Paragraph("",font10));
        table.addCell(cell);


        //右邊開始
        float[] widths3 = {1.00f};
        PdfPTable table3 = new PdfPTable(widths3);
        
        String xspace="                          ";    
        String showWord=xspace+companyName; 
        //if (website!=null && website.trim().length()>0)
        //    showWord += " (" + companyPhone + ")";

        showWord += "\n"+xspace+"地址: "+ companyAddress +"\n"+xspace;

        if (website==null || website.trim().length()==0)
            showWord += ("電話: "+ companyPhone);
        else
            showWord += website;

        cell= new PdfPCell(new Paragraph(showWord,font10));               
        cell.setFixedHeight(50f);
        cell.setBorderColor(new Color(255, 255, 255));
        table3.addCell(cell);

        String outName="\n         "+((payeeName2!=null)?payeeName2:"") +" "+payeeName1+"  家長 收";
        cell= new PdfPCell(new Paragraph(outName,font12b));               
        cell.setFixedHeight(55f);
        cell.setBorderColor(new Color(255, 255, 255));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        table3.addCell(cell);
            
        String titleSpace="             ";
        String nowTitle2=titleSpace+"本期應繳金額         繳款截止日 \n\n\n"+titleSpace+"     "+mnf.format(amount4) + "          " + sdf.format(billEndDate);
        cell= new PdfPCell(new Paragraph(nowTitle2,font10));               
        cell.setFixedHeight(55f);
        cell.setBorderColor(new Color(255, 255, 255));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        table3.addCell(cell);

/*
        String xxAmount="";
        if(amount2==(int)0 && amount3==(int)0)
            xxAmount="";
        else
            xxAmount="本期新增("+amount1+") + 前期未繳("+amount2+") - 本期已繳("+amount3+") = 本期應繳("+amount4+")";

        cell= new PdfPCell(new Paragraph("\n"+xxAmount,font8));               
        cell.setFixedHeight(20f);
        cell.setBorderColor(new Color(255, 255, 255));
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_TOP);
        table3.addCell(cell);
        table3.setWidthPercentage(100);
*/
       String outPs="  ";
        if (warning != null)
            outPs=warning;

        if(greeting !=null){
            if(warning !=null)
                outPs+="\n  ";
            outPs +=greeting;
        }

        cell= new PdfPCell(new Paragraph(outPs,font8));               
        cell.setBorderColor(new Color(255, 255, 255));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
        table3.addCell(cell);
        table3.setWidthPercentage(100);

        cell= new PdfPCell(table3);
        cell.setBorderColor(new Color(255, 255, 255));
        cell.setVerticalAlignment(Element.ALIGN_TOP);
        table.addCell(cell);

        table.setWidthPercentage(100);
        document.add(table);

        if(pageNum!=3 && (pageNum%3!=0)){
            Paragraph parag6=new Paragraph("\n\n",font10);
            parag6.setAlignment(Element.ALIGN_LEFT);
            document.add(parag6);
        }
        
        if(pageNum==pageTotal){

            if((pageNum%3)==1 || (pageNum%3)==2){
                Paragraph parag6=new Paragraph("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n end",font14);
                parag6.setAlignment(Element.ALIGN_LEFT);
                document.add(parag6);
            }
        }
    }	

    public void printPdf4(
        Document document,
        String subject,
        String title,  // *must*
        int nowPage,
        String logoPath, 
        String backimgPath, 
        String payeeName1,  // *must*
        String payeeName2,  
        String payeeName3,  
        String companyName, // *must*
        String companyAddress, // *must*
        String companyPhone, //*must*
        String website, 
        String ticketId, // *must*
        int amount1,
        int amount2,
        int amount3,  
        int amount4,  // *must*
        Date   billEndDate, // *must*
        String greeting,
        String greetingImgPath,
        String warning,
        String contentTableTitle, // *must*
        String blockLeft,  // *must* 
        String blockRight, // *must*
        String remark, // *must*
		String atmTitle, // *must*
		String atmContent, // *must*
		String acceptString, // *must*
        String payReminder,
        String bottomLeftBoxTitle,  // *must* "櫃臺繳款收訖戳記" or “便利商店櫃臺繳款收訖戳記”
        String bottomMiddleBoxTitle,
        String barcode1,  // *must*
        String barcode2,
        String barcode3,
        String[] bottomRightLines, String path711) throws Exception
    {
        PdfContentByte cb = this.pdfwriter.getDirectContent();

        float barcodeN=(float)1.7;
        float barcodeFontSize=(float)10.0;
        float barcodeHieght=(float)30.0;
        float barcodeHieght2=(float)24.0;
        float barcodeN2=(float)1.7;
        float barcodeN3=(float)2.0;

        BaseFont bfComic = BaseFont.createFont(fontPath,BaseFont.IDENTITY_H,BaseFont.NOT_EMBEDDED);
        Font font14b = new Font(bfComic, 14,Font.BOLD);
        Font font14 = new Font(bfComic, 14,Font.NORMAL);
        Font font12 = new Font(bfComic, 12,Font.NORMAL);
        Font font10 = new Font(bfComic, 10,Font.NORMAL);
        Font font10b = new Font(bfComic, 10,Font.BOLD);
        Font font8 = new Font(bfComic, 8,Font.NORMAL);
        Font font1 = new Font(bfComic,1,Font.NORMAL);
    
        BaseFont bfComic2 = BaseFont.createFont(fontPathName,BaseFont.IDENTITY_H,BaseFont.NOT_EMBEDDED);
        Font font12Name = new Font(bfComic2, 12,Font.NORMAL);
        Font font10Name = new Font(bfComic2, 10,Font.NORMAL);

        Paragraph cTitle = new Paragraph(subject,font1);
        cTitle.setAlignment(Element.ALIGN_RIGHT);
        Chapter chapter = new Chapter(cTitle,nowPage);
        document.add(chapter);
    
        String strTitle=title;
        Paragraph parag1=new Paragraph(strTitle,font14b);
        parag1.setAlignment(Element.ALIGN_CENTER);
        document.add(parag1);

        if (logoPath!=null && logoPath.length()>0) {
            try {
                Image  logoI= Image.getInstance(logoPath);
                logoI.setAbsolutePosition(10,770);
                document.add(logoI);
            }
            catch (java.io.IOException e) {}
        }

        if (backimgPath!=null && backimgPath.length()>0) {
            try {
                String backImge=backimgPath;
                Image backI=Image.getInstance(backImge);
                backI.setAbsolutePosition(200,400);
                document.add(backI);
            }
            catch (java.io.IOException e) {}
        }

        Paragraph paragX=new Paragraph("\n\n",font12);
        paragX.setAlignment(Element.ALIGN_LEFT);
        document.add(paragX);	

        String space="     ";
        String space2="                       ";
        String space3="                                                      ";
        String space4="                                      ";

        String outName= payeeName1 + " " + ((payeeName2!=null)?payeeName2:"") + " " + ((payeeName3!=null)?payeeName3:"") +"  收";
        String needSpace="";		
    
        int xLoop=49-countStringBytes(outName);
        for(int lp=0;lp<xLoop;lp++)
            needSpace+=" ";
    
        String showWord=space+outName+needSpace+companyName; 
        if (website!=null && website.trim().length()>0)
            showWord += " (" + companyPhone + ")";

        showWord += "\n"+space3+"地址: "+ companyAddress +"\n"+space3;

        if (website==null || website.trim().length()==0)
            showWord += ("電話: "+ companyPhone);
        else
            showWord += website;

        Paragraph parag6=new Paragraph(showWord,font12Name);
        parag6.setAlignment(Element.ALIGN_LEFT);
        document.add(parag6);	
    
        Barcode39 codeFeeticketId = new Barcode39();
        codeFeeticketId.setCode(ticketId);
        codeFeeticketId.setStartStopText(true);
        codeFeeticketId.setSize(barcodeFontSize);
        codeFeeticketId.setN(barcodeN);
        codeFeeticketId.setBarHeight(barcodeHieght2);

        Image imageFtId = codeFeeticketId.createImageWithBarcode(cb, null, null);
        //imageFtId.setAlignment(Element.ALIGN_CENTER);
        imageFtId.setAbsolutePosition(45,718);
        document.add(imageFtId);

        parag6=new Paragraph("\n",font12);
        parag6.setAlignment(Element.ALIGN_LEFT);
        document.add(parag6);
    
        if(amount2==(int)0 && amount3==(int)0)
        {
            parag6=new Paragraph(space+"                                  本期應繳金額         繳款截止日",font10b);
            parag6.setAlignment(Element.ALIGN_LEFT);
            document.add(parag6);                
            
            parag6=new Paragraph("\n",font8);
            parag6.setAlignment(Element.ALIGN_LEFT);
            document.add(parag6);
            
            parag6=new Paragraph(space+"                               " + mnf.format(amount4) + "          " + sdf.format(billEndDate)+"\n",font12);
            parag6.setAlignment(Element.ALIGN_LEFT);
            document.add(parag6);
            
            parag6=new Paragraph("\n",font8);
            parag6.setAlignment(Element.ALIGN_LEFT);
            document.add(parag6);
            
            String menuImge = menu2Path;
            Image  menuI= Image.getInstance(menuImge);
            //logoI.setAlignment(Image.LEFT | Image.UNDERLYING);
            menuI.setAbsolutePosition(200,644);
            document.add(menuI);    
        }
        else{
//System.out.println("## amount1=" + amount1 + " amount2=" + amount2 + " amount3=" + amount3 + " amount4=" + amount4);            
            parag6=new Paragraph(space+"    本期新增金額         前期未繳金額        本期已繳金額           本期應繳金額         繳款截止日",font10);
            parag6.setAlignment(Element.ALIGN_LEFT);
            document.add(parag6);
                            
            parag6=new Paragraph("\n",font8);
            parag6.setAlignment(Element.ALIGN_LEFT);
            document.add(parag6);
            
            String x="";
            int padding = 17-mnf.format(amount1).length();
            for(int i=0; i<padding; i++)
                x += " ";
            
            String y="";			
            padding = 15-mnf.format(amount2).length();
            for(int i=0; i<padding; i++)
                y += " ";
        
            String z="";
            padding = 19 - mnf.format(amount3).length();
            for(int i=0; i<padding; i++)
                z += " ";

            String line = mnf.format(amount1) + x + mnf.format(amount2)+ y + 
                mnf.format(amount3) + z + mnf.format(amount4);

            parag6=new Paragraph(space + "     " + line+ "          " + sdf.format(billEndDate) + "\n" ,font12);
            parag6.setAlignment(Element.ALIGN_LEFT);
            document.add(parag6);
            
            parag6=new Paragraph("\n",font8);
            parag6.setAlignment(Element.ALIGN_LEFT);
            document.add(parag6);
            
            String menuImge=menuPath;
            Image  menuI= Image.getInstance(menuImge);
            //logoI.setAlignment(Image.LEFT | Image.UNDERLYING);
            menuI.setAbsolutePosition(50,644);
            document.add(menuI);		
        }

        if (greeting!=null)
            document.add(new Paragraph("        "+greeting,font10b)); 

        if (greetingImgPath!=null) {
            Image  greetingI = Image.getInstance(greetingImgPath);
            greetingI.setAbsolutePosition(220,710);
            document.add(greetingI);	
        }	

        if (warning == null)
            warning = " ";
        parag6=new Paragraph(space + warning ,font8);
        parag6.setAlignment(Element.ALIGN_LEFT);
        document.add(parag6);

        parag6=new Paragraph("\n",font8);
        parag6.setAlignment(Element.ALIGN_LEFT);
        document.add(parag6);
    
        float[] widths = {0.50f, 0.50f};
        PdfPTable table = new PdfPTable(widths);

        float[] widths2 = {1.0f};
        PdfPTable nest = new PdfPTable(widths2);

        PdfPCell cell = new PdfPCell(new Paragraph(contentTableTitle,font12));
        cell.setFixedHeight(20f);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nest.addCell(cell);

        cell= new PdfPCell(new Paragraph("項目                                小計",font10));
        cell.setFixedHeight(20f);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nest.addCell(cell);

        cell = new PdfPCell(new Paragraph(blockLeft+blockRight,font10));
        //cell.setFixedHeight(500f);
        nest.addCell(cell);
        nest.setWidthPercentage(100);

        cell =new PdfPCell(nest);
        cell.setBorderColor(new Color(255, 255, 255));
        table.addCell(cell);

        //table.addCell(nest);


        nest = new PdfPTable(widths2);
        cell = new PdfPCell(new Paragraph("銀行轉帳",font12));
        cell.setFixedHeight(20f);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nest.addCell(cell);

        cell = new PdfPCell(new Paragraph(atmContent,font10));
        cell.setFixedHeight(160f);
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nest.addCell(cell);

        cell = new PdfPCell(new Paragraph("便利商店繳款",font12));
        cell.setFixedHeight(20f);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nest.addCell(cell);

        StringBuffer sContent4_1 = new StringBuffer();
        StringBuffer sCOntent4_2 = new StringBuffer();
        StringBuffer sb = sContent4_1;
        if (bottomRightLines!=null) {
            for (int i=0; i<bottomRightLines.length; i++)
            {
                sb.append(bottomRightLines[i]);
                if (bottomRightLines[i].indexOf("繳款人")>=0)
                    sb = sCOntent4_2;
            }
        } 
        
        String xWord="\n"+sContent4_1.toString()+payeeName1+"\n"+sCOntent4_2.toString()+"\n\n   -------------------------------------------\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"+sContent4_1.toString()+payeeName1+"\n"+sCOntent4_2.toString();

        cell = new PdfPCell(new Paragraph(xWord,font10));
        cell.setFixedHeight(300f);
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_TOP);
        nest.addCell(cell);

        nest.setWidthPercentage(100);
        
        cell =new PdfPCell(nest);
        cell.setBorderColor(new Color(255, 255, 255));
        table.addCell(cell);

        table.setWidthPercentage(90);
        document.add(table);

        document.add(new Paragraph("      " + remark, font10));  //ps;

        Barcode39 code1 = new Barcode39();
        code1.setCode(barcode1);
        code1.setStartStopText(true);
        code1.setSize(barcodeFontSize);
        code1.setN(barcodeN);
        code1.setBarHeight(barcodeHieght);
        Image imageCode1 = code1.createImageWithBarcode(cb, null, null);
        imageCode1.setAbsolutePosition(330,250);
        document.add(imageCode1);

        if (barcode2!=null) {
            Barcode39 code2 = new Barcode39();
            code2.setCode(barcode2);
            code2.setStartStopText(true);
            code2.setSize(barcodeFontSize);
            code2.setN(barcodeN);
            code2.setBarHeight(barcodeHieght);
            Image imageCode2 = code2.createImageWithBarcode(cb, null, null);
            imageCode2.setAbsolutePosition(330,200);
            document.add(imageCode2);
        }

        if (barcode3!=null) {
            Barcode39 code3 = new Barcode39();
            code3.setCode(barcode3);
            code3.setStartStopText(true);
            code3.setSize(barcodeFontSize);
            code3.setN(barcodeN);
            code3.setBarHeight(barcodeHieght);
            Image imageCode3 = code3.createImageWithBarcode(cb, null, null);
            imageCode3.setAbsolutePosition(330,150);
            document.add(imageCode3);
        }

       

        parag6=new Paragraph("本帳單列印由必亨商業軟體股份有限公司技術支援，02-23693566，http://www.phm.com.tw",font8);
        parag6.setAlignment(Element.ALIGN_CENTER);
        document.add(parag6); 
    }	


   public void printPdfType3(
        Document document,
        String companyName, // *must*
        String companyAddress, // *must*
        String companyPhone, //*must*
        String website, 
        String className,
        String studentName,
        String title,  // *must*
        Date billMonth,
        String ticketId, // *must*
        String remark, // *must*
        String greeting,
        int amount1,
        int amount2,
        int amount3,  
        int amount4,  // *must*
        int nowPage,
        String logoPath, 
        String backimgPath, 
        String payeeName1,  // *must*
        String payeeName2,  
        String payeeName3,  
        Date   billEndDate, // *must*
        String greetingImgPath,
        String warning,
        String contentTableTitle, // *must*
        String blockLeft,  // *must* 
        String blockRight, // *must*
		String atmTitle, // *must*
		String atmContent, // *must*
		String acceptString, // *must*
        String payReminder,
        String bottomLeftBoxTitle,  // *must* "櫃臺繳款收訖戳記" or “便利商店櫃臺繳款收訖戳記”
        String bottomMiddleBoxTitle,
        String barcode1,  // *must*
        String barcode2,
        String barcode3,
        String[] bottomRightLines) throws Exception
    {
        PdfContentByte cb = this.pdfwriter.getDirectContent();

        float barcodeN=(float)1.7;
        float barcodeFontSize=(float)10.0;
        float barcodeHieght=(float)13.0;
        float barcodeN2=(float)1.7;
        float barcodeN3=(float)2.0;

        BaseFont bfComic = BaseFont.createFont(fontPath,BaseFont.IDENTITY_H,BaseFont.NOT_EMBEDDED);
        Font font14b = new Font(bfComic, 14,Font.BOLD);
        Font font14 = new Font(bfComic, 14,Font.NORMAL);
        Font font12 = new Font(bfComic, 12,Font.NORMAL);
        Font font10 = new Font(bfComic, 10,Font.NORMAL);
        Font font10b = new Font(bfComic, 10,Font.BOLD);
        Font font8 = new Font(bfComic, 8,Font.NORMAL);
        Font font1 = new Font(bfComic,1,Font.NORMAL);
    
        BaseFont fx = BaseFont.createFont(fontPath2,BaseFont.IDENTITY_H,BaseFont.NOT_EMBEDDED);
        Font fx24b = new Font(fx, 24,Font.BOLD);
        Font fx22b = new Font(fx, 22,Font.BOLD);
        Font fx22 = new Font(fx, 22,Font.NORMAL);
        Font fx20b = new Font(fx, 20,Font.BOLD);
        Font fx20 = new Font(fx, 20,Font.NORMAL);
        Font fx18 = new Font(fx, 18,Font.NORMAL);
        Font fx14b = new Font(fx, 14,Font.BOLD);
        Font fx14 = new Font(fx, 14,Font.NORMAL);
        Font fx12b = new Font(fx, 12,Font.BOLD);
        Font fx12 = new Font(fx, 12,Font.NORMAL);
        Font fx10 = new Font(fx, 10,Font.NORMAL);
        Font fx8 = new Font(fx, 8,Font.NORMAL);

        BaseFont bfComic2 = BaseFont.createFont(fontPathName,BaseFont.IDENTITY_H,BaseFont.NOT_EMBEDDED);
        Font font12Name = new Font(bfComic2, 12,Font.NORMAL);
        Font font10Name = new Font(bfComic2, 10,Font.NORMAL);


        Font font= FontFactory.getFont(FontFactory.HELVETICA, Font.DEFAULTSIZE, Font.UNDERLINE);

        PdfTemplate template = this.pdfwriter.getDirectContent().createTemplate(20, 20);
        BaseFont bf = BaseFont.createFont("Helvetica", "winansi", false);
        String text = "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -- - - - - - - - - - - - - - - - - - - - - - - - ";
        float size = 16;
        float width = bf.getWidthPoint(text, size);
        template.beginText();
        template.setFontAndSize(bf, size);
        template.setTextMatrix(0, 2);
        template.showText(text);
        template.endText();
        template.setWidth(500);
        template.setHeight(15);
        // make an Image object from the template
        Image img = Image.getInstance(template);
        img.setRotationDegrees(90);



        Barcode39 codeFeeticketId = new Barcode39();
        codeFeeticketId.setCode(ticketId);
        codeFeeticketId.setStartStopText(true);
        codeFeeticketId.setSize(barcodeFontSize);
        codeFeeticketId.setN(barcodeN);
        codeFeeticketId.setBarHeight(barcodeHieght);




        float[] widths = {0.03f,0.29f,0.02f,0.03f,0.29f,0.02f,0.03f,0.29f};
        PdfPTable table = new PdfPTable(widths);
        table.getDefaultCell().setBorderWidth((float)0.0);

        PdfPCell cell4= new PdfPCell(new Paragraph("\n\n\n\n\n\n\n\n\n第\n三\n聯\n\n\n\n園\n所\n收\n據\n存\n根\n聯\n",font10));
        cell4.setBorderWidth((float)0.0);
        cell4.setFixedHeight(570f);
        cell4.setHorizontalAlignment(Element.ALIGN_MIDDLE);
        cell4.setVerticalAlignment(Element.ALIGN_TOP);
        table.addCell(cell4);

        PdfPCell cell3= new PdfPCell(img);
        cell3.setBorderWidth((float)0.0);
        cell3.setHorizontalAlignment(Element.ALIGN_MIDDLE);
        cell3.setVerticalAlignment(Element.ALIGN_MIDDLE);



        float[] widths2 = {0.25f, 0.25f,0.25f,0.25f};
        PdfPTable nested = new PdfPTable(widths2);

        PdfPCell cell2= new PdfPCell(new Paragraph("* "+companyName+" - "+title+" *",fx12b));
        cell2.setColspan(4);
        cell2.setBorderWidth((float)0.0);
        cell2.setFixedHeight(16f);
        cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell2.setVerticalAlignment(Element.ALIGN_TOP);
        nested.addCell(cell2);

        String xspace="       ";

        cell2= new PdfPCell(new Paragraph(xspace+"地址:"+companyAddress,fx10));
        cell2.setColspan(4);
        cell2.setBorderWidth((float)0.0);
        cell2.setFixedHeight(16f);
        cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell2.setVerticalAlignment(Element.ALIGN_TOP);
        nested.addCell(cell2);
       
        cell2= new PdfPCell(new Paragraph(xspace+"電話:"+companyPhone,fx10));
        cell2.setColspan(4);
        cell2.setBorderWidth((float)0.0);
        cell2.setFixedHeight(16f);
        cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell2.setVerticalAlignment(Element.ALIGN_TOP);
        nested.addCell(cell2);

if(website !=null && website.length()>0){

        cell2= new PdfPCell(new Paragraph(xspace+"網址:"+website,fx10));
        cell2.setColspan(4);
        cell2.setBorderWidth((float)0.0);
        cell2.setFixedHeight(16f);
        cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell2.setVerticalAlignment(Element.ALIGN_TOP);
        nested.addCell(cell2);
}

        cell2= new PdfPCell(new Paragraph("姓名: "+studentName+"  "+className,fx12));
        cell2.setColspan(4);
        cell2.setBorderWidth((float)0.0);
        cell2.setFixedHeight(16f);
        cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nested.addCell(cell2);

        cell2= new PdfPCell(new Paragraph("月份: "+(billMonth.getYear()-11)+"/"+(billMonth.getMonth()+1)+"   帳單編號: " ,fx12));
        cell2.setColspan(4);
        cell2.setBorderWidth((float)0.0);
        cell2.setFixedHeight(16f);
        cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nested.addCell(cell2);




        cell2= new PdfPCell(new Paragraph("",font10));
        cell2.setColspan(4);
        cell2.setBorderWidth((float)0.0);
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nested.addCell(cell2);

        cell2= new PdfPCell(new Paragraph("   收費項目         應 繳   減 免   小 計",font10));
        cell2.setColspan(4);
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nested.addCell(cell2);
        
        StringBuffer billword=new StringBuffer("\n"+blockLeft+blockRight);
        billword.append("\n\n  "+remark);
    
        cell2= new PdfPCell(new Paragraph(billword.toString(),fx10));
        cell2.setColspan(4);
        cell2.setFixedHeight(180f);
        cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell2.setVerticalAlignment(Element.ALIGN_TOP);
        nested.addCell(cell2);


        cell2= new PdfPCell(new Paragraph("本期費用",font10));
        cell2.setColspan(2);
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nested.addCell(cell2);

        cell2= new PdfPCell(new Paragraph(mnf.format(amount1),fx10));
        cell2.setColspan(2);
        cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nested.addCell(cell2);

        cell2= new PdfPCell(new Paragraph("前期未繳",font10));
        cell2.setColspan(2);
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nested.addCell(cell2);

        cell2= new PdfPCell(new Paragraph(mnf.format(amount2),fx10));
        cell2.setColspan(2);
        cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nested.addCell(cell2);

        cell2= new PdfPCell(new Paragraph("本期已繳",font10));
        cell2.setColspan(2);
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nested.addCell(cell2);

        cell2= new PdfPCell(new Paragraph(mnf.format(amount3),fx10));
        cell2.setColspan(2);
        cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nested.addCell(cell2);

        Paragraph p1xx = new Paragraph(new Chunk(" 合計應收: ",fx10));
        p1xx.add(new Phrase(mnf.format(amount4),font));
        p1xx.add(new Phrase("  ",fx12));

        p1xx.add(new Phrase("繳款截止日:",fx10));
        String billEndDateString=String.valueOf(billEndDate.getYear()+1900)+"/"+String.valueOf(billEndDate.getMonth()+1)+"/"+String.valueOf(billEndDate.getDate());
        p1xx.add(new Phrase(billEndDateString,fx10));

        p1xx.add(new Phrase("\n \n",fx8));
        p1xx.add(new Phrase(" 新 台 幣: "+getChineseNum(amount4)+" 元整 \n",fx10));


        cell2= new PdfPCell(p1xx);
        cell2.setColspan(4);
        cell2.setFixedHeight(40f);
        cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nested.addCell(cell2);


        cell2= new PdfPCell(new Paragraph(greeting,font10));
        cell2.setColspan(4);
        cell2.setBorderWidth((float)0.0);
        cell2.setFixedHeight(60f);
        cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell2.setVerticalAlignment(Element.ALIGN_TOP);
        nested.addCell(cell2);


        cell2= new PdfPCell(new Paragraph("□現金:       □匯款 帳號:___________\n\n□支票 票號:___________   到期日:_________    ",font10));
        cell2.setColspan(4);
        cell2.setBorderWidth((float)0.0);
        cell2.setFixedHeight(50f);
        cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell2.setVerticalAlignment(Element.ALIGN_TOP);
        nested.addCell(cell2);

        cell2= new PdfPCell(new Paragraph("\n經收人       會計       園(所)長     ",font10));
        cell2.setColspan(4);
        cell2.setBorderWidth((float)0.0);
        cell2.setFixedHeight(30f);
        cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell2.setVerticalAlignment(Element.ALIGN_TOP);
        nested.addCell(cell2);

        table.addCell(nested);

        table.addCell(cell3);

        cell4= new PdfPCell(new Paragraph("\n\n\n\n\n\n\n\n\n第\n二\n聯\n\n\n\n家\n長\n繳\n費\n收\n據\n聯\n",font10));
        cell4.setBorderWidth((float)0.0);
        cell4.setHorizontalAlignment(Element.ALIGN_MIDDLE);
        cell4.setVerticalAlignment(Element.ALIGN_TOP);
        table.addCell(cell4);

        table.addCell(nested);
 


        table.addCell(cell3);
        cell4= new PdfPCell(new Paragraph("\n\n\n\n\n\n\n\n\n第\n一\n聯\n\n\n\n學\n童\n繳\n費\n通\n知\n聯\n",font10));
        cell4.setBorderWidth((float)0.0);
        cell4.setHorizontalAlignment(Element.ALIGN_MIDDLE);
        cell4.setVerticalAlignment(Element.ALIGN_TOP);
        table.addCell(cell4);
        table.addCell(nested);
        table.setWidthPercentage(100);
        document.add(table);

        Image imageFtId = codeFeeticketId.createImageWithBarcode(cb, null, null);
        imageFtId.setAbsolutePosition(177,490);
        document.add(imageFtId);

        imageFtId.setAbsolutePosition(453,490);
        document.add(imageFtId);

        imageFtId.setAbsolutePosition(730,490);
        document.add(imageFtId);

    }	


    public void printPdf_KJF(
        Document document,
        String studentName,  
        String className,  
        String companyName, 
        String ticketId, 
        String payaccountId_14,
        int finalAmount,  // *must*
        Date   billEndDate, // *must*
        String greeting,
        String warning,
        String block,  // *must* 
        String remark, // *must*
        String barcode1,  // *must*
        String barcode2,
        String barcode3,
        Date billMonth) throws Exception
    {
        PdfContentByte cb = this.pdfwriter.getDirectContent();

        float barcodeN=(float)1.7;
        float barcodeFontSize=(float)8.0;
        float barcodeHieght=(float)20.0;
        float barcodeHieght2=(float)20.0;
        float barcodeN2=(float)1.7;
        float barcodeN3=(float)2.0;

        BaseFont bfComic = BaseFont.createFont(fontPath,BaseFont.IDENTITY_H,BaseFont.NOT_EMBEDDED);
        Font font14b = new Font(bfComic, 14,Font.BOLD);
        Font font14 = new Font(bfComic, 14,Font.NORMAL);
        Font font12 = new Font(bfComic, 12,Font.NORMAL);
        Font font10 = new Font(bfComic, 10,Font.NORMAL);
        Font font10b = new Font(bfComic, 10,Font.BOLD);
        Font font8 = new Font(bfComic, 8,Font.NORMAL);
        Font font1 = new Font(bfComic,1,Font.NORMAL);
    
        BaseFont bfComic2 = BaseFont.createFont(fontPathName,BaseFont.IDENTITY_H,BaseFont.NOT_EMBEDDED);
        Font font12Name = new Font(bfComic2, 12,Font.NORMAL);
        Font font10Name = new Font(bfComic2, 10,Font.NORMAL);


        BaseFont fx = BaseFont.createFont(fontPath2,BaseFont.IDENTITY_H,BaseFont.NOT_EMBEDDED);
        Font fx24b = new Font(fx, 24,Font.BOLD);
        Font fx22b = new Font(fx, 22,Font.BOLD);
        Font fx22 = new Font(fx, 22,Font.NORMAL);
        Font fx20b = new Font(fx, 20,Font.BOLD);
        Font fx20 = new Font(fx, 20,Font.NORMAL);
        Font fx18 = new Font(fx, 18,Font.NORMAL);
        Font fx14b = new Font(fx, 14,Font.BOLD);
        Font fx14 = new Font(fx, 14,Font.NORMAL);
        Font fx12 = new Font(fx, 12,Font.NORMAL);

        BaseFont fy = BaseFont.createFont(fontPath3,BaseFont.IDENTITY_H,BaseFont.NOT_EMBEDDED);
        Font fy20b = new Font(fy, 20,Font.BOLD);
        Font fy20 = new Font(fy, 20,Font.NORMAL);

        Paragraph parag1=new Paragraph("\n \n",font14b);
        parag1.setAlignment(Element.ALIGN_CENTER);
        document.add(parag1);


        float[] widths = {0.03f, 0.25f,0.03f,0.6f,0.09f};
        PdfPTable table = new PdfPTable(widths);

        PdfPCell cell = new PdfPCell(new Paragraph("",font12));
        cell.setBorderWidth((float)0.0);
        cell.setFixedHeight(160f);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table.addCell(cell);

        String showName="";

        if(companyName !=null && companyName.length()>5)
            showName=companyName.substring(0,5)+"\n"+companyName.substring(5);
        else
            showName=companyName;
        cell = new PdfPCell(new Paragraph(showName,fx22b));
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
        cell.setBorderWidth((float)0.0);
        table.addCell(cell);
        
        cell = new PdfPCell(new Paragraph("",font12));
        cell.setBorderWidth((float)0.0);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table.addCell(cell);

        Paragraph p1 = new Paragraph(new Chunk("\n",font12));
        p1.add(new Phrase(greeting,fx20));
        p1.add(new Phrase("\n\n",font12));
        p1.add(new Phrase(remark,font12));

        cell = new PdfPCell(p1);
        cell.setBorderWidth((float)0.0);
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_TOP);
        table.addCell(cell);

        cell = new PdfPCell(new Paragraph("",font12));
        cell.setBorderWidth((float)0.0);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table.addCell(cell);

        table.setWidthPercentage(100);
        document.add(table);
    
        document.add(new Paragraph("\n\n\n  ",font12));
        document.add(new Paragraph("\n",font8));

        float[] widths2 = {0.07f, 0.28f,0.45f,0.05f,0.15f};
        PdfPTable table2 = new PdfPTable(widths2);

        PdfPCell cell2 = new PdfPCell(new Paragraph(" ",font12));
        cell2.setFixedHeight(40f);
        cell2.setBorderWidth((float)0.0);
        cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);                

        cell = new PdfPCell(new Paragraph(showName,fx18));
        cell.setBorderWidth((float)0.0);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell); 

        int syear=0;

        int smonth=0;

        if(billMonth !=null){
            syear=billMonth.getYear()+1900-1911;
            smonth=billMonth.getMonth()+1;
        }                
        
        int classLength=0;

        if(className !=null && className.length()>0)
            classLength=className.length();
        cell = new PdfPCell(new Paragraph("  "+syear+"     "+smonth+"\n\n          "+className+"               "+setSpace(classLength,5,2)+studentName,font12));
        cell.setBorderWidth((float)0.0);
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_BOTTOM);
        table2.addCell(cell); 

        cell = new PdfPCell(new Paragraph("",font12));
        cell.setBorderWidth((float)0.0);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell);


        cell = new PdfPCell(new Paragraph(ticketId,font12));
        cell.setBorderWidth((float)0.0);
        cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cell.setVerticalAlignment(Element.ALIGN_TOP);
        table2.addCell(cell);

        table2.setWidthPercentage(100);
        document.add(table2);

        document.add(new Paragraph("\n  ",font10));

        float[] widths3 = {0.05f, 0.75f,0.2f};
        table2 = new PdfPTable(widths3);
        cell2 = new PdfPCell(new Paragraph("",font12));
        cell2.setBorderWidth((float)0.0);
        cell2.setFixedHeight(120f);
        cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2); 

        cell2 = new PdfPCell(new Paragraph("\n"+block,font10));
        cell2.setBorderWidth((float)0.0);
        cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell2.setVerticalAlignment(Element.ALIGN_TOP);
        table2.addCell(cell2); 
               

        cell2 = new PdfPCell(new Paragraph("\n     "+billEndDate.getDate(),font12));
        cell2.setBorderWidth((float)0.0);
        cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell2.setVerticalAlignment(Element.ALIGN_TOP);
        table2.addCell(cell2); 
        

        //next

        cell2 = new PdfPCell(new Paragraph("",font12));
        cell2.setBorderWidth((float)0.0);
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2); 

        String spaceCX4="              ";

        cell2 = new PdfPCell(new Paragraph(spaceCX4+" "+String.valueOf(finalAmount),font12));
        cell2.setBorderWidth((float)0.0);
        cell2.setColspan(3);
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell2.setVerticalAlignment(Element.ALIGN_TOP);
        table2.addCell(cell2); 

        //next

        cell2 = new PdfPCell(new Paragraph("",font12));
        cell2.setBorderWidth((float)0.0);
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2); 

        cell2 = new PdfPCell(new Paragraph(spaceCX4+getChineseNum(finalAmount),font12));
        cell2.setBorderWidth((float)0.0);
        cell2.setColspan(3);
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2); 
    
        //next
        cell2 = new PdfPCell(new Paragraph("",font12));
        cell2.setFixedHeight(20f);
        cell2.setBorderWidth((float)0.0);
        cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2); 

        cell2 = new PdfPCell(new Paragraph("             "+companyName,font10));
        cell2.setBorderWidth((float)0.0);
        cell2.setColspan(3);
        cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2); 
    
        table2.setWidthPercentage(100);
        document.add(table2);


        document.add(new Paragraph("  \n \n",font12));

        float[] widths4 = {0.05f, 0.60f,0.35f};
        table2 = new PdfPTable(widths4);
        table2.getDefaultCell().setBorderWidth((float)0.0);

        cell2 = new PdfPCell(new Paragraph("",font12));
        cell2.setBorderWidth((float)0.0);
        cell2.setFixedHeight(250f);
        cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2); 

        //nested
        float[] widths5 = {0.2f, 0.8f};
        PdfPTable nested = new PdfPTable(widths5);

        cell2= new PdfPCell(new Paragraph(" ",font10));
        cell2.setBorderWidth((float)0.0);
        cell2.setFixedHeight(40f);
        cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nested.addCell(cell2);

        cell2= new PdfPCell(new Paragraph(companyName,fx20));
        cell2.setBorderWidth((float)0.0);
        cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nested.addCell(cell2);

        String spaceXX2="     ";

        String spacexx3="       ";

        if(className !=null && className.length()>0)
            spacexx3="";
        
        cell2= new PdfPCell(new Paragraph(spaceXX2+spacexx3+className+"                    "+setSpace(classLength,5,2)+studentName+"          "+ticketId,font12));
        cell2.setBorderWidth((float)0.0);
        cell2.setFixedHeight(20f);
        cell2.setColspan(2);
        cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell2.setVerticalAlignment(Element.ALIGN_BOTTOM);
        nested.addCell(cell2);

        cell2= new PdfPCell(new Paragraph(" ",font10));
        cell2.setBorderWidth((float)0.0);
        cell2.setColspan(2);
        cell2.setFixedHeight(130f);
        cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell2.setVerticalAlignment(Element.ALIGN_TOP);
        nested.addCell(cell2);

        String spaceX="                                                  ";
        String spaceXX="                                              ";
        cell2= new PdfPCell(new Paragraph("",font10));
        cell2.setColspan(2);
        cell2.setBorderWidth((float)0.0);
        cell2.setFixedHeight(15f);
        cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell2.setVerticalAlignment(Element.ALIGN_TOP);
        nested.addCell(cell2);

//warning
        cell2= new PdfPCell(new Paragraph("\n"+spaceX+payaccountId_14+"\n"+spaceXX+String.valueOf(finalAmount),font10));
        cell2.setBorderWidth((float)0.0);
        cell2.setColspan(2);
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell2.setVerticalAlignment(Element.ALIGN_TOP);
        nested.addCell(cell2);

        // add nested
        table2.addCell(nested);

        String spaceX2="                                   ";
        nested = new PdfPTable(1);

        cell2= new PdfPCell(new Paragraph("\n\n\n"+payaccountId_14+"\n\n"+companyName+"\n\n"+String.valueOf(finalAmount),font8));
        cell2.setFixedHeight(80f);
        cell2.setBorderWidth((float)0.0);
        cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        nested.addCell(cell2);

        cell2= new PdfPCell(new Paragraph(warning,font10));
        cell2.setBorderWidth((float)0.0);
        cell2.setFixedHeight(100f);
        cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell2.setVerticalAlignment(Element.ALIGN_BOTTOM);
        nested.addCell(cell2);

        table2.addCell(nested); 


        table2.setWidthPercentage(100);
        document.add(table2);


        Barcode39 code1 = new Barcode39();
        code1.setCode(barcode1);
        code1.setStartStopText(true);
        code1.setSize(barcodeFontSize);
        code1.setN(barcodeN);
        code1.setBarHeight(barcodeHieght);
        Image imageCode1 = code1.createImageWithBarcode(cb, null, null);
        imageCode1.setAbsolutePosition(410,95);
        document.add(imageCode1);

        if (barcode2!=null) {
            Barcode39 code2 = new Barcode39();
            code2.setCode(barcode2);
            code2.setStartStopText(true);
            code2.setSize(barcodeFontSize);
            code2.setN(barcodeN);
            code2.setBarHeight(barcodeHieght);
            Image imageCode2 = code2.createImageWithBarcode(cb, null, null);
            imageCode2.setAbsolutePosition(410,65);
            document.add(imageCode2);
        }

        if (barcode3!=null) {
            Barcode39 code3 = new Barcode39();
            code3.setCode(barcode3);
            code3.setStartStopText(true);
            code3.setSize(barcodeFontSize);
            code3.setN(barcodeN);
            code3.setBarHeight(barcodeHieght);
            Image imageCode3 = code3.createImageWithBarcode(cb, null, null);
            imageCode3.setAbsolutePosition(410,35);
            document.add(imageCode3);
        }
        
    }	

    public String setSpace(int needSpace,int nowSpace,int unitSpace){

        
        if(nowSpace>=needSpace){
            return "";
        }else{
            
            int nowX=nowSpace-needSpace;
            
            String unitP=" ";

            if(unitSpace==2)
                  unitP="  ";                  
            StringBuffer sb=new StringBuffer();
            for(int i=0;i<nowX;i++)
                sb.append(unitP);

            return sb.toString();
        }
    }

    public String getChineseNum(int money){

        String moneyString=String.valueOf(money);
        
        StringBuffer sb=new StringBuffer();
        
        for(int i=0;i<moneyString.length();i++)
        {
            String nowNum=moneyString.substring(i,(i+1));

            if(Integer.parseInt(nowNum) !=0)
            {
                sb.append(" "+changeWord(nowNum));
                int nowPositiun=moneyString.length()-i;      
                sb.append(" "+getChinesePosition(nowPositiun));
            }
        }
        //sb.append(" 元整");
        return sb.toString();
    }

    public String getChinesePosition(int nowPositiun)
    {
        String word="";
        switch(nowPositiun)
        {
            case 9:
                word="億";
                break;
            case 8:
                word="仟";
                break;
            case 7:
                word="佰";
                break;
            case 6:
                word="拾";
                break;
            case 5:
                word="萬";
                break;
            case 4:
                word="仟";
                break;
            case 3:
                word="佰";
                break;
            case 2:
                word="拾";
                break;

            default:
                word="";
                break;
        }
        return word;
    }

    public String changeWord(String num){

        int runNum=Integer.parseInt(num);

        String word=changeWord(runNum);

        return word;
    }

    public String changeWord(int num){

        String word="";
        switch(num){
            case 0:
                word="";
                break;
            case 1:
                word="壹";
                break;
            case 2:
                word="貳";
                break;
            case 3:
                word="參";
                break;
            case 4:
                word="肆";
                break;
            case 5:
                word="伍";
                break;
            case 6:
                word="陸";
                break;
            case 7:
                word="柒";
                break;
            case 8:
                word="捌";
                break;
            case 9:
                word="玖";
                break;
            default:
                word="";
                break;
        }
        return word;
    }

    public static String getVirtualAccountId(String str_13char, int amount, PaySystem pSystem)
        throws Exception
    {
System.out.println("## str_13char=" + str_13char + " amount=" + amount);
        String chx = "";
        if (pSystem.getBanktype()==1) { // 臺新
            chx = getChecksumTaiXin(str_13char);
        }
        else if (pSystem.getBanktype()==2) { // 聯邦 C 類 (不檢核金額)
            chx = getChecksumLianBang_C(str_13char);
        }
        else if (pSystem.getBanktype()==3) { // 聯邦 D 類 (檢核金額)
            chx = getChecksumLianBang_D(str_13char, amount);
        }
        else 
            throw new Exception("沒有設定銀行資料，不能計算檢核碼");  
        return str_13char + chx;
    }

    public static int countStringBytes(String word)
    {
        if(word==null || word.length()==0)
            return 0;
        int totalLength=0;
        for(int i=0;i<word.length();i++)
        {
            char x=word.charAt(i);
            if(x>255)
                totalLength=totalLength+2;
            else
                totalLength++; 
        }
        return totalLength;
    }

   	public String replaceBirthGreetings(String msg, Date birth, String name)
   	{
   		StringBuffer sb = new StringBuffer();
   		SimpleDateFormat sdf=new SimpleDateFormat("MM月dd日");

        if(birth !=null){
            msg = msg.replace("XXX",sdf.format(birth));	
            msg = msg.replace("YYY",name);	
        }else{

            msg="";
        }
   		return msg;
   	}

    public String getWarningMsg(int amount, PaySystem pSystem, String companyName, boolean atmok)
    {
        String msg;
		if(pSystem.getPaySystemStoreActive()==1 && amount>pSystem.getPaySystemLimitMoney()){

            if(pSystem.getPagetype()==1){
                msg = "       現金請交" + companyName + "櫃臺點收.";
            }else{
			    msg = "*由於應繳金額超過便利商店上限" + pSystem.getPaySystemLimitMoney() + "元,本單請" +
                    ((atmok)?"用銀行轉帳":"");
            
                if (pSystem.getPagetype()!=6) // 通泉草不要印櫃臺繳款
                    msg += "或於 " + companyName + " 櫃臺繳納.";
            }

        }else if(pSystem.getPaySystemStoreActive()==0 ||pSystem.getPaySystemStoreActive()==9){
            msg = "  本單請" + ((atmok)?"用銀行轉帳或":"") + "於 " + companyName + " 櫃臺繳納.";
        }else{
            if(pSystem.getPagetype()==1)
                msg = "       現金請交" + companyName + "櫃臺點收.";
            else {    
                msg = "       *如超過繳費期限，請至"+pSystem.getPaySystemBankName()+"(免手續費)或各大銀行、ATM繳款.";
                if (pSystem.getPagetype()!=6) // 通泉草沒有櫃臺點收
                    msg += "現金請交" + companyName + "櫃臺點收.";
            }
        }

        return msg;
    }

    private String _make_prettier(String str)
    {
        if (str.length()!=14)
            return str;
        return str.substring(0,5) + "-" + str.substring(5,9) + "-" + str.substring(9);
    }

    public boolean setUpATMMessage(PaySystem pSystem, StringBuffer atmtitle, 
        StringBuffer atmcontent, StringBuffer acceptString, String floatingAccount, 
        int amount, int membrId, String companyName)        
            throws Exception
    {
        boolean ret = false;
        if(pSystem.getPaySystemATMActive()==1) // 浮動虛擬轉帳
		{
			atmtitle.append("銀 行 帳 號 轉 帳");

            atmcontent.append("\n轉帳銀行: [ "+ pSystem.getPaySystemBankName()+" ]  代號 [ " + pSystem.getPaySystemBankId() + " ]\n");              

            atmcontent.append("\n轉帳帳號: [ " + _make_prettier(getVirtualAccountId(floatingAccount, amount, pSystem)) + " ]\n");
            atmcontent.append("\n金    額: [ " +mnf.format(amount)+" ]\n\n");

            atmcontent.append("註1:至"+pSystem.getPaySystemBankName()+"分行以[存款單]繳款或使用台新銀行金融卡以ATM轉帳,免手續費.\n");
            atmcontent.append("註2:亦可至其他銀行或ATM轉帳,手續費以轉帳銀行規定為準.\n");
					
			if (amount>pSystem.getPaySystemLimitMoney() || 
                pSystem.getPaySystemStoreActive()==0 || 
                pSystem.getPaySystemStoreActive()==9)
			{
                if(pSystem.getCustomerType()==0)
    				acceptString.append("經收人蓋章(家長收執聯)");
                else                    
    				acceptString.append("經收人蓋章(客戶收執聯)");
			}
            else{

                if(pSystem.getCustomerType()==0)
    				acceptString.append("經收人蓋章(家長收執聯)");
                else
    				acceptString.append("經收人蓋章(客戶收執聯)");
			}
            ret = true;
		}
        else if(pSystem.getPaySystemATMActive()==2) // 要 先進先銷 才能用指定帳號轉帳
        {				
            atmtitle.append("銀 行 帳 號 轉 帳");
			if (pSystem.getPaySystemATMAccountId()==0) {
                atmcontent.append("系統尚未設定	匯款銀行帳戶\n");
                ret = false;
            }
            else
            {
                BankAccountMgr bam=BankAccountMgr.getInstance();
                BankAccount baATM=(BankAccount)bam.find(pSystem.getPaySystemATMAccountId());
                atmcontent.append("\n\n銀行代號: "+baATM.getBankAccountId());

                if(baATM.getBankAccountRealName()!=null && baATM.getBankAccountRealName().length()>0)
                    atmcontent.append("  銀行名稱:"+baATM.getBankAccountRealName()+" "+baATM.getBankAccountBranchName()+"分行");

                atmcontent.append("\n\n");
                atmcontent.append("帳    號: "+baATM.getBankAccountAccount()+"\n\n");

                if (baATM.getBankAccountAccountName() !=null && baATM.getBankAccountAccountName().length()>0)
                    atmcontent.append("帳戶名稱: "+baATM.getBankAccountAccountName()+"\n");

                acceptString.append("經收人蓋章(家長收執聯)");
                ret = true;
			}			
		}
        else if (pSystem.getPaySystemATMActive()==3) // 固定虛擬帳號
        {
            atmtitle.append("銀行帳號轉帳");
            //JsfPay jp=JsfPay.getInstance();
            //Student stu = (Student) ObjectService.find("jsf.Student", "id=" + membr.getSurrogateId());
            //String accountString=jp.getStuFixAccount(pSystem,membrId,true);
            BunitHelper bh = new BunitHelper();
            String v5digits = bh.getVirtualID(bunit.getId());
            String prefix = v5digits // pSystem.getPaySystemFirst5().trim() 
                            + pSystem.getPaySystemFixATMAccount().trim();
            String membrStr = makePrecise(membrId+"", 4, false, '0');
            prefix = makePrecise(prefix, 9, true, '0');
            String accountString = v5digits + "-" + 
                    pSystem.getPaySystemFixATMAccount().trim() + "-" +
                    membrStr;
            
            // prefix(9), membrStr(4)
            if (pSystem.getBanktype()==1) { // 臺新
                accountString += getChecksumTaiXin(prefix+membrStr);
            }
            else if (pSystem.getBanktype()==2) { // 聯邦 C 類 (不檢核金額)
                accountString += getChecksumLianBang_C(prefix+membrStr);
            }
            else if (pSystem.getBanktype()==3) { // 聯邦 D 類 (檢核金額)
                accountString += getChecksumLianBang_D(prefix+membrStr, amount);
            }
            else 
                throw new Exception("沒有設定銀行資料，不能計算檢核碼");

            boolean printExtra = pSystem.getExtraBankInfo()!=null && pSystem.getExtraBankInfo().trim().length()>0;
            if (!printExtra)
                atmcontent.append("\n");
            atmcontent.append(" 匯款銀行: [ ");
            atmcontent.append(pSystem.getPaySystemBankName()+" ] 代號 [ "+pSystem.getPaySystemBankId()+" ]\n");
            if (printExtra)
                atmcontent.append(" " + pSystem.getExtraBankInfo().trim() + "\n");
            atmcontent.append(" 匯款帳號: [ "+accountString+ "]\n");
            atmcontent.append(" 轉帳金額: [ "+mnf.format(amount)+" ] 元\n");

            if (pSystem.getBanktype()!=3) { // 聯邦 D 類加金額沒辦法固定
                atmcontent.append("\n *本帳號為你在"+companyName+"的學費專戶,亦可設定為約定轉帳帳號,以方便之後的繳款作業.\n");
            }
            atmcontent.append("\n註1:至"+pSystem.getPaySystemBankName()+"分行以[存款單]繳款或使用台新銀行金融卡以ATM轉帳,免手續費.\n");
            atmcontent.append("註2:亦可至其他銀行或ATM轉帳,手續費以轉帳銀行規定為準.\n");


            acceptString.append("經收人蓋章(家長收執聯)");	
            ret = true;
		}
        else { //if(pSystem.getPaySystemATMActive()==0 || pSystem.getPaySystemATMActive()==9){
			atmtitle.append("貼心叮嚀");
			atmcontent.append(pSystem.getPaySystemReplaceWord());
			acceptString.append("經收人蓋章(家長收執聯)");
            return false;
		}
        return ret;
    }

    public static String makePrecise(String str, int size, boolean rightpadding, char padding)
    {
        StringBuffer result = new StringBuffer();
        if (str==null || str.length()==0) {
            for (int i=0; i<size; i++)
                result.append(padding);
            return result.toString();
        }
            
        if (rightpadding) {
            int cur = 0;
            int i=0;
            while (cur<str.length()) {
                char c = str.charAt(cur ++);
                int s = (c>255)?2:1;
                if ((i+s)>size)
                    break;
                result.append(c);
                i += s;
            }
            for ( ;i<size; i++)
                result.append(padding);
        }
        else {
            int cur = str.length()-1;
            int i=0;
            while (cur>=0) {
                char c = str.charAt(cur--);
                int s = (c>255)?2:1;
                if ((i+s)>size)
                    break;
                result.insert(0, c);
                i += s;
            }
            for ( ;i<size; i++)
                result.insert(0, padding);
        }
        return result.toString();
    }

    // 41 byte length
    static String makeItemStringType5Receipt(String name, int payAmount, int discountAmount)
    {
        StringBuffer line = new StringBuffer();
        line.append(makePrecise(name, 15, true, ' '));
        line.append(makePrecise(mnf.format(payAmount-discountAmount), 18, false, ' '));
        line.append("  ");
        return line.toString();
    }

    // 41 byte length
    static String makeItemString(String name, int payAmount, int discountAmount)
    {
        StringBuffer line = new StringBuffer();
        line.append(makePrecise(name, 17, true, ' '));
        line.append(' ');
        line.append(makePrecise(mnf.format(payAmount), 7, false, ' '));
        line.append(' ');
        if (discountAmount>0)
            line.append(makePrecise(mnf.format(discountAmount), 7, false, ' '));
        else
            line.append("       ");
        line.append(' ');
        line.append(makePrecise(mnf.format(payAmount-discountAmount), 7, false, ' '));
        return line.toString();
    }

    // 46 byte length
    static String makeItemString_Neil(String name, int payAmount)
    {
        StringBuffer line = new StringBuffer();
        line.append(makePrecise(name, 34, true, ' '));
        line.append(makePrecise(mnf.format(payAmount), 7, false, ' '));
        return line.toString();
    }

    // 40 + 20 chars
    static String makeItemString_KJF(String name, int payAmount, int discountAmount)
    {
        StringBuffer line = new StringBuffer();
        line.append("    "); // 4 chars
        if (discountAmount==0) {
            line.append(makePrecise(name, 36, true, ' '));
            line.append(makePrecise(payAmount+"", 20, false, ' '));
        }
        else {
            name = name + " (應收:" + payAmount + " 折扣:" + discountAmount +")";
            line.append(makePrecise(name, 48, true, ' '));
            line.append(makePrecise((payAmount-discountAmount)+"", 8, false, ' '));
        }
        return line.toString();
    }

    static void appendItem_KJF(int i, StringBuffer blk, String content)
        throws Exception
    {
        if (i<8) {
            blk.append(content);
            blk.append("\n");
        }
        //else
        //    throw new Exception("超過7行印不下");
    }

    static void appendItem(int i, StringBuffer left, StringBuffer right, String content)
    {
        if (i<9) {
            left.append(content);
            left.append('\n');
        }
        else {
            right.append(content);
            right.append('\n');
        }
    }

    static void appendItemType5Receipt(int i,int total,StringBuffer left, StringBuffer right, String content)
    {
        if(total <=5){
            left.append(content);
            left.append('\n');            
        }else if(total <=10){

            if(i<=4){
                left.append(content);
                left.append('\n');                 
            }else{
                right.append(content);
                right.append('\n');                
            }
        }else{

            int halfItem=total/2;

            if (i<halfItem) {
                left.append(content);
                left.append('\n');
            }
            else {
                right.append(content);
                right.append('\n');
            }
        }
    }

    static String getAlignWord(int xLength,String xWord)
    {
        if(xLength <0)
            return xWord;
        StringBuffer sb=new StringBuffer();
        
        int nowLength=xLength-xWord.length();

        if(nowLength<=0)
            return xWord;

        for(int i=0;i<nowLength;i++)
            sb.append(" ");
        
        sb.append(xWord);
        return sb.toString();
    }

    static void mergeAlias(ArrayList<ChargeItemMembr> charges, Map<String, ArrayList<Discount>> discountMap)
        throws Exception
    {
        ArrayList<ChargeItemMembr> tmp = new ArrayList<ChargeItemMembr>();
        Map<Integer, ArrayList<ChargeItemMembr>> chargeMap = new SortingMap(charges).doSortA("getAliasId");
        Iterator<Integer> iter = chargeMap.keySet().iterator();
        while (iter.hasNext()) {
            Integer aliasId = iter.next();
            int aid = aliasId.intValue();
            ArrayList<ChargeItemMembr> vc = chargeMap.get(aliasId);
            if (aid>0) {
                int amount = 0;
                int discount = 0;
                for (int i=0; i<vc.size(); i++) {
                    ChargeItemMembr c = vc.get(i);
                    ArrayList<Discount> dv = discountMap.get(c.getChargeKey());
                    for (int j=0; dv!=null && j<dv.size(); j++) {
                        Discount d = dv.get(j);
                        discount += d.getAmount();
                    }
                    discountMap.remove(c.getChargeKey());
                    amount += c.getMyAmount();
                }
                ChargeItemMembr newc = new ChargeItemMembr();
                newc.setChargeName_(BillItem.getAliasName(aid));
                newc.setChargeAmount(amount);
                // ## setup 人工的 chargekey for chargeitemmembr and discount for discountMap ######
                newc.setMembrId(vc.get(0).getMembrId()); 
                newc.setChargeItemId(vc.get(0).getChargeItemId());
                Discount d = new Discount();
                d.setAmount(discount);
                ArrayList<Discount> vd = new ArrayList<Discount>();
                vd.add(d);
                discountMap.put(vc.get(0).getMembrId() + "#" + vc.get(0).getChargeItemId(), vd);
                // ##################################################################################
                tmp.add(newc);
            }
            else {
                for (int i=0; i<vc.size(); i++) {
                    tmp.add(vc.get(i));
                }
            }
        }
        // copy to charges
        charges.clear();
        for (int i=0; i<tmp.size(); i++)
            charges.add(tmp.get(i));
    }

    static void setUpChargeDetail(MembrInfoBillRecord sinfo, 
               // ticketId
            Map<String, ArrayList<ChargeItemMembr>> chargeMap, 
               // chargeKey
            Map<String, ArrayList<Discount>> discountMap,
               // chargeKey
            Map<String, ArrayList<FeeDetail>> feeMap, 
            StringBuffer left, StringBuffer right, 
            boolean printSummary, 
            int unpaidPrevious, 
            int pagetype)
        throws Exception
    {
        int subtotal = (int) 0;
        ArrayList<ChargeItemMembr> charges = chargeMap.get(sinfo.getTicketId());
        if (charges==null)
            charges = new ArrayList<ChargeItemMembr>(); // 有可能項目為零可是帳單還在
        //### 看有沒有用 Alias
        Map<Integer, ArrayList<ChargeItemMembr>> aliasMap = new SortingMap(charges).doSort("getAliasId");
        boolean useAlias = ((aliasMap.size()==0) || (aliasMap.size()==1 && aliasMap.get(new Integer(0))!=null))?false:true;
        if (useAlias) 
            mergeAlias(charges, discountMap);

        int i = 0;
        int cur = 0;
        while (cur<charges.size()) {

            ChargeItemMembr c = charges.get(cur++);
            
            ArrayList<FeeDetail> fv = feeMap.get(c.getChargeKey());
            SimpleDateFormat sdf2 = new SimpleDateFormat("yy/MM/dd");
            SimpleDateFormat sdf3 = new SimpleDateFormat("MM/dd");
            DecimalFormat mnf2 = new DecimalFormat("###,###,##0");

            ArrayList<Discount> dv = discountMap.get(c.getChargeKey());
            int dAmount = 0;

            String xDiscount="";
            for (int j=0; dv!=null && j<dv.size(); j++) {
                Discount d = dv.get(j);
                dAmount += d.getAmount();
                //if(d.getCopy()==1 && d.getNote()!=null)  //不延續的折扣
                if(d.getNote()!=null)
                    xDiscount +=" "+d.getNote();
            }
            if (fv!=null) {
                String item_str = null;
                if (pagetype==4)
                    item_str = makeItemString_Neil(c.getChargeName(), c.getMyAmount());
                else
                    item_str = makeItemString(c.getChargeName(), c.getMyAmount(), dAmount);
                appendItem(i, left, right, item_str);
                subtotal += (c.getMyAmount() - dAmount);
                i++;  

                for (int j=0; j<fv.size(); j++)
                {
                    FeeDetail fd = fv.get(j);
                    Date twd = convertToTaiwanDate(fd.getFeeTime());
                    String x1=getAlignWord(9,String.valueOf(fd.getUnitPrice())+"(元)");
                    String x2=getAlignWord(7,String.valueOf(fd.getNum())+"(單位)");
                    String str = "  "+sdf2.format(twd)+x1 +
                            " x"+x2;
                    if (fd.getNote()!=null)
                        str += " " + makePrecise(fd.getNote(), 7, true, ' ');
                    appendItem(i++, left, right,makePrecise(str, 41, true, ' '));
                }
                appendItem(i++, left, right,makePrecise("", 41, true, ' '));                           
            }else{
                 // myamount, d.amount is what we want
                if (pagetype==1) {
                    appendItem_KJF(i, left, makeItemString_KJF(c.getChargeName(), c.getMyAmount(), dAmount)); 
                }
                else {
                        String itemString=makeItemString(c.getChargeName(), c.getMyAmount(), dAmount);
                        if(pagetype ==5){ 
                            //道禾要加註記
                            itemString+=xDiscount;
                        }
                    appendItem(i, left, right,itemString);
                } 
                
                subtotal += (c.getMyAmount() - dAmount);
                i++;
            }
        }

        if (pagetype==1) {
            if (i<7)
                appendItem_KJF(i++, left, "");
        }
        else
            appendItem(i++, left, right, "");

        String pagetype1_note = "    ";
        if (sinfo.getReceived()>0) {
            if (pagetype==1) {
                pagetype1_note += "-本期已繳金額：" + mnf.format(sinfo.getReceived());
            }
            else {
                String tmpstr1 = makePrecise("*小計", 33, true, ' ') + makePrecise(mnf.format(sinfo.getReceivable()), 8, false, ' ');
                String tmpstr2 = makePrecise("*本期已繳金額", 31, true, ' ') + makePrecise("(" + mnf.format(sinfo.getReceived())+")", 10, false, ' ');
                appendItem(i++, left, right, tmpstr1);
                appendItem(i++, left, right, tmpstr2);
            }
            subtotal -= sinfo.getReceived();
        }
        if (unpaidPrevious>0) {
            if (pagetype==1) {
                pagetype1_note += "  +前期未繳金額：" + mnf.format(unpaidPrevious);
            }else if(pagetype==5){

                String strXX = makePrecise("*本期新增金額", 33, true, ' ') + makePrecise(mnf.format(subtotal), 8, false, ' ');
                appendItem(i++, left, right, strXX);

                String str = makePrecise("*前期未繳金額", 33, true, ' ') + makePrecise(mnf.format(unpaidPrevious), 8, false, ' ');
                appendItem(i++, left, right, str);            
            }else {
                String str = makePrecise("*前期未繳金額", 33, true, ' ') + makePrecise(mnf.format(unpaidPrevious), 8, false, ' ');
                appendItem(i++, left, right, str);
            }
            subtotal += unpaidPrevious;
        }

        if (pagetype==1 && pagetype1_note.trim().length()>0) {
            appendItem_KJF(i, left, pagetype1_note); 
        }

        if (printSummary) {
            if (pagetype!=1) {
                String str = makePrecise("*本期應繳金額小計", 33, true, ' ') + makePrecise(mnf.format(subtotal), 8, false, ' ');
                appendItem(i++, left, right, str);
            }
        }
    }


    static void setUpChargeDetailType5Receipt(MembrInfoBillRecord sinfo, 
               // ticketId
            Map<String, ArrayList<ChargeItemMembr>> chargeMap, 
               // chargeKey
            Map<String, ArrayList<Discount>> discountMap,
               // chargeKey
            Map<String, ArrayList<FeeDetail>> feeMap, 
            StringBuffer left, StringBuffer right, StringBuffer other,
            boolean printSummary, 
            int unpaidPrevious, 
            int pagetype)
        throws Exception
    {
        int subtotal = (int) 0;
        ArrayList<ChargeItemMembr> charges = chargeMap.get(sinfo.getTicketId());
        //### 看有沒有用 Alias
        Map<Integer, ArrayList<ChargeItemMembr>> aliasMap = new SortingMap(charges).doSort("getAliasId");
        boolean useAlias = (aliasMap.size()==1 && aliasMap.get(new Integer(0))!=null)?false:true;
        if (useAlias) 
            mergeAlias(charges, discountMap);

        int i = 0;
        int cur = 0;
        int totalItem=charges.size()+2;
        while (cur<charges.size()) {

            ChargeItemMembr c = charges.get(cur++);
            
            ArrayList<FeeDetail> fv = feeMap.get(c.getChargeKey());
            SimpleDateFormat sdf2 = new SimpleDateFormat("yy/MM/dd");
            SimpleDateFormat sdf3 = new SimpleDateFormat("MM/dd");
            DecimalFormat mnf2 = new DecimalFormat("###,###,##0");

            ArrayList<Discount> dv = discountMap.get(c.getChargeKey());
            int dAmount = 0;

            String xDiscount="";
            for (int j=0; dv!=null && j<dv.size(); j++) {
                Discount d = dv.get(j);
                dAmount += d.getAmount();
                if(d.getCopy()==1 && d.getNote()!=null)  //不延續的折扣
                    xDiscount +=" "+d.getNote();
            }

    
            String itemString=makeItemStringType5Receipt(c.getChargeName(), c.getMyAmount(), dAmount);



            appendItemType5Receipt(i,totalItem, left, right,itemString);
                
            subtotal += (c.getMyAmount() - dAmount);
            i++;
        }
       
        appendItemType5Receipt(i++,totalItem, left, right, "");  //空行

        String pagetype1_note = "    ";
        if (sinfo.getReceived()>0) {
            if (pagetype==1) {
                pagetype1_note += "-本期已繳金額：" + mnf.format(sinfo.getReceived());
            }
            else {
                String tmpstr1 = makePrecise("*小計", 27, true, ' ') + makePrecise(mnf.format(sinfo.getReceivable()), 8, false, ' ');
                String tmpstr2 = makePrecise("*本期已繳金額", 25, true, ' ') + makePrecise(mnf.format(sinfo.getReceived()), 10, false, ' ');
                //appendItemType5Receipt(i++, totalItem, left, right, tmpstr1);
                //appendItemType5Receipt(i++, totalItem, left, right, tmpstr2);
                other.append(tmpstr1 + "\n");
                other.append(tmpstr2 + "\n");
            }
            subtotal -= sinfo.getReceived();
        }
        if (unpaidPrevious>0) {
            if (pagetype==1) {
                pagetype1_note += "  +前期未繳金額：" + mnf.format(unpaidPrevious);
            }else if(pagetype==5){

                String strXX = makePrecise("*本期新增金額", 33, true, ' ') + makePrecise(mnf.format(subtotal), 8, false, ' ');
                // appendItemType5Receipt(i++, totalItem, left, right, strXX);
                other.append(strXX + "\n");

                String str = makePrecise("*前期未繳金額", 33, true, ' ') + makePrecise(mnf.format(unpaidPrevious), 8, false, ' ');
                //appendItemType5Receipt(i++, totalItem, left, right, str);            
                other.append(str + "\n");
            }else {
                String str = makePrecise("*前期未繳金額", 33, true, ' ') + makePrecise(mnf.format(unpaidPrevious), 8, false, ' ');
                //appendItemType5Receipt(i++, totalItem, left, right, str);
                other.append(str + "\n");
            }
            subtotal += unpaidPrevious;
        }


        if (printSummary) {
                String str = makePrecise("*本期應繳金額小計", 33, true, ' ') + makePrecise(mnf.format(subtotal), 8, false, ' ');
                //appendItemType5Receipt(i++, totalItem, left, right, str);
                other.append(str + "\n");
        }
    }

    public boolean doStorePay(PaySystem pSystem, int amount)
    {
//System.out.println("### amount=" + amount);
//System.out.println("### pSystem.getPaySystemLimitMoney()=" + pSystem.getPaySystemLimitMoney());
//System.out.println("### pSystem.getPaySystemStoreActive()=" + pSystem.getPaySystemStoreActive());

        if(amount>pSystem.getPaySystemLimitMoney() || pSystem.getPaySystemStoreActive()==0 || pSystem.getPaySystemStoreActive()==9)
            return false;
        return true;
    }


    public static String getChecksumLianBang_C(String d0)
        throws Exception
    {
        if (d0.length()!=13)
            throw new Exception("getChecksumLianBang_C:checksum prefix length is not 13");

        int d0Sum=0;
        for(int i=0;i<d0.length();i++)
        {
            d0Sum+=Integer.parseInt(d0.substring(i,(i+1)));
        }    

        int checkNum2=d0Sum%10;
        return checkNum2 + "";
    }

    public static String getChecksumLianBang_D(String d1, int billmoney)
        throws Exception
    {
        if (d1.length()!=13)
            throw new Exception("getChecksumLianBang_D:checksum prefix length is not 13");

        String mString=String.valueOf(billmoney);    

        String d2="";
        int runZ=13-mString.length();   
        for(int i=0;i<runZ;i++)
            d2+="0";
        d2+=mString;

        int[] xdata={9,8,7,6,5,4,3,2,2,3,4,5,6};
        int sum=0;
        for(int i=0;i<d1.length();i++)
        {
            String d1x=d1.substring(i,(i+1));
            String d2x=d2.substring(i,(i+1));

            int x1=Integer.parseInt(d1x);
            int x2=Integer.parseInt(d2x);
            
            sum+=(x1^x2)*xdata[i];
        }

        int checkNum=sum%10;
        return checkNum + "";
    }

    public static String getChecksumTaiXin(String numX)
        throws Exception
    {
        if (numX.length()!=13)
            throw new Exception("getChecksumTaiXin:checksum prefix length is not 13");

        int xSum=0;
        int ySum=0;
        for(int i=0;i<13;i++)
        {
            if(i==0 || i%2==0)
            {    
                xSum+=Integer.parseInt(numX.substring(i,(i+1)));            
            }else{
                ySum+=Integer.parseInt(numX.substring(i,(i+1)));
            }
        }
        xSum=xSum*3;
        String suntotal=String.valueOf(xSum+ySum);
        int sunTotalInt=Integer.parseInt(suntotal.substring((suntotal.length()-1),suntotal.length()));
        if(sunTotalInt !=0)
            sunTotalInt=10-sunTotalInt;

        return sunTotalInt+"";
    }

    public String checkCode(String month, String money, String barcode1, String barcode2)
    {
		JsfTool jt = JsfTool.getInstance();

        String tempCode3=month+money;
		int[] sumCode1=jt.checkCode(barcode1);
		int[] sumCode2=jt.checkCode(barcode2);
		int[] sumCode3=jt.checkCode(tempCode3);
		
		int checkSum1=sumCode1[0]+sumCode2[0]+sumCode3[0];
		int checkSum2=sumCode1[1]+sumCode2[1]+sumCode3[1];
	
		String checkCode1;
		String checkCode2;
	
		int xcode1=checkSum1%11;
	
		if(xcode1==0)
			checkCode1="A";
		else if(xcode1==10)
			checkCode1="B";
		else
			checkCode1=String.valueOf(xcode1);
			
		int xcode2=checkSum2%11;
	
		if(xcode2==0)
			checkCode2="X";
		else if(xcode2==10)
			checkCode2="Y";
		else
			checkCode2=String.valueOf(xcode2);	

        return checkCode1 + checkCode2;
    }

    public static Date convertToTaiwanDate(Date d)
    {
        Date tmp = (Date) d.clone();
        tmp.setYear(d.getYear()-1911);
        return tmp;
    }

    public void printPayment(MembrInfoBillRecord sinfo, int pageNum,int pageTotal, String username)
        throws Exception
    {
        // get the system parameter
        PaySystem pSystem = (PaySystem) ObjectService.find("jsf.PaySystem", "id=1");
        this.currentTicketId = sinfo.getTicketId();

        // get billrecord
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月");
        SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy年MM月dd日");

        // Student st = (Student)ObjectService.find("jsf.Student", "id="+sinfo.getStudentId());
        String billPrettyName = sinfo.getBillPrettyName();
        
        BunitHelper bh = new BunitHelper();
        String title = billPrettyName + "    " + sdf.format(br.getMonth());
        String companyName = bh.getBillCompanyName(bunit.getId()); //pSystem.getPaySystemCompanyName();
        String companyAddress = bh.getBillAddress(bunit.getId()); // pSystem.getPaySystemCompanyAddress();
        String companyPhone = bh.getBillPhone(bunit.getId()); // pSystem.getPaySystemCompanyPhone();
        String studentName = sinfo.getMembrName(); //st.getStudentName();


        String logoPath = pSystem.getBillLogoPath();  // new File(toolDir, "font/logo.tif").getAbsolutePath();
        String bgPath = pSystem.getBillWaterMarkPath(); // new File(toolDir, "font/bg.tif").getAbsolutePath();

        String greetingImgPath = null;
        String greetings = null;


        String path711=new File(toolDir, "font/711W150.tif").getAbsolutePath();;
        String mcalogo=new File(toolDir, "font/MCALOGO.TIF").getAbsolutePath();;
    
        if (pSystem.getPagetype()==1) {
            greetings = replaceBirthGreetings(pSystem.getPaySystemBirthWord(), 
                    sinfo.getMembrBirth(), sinfo.getMembrName());
        }
        else if (pSystem.getPaySystemBirthActive()==1) {
            Date bday = sinfo.getMembrBirth(); // st.getStudentBirth();
//System.out.println("### br.getMonth().getMonth()=" + br.getMonth().getMonth() + " " + sdf.format(br.getMonth()));
            if (bday!=null && bday.getMonth()==br.getMonth().getMonth()) {
                greetingImgPath = new File(toolDir, "font/birth.tif").getAbsolutePath();
                greetings = replaceBirthGreetings(pSystem.getPaySystemBirthWord(), 
                    sinfo.getMembrBirth(), sinfo.getMembrName());

            }else if (br.getMonth().getMonth()==0) {
                greetingImgPath = new File(toolDir, "font/feb.tif").getAbsolutePath();
                greetings = "";
            }else if (br.getMonth().getMonth()==1) {
                greetingImgPath = new File(toolDir, "font/t2.tif").getAbsolutePath();
                greetings = "";
            }else if (br.getMonth().getMonth()==2) {
                greetingImgPath = new File(toolDir, "font/t3.tif").getAbsolutePath();
                greetings = "";
            }else if (br.getMonth().getMonth()==3) {
                greetingImgPath = new File(toolDir, "font/t4.tif").getAbsolutePath();
                greetings = "";
            }else if (br.getMonth().getMonth()==4) {
                greetingImgPath = new File(toolDir, "font/t5.tif").getAbsolutePath();
                greetings = "";
            }else if (br.getMonth().getMonth()==5) {
                greetingImgPath = new File(toolDir, "font/t6.tif").getAbsolutePath();
                greetings = "";
            }else if (br.getMonth().getMonth()==7) {
                greetingImgPath = new File(toolDir, "font/fathers_day.tif").getAbsolutePath();
            }else if (br.getMonth().getMonth()==8) {
                greetingImgPath = new File(toolDir, "font/moon.tif").getAbsolutePath();
                greetings = "";
            }else if (br.getMonth().getMonth()==9) {
                greetingImgPath = new File(toolDir, "font/oct.tif").getAbsolutePath();
                greetings = "";
            }else if (br.getMonth().getMonth()==10) {
                greetingImgPath = new File(toolDir, "font/turkey.tif").getAbsolutePath();
                greetings = "";
            }else if (br.getMonth().getMonth()==11) {
                greetingImgPath = new File(toolDir, "font/t12.tif").getAbsolutePath();
                greetings = "";
            }
            //##
        }

        int newTotal = sinfo.getReceivable();
        int finalAmount = sinfo.getReceivable() - sinfo.getReceived();
        int paidAmount = 0;
        int unpaidAmount = 0;
        if (sinfo.getReceived()>0) {
            paidAmount = sinfo.getReceived();
        }
        Date now = new Date();
        // print_bill_step2.jsp 看 unpaidMap 的說明 (去掉 BillId的部分)
        // ArrayList<MembrInfoBillRecord> unpaid = unpaidMap.get(sinfo.getMembrId()+"#"+sinfo.getBillId());
        ArrayList<MembrInfoBillRecord> unpaid = unpaidMap.get(sinfo.getMembrId());
        if (unpaid!=null && unpaid.size()>0) {
            for (int i=0; i<unpaid.size(); i++) {
                MembrInfoBillRecord mib = unpaid.get(i);
                // 2009/2/19 因 Robert 來電討論後決議把所有未繳的帳單都作為前期未繳
                //if (mib.getBillId()==sinfo.getBillId() && // 型別一樣的才會把餘額放在這
                //    mib.getMyBillDate().compareTo(now)<0 && 
                //    mib.getTicketId().compareTo(sinfo.getTicketId())<0) 
                if (mib.getMyBillDate().compareTo(now)<0 && 
                    mib.getTicketId().compareTo(sinfo.getTicketId())<0) 
                {
                    unpaidAmount += (mib.getReceivable()-mib.getReceived());
                    finalAmount += (mib.getReceivable()-mib.getReceived());
                }
            }
        }
        sinfo.setInheritUnpaid(unpaidAmount); // will be saved before end
        
        String ticketId = sinfo.getTicketId();
        Date billdate = sinfo.getMyBillDate();

        String v5digits = bh.getVirtualID(bunit.getId());
        String floatingAccount = v5digits + ticketId; // 95481 98020001
        
        StringBuffer atmtitle = new StringBuffer();
        StringBuffer atmcontent = new StringBuffer();
        StringBuffer acceptString = new StringBuffer();
        // boolean FIFO_balance = (sinfo.getBalanceWay()==1);
        boolean atmok = setUpATMMessage(pSystem, atmtitle, atmcontent, 
            acceptString, floatingAccount, finalAmount, sinfo.getMembrId(), companyName) ;

        String warning = getWarningMsg(finalAmount, pSystem, companyName, atmok);

        StringBuffer leftBlock = new StringBuffer();
        StringBuffer rightBlock = new StringBuffer();
        setUpChargeDetail(sinfo, chargeMap, discountMap, feeMap, leftBlock, rightBlock, true, unpaidAmount, 
            pSystem.getPagetype());

        String remark = "";
        String payReminder = "";
        String bottomLeftBoxTitle = "";
        String barcode1 = null, barcode2 = null, barcode3 = null;
        String[] lines = null;
        String n = bh.getServiceID(bunit.getId()); // pSystem.getPaySystemBankStoreNickName(); // 669
        String nn = bh.getStoreID(bunit.getId()); // pSystem.getPaySystemCompanyStoreNickName(); // PHM00..
        DecimalFormat mnf = new DecimalFormat("###,###,##0");
        DecimalFormat mnf2 = new DecimalFormat("########0");

//System.out.println("## doStorePay(pSystem, finalAmount)=" + doStorePay(pSystem, finalAmount));
//System.out.println("## n.trim()=" + n.trim() + "#");
//System.out.println("## nn.trim()=" + nn.trim() + "#");
//System.out.println("## all=" + (doStorePay(pSystem, finalAmount)
//            && n!=null && n.trim().length()>0 && nn!=null && nn.trim().length()>0));

        if (doStorePay(pSystem, finalAmount) 
            && n!=null && n.trim().length()>0 && nn!=null && nn.trim().length()>0) 
        {
            payReminder = "       便利商店繳款(7-ELEVEN,全家,萊爾富,OK)                         *便利商店收據請保留六個月";
            bottomLeftBoxTitle = "便利商店/櫃臺繳款收訖戳記";
            SimpleDateFormat df = new SimpleDateFormat("yyMMdd");
            Date deadline = billdate;
            if (pSystem.getPaySystemBeforeLimitDate()>0) {
                deadline = new Date(billdate.getTime() + ((long)pSystem.getPaySystemBeforeLimitDate())*(long)86400*(long)1000);
            }
            barcode1 = df.format(convertToTaiwanDate(deadline)) 
                + bh.getServiceID(bunit.getId()); // pSystem.getPaySystemBankStoreNickName().trim();

            if (pSystem.getBanktype()==1) { // 臺新
                barcode2 = makePrecise(bh.getStoreID(bunit.getId()), 7,true,'0') +
                    makePrecise(ticketId, 9, false, '0');
            }
            else if (pSystem.getBanktype()==2) { // 聯邦 C 類 (不檢核金額)
                String strOf13 = v5digits + makePrecise(ticketId, 8, false, '0');
                barcode2 = "33" + strOf13 + getChecksumLianBang_C(strOf13);
            }
            else if (pSystem.getBanktype()==3) { // 聯邦 D 類 (檢核金額)
                String strOf13 = v5digits + makePrecise(ticketId, 8, false, '0');
                barcode2 = "33" + strOf13 + getChecksumLianBang_D(strOf13, finalAmount);
            }
            else 
                throw new Exception("沒有設定銀行資料，不能計算檢核碼");                
            
            df = new SimpleDateFormat("yyMM");
            String mm = df.format(convertToTaiwanDate(br.getMonth()));
            String mn = mnf2.format(finalAmount);
            barcode3 = mm + checkCode(mm, makePrecise(mn, 9, false, '0'), barcode1, barcode2) + 
                    makePrecise(mn, 9, false, '0');
            String[] l = {
                "繳款期限:" + sdf2.format(billdate),
                "\n繳款人:",
                "\n繳款金額:" + mnf.format(finalAmount),
                "\n",
                "\n開單機構:" + companyName,
                "\n帳單流水號:" + ticketId } ;
            lines = l;
        }
        else { 
            bottomLeftBoxTitle = "櫃臺繳款收訖戳記";
            barcode1 = ticketId;
            String[] l = {
                "帳單月份:" + sdf.format(br.getMonth()),
                "\n繳款人:",
                "\n繳款金額:" + mnf.format(finalAmount),
                "\n繳款期限:" + sdf2.format(billdate) };
            lines = l;
        }

        ArrayList<BillComment> bc = commentMap.get(sinfo.getBillKey());
        if (bc!=null)
            remark = bc.get(0).getComment();

        // #### if there are other non-paid bills, put in remark as well
        StringBuffer sb_ = new StringBuffer();
        if (unpaid!=null && unpaid.size()>0) {
            SimpleDateFormat sdfm = new SimpleDateFormat("yy/MM");
            for (int i=0; i<unpaid.size(); i++) {
                MembrInfoBillRecord mib = unpaid.get(i);
                if (mib.getBillId()!=sinfo.getBillId() && // 型別不同的才會在備注中提醒
                    mib.getMyBillDate().compareTo(now)<0) 
                {
                    sb_.append(sdfm.format(mib.getBillMonth())+mib.getBillName());
                    sb_.append(",");
                }
            }
        }
        if (sb_.length()>0) {
            if (remark.length()>0) remark += "\n";
            remark += "      **逾期未繳帳單:" + sb_.toString();
        }
        // #################
        String website = pSystem.getWebsite();

        if(pSystem.getPagetype()==0|| pSystem.getPagetype()==6){ // 6 是通泉草只有里面一點不同
            String billGot="";
            if(pSystem.getCustomerType()==0)
                billGot=" 家長 收";
            else
                billGot=" 收";

            printPdf(this.getDocument(),
                studentName + " " + pageNum,   // subject
                title,    
                1,          //int nowPage,
                logoPath,       //String logoPath, 
                bgPath,       //String backimgPath, 
                studentName,  //String payeeName1,  // *must*
                "",       //String payeeName2,  
                "",       //String payeeName3,  
                companyName, //String companyName, // *must*
                companyAddress, //String companyAddress, // *must*
                companyPhone, // String companyPhone, //*must*
                website, 
                ticketId, //String ticketId, // *must*
                newTotal, //int newTotalAmount,
                unpaidAmount, //int lateAmount,
                paidAmount, //int paidAmount,  
                finalAmount,  //int amount4,  // *must*
                convertToTaiwanDate(billdate),     //Date   billEndDate, // *must*
                greetings, //String greeting,
                greetingImgPath,       //String greetingImgPath,
                warning,       //String warning,
                billPrettyName + "明細", //String contentTableTitle, // *must*
                leftBlock.toString(),    //String blockLeft,  // *must* 
                rightBlock.toString(), //String blockRight, // *must*
                remark, //String remark, // *must*
                atmtitle.toString(),     //String atmTitle, // *must*
                atmcontent.toString(),   //String atmContent, // *must*
                acceptString.toString(), //String acceptString, // *must*
                payReminder,  //String payReminder,
                bottomLeftBoxTitle, //String bottomLeftBoxTitle,  // *must* "櫃臺繳款收訖戳記" or “便利商店櫃臺繳款收訖戳記”
                "帳單條碼", //String bottomMiddleBoxTitle,
                barcode1,   //String barcode1,  // *must*
                barcode2,   //String barcode2,
                barcode3,   //String barcode3,
                lines,//String[] bottomRightLines);
                path711,
                (doStorePay(pSystem, finalAmount)?1:0), 
                billGot); 

        }else if(pSystem.getPagetype()==1){
                // different: className, payaccountId_14, leftBlock, rightBlock
                String className = "";
                if (tagmembrMap!=null) {
                    ArrayList<TagMembrStudent> vt = tagmembrMap.get(new Integer(sinfo.getMembrId()));
                    if (vt!=null)
                        className = vt.get(0).getTagName();
                }                
                String payaccountId_14 = getVirtualAccountId(floatingAccount, finalAmount, pSystem);

                printPdf_KJF(this.getDocument(),
                    studentName,  //String payeeName1,  // *must*
                    className, 
                    companyName, //String companyName, // *must*
                    ticketId, //String ticketId, // *must*
                    payaccountId_14, // 虛擬帳號
                    finalAmount,  //int amount4,  // *must*
                    convertToTaiwanDate(billdate),     //Date   billEndDate, // *must*
                    greetings, //String greeting,
                    warning,       //String warning,
                    leftBlock.toString(),    //String blockLeft,  // *must* 
                    remark, //String remark, // *must*
                    barcode1,   //String barcode1,  // *must*
                    barcode2,   //String barcode2,
                    barcode3,   //String barcode3,
                    sinfo.getBillMonth());
        }else if(pSystem.getPagetype()==2){  //傳統三聯式

                String className = "";
                if (tagmembrMap!=null) {
                    ArrayList<TagMembrStudent> vt = tagmembrMap.get(new Integer(sinfo.getMembrId()));
                    if (vt!=null)
                        className = vt.get(0).getTagName();
                }                

                printPdfType3(this.getDocument(),  
                    companyName, //String companyName, // *must*
                    companyAddress, //String companyAddress, // *must*
                    companyPhone, // String companyPhone, //*must*
                    website, 
                    className,
                    studentName,   // subject
                    title,
                    sinfo.getBillMonth(),
                    ticketId,
                    remark, //String remark, // *must*
                    greetings, //String greeting,
                    newTotal, //int newTotalAmount,
                    unpaidAmount, //int lateAmount,
                    paidAmount, //int paidAmount,  
                    finalAmount,  //int amount4,  // *must*
                    1,          //int nowPage,
                    logoPath,       //String logoPath, 
                    bgPath,       //String backimgPath, 
                    studentName,  //String payeeName1,  // *must*
                    "",       //String payeeName2,  
                    "",       //String payeeName3,  
                    convertToTaiwanDate(billdate),     //Date   billEndDate, // *must*

                    greetingImgPath,       //String greetingImgPath,
                    warning,       //String warning,
                    billPrettyName + "明細", //String contentTableTitle, // *must*
                    leftBlock.toString(),    //String blockLeft,  // *must* 
                    rightBlock.toString(), //String blockRight, // *must*

                    atmtitle.toString(),     //String atmTitle, // *must*
                    atmcontent.toString(),   //String atmContent, // *must*
                    acceptString.toString(), //String acceptString, // *must*
                    payReminder,  //String payReminder,
                    bottomLeftBoxTitle, //String bottomLeftBoxTitle,  // *must* "櫃臺繳款收訖戳記" or “便利商店櫃臺繳款收訖戳記”
                    "帳單條碼", //String bottomMiddleBoxTitle,
                    barcode1,   //String barcode1,  // *must*
                    barcode2,   //String barcode2,
                    barcode3,   //String barcode3,
                    lines); //String[] bottomRightLines);
        }else if(pSystem.getPagetype()==4){  //牛耳

            printPdf4(this.getDocument(),
                studentName + " " + pageNum,   // subject
                title,    
                1,          //int nowPage,
                logoPath,       //String logoPath, 
                bgPath,       //String backimgPath, 
                studentName,  //String payeeName1,  // *must*
                "",       //String payeeName2,  
                "",       //String payeeName3,  
                companyName, //String companyName, // *must*
                companyAddress, //String companyAddress, // *must*
                companyPhone, // String companyPhone, //*must*
                website, 
                ticketId, //String ticketId, // *must*
                newTotal, //int newTotalAmount,
                unpaidAmount, //int lateAmount,
                paidAmount, //int paidAmount,  
                finalAmount,  //int amount4,  // *must*
                convertToTaiwanDate(billdate),     //Date   billEndDate, // *must*
                greetings, //String greeting,
                greetingImgPath,       //String greetingImgPath,
                warning,       //String warning,
                billPrettyName + "明細", //String contentTableTitle, // *must*
                leftBlock.toString(),    //String blockLeft,  // *must* 
                rightBlock.toString(), //String blockRight, // *must*
                remark, //String remark, // *must*
                atmtitle.toString(),     //String atmTitle, // *must*
                atmcontent.toString(),   //String atmContent, // *must*
                acceptString.toString(), //String acceptString, // *must*
                payReminder,  //String payReminder,
                bottomLeftBoxTitle, //String bottomLeftBoxTitle,  // *must* "櫃臺繳款收訖戳記" or “便利商店櫃臺繳款收訖戳記”
                "帳單條碼", //String bottomMiddleBoxTitle,
                barcode1,   //String barcode1,  // *must*
                barcode2,   //String barcode2,
                barcode3,   //String barcode3,
                lines,//String[] bottomRightLines);
                path711); 
        }
        else if(pSystem.getPagetype()==7){  //馬禮遜

            String billHeader = sinfo.getPayNote();
            String billSubHeader = sinfo.getBillRecordName();
            String grade = mcasvc.getGrade(sinfo.getMembrId());
            String parents = mcasvc.getParent(sinfo.getMembrId());
            String bankName = sinfo.getComName();
            String accountName = sinfo.getComAddr();
            String schoolNo = sinfo.getRegInfo();
            // String studentAccountNumber = makePrecise(mcasvc.getCoopID(sinfo.getMembrId()), 7, false, '0');
            String studentAccountNumber = makePrecise(mcasvc.getNewCoopID(sinfo.getMembrId()), 7, false, '0');
System.out.println("##33## studentAccountNumber=" + studentAccountNumber);
            DateFormat sdfdue = DateFormat.getDateInstance(DateFormat.MEDIUM, Locale.US);
            String dueDate = sdfdue.format(sinfo.getMyBillDate());
            String amountStr = mnf.format(sinfo.getReceivable()-sinfo.getReceived());
            ArrayList<ChargeItemMembr> charges = chargeMap.get(sinfo.getTicketId());
            String payAcctStr = null;
            if (bunit.getLabel().equals("Bethany"))
                payAcctStr = "台北伯大尼美國學校";
            else if (bunit.getLabel().equals("Taichung"))
                payAcctStr = "馬禮遜學校";
            else
                payAcctStr = "馬禮遜美國學校";



            McaDeferred md = McaDeferredMgr.getInstance().find("ticketId='" + sinfo.getTicketId() + "'");

            printPdf7(this.getDocument(),
                billHeader,
                billSubHeader,
                studentName,
                grade,
                parents,
                bankName,
                accountName,
                schoolNo,
                studentAccountNumber,
                dueDate,
                amountStr,
                charges,
                discountMap,
                unpaidAmount,
                username,
                sinfo.getReceivable(),
                sinfo.getReceived(),
                payAcctStr
                ); 

            if (md!=null && md.getType()>0) {

                McaStudent ms = McaStudentMgr.getInstance().find("membrId=" + sinfo.getMembrId());
                Bunit bu = BunitMgr.getInstance().find("id=" + sinfo.getBunitId());
                int[] fees = new int[3];
                Map<Date, String> starndardMap = new LinkedHashMap<Date, String>();
                Map<Date, String> monthlyMap = new LinkedHashMap<Date, String>();
                mcasvc.breakingBillFees(sinfo, chargeMap, discountMap, fees, starndardMap, monthlyMap);
                int tuition = fees[0];
                int latefee = fees[1];
                int interest = fees[2];
                String lastname = ms.getStudentSurname().substring(0,1).toUpperCase() +
                                    ms.getStudentSurname().substring(1);
                String firstname = ms.getStudentFirstName().substring(0,1).toUpperCase() +
                                    ms.getStudentFirstName().substring(1);
                printMCADeferred(this.getDocument(),mcalogo, lastname, firstname,
                    new Date(), grade, sinfo.getBillRecordName(), bu.getLabel(), tuition, latefee, interest,
                    starndardMap, monthlyMap, sinfo.getReceivable());
            }

        }

        MembrBillRecordMgr mbrmgr = MembrBillRecordMgr.getInstance();
        sinfo.setPrintDate(new Date().getTime());
        mbrmgr.save(sinfo);
    }

    public void printPaymentType5(MembrInfoBillRecord[] sinfoA, int pageNum,int pageTotal)
        throws Exception
    {
        // get the system parameter
        PaySystem pSystem = (PaySystem) ObjectService.find("jsf.PaySystem", "id=1");

        // get billrecord
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月");
        SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy年MM月dd日");
        String logoPath = pSystem.getBillLogoPath();  // new File(toolDir, "font/logo.tif").getAbsolutePath();
        String bgPath = pSystem.getBillWaterMarkPath(); // new File(toolDir, "font/bg.tif").getAbsolutePath();

        PdfPTable[] pTable=new PdfPTable[3];
        
        BunitHelper bh = new BunitHelper();
        for(int k=0;k<3;k++){
            MembrInfoBillRecord sinfo=sinfoA[k];
            if(sinfo==null)
                continue;

            Bill billx=billMap.get(new Integer(sinfo.getBillId()));
            // Student st = (Student)ObjectService.find("jsf.Student", "id="+sinfo.getStudentId());
            this.currentTicketId = sinfo.getTicketId();
            String billPrettyName = sinfo.getBillPrettyName();        
            String title = billPrettyName + "    " + sdf.format(br.getMonth());
            String companyName = (billx.getComName()!=null)?billx.getComName():bh.getBillCompanyName(bunit.getId()); // pSystem.getPaySystemCompanyName();
            String companyAddress =(billx.getComAddr()!=null)?billx.getComAddr():bh.getBillAddress(bunit.getId()); // pSystem.getPaySystemCompanyAddress();
            String companyPhone = bh.getBillPhone(bunit.getId()); // pSystem.getPaySystemCompanyPhone();
            String studentName = sinfo.getMembrName(); //st.getStudentName();
            String greetingImgPath = null;
            String greetings = null;
            String path711=new File(toolDir, "font/711W150.tif").getAbsolutePath();

            int newTotal = sinfo.getReceivable();
            int finalAmount = sinfo.getReceivable() - sinfo.getReceived();
            int paidAmount = 0;
            int unpaidAmount = 0;
            if (sinfo.getReceived()>0) {
                paidAmount = sinfo.getReceived();
            }
            Date now = new Date();
            // print_bill_step2.jsp 看 unpaidMap 的說明 (去掉 BillId的部分)
            // ArrayList<MembrInfoBillRecord> unpaid = unpaidMap.get(sinfo.getMembrId()+"#"+sinfo.getBillId());
            ArrayList<MembrInfoBillRecord> unpaid = unpaidMap.get(sinfo.getMembrId());
            if (unpaid!=null && unpaid.size()>0) {
                for (int i=0; i<unpaid.size(); i++) {
                    MembrInfoBillRecord mib = unpaid.get(i);
                    if (mib.getBillId()==sinfo.getBillId() && // 型別一樣的才會把餘額放在這
                        mib.getMyBillDate().compareTo(now)<0 && 
                        mib.getTicketId().compareTo(sinfo.getTicketId())<0) 
                    {
                        unpaidAmount += (mib.getReceivable()-mib.getReceived());
                        finalAmount += (mib.getReceivable()-mib.getReceived());
                    }
                }
            }
            sinfo.setInheritUnpaid(unpaidAmount); // will be saved before end
            
            String ticketId = sinfo.getTicketId();
            Date billdate = sinfo.getMyBillDate();

            String v5digits = bh.getVirtualID(bunit.getId());

            String floatingAccount = v5digits + ticketId;
            StringBuffer atmtitle = new StringBuffer();
            StringBuffer atmcontent = new StringBuffer();
            StringBuffer acceptString = new StringBuffer();
            // boolean FIFO_balance = (sinfo.getBalanceWay()==1);
            boolean atmok = setUpATMMessage(pSystem, atmtitle, atmcontent, 
                acceptString, floatingAccount, finalAmount, sinfo.getMembrId(), companyName) ;

            String warning = getWarningMsg(finalAmount, pSystem, companyName, atmok);

            StringBuffer leftBlock = new StringBuffer();
            StringBuffer rightBlock = new StringBuffer();
            setUpChargeDetail(sinfo, chargeMap, discountMap, feeMap, leftBlock, rightBlock, true, unpaidAmount, 
                pSystem.getPagetype());

            String remark = "";
            String payReminder = "";
            String bottomLeftBoxTitle = "";
            String barcode1 = null, barcode2 = null, barcode3 = null;
            String[] lines = null;
            String n = bh.getServiceID(bunit.getId()); // pSystem.getPaySystemBankStoreNickName(); // 669
            String nn = bh.getStoreID(bunit.getId()); // pSystem.getPaySystemCompanyStoreNickName(); // PHM00..
            DecimalFormat mnf = new DecimalFormat("###,###,##0");
            DecimalFormat mnf2 = new DecimalFormat("########0");

            if (doStorePay(pSystem, finalAmount) 
                && n!=null && n.trim().length()>0 && nn!=null && nn.trim().length()>0) 
            {
                payReminder = "       便利商店繳款(7-ELEVEN,全家,萊爾富,OK)                         *便利商店收據請保留六個月";
                bottomLeftBoxTitle = "便利商店/櫃臺繳款收訖戳記";
                SimpleDateFormat df = new SimpleDateFormat("yyMMdd");
                Date deadline = billdate;
                if (pSystem.getPaySystemBeforeLimitDate()>0) {
                    deadline = new Date(billdate.getTime() + ((long)pSystem.getPaySystemBeforeLimitDate())*(long)86400*(long)1000);
                }
                barcode1 = df.format(convertToTaiwanDate(deadline)) 
                    + bh.getServiceID(bunit.getId()); // pSystem.getPaySystemBankStoreNickName().trim();

                if (pSystem.getBanktype()==1) { // 臺新
                    barcode2 = makePrecise(bh.getStoreID(bunit.getId()),7,true,'0') +
                        makePrecise(ticketId, 9, false, '0');
                }
                else if (pSystem.getBanktype()==2) { // 聯邦 C 類 (不檢核金額)
                    String strOf13 = v5digits + makePrecise(ticketId, 8, false, '0');
                    barcode2 = "33" + strOf13 + getChecksumLianBang_C(strOf13);
                }
                else if (pSystem.getBanktype()==3) { // 聯邦 D 類 (檢核金額)
                    String strOf13 = v5digits + makePrecise(ticketId, 8, false, '0');
                    barcode2 = "33" + strOf13 + getChecksumLianBang_D(strOf13, finalAmount);
                }
                else 
                    throw new Exception("沒有設定銀行資料，不能計算檢核碼");                
                
                df = new SimpleDateFormat("yyMM");
                String mm = df.format(convertToTaiwanDate(br.getMonth()));
                String mn = mnf2.format(finalAmount);
                barcode3 = mm + checkCode(mm, makePrecise(mn, 9, false, '0'), barcode1, barcode2) + 
                        makePrecise(mn, 9, false, '0');
                String[] l = {
                    "繳款期限:" + sdf2.format(billdate),
                    "\n繳款人:",
                    "\n繳款金額:" + mnf.format(finalAmount),
                    "\n",
                    "\n開單機構:" + companyName,
                    "\n帳單流水號:" + ticketId } ;
                lines = l;
            }
            else { 
                bottomLeftBoxTitle = "櫃臺繳款收訖戳記";
                barcode1 = ticketId;
                String[] l = {
                    "帳單月份:" + sdf.format(br.getMonth()),
                    "\n繳款人:",
                    "\n繳款金額:" + mnf.format(finalAmount),
                    "\n繳款期限:" + sdf2.format(billdate) };
                lines = l;
            }

            ArrayList<BillComment> bc = commentMap.get(sinfo.getBillKey());
            if (bc!=null)
                remark = bc.get(0).getComment();

            // #### if there are other non-paid bills, put in remark as well
            StringBuffer sb_ = new StringBuffer();
            if (unpaid!=null && unpaid.size()>0) {
                SimpleDateFormat sdfm = new SimpleDateFormat("yy/MM");
                for (int i=0; i<unpaid.size(); i++) {
                    MembrInfoBillRecord mib = unpaid.get(i);
                    if (mib.getBillId()!=sinfo.getBillId() && // 型別不同的才會在備注中提醒
                        mib.getMyBillDate().compareTo(now)<0) 
                    {
                        sb_.append(sdfm.format(mib.getBillMonth())+mib.getBillName());
                        sb_.append(",");
                    }
                }
            }
            if (sb_.length()>0) {
                if (remark.length()>0) remark += "\n";
                remark += "      **逾期未繳帳單:" + sb_.toString();
            }
            // #################
            String website = pSystem.getWebsite();


            String className = "";
            if (tagmembrMap!=null) {
                ArrayList<TagMembrStudent> vt = tagmembrMap.get(new Integer(sinfo.getMembrId()));
                if (vt!=null)
                    className = vt.get(0).getTagName();
            }      

            warning="請持本單於台中市私立道禾幼稚園財務室繳納 繳費時間 8:30am - 17:50pm\n";
            warning+=billx.getPayNote();

            //warning+="幼稚園家長: ATM轉帳銀行代號: 103 ; 帳號: 0930-10-001717-1 \n            支票抬頭:台中市私立道禾幼稚園\n";
            //warning+="安親班家長: ATM轉帳銀行代號: 103 ; 帳號: 0930-10-001718-0 \n            支票抬頭:台中市私立道禾美語會話短期補習班"; 

            pTable[k]=printPdf5(studentName + " " + pageNum,   // subject
            title,    
            1,          //int nowPage,
            logoPath,       //String logoPath, 
            bgPath,       //String backimgPath, 
            studentName,  //String payeeName1,  // *must*
            className,       //String payeeName2,  
            "",       //String payeeName3,  
            companyName, //String companyName, // *must*
            companyAddress, //String companyAddress, // *must*
            companyPhone, // String companyPhone, //*must*
            website, 
            ticketId, //String ticketId, // *must*
            newTotal, //int newTotalAmount,
            unpaidAmount, //int lateAmount,
            paidAmount, //int paidAmount,  
            finalAmount,  //int amount4,  // *must*
            convertToTaiwanDate(billdate),     //Date   billEndDate, // *must*
            greetings, //String greeting,
            greetingImgPath,       //String greetingImgPath,
            warning,       //String warning,
            billPrettyName + "明細", //String contentTableTitle, // *must*
            leftBlock.toString(),    //String blockLeft,  // *must* 
            rightBlock.toString(), //String blockRight, // *must*
            remark, //String remark, // *must*
            atmtitle.toString(),     //String atmTitle, // *must*
            atmcontent.toString(),   //String atmContent, // *must*
            acceptString.toString(), //String acceptString, // *must*
            payReminder,  //String payReminder,
            bottomLeftBoxTitle, //String bottomLeftBoxTitle,  // *must* "櫃臺繳款收訖戳記" or “便利商店櫃臺繳款收訖戳記”
            "帳單條碼", //String bottomMiddleBoxTitle,
            barcode1,   //String barcode1,  // *must*
            barcode2,   //String barcode2,
            barcode3,   //String barcode3,
            lines,//String[] bottomRightLines);
            path711,
            pSystem.getPaySystemStoreActive(),
            pageNum,
            pageTotal
            ); 

            MembrBillRecordMgr mbrmgr = MembrBillRecordMgr.getInstance();
            sinfo.setPrintDate(new Date().getTime());
            mbrmgr.save(sinfo);
        }

        BaseFont bfComic = BaseFont.createFont(fontPath,BaseFont.IDENTITY_H,BaseFont.NOT_EMBEDDED);
        Font font14b = new Font(bfComic, 14,Font.BOLD);
        Font font14 = new Font(bfComic, 14,Font.NORMAL);
        Font font12 = new Font(bfComic, 12,Font.NORMAL);
        Font font12b = new Font(bfComic, 12,Font.BOLD);
        Font font10 = new Font(bfComic, 10,Font.NORMAL);
        Font font10b = new Font(bfComic, 10,Font.BOLD);
        Font font8 = new Font(bfComic, 8,Font.NORMAL);
        Font font1 = new Font(bfComic,1,Font.NORMAL);


        float barcodeN=(float)2.0;
        float barcodeFontSize=(float)8.0;
        float barcodeHieght=(float)30.0;
        float barcodeHieght2=(float)10.0;
        float barcodeN2=(float)1.7;
        float barcodeN3=(float)2.0;

        Document document=this.getDocument();
        PdfContentByte cb = this.pdfwriter.getDirectContent();;
        document.newPage();
        for(int k=0;k<3;k++){

            if(k==0)
            {
                Paragraph parag6=new Paragraph("\n",font10);
                parag6.setAlignment(Element.ALIGN_LEFT);
                document.add(parag6);
            }

            if(pTable[k]==null)
                continue;


            if (bgPath!=null && bgPath.length()>0) {
                try {
                    Image  logoI= Image.getInstance(bgPath);

                    if(k==0)
                        logoI.setAbsolutePosition(60,610);
                    else if(k==1)                    
                        logoI.setAbsolutePosition(60,337);
                    else
                        logoI.setAbsolutePosition(60,59);
                    document.add(logoI);
                }
                catch (java.io.IOException e) {}
            }

            if (logoPath!=null && logoPath.length()>0) {
                try {
                    Image  logoI= Image.getInstance(logoPath);

                    if(k==0)
                        logoI.setAbsolutePosition(383,795);
                    else if(k==1)                    
                        logoI.setAbsolutePosition(383,526);
                    else
                        logoI.setAbsolutePosition(383,254);
                    document.add(logoI);
                }
                catch (java.io.IOException e) {}
            }


            Barcode39 codeFeeticketId = new Barcode39();
            codeFeeticketId.setCode(sinfoA[k].getTicketId());
            codeFeeticketId.setStartStopText(true);
            codeFeeticketId.setSize(barcodeFontSize);
            codeFeeticketId.setN(barcodeN);
            codeFeeticketId.setBarHeight(barcodeHieght2);

            Image imageFtId = codeFeeticketId.createImageWithBarcode(cb, null, null);
            if(k==0)
                imageFtId.setAbsolutePosition(355,723);
            else if(k==1)                    
                imageFtId.setAbsolutePosition(355,454);
            else
                imageFtId.setAbsolutePosition(355,184);
            document.add(imageFtId);


            String menuImge = menu2Path;
            Image  menuI= Image.getInstance(menuImge);
            if(k==0)
                menuI.setAbsolutePosition(355,663);
            else if(k==1)                    
                menuI.setAbsolutePosition(355,394);
            else
                menuI.setAbsolutePosition(355,124);
            document.add(menuI);
       
            document.add(pTable[k]);
            if(k==0){
                Paragraph parag6=new Paragraph("\n\n",font8);
                parag6.setAlignment(Element.ALIGN_LEFT);
                document.add(parag6);
            }else if(k==1){
                Paragraph parag6=new Paragraph("\n\n",font8);
                parag6.setAlignment(Element.ALIGN_LEFT);
                document.add(parag6);                
            }
        }
    }

    public void setupMcaStudent(mca.McaFee fee, ArrayList<MembrInfoBillRecord> sinfos)
        throws Exception
    {
        mcasvc.setupMembrsInfo(fee, new RangeMaker().makeRange(sinfos, "getMembrId"));
    }
}
