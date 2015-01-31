<%@ page language="java"  
    import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,com.lowagie.text.*,com.lowagie.text.pdf.PdfPCell,com.lowagie.text.pdf.PdfPTable,com.lowagie.text.pdf.PdfWriter,com.lowagie.text.pdf.*,java.io.*,java.awt.Color" 
    contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=1;
    int leftMenu=10;
%>
<%@ include file="topMenu.jsp"%>
<%
    if(!checkAuth(ud2,authHa,502))
    {
        response.sendRedirect("authIndex.jsp?code=502");
    }
%>
<%@ include file="leftMenu10.jsp"%>
<%
    //##v2


    DecimalFormat nf = new DecimalFormat("###,##0");
  	DecimalFormat mnf = new DecimalFormat("###,###,##0");

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");

    Date d = new Date();
    try { d = sdf.parse(request.getParameter("calcDate")); } catch (Exception e) {}

    // 資產有
    //    現金(0), 未兌現收款支票3, 應收(學費1, 雜費2)
    // 負債有
    //    預收款4, 未兌現付款支票5, 應付(應付薪資13, 雜費6), 
    // 股東權益有
    //    股東挹注7 提領8, 累計盈虧(學費9 薪資支出10 雜費收入11 雜費支出12)
    
    Map<Object/*帳號*/, Integer/*餘額*/> cashaccounts = new LinkedHashMap<Object/*帳號名*/, Integer/*餘額*/>();   
    int[] numbers = new int[22];
    EzCountingService ezsvc = EzCountingService.getInstance();
    ezsvc.getAccountingNumbers(d, cashaccounts, numbers);

    int cash_total = numbers[0];
    int revenue_receivable = numbers[1];
    int income_receivable = numbers[2];
    int cheque_receivable = numbers[3];
    int pre_received = numbers[4];
    int cheque_payable = numbers[5];
    int spending_payable = numbers[6];
    int shareholder_moneyin = numbers[7];
    int shareholder_moneyout = numbers[8];

    int totalX = pre_received + cheque_payable + spending_payable + shareholder_moneyin - shareholder_moneyout + (numbers[9] + numbers[11] - numbers[10] - numbers[12] + numbers[13] + numbers[14]);

    int xtotal2=pre_received+cheque_payable+spending_payable+numbers[13];
    int showSO=shareholder_moneyout-(shareholder_moneyout*2);       
    int totalIncome=numbers[9]+numbers[11]-numbers[10]-numbers[12];     
    int sharetotal=shareholder_moneyin-shareholder_moneyout+totalIncome;


    Document document = null;
            
    String fname = "";
    try {
        File toolDir = new File(request.getRealPath("/") + "/eSystem/pdf_example");
        ReceiptPrinter p = ReceiptPrinter.getPdfPrinter(toolDir);
        document = new Document(PageSize.A4,15,15,10,10);
        fname = new Date().getTime() + ".pdf";
        File outdir = new File(request.getRealPath("/"), "pdf_output");
        if (!outdir.exists()) {
            outdir.mkdir();
        }

        File testout = new File(outdir, fname);
        PdfWriter pdfwriter = PdfWriter.getInstance(document, new FileOutputStream(testout));
        pdfwriter.setViewerPreferences(PdfWriter.PageModeUseOutlines);
        document.open();


        PaySystem2 e = PaySystem2Mgr.getInstance().find("id=1");
        String bgPath = e.getBillWaterMarkPath();
        String logoPath = e.getBillLogoPath();
        String companyName = e.getPaySystemCompanyName();

//### begin the mess
        PdfContentByte cb = pdfwriter.getDirectContent();		
        String fontPath=toolDir+"/font/dffn_m5.ttc,0";
	
        if (bgPath!=null && bgPath.length()>0) {
            try {
                Image bgImg = Image.getInstance(bgPath);
                bgImg.setAbsolutePosition(200,400);
                document.add(bgImg);
            }
            catch (java.io.IOException ioe) {}
        }
			
        String confImgPath = toolDir +"/font/confidential.tif";
        Image confImg = Image.getInstance(confImgPath);
        confImg.setAbsolutePosition(430,40);
        document.add(confImg);

        BaseFont bfComic = BaseFont.createFont(fontPath,BaseFont.IDENTITY_H,BaseFont.NOT_EMBEDDED);
        Font font14b = new Font(bfComic, 14,Font.BOLD);
        Font font14 = new Font(bfComic, 14,Font.NORMAL);
        Font font12b = new Font(bfComic, 10,Font.BOLD);
        Font font12 = new Font(bfComic, 10,Font.NORMAL);
        Font font10 = new Font(bfComic, 10,Font.NORMAL);
        Font font10b = new Font(bfComic, 10,Font.BOLD);
        Font font8 = new Font(bfComic, 8,Font.NORMAL);
        Font font= FontFactory.getFont(FontFactory.HELVETICA,10, Font.UNDERLINE);
	
        Paragraph parag1=new Paragraph(companyName,font14b);
        parag1.setAlignment(Element.ALIGN_CENTER);
        document.add(parag1);

        String title ="  資 產 負 債 表  ";
        parag1=new Paragraph(title,font10);
        parag1.setAlignment(Element.ALIGN_CENTER);
        document.add(parag1);

        title =sdf.format(d);
        parag1=new Paragraph(title,font10);
        parag1.setAlignment(Element.ALIGN_CENTER);
        document.add(parag1);

        title ="單位: 新台幣 元              \n\n";
        parag1=new Paragraph(title,font10);
        parag1.setAlignment(Element.ALIGN_RIGHT);
        document.add(parag1);

        if (logoPath!=null && logoPath.length()>0) {
            try {
                Image logoI = Image.getInstance(logoPath);
                logoI.setAbsolutePosition(10,770);
                document.add(logoI);
            }
            catch (java.io.IOException ioe) {}
        }



        float[] widths2 = {0.08f, 0.2f, 0.1f,0.05f,0.04f,0.08f, 0.2f, 0.1f,0.05f};		

        PdfPTable table2 = new PdfPTable(widths2);

        PdfPCell cell2 = new PdfPCell(new Paragraph(" 資 產 ",font10b));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setColspan(4);
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);

        cell2 = new PdfPCell(new Paragraph("",font10b));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);

        cell2 = new PdfPCell(new Paragraph(" 負 債 及 業 主 權 益  ",font10b));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setColspan(4);
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);

        
        cell2 = new PdfPCell(new Paragraph("  代 碼",font10b));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
	    cell2.setBackgroundColor(new Color(205, 205, 205));
        table2.addCell(cell2);

        cell2 = new PdfPCell(new Paragraph("       資  產",font10b));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
	    cell2.setBackgroundColor(new Color(205, 205, 205));
        table2.addCell(cell2);

        cell2 = new PdfPCell(new Paragraph(" 金  額",font10b));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
	    cell2.setBackgroundColor(new Color(205, 205, 205));
        table2.addCell(cell2);
        
        cell2 = new PdfPCell(new Paragraph("  %",font10b));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
	    cell2.setBackgroundColor(new Color(205, 205, 205));
        table2.addCell(cell2);
        

        cell2 = new PdfPCell(new Paragraph("",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);

        cell2 = new PdfPCell(new Paragraph("  代 碼",font10b));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
	    cell2.setBackgroundColor(new Color(205, 205, 205));
        table2.addCell(cell2);

        cell2 = new PdfPCell(new Paragraph("  負 債 及 業 主 權 益",font10b));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
	    cell2.setBackgroundColor(new Color(205, 205, 205));
        table2.addCell(cell2);

        cell2 = new PdfPCell(new Paragraph("  金 額",font10b));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
	    cell2.setBackgroundColor(new Color(205, 205, 205));
        table2.addCell(cell2);
        
        cell2 = new PdfPCell(new Paragraph("  %",font10b));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
	    cell2.setBackgroundColor(new Color(205, 205, 205));
        table2.addCell(cell2);

        cell2 = new PdfPCell(new Paragraph("",font10b));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);

        cell2 = new PdfPCell(new Paragraph("現 金",font10b));
        cell2.setColspan(3);
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);

        cell2 = new PdfPCell(new Paragraph("",font10b));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);

        cell2 = new PdfPCell(new Paragraph("",font10b));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);


        cell2 = new PdfPCell(new Paragraph("負  債",font10b));
        cell2.setColspan(3);
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);


        int nowrow=1;
        int assetTotal=cash_total+cheque_receivable+revenue_receivable+income_receivable;

        Set keys = cashaccounts.keySet();
        Iterator<Object> iter = keys.iterator();
        while (iter.hasNext()) {
            
            nowrow++;
            
            Object o = iter.next();
            Integer v = cashaccounts.get(o);
            if (o instanceof Tradeaccount) { 
                Tradeaccount t = (Tradeaccount) o;

                cell2 = new PdfPCell(new Paragraph("1112",font12));
                cell2.setBorderColor(new Color(255, 255, 255));
                cell2.setFixedHeight(20f);
                cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                table2.addCell(cell2);


                cell2 = new PdfPCell(new Paragraph("  零用金:"+t.getTradeaccountName(),font12));
                cell2.setBorderColor(new Color(255, 255, 255));
                cell2.setFixedHeight(20f);
                cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                table2.addCell(cell2);



                cell2 = new PdfPCell(new Paragraph(changeNumber(v.intValue()),font12));
                cell2.setBorderColor(new Color(255, 255, 255));
                cell2.setFixedHeight(20f);
                cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
                cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                table2.addCell(cell2);



                cell2 = new PdfPCell(new Paragraph(changePercent(v.intValue(),assetTotal),font12));
                cell2.setBorderColor(new Color(255, 255, 255));
                cell2.setFixedHeight(20f);
                cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
                cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                table2.addCell(cell2);


            } else { 
                BankAccount b = (BankAccount) o;

                cell2 = new PdfPCell(new Paragraph("1113",font12));
                cell2.setBorderColor(new Color(255, 255, 255));
                cell2.setFixedHeight(20f);
                cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                table2.addCell(cell2);


                cell2 = new PdfPCell(new Paragraph("  銀行:"+b.getBankAccountName(),font12));
                cell2.setBorderColor(new Color(255, 255, 255));
                cell2.setFixedHeight(20f);
                cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                table2.addCell(cell2);



                cell2 = new PdfPCell(new Paragraph(changeNumber(v.intValue()),font12));
                cell2.setBorderColor(new Color(255, 255, 255));
                cell2.setFixedHeight(20f);
                cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
                cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                table2.addCell(cell2);



                cell2 = new PdfPCell(new Paragraph(changePercent(v.intValue(),assetTotal),font12));
                cell2.setBorderColor(new Color(255, 255, 255));
                cell2.setFixedHeight(20f);
                cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
                cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                table2.addCell(cell2);
            } 

           doLeft(nowrow,table2,font12,numbers,font12b);

        } 
    
        nowrow++;

        cell2 = new PdfPCell(new Paragraph("111x",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);


        cell2 = new PdfPCell(new Paragraph("  現金合計:",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);



        cell2 = new PdfPCell(new Paragraph(changeNumber(cash_total),font));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);

        cell2 = new PdfPCell(new Paragraph(changePercent(cash_total,assetTotal),font));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);

        doLeft(nowrow,table2,font12,numbers,font12b);


        nowrow++;

        cell2 = new PdfPCell(new Paragraph("",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);


        cell2 = new PdfPCell(new Paragraph("應收票據",font12b));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);



        cell2 = new PdfPCell(new Paragraph("",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);

        cell2 = new PdfPCell(new Paragraph("",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);

        doLeft(nowrow,table2,font12,numbers,font12b);


        nowrow++;

        cell2 = new PdfPCell(new Paragraph("1131",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);


        cell2 = new PdfPCell(new Paragraph("  支票",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);


       cell2 = new PdfPCell(new Paragraph(changeNumber(cheque_receivable),font12));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);

        cell2 = new PdfPCell(new Paragraph(changePercent(cheque_receivable,assetTotal),font12));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);

        doLeft(nowrow,table2,font12,numbers,font12b);

        
        nowrow++;

        cell2 = new PdfPCell(new Paragraph("",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);


        cell2 = new PdfPCell(new Paragraph("  應收票據合計",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);


       cell2 = new PdfPCell(new Paragraph(changeNumber(cheque_receivable),font));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);

        cell2 = new PdfPCell(new Paragraph(changePercent(cheque_receivable,assetTotal),font));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);

        doLeft(nowrow,table2,font12,numbers,font12b);

        nowrow++;

        cell2 = new PdfPCell(new Paragraph("",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);


        cell2 = new PdfPCell(new Paragraph("應收帳款",font12b));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);



        cell2 = new PdfPCell(new Paragraph("",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);

        cell2 = new PdfPCell(new Paragraph("",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);

        doLeft(nowrow,table2,font12,numbers,font12b);




        nowrow++;

        cell2 = new PdfPCell(new Paragraph("1141",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);


        cell2 = new PdfPCell(new Paragraph("  應收帳款 學費",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);

       cell2 = new PdfPCell(new Paragraph(changeNumber(revenue_receivable),font12));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);

        cell2 = new PdfPCell(new Paragraph(changePercent(revenue_receivable,assetTotal),font12));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);

        doLeft(nowrow,table2,font12,numbers,font12b);


        nowrow++;

        cell2 = new PdfPCell(new Paragraph("1141",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);


        cell2 = new PdfPCell(new Paragraph("  應收帳款 雜費",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);

       cell2 = new PdfPCell(new Paragraph(changeNumber(income_receivable),font12));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);

        cell2 = new PdfPCell(new Paragraph(changePercent(income_receivable,assetTotal),font12));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);

        doLeft(nowrow,table2,font12,numbers,font12b);


        int shouldTotal=revenue_receivable+income_receivable;

        nowrow++;

        cell2 = new PdfPCell(new Paragraph("114x",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);


        cell2 = new PdfPCell(new Paragraph("  應收帳款合計",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);

       cell2 = new PdfPCell(new Paragraph(changeNumber(shouldTotal),font));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);

        cell2 = new PdfPCell(new Paragraph(changePercent(shouldTotal,assetTotal),font));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);

        doLeft(nowrow,table2,font12,numbers,font12b);


        nowrow++;

        cell2 = new PdfPCell(new Paragraph("1xxx",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);


        cell2 = new PdfPCell(new Paragraph("資 產 總 計",font12b));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);

       cell2 = new PdfPCell(new Paragraph(changeNumber(assetTotal),font));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);

        cell2 = new PdfPCell(new Paragraph(changePercent(assetTotal,assetTotal),font));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);

        doLeft(nowrow,table2,font12,numbers,font12b);


        if(nowrow <13){

            int xrow=13-nowrow;

            for(int i=0;i<xrow;i++){

                nowrow++;

                cell2 = new PdfPCell(new Paragraph("",font12));
                cell2.setColspan(4);
                cell2.setBorderColor(new Color(255, 255, 255));
                cell2.setFixedHeight(20f);
                cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                table2.addCell(cell2);

                doLeft(nowrow,table2,font12,numbers,font12b);

            }
        }


			
        table2.setWidthPercentage(98);

        document.add(table2);


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
<%=(d!=null)?sdf.format(d):""%>-下載資產負債表</b>
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
                <form target=_blank action="../pdf_output/<%=fname%>">
                <input type=submit value="下載PDF">
                </form>
            
                <br>
                <div class=es02><b>資產負債表下載資訊:</b></div>
                <table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
                <tr align=left valign=top>
                <td bgcolor="#e9e3de">
                    <table width="100%" border=0 cellpadding=4 cellspacing=1>
                        <tr bgcolor=#f0f0f0 class=es02>
                        <td>狀態</td>
                        <tD bgcolor=ffffff>
                            已產生資產負債表,<a target="_blank" href="../pdf_output/<%=fname%>"><font color=blue>可下載</font></a>.
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
<br>
<%@ include file="bottom.jsp"%>	
</body>

<%!
    DecimalFormat nf = new DecimalFormat("###,##0");
  	DecimalFormat mnf = new DecimalFormat("###,###,##0");

    public String changeNumber(int number){

        if(number >=0)
        {
            return mnf.format(number);
        }else{

            return "("+mnf.format(Math.abs(number))+")";
        }
    }


    public String changePercent(int number,int total){

        if(number==0 ||total==0)
        {
            return "-";
        }

        if(number >0){
            return nf.format(((float)number/(float)total*100));
        }

        if(number <0){
            int abs=Math.abs(number);
            return "("+nf.format(((float)abs/(float)total*100))+")";
        }

        return "";
    }

    Font font= FontFactory.getFont(FontFactory.HELVETICA,10, Font.UNDERLINE);
    public boolean doLeft(int nowrow,PdfPTable table2,Font font12,int[] numbers,Font font12b){

    int cash_total = numbers[0];
    int revenue_receivable = numbers[1];
    int income_receivable = numbers[2];
    int cheque_receivable = numbers[3];
    int pre_received = numbers[4];
    int cheque_payable = numbers[5];
    int spending_payable = numbers[6];
    int shareholder_moneyin = numbers[7];
    int shareholder_moneyout = numbers[8];

    int totalX = pre_received + cheque_payable + spending_payable + shareholder_moneyin - shareholder_moneyout + (numbers[9] + numbers[11] - numbers[10] - numbers[12] + numbers[13] + numbers[14]);

    int xtotal2=pre_received+cheque_payable+spending_payable+numbers[13];
    int showSO=shareholder_moneyout-(shareholder_moneyout*2);       
    int totalIncome=numbers[9]+numbers[11]-numbers[10]-numbers[12]; 
    int sharetotal=shareholder_moneyin-shareholder_moneyout+totalIncome;

        PdfPCell cell2=null;
        
        switch(nowrow){
            
                case 2:
                    cell2 = new PdfPCell(new Paragraph("",font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);

                    cell2 = new PdfPCell(new Paragraph("2131",font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);


                    cell2 = new PdfPCell(new Paragraph("  應付票據 :",font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);



                    cell2 = new PdfPCell(new Paragraph(changeNumber(cheque_payable),font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);



                    cell2 = new PdfPCell(new Paragraph(changePercent(cheque_payable,totalX),font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);
                break;
                
            case 3:
                    cell2 = new PdfPCell(new Paragraph("",font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);

                    cell2 = new PdfPCell(new Paragraph("2141",font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);


                    cell2 = new PdfPCell(new Paragraph("  應付帳款-雜費:",font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);



                    cell2 = new PdfPCell(new Paragraph(changeNumber(spending_payable),font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);



                    cell2 = new PdfPCell(new Paragraph(changePercent(spending_payable,totalX),font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);
                break;
            
             case 4:
                    cell2 = new PdfPCell(new Paragraph("",font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);

                    cell2 = new PdfPCell(new Paragraph("2141",font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);


                    cell2 = new PdfPCell(new Paragraph("  應付帳款-薪資:",font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);



                    cell2 = new PdfPCell(new Paragraph(changeNumber(numbers[13]),font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);



                    cell2 = new PdfPCell(new Paragraph(changePercent(numbers[13],totalX),font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);
                break;

             case 5:
                    cell2 = new PdfPCell(new Paragraph("",font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);

                    cell2 = new PdfPCell(new Paragraph("2262",font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);


                    cell2 = new PdfPCell(new Paragraph("  預收收入 :",font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);



                    cell2 = new PdfPCell(new Paragraph(changeNumber(pre_received),font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);



                    cell2 = new PdfPCell(new Paragraph(changePercent(pre_received,totalX),font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);
                break;

             case 6:
                    cell2 = new PdfPCell(new Paragraph("",font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);

                    cell2 = new PdfPCell(new Paragraph("2xxx",font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);


                    cell2 = new PdfPCell(new Paragraph("  負債合計:",font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);



                    cell2 = new PdfPCell(new Paragraph(changeNumber(xtotal2),font));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);



                    cell2 = new PdfPCell(new Paragraph(changePercent(xtotal2,totalX),font));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);
                break;

            case 7:
                    cell2 = new PdfPCell(new Paragraph("",font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);

                    cell2 = new PdfPCell(new Paragraph("",font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);


                    cell2 = new PdfPCell(new Paragraph("股東權益:",font12b));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setColspan(3);
                    cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);
                break;
                
                case 8:
                    cell2 = new PdfPCell(new Paragraph("",font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);

                    cell2 = new PdfPCell(new Paragraph("3116",font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);


                    cell2 = new PdfPCell(new Paragraph("  股東挹注",font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);

                    cell2 = new PdfPCell(new Paragraph(changeNumber(shareholder_moneyin),font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);

                    cell2 = new PdfPCell(new Paragraph(changePercent(shareholder_moneyin,totalX),font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);
                break;

                case 9:
                    cell2 = new PdfPCell(new Paragraph("",font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);

                    cell2 = new PdfPCell(new Paragraph("3117",font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);


                    cell2 = new PdfPCell(new Paragraph("  股東提取",font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);

                    cell2 = new PdfPCell(new Paragraph(changeNumber(showSO),font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);

                    cell2 = new PdfPCell(new Paragraph(changePercent(showSO,totalX),font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);
                break;

               case 10:
                    cell2 = new PdfPCell(new Paragraph("",font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);

                    cell2 = new PdfPCell(new Paragraph("3351",font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);


                    cell2 = new PdfPCell(new Paragraph("  累積盈虧",font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);

                    cell2 = new PdfPCell(new Paragraph(changeNumber(totalIncome),font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);

                    cell2 = new PdfPCell(new Paragraph(changePercent(totalIncome,totalX),font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);
                break;

           case 11:
                    cell2 = new PdfPCell(new Paragraph("",font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);

                    cell2 = new PdfPCell(new Paragraph("",font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);


                    cell2 = new PdfPCell(new Paragraph("  本期損益",font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);

                    cell2 = new PdfPCell(new Paragraph("",font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);

                    cell2 = new PdfPCell(new Paragraph("",font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);
                break;


           case 12:
                    cell2 = new PdfPCell(new Paragraph("",font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);

                    cell2 = new PdfPCell(new Paragraph("3xxx",font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);


                    cell2 = new PdfPCell(new Paragraph("  股東權益合計",font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);

                  
                    cell2 = new PdfPCell(new Paragraph(changeNumber(sharetotal),font));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);

                    cell2 = new PdfPCell(new Paragraph(changePercent(sharetotal,totalX),font));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);
                break;
            case 13:
                    cell2 = new PdfPCell(new Paragraph("",font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);

                    cell2 = new PdfPCell(new Paragraph("",font12));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);


                    cell2 = new PdfPCell(new Paragraph("負債及股東權益總計",font12b));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);

                  
                    cell2 = new PdfPCell(new Paragraph(changeNumber(totalX),font));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);

                    cell2 = new PdfPCell(new Paragraph(changePercent(totalX,totalX),font));
                    cell2.setBorderColor(new Color(255, 255, 255));
                    cell2.setFixedHeight(20f);
                    cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table2.addCell(cell2);
                break;
            default:

                cell2 = new PdfPCell(new Paragraph("",font12));
                cell2.setBorderColor(new Color(255, 255, 255));
                cell2.setFixedHeight(20f);
                cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                table2.addCell(cell2);


                cell2 = new PdfPCell(new Paragraph("",font12));
                cell2.setColspan(4);
                cell2.setBorderColor(new Color(255, 255, 255));
                cell2.setFixedHeight(20f);
                cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
                cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                table2.addCell(cell2);

                break;

                
            }
        return true;
    }
%>


