<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,java.io.*" contentType="text/html;charset=UTF-8"%>
<%@ page import="org.apache.poi.hssf.usermodel.*" %>
<%@ page import="org.apache.poi.hssf.util.HSSFColor" %>
<%@ page import="org.apache.poi.hssf.util.Region" %>
<link rel="stylesheet" href="style.css" type="text/css">
<%@ include file="jumpTop.jsp"%>
<%!
    public boolean canWire(MembrInfoBillRecord sinfo, MembrTeacher teachr)
    {
        if (teachr.getTeacherIdNumber()==null || teachr.getTeacherIdNumber().length()!=10)
            return false;
        if (teachr.getTeacherBank1()==null || teachr.getTeacherBank1().length()==0)
            return false;
        if (teachr.getTeacherAccountNumber1()==null || teachr.getTeacherAccountNumber1().length()==0)
            return false;
        if (teachr.getTeacherAccountName1()==null || teachr.getTeacherAccountName1().length()==0)
            return false;
        return true;
    }
%>
<%
    //##v2
    if(!checkAuth(ud2,authHa,302))
    {
        response.sendRedirect("authIndex.jsp?code=302");
    }
%>
<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy/MM");
    SimpleDateFormat sdf3 = new SimpleDateFormat("yy-MM-dd");
    DecimalFormat mnf = new DecimalFormat("###,###,##0");

    int pid = Integer.parseInt(request.getParameter("pid"));
    Date payDate = sdf.parse(request.getParameter("payDate").trim());
    Date twDate = PaymentPrinter.convertToTaiwanDate(payDate);

    BillPayMgr bpmgr = BillPayMgr.getInstance();
    BillPay bpay = bpmgr.find("billpay.id=" + pid);
    bpay.setExportDate(new Date().getTime());
    bpay.setExportUserId(ud2.getId());
    bpmgr.save(bpay);
    PaySystem pZ2 = (PaySystem) ObjectService.find("jsf.PaySystem", "id=1");

    ArrayList<BillPaidInfo> paid_entries = 
        BillPaidInfoMgr.getInstance().retrieveList("billpay.id=" + pid, "");

    String ticketIds = new RangeMaker().makeRange(paid_entries, "getTicketId");

    ArrayList<MembrInfoBillRecord> salaries = 
        MembrInfoBillRecordMgr.getInstance().retrieveList("ticketId in (" + ticketIds + ")", "");

    Map<String, Vector<MembrInfoBillRecord>> salaryMap = 
        new SortingMap(salaries).doSort("getTicketId");

    String membrIds = new RangeMaker().makeRange(salaries, "getMembrId");

    ArrayList<MembrTeacher> teachers = MembrTeacherMgr.getInstance().retrieveList("membr.id in (" + membrIds + ")", "");
    Map<Integer/*membrId*/, Vector<MembrTeacher>> teacherMap = new SortingMap(teachers).doSort("getMembrId");

    Iterator<BillPaidInfo> iter = paid_entries.iterator();

    Costpay2 cp = Costpay2Mgr.getInstance().find("costpayFeePayFeeID=" + Costpay2.COSPAY_TYPE_SALARY + 
        " and costpayStudentAccountId=" + bpay.getId());
    BankAccount ba=null;
    String acctName = "";
    if (bpay.getVia()==BillPay.SALARY_CASH) {
        Tradeaccount ta = (Tradeaccount) ObjectService.find("jsf.Tradeaccount", "id=" + cp.getCostpayAccountId());
        acctName = ta.getTradeaccountName();
    }
    else if (bpay.getVia()==BillPay.SALARY_WIRE) {
        ba= (BankAccount) ObjectService.find("jsf.BankAccount", "id=" + cp.getCostpayAccountId());
        acctName = ba.getBankAccountName();
    }

    int total = (int)0;


    // 建立活頁簿
    HSSFWorkbook wb=new HSSFWorkbook();
    // 建立工作表
    HSSFSheet sheet1=wb.createSheet("sheet1");
    sheet1.setGridsPrinted(true);
    sheet1.setHorizontallyCenter(true);
    sheet1.setVerticallyCenter(true);

    short columnWidthUnit = 256; 
    sheet1.setMargin(sheet1.TopMargin,(double)0.2);
    sheet1.setMargin(sheet1.LeftMargin,(double)0.0);
    sheet1.setMargin(sheet1.RightMargin,(double)0.0);
    sheet1.setMargin(sheet1.BottomMargin,(double)0.1);

    HSSFPrintSetup hps=sheet1.getPrintSetup();
    hps.setLandscape(true);

    HSSFFooter footer = sheet1.getFooter();
    footer.setCenter( "page: " + HSSFFooter.page() + " of " + HSSFFooter.numPages() );
       

    HSSFFont font=wb.createFont();
    font.setFontHeightInPoints((short)10);
    font.setColor(HSSFColor.GREY_80_PERCENT.index);

    HSSFCellStyle style=wb.createCellStyle();
    style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
    style.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
    style.setFont(font);
    style.setWrapText(true);

    //title style
    HSSFFont font2=wb.createFont();
    font2.setFontHeightInPoints((short)10);
    font2.setColor(HSSFColor.GREY_80_PERCENT.index);
    HSSFCellStyle style2=wb.createCellStyle();
    style2.setAlignment(HSSFCellStyle.ALIGN_LEFT);
    style2.setVerticalAlignment(HSSFCellStyle.VERTICAL_TOP);
    style2.setFont(font2); 
    style2.setWrapText(true);


    HSSFFont font3=wb.createFont();
    font3.setFontHeightInPoints((short)12);
    font3.setColor(HSSFColor.GREY_80_PERCENT.index);

    HSSFCellStyle style3=wb.createCellStyle();
    style3.setAlignment(HSSFCellStyle.ALIGN_CENTER);
    style3.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
    style3.setFont(font3);
    style3.setWrapText(false);

    // 製表人:"+ud2.getUserFullname()
    // title
    String exlTitle = new BunitHelper().getCompanyNameTitle(_ws2.getSessionBunitId()) +
        " 薪資轉帳明細    製表日期:"+sdf.format(new Date());;
    
    HSSFRow row0=sheet1.createRow((short)0);
    sheet1.addMergedRegion(new Region(0,(short)0,0,(short)6));
    HSSFCell cell0=row0.createCell((short)0);
    cell0.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell0.setCellValue(exlTitle);
    cell0.setCellStyle(style3);

    // 項目
    HSSFRow row1=sheet1.createRow((short)2);

    HSSFCell cell2=row1.createCell((short)0);
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue("序號");
    cell2.setCellStyle(style);
    sheet1.setColumnWidth((short) 0, (short) (15 * columnWidthUnit)); 
    
    cell2=row1.createCell((short)1);
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue("收款行庫代號");
    cell2.setCellStyle(style);
    sheet1.setColumnWidth((short) 1, (short) (20 * columnWidthUnit)); 

    cell2=row1.createCell((short)2);
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue("收款人帳號");
    cell2.setCellStyle(style);
    sheet1.setColumnWidth((short) 2, (short) (30 * columnWidthUnit)); 

    cell2=row1.createCell((short)3);
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue("收款人名稱");
    cell2.setCellStyle(style);
    sheet1.setColumnWidth((short) 3, (short) (20 * columnWidthUnit)); 


    cell2=row1.createCell((short)4);
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue("身份證字號");
    cell2.setCellStyle(style);
    sheet1.setColumnWidth((short) 4, (short) (20 * columnWidthUnit)); 

    cell2=row1.createCell((short)5);
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue("匯款金額");
    cell2.setCellStyle(style);
    sheet1.setColumnWidth((short) 5, (short) (10 * columnWidthUnit)); 

    cell2=row1.createCell((short)6);
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue("附言");
    cell2.setCellStyle(style);
    sheet1.setColumnWidth((short) 6, (short) (20 * columnWidthUnit)); 

    int sub_total = bpay.getAmount();

    int nowtotal=0;
    int nowRun=0;
    while(iter.hasNext()) {
        BillPaidInfo b = iter.next(); 
        sub_total -= b.getPaidAmount();

        nowtotal+=b.getPaidAmount();

        MembrInfoBillRecord s = salaryMap.get(b.getTicketId()).get(0);
        String ps=sdf2.format(s.getBillMonth()) + "  " + new BunitHelper().getCompanyNameTitle(_ws2.getSessionBunitId());
        
        Vector<MembrTeacher> vt = teacherMap.get(new Integer(s.getMembrId()));
        if (vt==null) {
            out.println("<div class=es02><font color=red>Error:</font>系統發生錯誤!</div>");
            return;
        }
        MembrTeacher t = vt.get(0);
        //out.println("<br>" + t.getTeacherIdNumber() + " " + t.getTeacherBank1());
        
        row0=sheet1.createRow((short)(nowRun+3));
        cell2=row0.createCell((short)0);
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        cell2.setCellValue(String.valueOf(nowRun+1));
        cell2.setCellStyle(style2);

        cell2=row0.createCell((short)1);
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        if(t.getTeacherAccountDefaut()==1)
            cell2.setCellValue(t.getTeacherBank1());
        else
            cell2.setCellValue(t.getTeacherBank2());
        cell2.setCellStyle(style2);
        
        cell2=row0.createCell((short)2);
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        if(t.getTeacherAccountDefaut()==1)
            cell2.setCellValue(t.getTeacherAccountNumber1());
        else
            cell2.setCellValue(t.getTeacherAccountNumber2());
        cell2.setCellStyle(style2);

        cell2=row0.createCell((short)3);
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        cell2.setCellValue(t.getName());
        cell2.setCellStyle(style);

        cell2=row0.createCell((short)4);
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        cell2.setCellValue(t.getTeacherIdNumber());
        cell2.setCellStyle(style2);

        cell2=row0.createCell((short)5);
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        cell2.setCellValue(b.getPaidAmount());
        cell2.setCellStyle(style);

        cell2=row0.createCell((short)6);
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        cell2.setCellValue(ps);
        cell2.setCellStyle(style2);

        nowRun++;
    }


    int nowRow=nowRun+3;
             
    // 項目
    String dateString=ba.getBankAccountPayDate();
    if(dateString.length()==1)
          dateString="0"+dateString ;


    HSSFRow rowF=sheet1.createRow((short)(nowRow+1));
    HSSFCell cell=rowF.createCell((short)0);
    cell.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell.setCellValue("企業編號:");
    cell.setCellStyle(style2);
      

    cell=rowF.createCell((short)1);
    cell.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell.setCellValue(ba.getBankAccount2client());
    cell.setCellStyle(style2);   


    rowF=sheet1.createRow((short)(nowRow+2));
    cell=rowF.createCell((short)0);
    cell.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell.setCellValue("委辦帳號:");
    cell.setCellStyle(style2);
      
    cell=rowF.createCell((short)1);
    cell.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell.setCellValue(ba.getBankAccountAccount());
    cell.setCellStyle(style2);      

    rowF=sheet1.createRow((short)(nowRow+3));

    cell=rowF.createCell((short)0);
    cell.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell.setCellValue("匯款總筆數");
    cell.setCellStyle(style2);
      

    cell=rowF.createCell((short)1);
    cell.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell.setCellValue(String.valueOf(nowRun));
    cell.setCellStyle(style2);   

    rowF=sheet1.createRow((short)(nowRow+4));

    cell=rowF.createCell((short)0);
    cell.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell.setCellValue("匯款總金額");
    cell.setCellStyle(style2);
      

    cell=rowF.createCell((short)1);
    cell.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell.setCellValue(mnf.format(nowtotal));
    cell.setCellStyle(style2);   

    rowF=sheet1.createRow((short)(nowRow+5));
    cell=rowF.createCell((short)0);
    cell.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell.setCellValue("匯款日期");
    cell.setCellStyle(style2);


    cell=rowF.createCell((short)1);
    cell.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell.setCellValue(sdf3.format(twDate));
    cell.setCellStyle(style2);

    String path=application.getRealPath("/");
    Date nowX=new Date();
    long nowLong=nowX.getTime();
    String creatFile=String.valueOf(nowLong);
    // 儲存
    FileOutputStream fso=new FileOutputStream(path+"eSystem/exlfile/"+creatFile+".xls");
    wb.write(fso);
    fso.close();
%>

<br>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/excel2.gif" border=0>&nbsp薪資匯款檔案</b> 
&nbsp;&nbsp;
</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>


<blockquote>
<div class=es02>
<font size=2 color=red>注意:</font>此為機密資訊,下載後請妥善保存.<br><br>
</div>
	<table width="58%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>

	<tr bgcolor=ffffff class=es02>
		<td colspan=2>
            <font size=2 color=blue>檔案已產生!</font>
        </td>
	</tr>
	<tr bgcolor=#f0f0f0 class=es02>
		<td>檔名</td>
		<td  bgcolor=ffffff><%=creatFile%>.xls</td>
	</tr>
	<tr bgcolor=#f0f0f0 class=es02>
	<td>標題</td>
	<td bgcolor=ffffff><%=exlTitle%></td>
	</tr>
	<tr bgcolor=#ffffff class=es02>
	<td colspan=2>
	    <center>
            <a target=_blank href="exlfile/<%=creatFile%>.xls"><img src="images/excel2.gif" border=0>下載Excel匯款明細</a>
           
        </center>
	</td>
	</td>
	</tr>
	</table>
	</td>
	</tr>
	</table>
<br>
<br>
<div class=es02>
說明: 如需使用台新銀行匯款電子檔,請按此處<a href="addBankWireTxt.jsp?pid=<%=pid%>&payDate=<%=sdf3.format(twDate)%>&nowTotal=<%=nowtotal%>&nowRun=<%=nowRun%>">下載</a>台新銀行
 <a href="addBankWireTxt.jsp?pid=<%=pid%>&payDate=<%=sdf3.format(twDate)%>&nowTotal=<%=nowtotal%>&nowRun=<%=nowRun%>">匯款批次檔</a>
</div>
    </blockquote>
<br><br><br><br>

