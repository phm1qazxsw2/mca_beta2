<%@ page language="java"  
    import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,com.lowagie.text.*,com.lowagie.text.pdf.PdfPCell,com.lowagie.text.pdf.PdfPTable,com.lowagie.text.pdf.PdfWriter,com.lowagie.text.pdf.*,java.io.*,java.awt.Color" 
    contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%!
    public int getChargeAmount(ChargeItemMembr ci, Map<String, Vector<Discount>> discountMap)
    {
        int ret = ci.getMyAmount();
        Vector<Discount> dv = discountMap.get(ci.getChargeKey());
        if (dv!=null) {
            for (int i=0; i<dv.size(); i++) {
                ret -= dv.get(i).getAmount();
            }
        }
        return ret;
    }
%>
<%
    int topMenu=1;
    int leftMenu=10;
%>
<%@ include file="topMenu.jsp"%>
<%
    if(!checkAuth(ud2,authHa,501))
    {
        response.sendRedirect("authIndex.jsp?code=501");
    }
%>
<%@ include file="leftMenu10.jsp"%>
<%
    //##v2


    SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM");
    SimpleDateFormat sdf2=new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat sdf3=new SimpleDateFormat("yyyy-MM-dd HH:mm");
    SimpleDateFormat sdf4=new SimpleDateFormat("yyyy/MM/dd");
    Date cur = sdf.parse(request.getParameter("t"));

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

        ArrayList<MembrInfoBillRecord> bills = new ArrayList<MembrInfoBillRecord>();
        ArrayList<MembrInfoBillRecord> salaries = new ArrayList<MembrInfoBillRecord>();
        ArrayList<Vitem> income = new ArrayList<Vitem>();
        ArrayList<Vitem> cost = new ArrayList<Vitem>();
        int[] numbers = new int[8]; // 
        Calendar cal = Calendar.getInstance();
        cal.setTime(cur);
        java.util.Date curMonthStart = sdf.parse(sdf.format(cal.getTime()));
        cal.add(Calendar.MONTH, 1);
        java.util.Date nextMonthStart = sdf.parse(sdf.format(cal.getTime()));
        cal.add(Calendar.DATE, -1);
        Date curMonthEnd = cal.getTime();
        EzCountingService ezsvc = EzCountingService.getInstance();    
        ezsvc.getMonthlyNumbers(_ws.getSessionBunitId(), numbers, curMonthStart, nextMonthStart, bills, salaries, income, cost);
        int income_total = numbers[0];
        int income_received = numbers[1];
        int spending_total = numbers[2];
        int spending_paid = numbers[3];
        int revenue_total = numbers[4];
        int revenue_received = numbers[5];
        int salary_total = numbers[6];
        int salary_paid = numbers[7];

        int costNum=salary_total+spending_total;
//## prepare some datastructure
        
        ArrayList<BillRecordInfo> targetRecords = BillRecordInfoMgr.getInstance().
            retrieveList("month='" + sdf2.format(cur) + "' and billType="+Bill.TYPE_BILLING, "");
        ArrayList<BillRecordInfo> salaryRecords = BillRecordInfoMgr.getInstance().
            retrieveList("month='" + sdf2.format(cur) + "' and billType="+Bill.TYPE_SALARY +
            " and privLevel>=" + ud2.getUserRole(), "");
        
        String brids = new RangeMaker().makeRange(targetRecords, "getId");

        // 找出這批record 所有的 charge, 并放到 feeMap 里
        ArrayList<ChargeItemMembr> all_fees = ChargeItemMembrMgr.getInstance().
            retrieveList("chargeitem.billRecordId in (" + brids + ")", "");
        String chargeIds = new RangeMaker().makeRange(all_fees, "getChargeItemId");
        ArrayList<DiscountInfo> all_discounts = DiscountInfoMgr.getInstance().
            retrieveList("chargeItemId in (" + chargeIds + ")", ""); 
        Map<Integer/*incomesmallitemId*/, Vector<ChargeItemMembr>> feeMap = 
            new SortingMap(all_fees).doSort("getSmallItemId");
        Map<String/*chargekey*/, Vector<Discount>> discountMap = 
            new SortingMap(all_discounts).doSort("getChargeKey");

        Object[] objs = SmallItemMgr.getInstance().retrieve("","");
        Map<Integer/*smallItemId*/, Vector<SmallItem>> smallitemMap = 
            new SortingMap().doSort(objs, new ArrayList<SmallItem>(), "getId");
        objs = IncomeSmallItemMgr.getInstance().retrieve("","");
        Map<Integer/*IncomeSmallItemId*/, Vector<IncomeSmallItem>> incomesmallitemMap = 
            new SortingMap().doSort(objs, new ArrayList<IncomeSmallItem>(), "getId");

        objs = BigItemMgr.getInstance().retrieve("", "");
        Map<String/*acctcode*/, Vector<BigItem>> bigitemMap 
            = new SortingMap().doSort(objs, new ArrayList<BigItem>(), "getAcctCode");

        Map<Integer/*billrecord.id*/, Vector<MembrInfoBillRecord>> salaryMap =
            new SortingMap(salaries).doSort("getBillRecordId");

//## end of preparation

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
        Font font12b = new Font(bfComic, 12,Font.BOLD);
        Font font12 = new Font(bfComic, 12,Font.NORMAL);
        Font font10 = new Font(bfComic, 10,Font.NORMAL);
        Font font10b = new Font(bfComic, 10,Font.BOLD);
        Font font8 = new Font(bfComic, 8,Font.NORMAL);
        Font font= FontFactory.getFont(FontFactory.HELVETICA, Font.DEFAULTSIZE, Font.UNDERLINE);
	
        Paragraph parag1=new Paragraph(companyName,font14b);
        parag1.setAlignment(Element.ALIGN_CENTER);
        document.add(parag1);

        String title ="  損 益 表  ";
        parag1=new Paragraph(title,font10);
        parag1.setAlignment(Element.ALIGN_CENTER);
        document.add(parag1);

        title = sdf4.format(curMonthStart)+" - "+sdf4.format(curMonthEnd);
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
			
        DecimalFormat nf = new DecimalFormat("###,##0");
        DecimalFormat mnf = new DecimalFormat("###,###,##0");



/*
        PdfPCell cell2 = new PdfPCell(new Paragraph("日期區間:"+sdf4.format(curMonthStart)+" - "+sdf4.format(curMonthEnd),font10b));
        cell2.setColspan(4);
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);		
*/			
//##### start 收入

        float[] widths2 = {0.1f, 0.4f, 0.2f,0.2f,0.1f};		

        PdfPTable table2 = new PdfPTable(widths2);
        
        PdfPCell cell2 = new PdfPCell(new Paragraph("   代 碼",font10b));
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
	    cell2.setBackgroundColor(new Color(205, 205, 205));
        table2.addCell(cell2);

        table2.getDefaultCell().setVerticalAlignment(Element.ALIGN_MIDDLE);        
        cell2 = new PdfPCell(new Paragraph("          金   額",font10b));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
	    cell2.setBackgroundColor(new Color(205, 205, 205));
        table2.addCell(cell2);

        table2.getDefaultCell().setVerticalAlignment(Element.ALIGN_MIDDLE);        
        cell2 = new PdfPCell(new Paragraph("          小   計",font10b));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
	    cell2.setBackgroundColor(new Color(205, 205, 205));
        table2.addCell(cell2);
        
        cell2 = new PdfPCell(new Paragraph("       %",font10b));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_MIDDLE);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
	    cell2.setBackgroundColor(new Color(205, 205, 205));
        table2.addCell(cell2);

        cell2 = new PdfPCell(new Paragraph("",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);
		
	    cell2 = new PdfPCell(new Paragraph("  學費收入",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);

		cell2 = new PdfPCell(new Paragraph(""));
        cell2.setBorderColor(new Color(255, 255, 255));
		cell2.setFixedHeight(20f);
        cell2.setColspan(3);
		cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);



        int total = revenue_total + income_total;
       
        Set<Integer> keys = feeMap.keySet();
        Iterator<Integer> keyIter = keys.iterator();
        while (keyIter.hasNext()) {
            int thisChargeAmount = 0;
			Integer incomesmallitemId = keyIter.next();
            Vector<IncomeSmallItem> visi = incomesmallitemMap.get(incomesmallitemId);
            if (visi==null)
                continue;
            IncomeSmallItem isi = visi.get(0);
			Vector<ChargeItemMembr> fees = feeMap.get(incomesmallitemId);
            for (int i=0; i<fees.size(); i++) {
                ChargeItemMembr ci = fees.get(i);
                thisChargeAmount += getChargeAmount(ci, discountMap);
            }

            String acctcodeStr = "4" + PaymentPrinter.makePrecise(isi.getId()+"", 3, false, '0');
			cell2 = new PdfPCell(new Paragraph("  "+acctcodeStr,font12));
			cell2.setFixedHeight(20f);
            cell2.setBorderColor(new Color(255, 255, 255));
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("    "+isi.getIncomeSmallItemName(),font12));
			cell2.setFixedHeight(20f);
            cell2.setBorderColor(new Color(255, 255, 255));
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph(mnf.format(thisChargeAmount),font12));
            cell2.setBorderColor(new Color(255, 255, 255));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
            cell2 = new PdfPCell(new Paragraph(""));
            cell2.setBorderColor(new Color(255, 255, 255));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph(nf.format(((float)thisChargeAmount/(float)total)*100),font12));
            cell2.setBorderColor(new Color(255, 255, 255));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
		}	
		
	    cell2 = new PdfPCell(new Paragraph("",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);
		
	    cell2 = new PdfPCell(new Paragraph("    學費收入小計",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);

		cell2 = new PdfPCell(new Paragraph("",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);

		cell2 = new PdfPCell(new Paragraph(mnf.format(revenue_total),font));
        cell2.setBorderColor(new Color(255, 255, 255));
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);

//System.out.println("### revenue_total=" + revenue_total + " total=" + total);
        cell2 = new PdfPCell(new Paragraph((total!=0)?nf.format(((float)revenue_total/(float)total)*100)+"":"-",font));
        cell2.setBorderColor(new Color(255, 255, 255));
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);



	    cell2 = new PdfPCell(new Paragraph("",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);


	    cell2 = new PdfPCell(new Paragraph("  雜費收入",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);

		cell2 = new PdfPCell(new Paragraph(""));
        cell2.setBorderColor(new Color(255, 255, 255));
		cell2.setFixedHeight(20f);
        cell2.setColspan(3);
		cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);
 
//### 雜費收入·

        Map<String/*acctcode first 4*/, Vector<Vitem>> incomeMap = new SortingMap(income).doSort("getAcctMajorCode");
        Set<String> keys2 = incomeMap.keySet();
        Iterator<String> keyIter2 = keys2.iterator();
		while(keyIter2.hasNext()) {
            String code4 = keyIter2.next();
            Vector<BigItem> vb = bigitemMap.get(code4);
            Vector<Vitem> vitems = incomeMap.get(code4);
            String catName = "";
            if (vb!=null) {
                catName = vb.get(0).getBigItemName();
            }
            int income_num = 0;
            for (int i=0; i<vitems.size(); i++)
                income_num += vitems.get(i).getTotal();
                        
            cell2 = new PdfPCell(new Paragraph("  "+code4,font12));
            cell2.setBorderColor(new Color(255, 255, 255));
            cell2.setFixedHeight(20f);
            cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
            cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            table2.addCell(cell2);            
            
            cell2 = new PdfPCell(new Paragraph("    "+catName,font12));
            cell2.setBorderColor(new Color(255, 255, 255));
            cell2.setFixedHeight(20f);
            cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
            cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            table2.addCell(cell2);

            cell2 = new PdfPCell(new Paragraph(mnf.format(income_num),font12));
            cell2.setBorderColor(new Color(255, 255, 255));
            cell2.setFixedHeight(20f);
            cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
            cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            table2.addCell(cell2);    

            cell2 = new PdfPCell(new Paragraph(""));
            cell2.setBorderColor(new Color(255, 255, 255));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
            
            String percentX = (total!=0)?nf.format(((float)income_num/(float)total)*100):"-";
            
            cell2 = new PdfPCell(new Paragraph(percentX,font12));
            cell2.setBorderColor(new Color(255, 255, 255));
            cell2.setFixedHeight(20f);
            cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
            cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            table2.addCell(cell2);	
        }
        
	    cell2 = new PdfPCell(new Paragraph("",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);
		
	    cell2 = new PdfPCell(new Paragraph("    雜費收入小計",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);

		cell2 = new PdfPCell(new Paragraph("",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);

		cell2 = new PdfPCell(new Paragraph(mnf.format(income_total),font));
        cell2.setBorderColor(new Color(255, 255, 255));
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);

//System.out.println("### revenue_total=" + revenue_total + " total=" + total);
		cell2 = new PdfPCell(new Paragraph((total!=0)?nf.format(((float)income_total/(float)total)*100):"-",font));
        cell2.setBorderColor(new Color(255, 255, 255));
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);

         
	    cell2 = new PdfPCell(new Paragraph("  4xxx",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);


        cell2 = new PdfPCell(new Paragraph("營業收入總計",font12b));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);
	
	    cell2 = new PdfPCell(new Paragraph("",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);

        cell2 = new PdfPCell(new Paragraph(mnf.format(income_total+revenue_total),font));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);

        cell2 = new PdfPCell(new Paragraph("100",font));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);

//###### end of 收入, start of 支出

        cell2 = new PdfPCell(new Paragraph("",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);

			
        cell2 = new PdfPCell(new Paragraph("  薪資支出",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);

        cell2 = new PdfPCell(new Paragraph("",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setColspan(3);
        cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);


        Iterator<BillRecordInfo> brIter = salaryRecords.iterator();
        while (brIter.hasNext()) {

            BillRecordInfo br = brIter.next();

            String acctcodeStr = "  6151 " + PaymentPrinter.makePrecise(br.getBillId()+"",3,false,'0');
            cell2 = new PdfPCell(new Paragraph(acctcodeStr,font12));
            cell2.setBorderColor(new Color(255, 255, 255));
            cell2.setFixedHeight(20f);
            cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
            cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            table2.addCell(cell2);
	
            cell2 = new PdfPCell(new Paragraph("    "+br.getBillName(),font12));
            cell2.setBorderColor(new Color(255, 255, 255));
            cell2.setFixedHeight(20f);
            cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
            cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            table2.addCell(cell2);
                    
            Vector<MembrInfoBillRecord> items = salaryMap.get(new Integer(br.getId()));
            int salary_sum = 0;
            for (int i=0; items!=null && i<items.size(); i++) {
                salary_sum += items.get(i).getReceivable();
            }
            cell2 = new PdfPCell(new Paragraph(mnf.format(salary_sum),font12));
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

            cell2 = new PdfPCell(new Paragraph(nf.format(((float)salary_sum/(float)costNum)*100),font12));
            cell2.setBorderColor(new Color(255, 255, 255));
            cell2.setFixedHeight(20f);
            cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
            cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            table2.addCell(cell2);
            
	    }
		
        cell2 = new PdfPCell(new Paragraph("",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);
		
	    cell2 = new PdfPCell(new Paragraph("    薪資支出小計",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);

//	    Font fontxx = FontFactory.getFont(FontFactory.HELVETICA, Font.DEFAULTSIZE, Font.UNDERLINE);
		cell2 = new PdfPCell(new Paragraph("",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);

		cell2 = new PdfPCell(new Paragraph(mnf.format(salary_total),font));
        cell2.setBorderColor(new Color(255, 255, 255));
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);

		cell2 = new PdfPCell(new Paragraph((total!=0)?nf.format(((float)salary_total/(float)costNum)*100):"-",font));
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


        cell2 = new PdfPCell(new Paragraph("  雜費支出",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);

        cell2 = new PdfPCell(new Paragraph("",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setColspan(3);
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);
	
        Map<String/*acctcode first 4*/, Vector<Vitem>> costMap = new SortingMap(cost).doSort("getAcctMajorCode");
        keys2 = costMap.keySet();
        keyIter2 = keys2.iterator();
		while(keyIter2.hasNext()) {
            String code4 = keyIter2.next();
            Vector<BigItem> vb = bigitemMap.get(code4);
            Vector<Vitem> vitems = costMap.get(code4);
            String catName = "";
            if (vb!=null) {
                catName = vb.get(0).getBigItemName();
            }
            int cost_num = 0;
            for (int i=0; i<vitems.size(); i++)
                cost_num += vitems.get(i).getTotal();
		
            cell2 = new PdfPCell(new Paragraph("  "+code4,font12));
            cell2.setBorderColor(new Color(255, 255, 255));
            cell2.setFixedHeight(20f);
            cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
            cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            table2.addCell(cell2);
				
            cell2 = new PdfPCell(new Paragraph("    "+catName,font12));
            cell2.setBorderColor(new Color(255, 255, 255));
            cell2.setFixedHeight(20f);
            cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
            cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            table2.addCell(cell2);
		
            cell2 = new PdfPCell(new Paragraph(mnf.format(cost_num),font12));
            cell2.setBorderColor(new Color(255, 255, 255));
            cell2.setFixedHeight(20f);
            cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
            cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            table2.addCell(cell2);	
	
            cell2 = new PdfPCell(new Paragraph("",font12));
            cell2.setBorderColor(new Color(255, 255, 255));
            cell2.setFixedHeight(20f);
            cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
            cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            table2.addCell(cell2);


            String percentX = (total!=0)?nf.format(((float)cost_num/(float)costNum)*100):"-";

            cell2 = new PdfPCell(new Paragraph(percentX,font12));
            cell2.setBorderColor(new Color(255, 255, 255));
            cell2.setFixedHeight(20f);
            cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
            cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            table2.addCell(cell2);   
        }

        cell2 = new PdfPCell(new Paragraph("",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);
		
	    cell2 = new PdfPCell(new Paragraph("    雜費支出小計",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);

//	    Font fontxx = FontFactory.getFont(FontFactory.HELVETICA, Font.DEFAULTSIZE, Font.UNDERLINE);
		cell2 = new PdfPCell(new Paragraph("",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);

		cell2 = new PdfPCell(new Paragraph(mnf.format(spending_total),font));
        cell2.setBorderColor(new Color(255, 255, 255));
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);

		cell2 = new PdfPCell(new Paragraph((total!=0)?nf.format(((float)spending_total/(float)costNum)*100):"-",font));
        cell2.setBorderColor(new Color(255, 255, 255));
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);


        cell2 = new PdfPCell(new Paragraph("  6xxx",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);


        cell2 = new PdfPCell(new Paragraph("營業支出總計",font12b));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);
	
	    cell2 = new PdfPCell(new Paragraph("",font12));
        cell2.setBorderColor(new Color(255, 255, 255));
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);

        cell2 = new PdfPCell(new Paragraph(mnf.format(costNum),font));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);


        cell2 = new PdfPCell(new Paragraph("100",font));
        cell2.setBorderColor(new Color(255, 255, 255));

        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);


        cell2 = new PdfPCell(new Paragraph("",font));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setColspan(5);
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);



        cell2 = new PdfPCell(new Paragraph("      ***本期損益***",font12b));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setColspan(2);
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);

        cell2 = new PdfPCell(new Paragraph(" ",font12b));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);




        cell2 = new PdfPCell(new Paragraph(mnf.format(income_total+revenue_total-spending_total-salary_total),font));

        //cell2 = new PdfPCell(new Paragraph(new Chunk("underline", font),font));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);
		
        cell2 = new PdfPCell(new Paragraph("",font12b));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);

        cell2 = new PdfPCell(new Paragraph("製表日期:"+sdf2.format(new Date())+"  製表人:"+ud2.getUserFullname(),font10));
        cell2.setBorderColor(new Color(255, 255, 255));
        cell2.setColspan(4);
        cell2.setFixedHeight(20f);
        cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table2.addCell(cell2);
			
        table2.setWidthPercentage(90);

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
<%=(cur!=null)?sdf.format(cur):""%>-下載損益表</b>
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
<br>
<%@ include file="bottom.jsp"%>	
</body>


