package phm.ezcounting;

import java.text.*;
import java.util.*;
import java.io.*;
import com.lowagie.text.*;
import com.lowagie.text.pdf.*;
import jsf.*;
import java.awt.Color;

public class ReceiptPrinter
{
    String fontPath = null;
    File toolDir = null;

    private static SimpleDateFormat sdf =  new SimpleDateFormat("yy/MM/dd");
    private static DecimalFormat mnf = new DecimalFormat("###,###,##0");
    public static ReceiptPrinter getPdfPrinter(File toolDir)
        throws Exception
    {
        if (!toolDir.exists())
            throw new Exception("pdf tool directory not exists!");
        ReceiptPrinter p = new ReceiptPrinter();
        p.fontPath = new File(toolDir, "font/simsun.ttc,0").getAbsolutePath();
        p.toolDir = toolDir;
        return p;
    }

    public void printPdf(
        PdfWriter docwriter,
        Document document,
        String title,  // *must*
        String logoPath, 
        String payeeName1,  // *must*
        String payeeName2,  
        String payeeName3,  
        String companyName, // *must*
        String companyAddress, // *must*
        String companyPhone, //*must*
        String ticketId, // *must*
        String blockLeft,  // *must* 
        String blockRight, // *must*
        String paidStatus, // *must*
        int paidMoney, // *must*
        String paidDetails) // *must*
        throws Exception
    {
        PdfContentByte cb = docwriter.getDirectContent();

        float barcodeN=(float)1.7;
        float barcodeFontSize=(float)10.0;
        float barcodeHieght=(float)15.0;
        float barcodeHieght2=(float)10.0;

        BaseFont bfComic = BaseFont.createFont(fontPath,BaseFont.IDENTITY_H,BaseFont.NOT_EMBEDDED);

        Font font14b = new Font(bfComic, 14,Font.BOLD);
        Font font14 = new Font(bfComic, 14,Font.NORMAL);
        Font font12 = new Font(bfComic, 12,Font.NORMAL);
        Font font10 = new Font(bfComic, 10,Font.NORMAL);
        Font font8 = new Font(bfComic, 8,Font.NORMAL);
        
        Paragraph parag1=new Paragraph(title,font14b);
        parag1.setAlignment(Element.ALIGN_CENTER);
        document.add(parag1);

        if (logoPath!=null && logoPath.length()>0) {
            try {
                Image  logoI= Image.getInstance(logoPath);
                logoI.setAlignment(Image.LEFT | Image.UNDERLYING);
                document.add(logoI);
            }
            catch (java.io.IOException e) {}
        }

        Paragraph parag2=new Paragraph("           "+companyName,font12);
        parag2.setAlignment(Element.ALIGN_LEFT);
        document.add(parag2);

        Paragraph parag3=new Paragraph("           地址: "+companyAddress,font12);
        parag3.setAlignment(Element.ALIGN_LEFT);
        document.add(parag3);


        Paragraph parag4=new Paragraph("           電話: "+companyPhone,font12);
        parag4.setAlignment(Element.ALIGN_LEFT);
        document.add(parag4);

        String space="                                    ";
        String outName= payeeName1 + " " + ((payeeName2!=null)?payeeName2:"") + " " + ((payeeName3!=null)?payeeName3:"") +"  收";
        Paragraph parag5=new Paragraph(space + outName, font12);
        parag5.setAlignment(Element.ALIGN_LEFT);
        document.add(parag5);

        Barcode39 codeFeeticketId = new Barcode39();
        codeFeeticketId.setCode(ticketId);
        codeFeeticketId.setStartStopText(true);
        codeFeeticketId.setSize(barcodeFontSize);
        codeFeeticketId.setN(barcodeN);
        codeFeeticketId.setBarHeight(barcodeHieght);
        Image imageFtId = codeFeeticketId.createImageWithBarcode(cb, null, null);
        imageFtId.setAlignment(Element.ALIGN_CENTER);
        document.add(imageFtId);

        float[] widths = {0.15f, 0.35f, 0.15f, 0.35f};
        PdfPTable table = new PdfPTable(widths);

        PdfPCell cell = new PdfPCell(new Paragraph("繳款明細",font12));
        cell.setColspan(4);
        cell.setFixedHeight(20f);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table.addCell(cell);

        cell= new PdfPCell(new Paragraph("項目                     應收      折扣     小計",font10));
        cell.setColspan(2);
        cell.setFixedHeight(20f);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table.addCell(cell);

        cell= new PdfPCell(new Paragraph("項目                     應收      折扣     小計",font10));
        cell.setColspan(2);
        cell.setFixedHeight(20f);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table.addCell(cell);			

        cell = new PdfPCell(new Paragraph(blockLeft,font12));
        cell.setColspan(2);
        cell.setFixedHeight(80f);
        table.addCell(cell);


        cell = new PdfPCell(new Paragraph(blockRight,font12));
        cell.setColspan(2);
        cell.setFixedHeight(80f);
        table.addCell(cell);

        cell= new PdfPCell(new Paragraph("狀態",font12));
        cell.setFixedHeight(20f);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table.addCell(cell);

        cell= new PdfPCell(new Paragraph(paidStatus,font12));
        cell.setFixedHeight(20f);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table.addCell(cell);

        cell= new PdfPCell(new Paragraph("已繳金額",font12));
        cell.setFixedHeight(20f);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table.addCell(cell);

        cell= new PdfPCell(new Paragraph(mnf.format(paidMoney),font12));
        cell.setFixedHeight(20f);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table.addCell(cell);

        table.setWidthPercentage(90);
        document.add(table);

        Paragraph paragv1=new Paragraph("\n",font14);
        paragv1.setAlignment(Element.ALIGN_LEFT);
        document.add(paragv1);

        float[] widths2 = {0.05f, 0.50f, 0.45f};
        PdfPTable table2 = new PdfPTable(widths2);

        PdfPCell cell2 = new PdfPCell(new Paragraph("繳款明細",font12));
        cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell2.setFixedHeight(100f);			

        table2.addCell(cell2);		
                    
        cell2= new PdfPCell(new Paragraph("  繳費時間       金 額        付款方式 \n" + paidDetails, font12));
        table2.addCell(cell2);
                
        PdfPTable nested2 = new PdfPTable(1);
        cell2= new PdfPCell(new Paragraph(companyName+"蓋章",font12));
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

        Paragraph parag6=new Paragraph("本收據列印由必亨商業軟體股份有限公司技術支援，02-23693566，http://www.phm.com.tw",font8);
        parag6.setAlignment(Element.ALIGN_CENTER);
        document.add(parag6);    
    }

    public void printReceipt(MembrInfoBillRecord sinfo, Document document, PdfWriter pdfwriter, int pageNum, BillPay bpay)
        throws Exception
    {
		PaySystem2 pSystem = (PaySystem2) PaySystem2Mgr.getInstance().find("id=1");
        SimpleDateFormat sdf = new SimpleDateFormat("yy 年 MM 月");
        String title ="";
        
        if(pSystem.getPagetype()!=5){
            title=sinfo.getBillPrettyName() + "收據    " + 
            sdf.format(PaymentPrinter.convertToTaiwanDate(sinfo.getBillMonth()));
        }else{
            title=sdf.format(PaymentPrinter.convertToTaiwanDate(sinfo.getBillMonth()))+" 學費";  //+sinfo.getBillPrettyName();
        }

        String logoPath = pSystem.getBillLogoPath();
        String companyName = pSystem.getPaySystemCompanyName();
        String companyAddress = pSystem.getPaySystemCompanyAddress();
        String companyPhone = pSystem.getPaySystemCompanyPhone();
        String studentName = sinfo.getMembrName();
        StringBuffer blockLeft = new StringBuffer();
        StringBuffer blockRight = new StringBuffer();        

        ArrayList<ChargeItemMembr> charges = ChargeItemMembrMgr.getInstance().retrieveList
            ("ticketId in (" + sinfo.getTicketId() + ")", "");
        Map<String, ArrayList<ChargeItemMembr>> chargeMap = new SortingMap(charges).doSortA("getTicketId");
        String chargeItemIds = new RangeMaker().makeRange(charges, "getChargeItemId");
        String membrIds = new RangeMaker().makeRange(charges, "getMembrId");
        ArrayList<Discount> discounts = DiscountMgr.getInstance().retrieveList
            ("chargeItemId in (" + chargeItemIds + ") and membrId in (" + membrIds + ")", "");
        Map<String, ArrayList<Discount>> discountMap = new SortingMap(discounts).doSortA("getChargeKey");
        ArrayList<FeeDetail> fees = FeeDetailMgr.getInstance().retrieveList
            ("chargeItemId in (" + chargeItemIds + ") and membrId in (" + membrIds + ")", "");
        Map<String, ArrayList<FeeDetail>> feeMap = new SortingMap(fees).doSortA("getChargeKey");

        StringBuffer other = new StringBuffer(); // 2009/1/3 peter, 宗玫要把 本期繳小計的放在備注
        if(pSystem.getPagetype()!=5)
            PaymentPrinter.setUpChargeDetail(sinfo, chargeMap, discountMap, feeMap, blockLeft, blockRight, false, 0, 0);
        else
            PaymentPrinter.setUpChargeDetailType5Receipt(sinfo, chargeMap, discountMap, feeMap, blockLeft, blockRight, other, false, 0, 0);


        String paidStatus = null;
        if (sinfo.getPaidStatus()==MembrBillRecord.STATUS_FULLY_PAID)
            paidStatus = "已繳清";
        else if (sinfo.getPaidStatus()==MembrBillRecord.STATUS_PARTLY_PAID)
            paidStatus = "已繳款,尚未繳清";
        else 
            paidStatus = "尚未繳款";

        String q = "billpaid.ticketId='" + sinfo.getTicketId() + "'";
        if (bpay!=null)
            q += " and billPayId=" + bpay.getId();
        ArrayList<BillPaidInfo> paidrecords = 
            BillPaidInfoMgr.getInstance().retrieveList(q, "");
        Iterator<BillPaidInfo> iter = paidrecords.iterator();
        String paidDetails = "";
        int thisPaid = 0;
        while (iter.hasNext()) {
            BillPaidInfo pinfo = iter.next();
            if (bpay!=null) //## 2009/3/12 by peter，道禾要這次付款且只有針對這一張的金額
                thisPaid += pinfo.getPayAmount(); // pinfo.getPaidAmount(); ## 2009/4/3, 原來是這次付的錢，大于帳單費也要出來大于的錢
            String payway = null;
            if (pinfo.getVia()==BillPay.VIA_INPERSON)
                payway = "櫃臺繳費";
            else if (pinfo.getVia()==BillPay.VIA_STORE)
                payway = "便利商店代收";
            else if (pinfo.getVia()==BillPay.VIA_ATM) {
                payway = "銀行ATM轉帳";
                SimpleDateFormat tmpsdf = new SimpleDateFormat("yyyy/MM/dd");
                payway += " 轉帳日期: " + tmpsdf.format(pinfo.getPaidTime());
            }
            else if (pinfo.getVia()==BillPay.VIA_CHECK) {
                payway = "支票";
                if (pinfo.getChequeId()>0) {
                    Cheque ck = ChequeMgr.getInstance().find("id=" + pinfo.getChequeId());
                    String str = ((ck.getIssueBank()==null)?"":(ck.getIssueBank()+" ")) + ck.getChequeId();
                    payway = "\n            " + payway + "(" + str + ")";
                }
            }
            else if (pinfo.getVia()==BillPay.VIA_WIRE) {
                payway = "轉帳";
            }
            else if (pinfo.getVia()==BillPay.VIA_CREDITCARD)
                payway = "信用卡";

            SimpleDateFormat sdf2 = new SimpleDateFormat("yy/MM/dd");
            paidDetails += "* " + PaymentPrinter.makePrecise(sdf2.format(PaymentPrinter.convertToTaiwanDate(pinfo.getPaidTime())), 10, true, ' ')
                           + PaymentPrinter.makePrecise(mnf.format(pinfo.getPaidAmount()), 6, false, ' ') + "元 "
                           + payway + "\n";
        }

        if(pSystem.getPagetype()!=5){
            printPdf(pdfwriter, document, title, logoPath, studentName, null, null,
                companyName, companyAddress, companyPhone, sinfo.getTicketId(), 
                blockLeft.toString(), blockRight.toString(), paidStatus, sinfo.getReceived(),
                paidDetails);
        }else{
            // 找出該人的級別,班別,學號
            ArrayList<TagStudent> tags = TagStudentMgr.getInstance().retrieveList("membrId=" + sinfo.getMembrId(), "");
            Map<Integer, ArrayList<TagStudent>> tagtypeMap = new SortingMap(tags).doSortA("getTypeId");
            TagType gradetype = TagTypeMgr.getInstance().find("name='年級'");
            TagType classtype = TagTypeMgr.getInstance().find("name='班級'");    
            MembrStudent student = MembrStudentMgr.getInstance().find("membr.id=" + sinfo.getMembrId());
            String gradename = "";
            try { gradename = tagtypeMap.get(gradetype.getId()).get(0).getTagName(); } catch (Exception e) {}
            String classname = "";
            try { classname = tagtypeMap.get(classtype.getId()).get(0).getTagName(); } catch (Exception e) {}
            String studentNo = "";
            try { studentNo = student.getStudentNumber(); }  catch (Exception e) {}
            String regInfo = BillMgr.getInstance().find("id=" + sinfo.getBillId()).getRegInfo();
            if (regInfo==null || regInfo.length()==0)
                regInfo = "86府教國字第176449號";
            
            //道禾 
            String summary = "";
            if (bpay!=null) 
                summary = "*本次繳費金額: " + mnf.format(thisPaid) + " 元";
            else
                summary = other.toString();
            printPdfType5(pdfwriter, document, title, logoPath, studentName, null, null,
                companyName, companyAddress, companyPhone, sinfo.getTicketId(), 
                blockLeft.toString(), blockRight.toString(), paidStatus, sinfo.getReceived(),
                paidDetails, gradename, classname, studentNo, regInfo, summary);
        }
    }

      public void printPdfType5(
        PdfWriter docwriter,
        Document document,
        String title,  // *must*
        String logoPath, 
        String payeeName1,  // *must*
        String payeeName2,  
        String payeeName3,  
        String companyName, // *must*
        String companyAddress, // *must*
        String companyPhone, //*must*
        String ticketId, // *must*
        String blockLeft,  // *must* 
        String blockRight, // *must*
        String paidStatus, // *must*
        int paidMoney, // *must*
        String paidDetails, // *must*
        String gradename, 
        String classname, 
        String studentNo,
        String regInfo,
        String other)
        throws Exception
    {
        PdfContentByte cb = docwriter.getDirectContent();

        float barcodeN=(float)1.7;
        float barcodeFontSize=(float)10.0;
        float barcodeHieght=(float)15.0;
        float barcodeHieght2=(float)10.0;

        BaseFont bfComic = BaseFont.createFont(fontPath,BaseFont.IDENTITY_H,BaseFont.NOT_EMBEDDED);

        Font font14b = new Font(bfComic, 14,Font.BOLD);
        Font font15 = new Font(bfComic, 15,Font.NORMAL);
        Font font14 = new Font(bfComic, 14,Font.NORMAL);
        Font font13 = new Font(bfComic, 13,Font.NORMAL);
        Font font12 = new Font(bfComic, 12,Font.NORMAL);
        Font font10 = new Font(bfComic, 10,Font.NORMAL);
        Font font8 = new Font(bfComic, 8,Font.NORMAL);
       


        Paragraph parag5=new Paragraph("\n\n\n", font12);
        parag5.setAlignment(Element.ALIGN_LEFT);
        document.add(parag5);

        Paragraph parag1=new Paragraph(PaymentPrinter.makePrecise(regInfo, 35, true, ' ')+"             "+title+"         ", font14);
        parag1.setAlignment(Element.ALIGN_CENTER);
        document.add(parag1);

        parag5=new Paragraph("\n", font12);
        parag5.setAlignment(Element.ALIGN_LEFT);
        document.add(parag5);

      //String space="                                                                ";
      //String space="1234567890123456789012345678901234567890123456789012345678901234";

        String outName= payeeName1 + " " + ((payeeName2!=null)?payeeName2:"") + " " + ((payeeName3!=null)?payeeName3:"");
        String line = "  " + 
                      PaymentPrinter.makePrecise(gradename, 12, true, ' ') +
                      "           " +
                      PaymentPrinter.makePrecise(classname, 12, true, ' ') +
                      "          " + 
                      PaymentPrinter.makePrecise(studentNo, 12, true, ' ') +
                      "       " +outName;
            
        parag5=new Paragraph(line, font14);
        parag5.setAlignment(Element.ALIGN_LEFT);
        document.add(parag5);

        parag5=new Paragraph("\n\n", font12);
        parag5.setAlignment(Element.ALIGN_LEFT);
        document.add(parag5);

        parag5=new Paragraph("\n\n\n", font10);
        parag5.setAlignment(Element.ALIGN_LEFT);
        document.add(parag5);

        float[] widths = {0.5f, 0.5f};
        PdfPTable table = new PdfPTable(widths);

        PdfPCell cell = new PdfPCell(new Paragraph(blockLeft,font15));
        cell.setFixedHeight(100f);
        cell.setBorderColor(new Color(255, 255, 255));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_TOP);
        table.addCell(cell);

        cell = new PdfPCell(new Paragraph(blockRight,font15));
        cell.setBorderColor(new Color(255, 255, 255));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_TOP);
        table.addCell(cell);

        table.setWidthPercentage(100);
        document.add(table);

        //#### by peter
        float[] ww = {0.5f, 0.5f};
        table = new PdfPTable(ww);

        String left = "      付款方式 :" + paidDetails;
        left += "\n";
        left += "      印製日期 : " +sdf.format(PaymentPrinter.convertToTaiwanDate(new Date()));

        cell = new PdfPCell(new Paragraph(left,font12));
        cell.setFixedHeight(100f);
        cell.setBorderColor(new Color(255, 255, 255));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_TOP);
        table.addCell(cell);

        cell = new PdfPCell(new Paragraph(other,font12));
        cell.setBorderColor(new Color(255, 255, 255));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_TOP);
        table.addCell(cell);

        table.setWidthPercentage(100);
        document.add(table);
        // ###############


        //parag5=new Paragraph("      付款方式 : " + paidDetails, font12);
        //parag5.setAlignment(Element.ALIGN_LEFT);
        //document.add(parag5);
        
        //parag5=new Paragraph("      印製日期 : " +sdf.format(PaymentPrinter.convertToTaiwanDate(new Date())), font12);
        //parag5.setAlignment(Element.ALIGN_LEFT);
        //document.add(parag5);
    }
}