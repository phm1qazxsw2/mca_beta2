<%@ page language="java" 
    import="jsf.*,phm.ezcounting.*,com.lowagie.text.*,com.lowagie.text.pdf.*,java.io.*,java.util.*,java.text.*"
    contentType="text/html;charset=UTF-8"%>
<%
    // find the bill
    EzCountingService ezsvc = EzCountingService.getInstance();
    String ticketId = request.getParameter("ticketId");
    MembrBillRecord sbr = MembrBillRecordMgr.getInstance().find("ticketId='"+ticketId+"'");
    if (sbr==null) {
        out.println("輸入的 ticketId 無效，沒有找到帳單");
        return;
    }

    // get the system parameter
    PaySystem pSystem = (PaySystem) ObjectService.find("jsf.PaySystem", "id=1");

    // get billrecord
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月");
    SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy年MM月dd日");
    BillRecord br = BillRecordMgr.getInstance().find("id="+sbr.getBillRecordId());

    Membr membr = MembrMgr.getInstance().find("id="+sbr.getMembrId());
    
    String title = "學雜費通知單    " + sdf.format(br.getMonth());
    String companyName = pSystem.getPaySystemCompanyName();
    String companyAddress = pSystem.getPaySystemCompanyAddress();
    String companyPhone = pSystem.getPaySystemCompanyPhone();
    String studentName = membr.getName();

    File toolDir = new File(request.getRealPath("/") + "/eSystem/pdf_example");
    if (!toolDir.exists())
        throw new Exception("pdf tool directory not exists!");

    String logoPath = new File(toolDir, "font/logo.tif").getAbsolutePath();
    String bgPath = new File(toolDir, "font/bg.tif").getAbsolutePath();

    PaymentPrinter p = PaymentPrinter.getPdfPrinter(toolDir);

    String greetingImgPath = null;
    String greetings = null;
    if (pSystem.getPaySystemBirthActive()==1) {
        Date bday = membr.getBirth();
        if (bday.getMonth()==br.getMonth().getMonth()) {
            greetingImgPath = new File(toolDir, "font/birth.tif").getAbsolutePath();
            greetings = p.replaceBirthGreetings(pSystem.getPaySystemBirthWord(), st);
        }
    }
    Date billdate = sbr.getBillDate();
    if (billdate==null)
        billdate = br.getBillDate();
    String warning = p.getWarningMsg(sbr.getReceivable(), pSystem, companyName);
    String floatingAccount = pSystem.getPaySystemFirst5().trim() + ticketId;
    StringBuffer atmtitle = new StringBuffer();
    StringBuffer atmcontent = new StringBuffer();
    StringBuffer acceptString = new StringBuffer();
    p.setUpATMMessage(pSystem, atmtitle, atmcontent, 
        acceptString, floatingAccount, sbr.getReceivable(), st, companyName) ;

    StringBuffer leftBlock = new StringBuffer();
    StringBuffer rightBlock = new StringBuffer();
    p.setUpChargeDetail(sbr, leftBlock, rightBlock);

    String remark = "";
    String payReminder = "";
    String bottomLeftBoxTitle = "";
    String barcode1 = null, barcode2 = null, barcode3 = null;
    String[] lines = null;
    String n = pSystem.getPaySystemBankStoreNickName(); // 669
    String nn = pSystem.getPaySystemCompanyStoreNickName(); // PHM00..
    DecimalFormat mnf = new DecimalFormat("###,###,##0");
    DecimalFormat mnf2 = new DecimalFormat("########0");

    if (p.doStorePay(pSystem, sbr.getReceivable()) 
        && n!=null && n.trim().length()>0 && nn!=null && nn.trim().length()>0) 
    {
        payReminder = "       便利商店繳款(7-ELEVEN,全家,萊爾富,OK)                         *便利商店收據請保留六個月";
        bottomLeftBoxTitle = "便利商店/櫃臺繳款收訖戳記";
        SimpleDateFormat df = new SimpleDateFormat("yyMMdd");
        barcode1 = df.format(p.convertToTaiwanDate(billdate)) + pSystem.getPaySystemBankStoreNickName().trim();
        barcode2 = pSystem.getPaySystemCompanyStoreNickName().trim()+"0000"+ticketId;
        df = new SimpleDateFormat("yyMM");
        String mm = df.format(p.convertToTaiwanDate(br.getMonth()));
        String mn = mnf2.format(sbr.getReceivable());
        barcode3 = mm + p.checkCode(mm, mn, barcode1, barcode2) + p.makePrecise(mn, 9, false, '0');
        String[] l = {
            "繳款期限:" + sdf2.format(billdate),
            "\n繳款人:" + studentName,
            "\n繳款金額:" + mnf.format(sbr.getReceivable()),
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
            "\n繳款人:" + studentName,
            "\n繳款金額:" + mnf.format(sbr.getReceivable()),
            "\n繳款期限:" + sdf2.format(billdate) };
        lines = l;
    }

    Document document = null;
    try {
        document = new Document(PageSize.A4,15,15,10,10);
        File testout = new File(request.getRealPath("/") + "/WEB-INF/tmp/test.pdf");
        if (testout.exists())
            testout.delete();
        if (testout.exists()) {
            out.println("File " + testout.getAbsolutePath() + " is being used, cannot overwrite it now");
            return;
        }

        PdfWriter pdfwriter = PdfWriter.getInstance(document, new FileOutputStream(testout));
        document.open();
        p.printPdf(pdfwriter, document,
            "",   // subject
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
            ticketId, //String ticketId, // *must*
            (int)0.0, //double amount1,
            (int)0.0, //double amount2,
            (int)0.0, //double amount3,  
            sbr.getReceivable(),  //double amount4,  // *must*
            p.convertToTaiwanDate(billdate),     //Date   billEndDate, // *must*
            greetings, //String greeting,
            greetingImgPath,       //String greetingImgPath,
            warning,       //String warning,
            "學雜費繳費明細(家長收執聯)", //String contentTableTitle, // *must*
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
            lines); //String[] bottomRightLines);
    } 
    finally {
        if (document!=null)
            document.close();
    }
%>    