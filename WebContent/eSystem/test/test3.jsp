<%@ page language="java" 
    import="jsf.*,phm.ezcounting.*,com.lowagie.text.*,com.lowagie.text.pdf.*,java.io.*,java.util.*"
    contentType="text/html;charset=UTF-8"%>
<%
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
    File toolDir = new File(request.getRealPath("/") + "/eSystem/pdf_example");
    if (!toolDir.exists())
        throw new Exception("pdf tool directory not exists!");

    PdfWriter pdfwriter = PdfWriter.getInstance(document, new FileOutputStream(testout));
    document.open();
    PaymentPrinter p = PaymentPrinter.getPdfPrinter(toolDir);
    String[] lines = {"a","b","c"};
    p.printPdf(pdfwriter, document,
        "subject",
        "title",    
        1,          //int nowPage,
        new File(toolDir, "font/logo.tif").getAbsolutePath(),       //String logoPath, 
        new File(toolDir, "font/bg.tif").getAbsolutePath(),       //String backimgPath, 
        "林公君豪",  //String payeeName1,  // *must*
        "阿豪",       //String payeeName2,  
        "親親愛愛家",       //String payeeName3,  
        "必亨軟體股份有限公司", //String companyName, // *must*
        "231 新店市明德路65巷5號", //String companyAddress, // *must*
        "02-29110833", // String companyPhone, //*must*
        "123456789", //String ticketId, // *must*
        (int)0.0, //int amount1,
        (int)0.0, //int amount2,
        (int)0.0, //int amount3,  
        (int)100.0,  //int amount4,  // *must*
        new Date(),     //Date   billEndDate, // *must*
        "greetings..!", //String greeting,
        new File(toolDir, "font/birth.tif").getAbsolutePath(),       //String greetingImgPath,
        "warnings..!",       //String warning,
        "contentTableTitle", //String contentTableTitle, // *must*
        "hello",    //String blockLeft,  // *must* 
        "helloright", //String blockRight, // *must*
        "this is the remark!", //String remark, // *must*
		"atmTitle",     //String atmTitle, // *must*
		"atmCOntent",   //String atmContent, // *must*
		"acceptString", //String acceptString, // *must*
        "payReminder",  //String payReminder,
        "bottomLeftBoxTitle", //String bottomLeftBoxTitle,  // *must* "櫃臺繳款收訖戳記" or “便利商店櫃臺繳款收訖戳記”
        "bottomMiddleBoxTitle", //String bottomMiddleBoxTitle,
        "9876543321",   //String barcode1,  // *must*
        "9874324234329",   //String barcode2,
        "9843234732",   //String barcode3,
        lines); //String[] bottomRightLines);
} 
finally {
    if (document!=null)
        document.close();
}
%>    