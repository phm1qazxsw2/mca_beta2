package phm.ezcounting;

import java.text.*;
import java.util.*;
import java.io.*;
import com.lowagie.text.*;
import com.lowagie.text.pdf.*;
import jsf.*;
import java.awt.Color;

public class SalarySlipPrinter
{
    String fontPath = null;
    File toolDir = null;

    private static SimpleDateFormat sdf =  new SimpleDateFormat("yy/MM/dd");
    private static DecimalFormat mnf = new DecimalFormat("###,###,##0");
    
    private Map<String, Vector<ChargeItemMembr>> chargeMap = null;
    private Map<String, Vector<FeeDetail>> feeMap = null;

    public static SalarySlipPrinter getPdfPrinter(File toolDir,
        Map<String, Vector<ChargeItemMembr>> chargeMap,
        Map<String, Vector<FeeDetail>> feeMap
        )
        throws Exception
    {
        if (!toolDir.exists())
            throw new Exception("pdf tool directory not exists!");
        SalarySlipPrinter p = new SalarySlipPrinter();
        p.fontPath = new File(toolDir, "font/simsun.ttc,0").getAbsolutePath();
        p.toolDir = toolDir;
        p.chargeMap = chargeMap;
        p.feeMap = feeMap;
        return p;
    }

    static void setUpSalaryDetail(MembrInfoBillRecord sinfo, 
               // ticketId
            Map<String, Vector<ChargeItemMembr>> chargeMap, 
               // chargeKey
            Map<String, Vector<FeeDetail>> feeMap, 
            
            StringBuffer left, StringBuffer right, 
            int[] totals)
             
        throws Exception
    {
        SimpleDateFormat sdf2 = new SimpleDateFormat("yy/MM/dd");
        SimpleDateFormat sdf3 = new SimpleDateFormat("MM/dd");
        DecimalFormat mnf2 = new DecimalFormat("###,###,##0");

        int cur = 0;
        Vector<ChargeItemMembr> charges = chargeMap.get(sinfo.getTicketId());
        int lt = 0;
        int rt = 0;
        while (cur<charges.size()) {
            ChargeItemMembr c = charges.get(cur++);            
            Vector<FeeDetail> fv = feeMap.get(c.getChargeKey());
            StringBuffer sb = null;
            Integer sub = null;
            if (c.getSmallItemId()==BillItem.SALARY_PAY) {
                sb = left;
                lt += c.getMyAmount();
            }
            else {
                sb = right;
                rt += c.getMyAmount();
            }
            sb.append("      ");
            sb.append(PaymentPrinter.makePrecise(c.getChargeName(), 20, true, ' '));
            sb.append(PaymentPrinter.makePrecise(mnf.format(Math.abs(c.getMyAmount())), 15, false, ' '));
            sb.append("\n");

            if (fv!=null) {
                for (int j=0; j<fv.size(); j++)
                {
                    FeeDetail fd = fv.get(j);
                    Date twd = PaymentPrinter.convertToTaiwanDate(fd.getFeeTime());
                    String x1 = PaymentPrinter.makePrecise(Math.abs(fd.getUnitPrice())+"(元)", 10, false, ' ');
                    String x2 = PaymentPrinter.makePrecise(fd.getNum()+"(單位)", 7, true, ' ');
                    String str = "  "+sdf2.format(twd)+x1 +" x"+x2 ;
                    sb.append("         " + str +" \n");
                    if(fd.getNote() !=null && fd.getNote().length()>0)
                        sb.append("                 "+fd.getNote()+"\n");
                }
                sb.append("\n");
            }
        }
        totals[0] = lt;
        totals[1] = rt;
    }

    public void printPdf(
        Document document,
        String subject,  // *must*
        String title,
        int nowPage,
        String logoPath, 
        String payeeName,
		StringBuffer leftBlock,
		StringBuffer rightBlock,
		Integer leftTotal,
		Integer rightTotal,
        String remark,
        ArrayList<BillPaidInfo> paidrecords) throws Exception
    {
    	DecimalFormat mnf = new DecimalFormat("###,###,##0");    			 			
				
		BaseFont bfComic = BaseFont.createFont(fontPath,BaseFont.IDENTITY_H,BaseFont.NOT_EMBEDDED);
		Font font14b = new Font(bfComic, 12,Font.NORMAL);
		Font font14T = new Font(bfComic, 14,Font.BOLD);
		Font font12 = new Font(bfComic, 12,Font.NORMAL);
		Font font10 = new Font(bfComic, 10,Font.NORMAL);
        Font font1 = new Font(bfComic,1,Font.NORMAL);

        Paragraph cTitle = new Paragraph(subject,font1);
        cTitle.setAlignment(Element.ALIGN_RIGHT);
        Chapter chapter = new Chapter(cTitle,nowPage);
        document.add(chapter);
        
        if (logoPath!=null && logoPath.length()>0) {
            try {
                Image logoI = Image.getInstance(logoPath);
        		logoI.setAlignment(Image.LEFT | Image.UNDERLYING);
                document.add(logoI);
            }
            catch (java.io.IOException e) {}
        }
				
		Paragraph parag1=new Paragraph(title,font14b);
		parag1.setAlignment(Element.ALIGN_CENTER);
		document.add(parag1);

		String strTitle="姓名:"+ payeeName;
		parag1=new Paragraph(strTitle,font14T);
		parag1.setAlignment(Element.ALIGN_CENTER);
		document.add(parag1);
				
		strTitle="............................................................................\n";
		parag1=new Paragraph(strTitle,font14b);
		parag1.setAlignment(Element.ALIGN_CENTER);
		document.add(parag1);				
		
		strTitle="     薪資明細:\n\n"; 
		parag1=new Paragraph(strTitle,font14b);
		parag1.setAlignment(Element.ALIGN_LEFT);
		document.add(parag1);
				
		float[] widths = {0.15f, 0.35f, 0.15f, 0.35f};
		PdfPTable table = new PdfPTable(widths);
		
		PdfPCell cell = new PdfPCell(new Paragraph("加 項 薪 資",font12));
		cell.setColspan(2);
		cell.setFixedHeight(20f);
		cell.setHorizontalAlignment(Element.ALIGN_CENTER);
		cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table.addCell(cell); 
		
		cell = new PdfPCell(new Paragraph("減 項 薪 資",font12));
		cell.setColspan(2);
		cell.setFixedHeight(20f);
		cell.setHorizontalAlignment(Element.ALIGN_CENTER);
		cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table.addCell(cell);  

		cell = new PdfPCell(new Paragraph(leftBlock.toString(),font10));
		cell.setColspan(2);
		cell.setHorizontalAlignment(Element.ALIGN_LEFT);
		cell.setVerticalAlignment(Element.ALIGN_TOP);
		table.addCell(cell); 

   		cell = new PdfPCell(new Paragraph(rightBlock.toString(),font10));
		cell.setColspan(2);
		//cell.setFixedHeight(20f);
		cell.setHorizontalAlignment(Element.ALIGN_LEFT);
		cell.setVerticalAlignment(Element.ALIGN_TOP);
		table.addCell(cell); 
 
		cell = new PdfPCell(new Paragraph("加項合計(a):",font12));
		cell.setFixedHeight(20f);
		cell.setHorizontalAlignment(Element.ALIGN_CENTER);
		cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table.addCell(cell); 

		cell = new PdfPCell(new Paragraph("                 "+
            mnf.format(leftTotal.intValue()),font12));
		cell.setFixedHeight(20f);
		cell.setHorizontalAlignment(Element.ALIGN_CENTER);
		cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table.addCell(cell); 
		
		cell = new PdfPCell(new Paragraph("減項合計(b):",font12));
		cell.setFixedHeight(20f);
		cell.setHorizontalAlignment(Element.ALIGN_CENTER);
		cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table.addCell(cell); 

		cell = new PdfPCell(new Paragraph("                 " +
            mnf.format(Math.abs(rightTotal.intValue())),font12));
		cell.setFixedHeight(20f);
		cell.setHorizontalAlignment(Element.ALIGN_CENTER);
		cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table.addCell(cell); 
		
		cell = new PdfPCell(new Paragraph("                                                    實發金額 (a)-(b):  "+
            mnf.format(leftTotal.intValue()+rightTotal.intValue()),font12));
		cell.setColspan(4);
		cell.setFixedHeight(20f);
		cell.setHorizontalAlignment(Element.ALIGN_CENTER);
		cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table.addCell(cell); 

		table.setWidthPercentage(90);
		document.add(table);


        if (remark!=null) {
            Paragraph comment=new Paragraph("     備註:" + remark + "\n", font14b);
            comment.setAlignment(Element.ALIGN_LEFT);
            document.add(comment);
        }
                
        if (paidrecords.size()>0) {

            strTitle="     薪資發放明細:\n\n"; 
            parag1=new Paragraph(strTitle,font14b);
            parag1.setAlignment(Element.ALIGN_LEFT);
            document.add(parag1);

            SimpleDateFormat sdf5=new SimpleDateFormat("yyyy/MM/dd"); 

            float[] widths2 = {0.15f, 0.15f,0.30f, 0.20f, 0.20f};
            table = new PdfPTable(widths2);

            cell = new PdfPCell(new Paragraph("發放日期",font12));
            cell.setFixedHeight(20f);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            table.addCell(cell); 

            cell = new PdfPCell(new Paragraph("發放方式",font12));
            cell.setFixedHeight(20f);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            table.addCell(cell);    		

            cell = new PdfPCell(new Paragraph("交易帳戶",font12));
            cell.setFixedHeight(20f);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            table.addCell(cell); 

            cell = new PdfPCell(new Paragraph("發放金額",font12));
            cell.setFixedHeight(20f);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            table.addCell(cell); 

            cell = new PdfPCell(new Paragraph("經手人",font12));
            cell.setFixedHeight(20f);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            table.addCell(cell); 

            Iterator<BillPaidInfo> iter = paidrecords.iterator();
            while (iter.hasNext()) {
            
                BillPaidInfo paid = iter.next();
                String outWord2 = sdf5.format(paid.getPaidTime());

                cell = new PdfPCell(new Paragraph(outWord2,font10));
                cell.setFixedHeight(20f);
                cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
                table.addCell(cell); 

                String method = "其他";
                String acctName = getAccountName(paid);
                switch (paid.getVia())
                {
                    case BillPay.SALARY_CASH: 
                        method = "現金"; 
                        break;
                    case BillPay.SALARY_WIRE: 
                        method = "轉帳"; 
                        break;
                    case BillPay.SALARY_CHECK: 
                        method = "支票"; 
                        break;        
                }

                cell = new PdfPCell(new Paragraph(method,font10));
                cell.setFixedHeight(20f);
                cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
                table.addCell(cell); 

                cell = new PdfPCell(new Paragraph(acctName,font10));
                cell.setFixedHeight(20f);
                cell.setHorizontalAlignment(Element.ALIGN_LEFT);
                cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
                table.addCell(cell); 

                cell = new PdfPCell(new Paragraph(mnf.format(paid.getPaidAmount()),font10));
                cell.setFixedHeight(20f);
                cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
                table.addCell(cell); 

                cell = new PdfPCell(new Paragraph(paid.getUserLoginId(), font10)); 

                cell.setFixedHeight(20f);
                cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
                table.addCell(cell); 
            }
            table.setWidthPercentage(90);
            document.add(table);		
        }
    }

    public void printSalarySlip(MembrInfoBillRecord sinfo, Document document, PdfWriter pdfwriter, int pageNum,
        Map<String, Vector<ChargeItemMembr>> chargeMap, Map<String, Vector<FeeDetail>> feeMap, String remark)
        throws Exception
    {
		PaySystem2 pSystem = (PaySystem2) PaySystem2Mgr.getInstance().find("id=1");
        SimpleDateFormat sdf = new SimpleDateFormat("yy年MM月");
        String logoPath = pSystem.getBillLogoPath();
        String companyName = pSystem.getPaySystemCompanyName();
 
        StringBuffer leftBlock = new StringBuffer();
        StringBuffer rightBlock = new StringBuffer();   

        leftBlock.append("◎應領所得\n");
        rightBlock.append("◎扣項\n");
        int[] totals = new int[2];
        setUpSalaryDetail(sinfo, chargeMap, feeMap, leftBlock, rightBlock, totals);

        Integer leftTotal = new Integer(totals[0]);
        Integer rightTotal = new Integer(totals[1]);

        String subject = sinfo.getMembrName() + " 薪資";
        String title = companyName + "  月份:" + 
            sdf.format(PaymentPrinter.convertToTaiwanDate(sinfo.getBillMonth()))+" 薪資明細";
        ArrayList<BillPaidInfo> paidrecords = BillPaidInfoMgr.getInstance().
            retrieveList("billpaid.ticketId='" + sinfo.getTicketId() + 
            "' and billpay.membrId=0", ""); // billpay.membrId is 0 if it's salary

        printPdf(document, subject, title, 1, logoPath, sinfo.getMembrName(), 
            leftBlock, rightBlock, leftTotal, rightTotal, remark, paidrecords);
    }

    String getAccountName(BillPaidInfo paidinfo)
        throws Exception
    {
        Costpay2 cp = Costpay2Mgr.getInstance().find("costpayFeePayFeeID=" + Costpay2.COSPAY_TYPE_SALARY + 
            " and costpayStudentAccountId=" + paidinfo.getBillPayId());
        String ret = "##";
        if (paidinfo.getVia()==BillPay.SALARY_CASH) {
            try {
                Tradeaccount t = (Tradeaccount) TradeaccountMgr.getInstance().find(cp.getCostpayAccountId());
                ret = t.getTradeaccountName();
            } 
            catch (Exception e) {
                ret = "零用金帳戶";
            }
        }
        else if (paidinfo.getVia()==BillPay.SALARY_WIRE) {
            try {
                BankAccount b = (BankAccount) BankAccountMgr.getInstance().find(cp.getCostpayAccountId());
                ret = b.getBankAccountName();
            } catch (Exception e) {
                ret = "銀行帳戶";
            }
        }      
        else if (paidinfo.getVia()==BillPay.SALARY_CHECK) {
            try {
                BankAccount b = (BankAccount) BankAccountMgr.getInstance().find(cp.getCostpayAccountId());
                ret = b.getBankAccountName();
            } catch (Exception e) {
                ret = "甲存";
            }
        }
        return ret;
    }


    public PdfPTable printSalarySlipAsPdfTable(MembrInfoBillRecord sinfo, String remark)
        throws Exception
    {
		PaySystem2 pSystem = (PaySystem2) PaySystem2Mgr.getInstance().find("id=1");
        SimpleDateFormat sdf = new SimpleDateFormat("yy年MM月");
        String logoPath = pSystem.getBillLogoPath();
        String companyName = pSystem.getPaySystemCompanyName();
 
        StringBuffer leftBlock = new StringBuffer();
        StringBuffer rightBlock = new StringBuffer();   

        leftBlock.append("◎應領所得\n");
        rightBlock.append("◎扣項\n");
        int[] totals = new int[2];
        setUpSalaryDetail(sinfo, chargeMap, feeMap, leftBlock, rightBlock, totals);

        Integer leftTotal = new Integer(totals[0]);
        Integer rightTotal = new Integer(totals[1]);

        String subject = sinfo.getMembrName() + " 薪資";
        String title = companyName + "  月份:" + 
            sdf.format(PaymentPrinter.convertToTaiwanDate(sinfo.getBillMonth()))+" 薪資明細";
        ArrayList<BillPaidInfo> paidrecords = BillPaidInfoMgr.getInstance().
            retrieveList("billpaid.ticketId='" + sinfo.getTicketId() + 
            "' and billpay.membrId=0", ""); // billpay.membrId is 0 if it's salary

        return printPdfAsPdfTable(subject, title, 1, logoPath, sinfo.getMembrName(), 
            leftBlock, rightBlock, leftTotal, rightTotal, remark, paidrecords);
    }


    public PdfPTable printPdfAsPdfTable(
        String subject,  // *must*
        String title,
        int nowPage,
        String logoPath, 
        String payeeName,
		StringBuffer leftBlock,
		StringBuffer rightBlock,
		Integer leftTotal,
		Integer rightTotal,
        String remark,
        ArrayList<BillPaidInfo> paidrecords) throws Exception
    {
    	DecimalFormat mnf = new DecimalFormat("###,###,##0");    			 			
				
		BaseFont bfComic = BaseFont.createFont(fontPath,BaseFont.IDENTITY_H,BaseFont.NOT_EMBEDDED);
		Font font14b = new Font(bfComic, 12,Font.NORMAL);
		Font font14T = new Font(bfComic, 14,Font.BOLD);
		Font font12 = new Font(bfComic, 12,Font.NORMAL);
		Font font10 = new Font(bfComic, 10,Font.NORMAL);
        Font font1 = new Font(bfComic,1,Font.NORMAL);

        PdfPTable ret = new PdfPTable(1);

        /*
        Paragraph cTitle = new Paragraph(subject,font1);
        cTitle.setAlignment(Element.ALIGN_RIGHT);
        Chapter chapter = new Chapter(cTitle,nowPage);
        document.add(chapter);
        
        if (logoPath!=null && logoPath.length()>0) {
            try {
                Image logoI = Image.getInstance(logoPath);
        		logoI.setAlignment(Image.LEFT | Image.UNDERLYING);
                document.add(logoI);
            }
            catch (java.io.IOException e) {}
        }
        */
        
				
		Paragraph parag1=new Paragraph(title,font14b);
        PdfPCell topcell = new PdfPCell(parag1);
        topcell.setHorizontalAlignment(Element.ALIGN_CENTER);
        topcell.setBorderColor(new Color(255, 255, 255));
		ret.addCell(topcell);

		String strTitle="姓名:"+ payeeName;
		parag1=new Paragraph(strTitle,font14T);
        topcell = new PdfPCell(parag1);
        topcell.setHorizontalAlignment(Element.ALIGN_CENTER);
        topcell.setBorderColor(new Color(255, 255, 255));
		ret.addCell(topcell);
						
		strTitle="     薪資明細:"; 
		parag1=new Paragraph(strTitle,font14b);
        topcell = new PdfPCell(parag1);
        topcell.setBorderColor(new Color(255, 255, 255));
        topcell.setHorizontalAlignment(Element.ALIGN_LEFT);
		ret.addCell(topcell);
				
		float[] widths = {0.15f, 0.35f, 0.15f, 0.35f};
		PdfPTable table = new PdfPTable(widths);
		
		PdfPCell cell = new PdfPCell(new Paragraph("加 項 薪 資",font12));
		cell.setColspan(2);
		cell.setFixedHeight(20f);
		cell.setHorizontalAlignment(Element.ALIGN_CENTER);
		cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table.addCell(cell); 
		
		cell = new PdfPCell(new Paragraph("減 項 薪 資",font12));
		cell.setColspan(2);
		cell.setFixedHeight(20f);
		cell.setHorizontalAlignment(Element.ALIGN_CENTER);
		cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table.addCell(cell);  

		cell = new PdfPCell(new Paragraph(leftBlock.toString(),font10));
		cell.setColspan(2);
		cell.setHorizontalAlignment(Element.ALIGN_LEFT);
		cell.setVerticalAlignment(Element.ALIGN_TOP);
		table.addCell(cell); 

   		cell = new PdfPCell(new Paragraph(rightBlock.toString(),font10));
		cell.setColspan(2);
		//cell.setFixedHeight(20f);
		cell.setHorizontalAlignment(Element.ALIGN_LEFT);
		cell.setVerticalAlignment(Element.ALIGN_TOP);
		table.addCell(cell); 
 
		cell = new PdfPCell(new Paragraph("加項合計(a):",font12));
		cell.setFixedHeight(20f);
		cell.setHorizontalAlignment(Element.ALIGN_CENTER);
		cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table.addCell(cell); 

		cell = new PdfPCell(new Paragraph("                 "+
            mnf.format(leftTotal.intValue()),font12));
		cell.setFixedHeight(20f);
		cell.setHorizontalAlignment(Element.ALIGN_CENTER);
		cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table.addCell(cell); 
		
		cell = new PdfPCell(new Paragraph("減項合計(b):",font12));
		cell.setFixedHeight(20f);
		cell.setHorizontalAlignment(Element.ALIGN_CENTER);
		cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table.addCell(cell); 

		cell = new PdfPCell(new Paragraph("                 " +
            mnf.format(Math.abs(rightTotal.intValue())),font12));
		cell.setFixedHeight(20f);
		cell.setHorizontalAlignment(Element.ALIGN_CENTER);
		cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table.addCell(cell); 
		
		cell = new PdfPCell(new Paragraph("實發金額 (a)-(b):  "+
            mnf.format(leftTotal.intValue()+rightTotal.intValue()) + "　",font12));
		cell.setColspan(4);
		cell.setFixedHeight(20f);
		cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
		cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table.addCell(cell); 
        
		table.setWidthPercentage(90);
        topcell = new PdfPCell(table);
        topcell.setBorderColor(new Color(255, 255, 255));
		ret.addCell(topcell);


        if (remark!=null) {
            Paragraph comment=new Paragraph("     備註:" + remark + "\n", font14b);
            comment.setAlignment(Element.ALIGN_LEFT);
            topcell = new PdfPCell(comment);
            topcell.setHorizontalAlignment(Element.ALIGN_LEFT);
            topcell.setBorderColor(new Color(255, 255, 255));
            ret.addCell(comment);
        }
                
        if (paidrecords.size()>0) {
            topcell = new PdfPCell();
            topcell.setHorizontalAlignment(Element.ALIGN_LEFT);
            topcell.setFixedHeight(1f);
            ret.addCell(topcell);

            strTitle="     薪資發放明細:"; 
            parag1=new Paragraph(strTitle,font14b);
            parag1.setAlignment(Element.ALIGN_LEFT);
            topcell = new PdfPCell(parag1);
            topcell.setHorizontalAlignment(Element.ALIGN_LEFT);
            topcell.setBorderColor(new Color(255, 255, 255));
            ret.addCell(topcell);

            SimpleDateFormat sdf5=new SimpleDateFormat("yyyy/MM/dd"); 

            float[] widths2 = {0.15f, 0.15f,0.30f, 0.20f, 0.20f};
            table = new PdfPTable(widths2);

            cell = new PdfPCell(new Paragraph("發放日期",font12));
            cell.setFixedHeight(20f);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            table.addCell(cell); 

            cell = new PdfPCell(new Paragraph("發放方式",font12));
            cell.setFixedHeight(20f);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            table.addCell(cell);    		

            cell = new PdfPCell(new Paragraph("交易帳戶",font12));
            cell.setFixedHeight(20f);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            table.addCell(cell); 

            cell = new PdfPCell(new Paragraph("發放金額",font12));
            cell.setFixedHeight(20f);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            table.addCell(cell); 

            cell = new PdfPCell(new Paragraph("經手人",font12));
            cell.setFixedHeight(20f);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            table.addCell(cell); 

            Iterator<BillPaidInfo> iter = paidrecords.iterator();
            while (iter.hasNext()) {
            
                BillPaidInfo paid = iter.next();
                String outWord2 = sdf5.format(paid.getPaidTime());

                cell = new PdfPCell(new Paragraph(outWord2,font10));
                cell.setFixedHeight(20f);
                cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
                table.addCell(cell); 

                String method = "其他";
                String acctName = getAccountName(paid);
                switch (paid.getVia())
                {
                    case BillPay.SALARY_CASH: 
                        method = "現金"; 
                        break;
                    case BillPay.SALARY_WIRE: 
                        method = "轉帳"; 
                        break;
                    case BillPay.SALARY_CHECK: 
                        method = "支票"; 
                        break;        
                }

                cell = new PdfPCell(new Paragraph(method,font10));
                cell.setFixedHeight(20f);
                cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
                table.addCell(cell); 

                cell = new PdfPCell(new Paragraph(acctName,font10));
                cell.setFixedHeight(20f);
                cell.setHorizontalAlignment(Element.ALIGN_LEFT);
                cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
                table.addCell(cell); 

                cell = new PdfPCell(new Paragraph(mnf.format(paid.getPaidAmount()),font10));
                cell.setFixedHeight(20f);
                cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
                table.addCell(cell); 

                cell = new PdfPCell(new Paragraph(paid.getUserLoginId(), font10)); 

                cell.setFixedHeight(20f);
                cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
                table.addCell(cell); 
            }
            table.setWidthPercentage(90);
            topcell = new PdfPCell(table);
            topcell.setBorderColor(new Color(255, 255, 255));
            ret.addCell(topcell);		
        }

        topcell = new PdfPCell();
        topcell.setHorizontalAlignment(Element.ALIGN_LEFT);
        topcell.setFixedHeight(1f);
        ret.addCell(topcell);

		strTitle="........................................................................";
		parag1=new Paragraph(strTitle,font14b);
        topcell = new PdfPCell(parag1);
        topcell.setBorderColor(new Color(255, 255, 255));
        topcell.setHorizontalAlignment(Element.ALIGN_CENTER);
		ret.addCell(topcell);				

        return ret;
    }
}