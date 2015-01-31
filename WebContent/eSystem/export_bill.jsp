<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,java.io.*,phm.accounting.*,mca.*" 
    contentType="text/html;charset=UTF-8"%>
<%@ page import="org.apache.poi.hssf.usermodel.*" %>
<%@ page import="org.apache.poi.hssf.util.HSSFColor" %>
<%@ page import="org.apache.poi.hssf.util.Region" %>
<%@ include file="jumpTop.jsp"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%!
    Map<String, BillComment> getComments(ArrayList<MembrInfoBillRecord> all_bills)
        throws Exception
    {
        String membrIds = new RangeMaker().makeRange(all_bills, "getMembrId");
        String billRecordIds = new RangeMaker().makeRange(all_bills, "getBillRecordId");
        ArrayList<BillComment> comments = BillCommentMgr.getInstance().retrieveList("membrId in (" + membrIds + ")"
            + " and billRecordId in (" + billRecordIds + ")", "");
        return new SortingMap(comments).doSortSingleton("getBillKey");
    }

    String getFullName(Membr mts, Vector<MembrInfoBillRecord> bills, MainTagHelper mh)
        throws Exception
    {
        String name = mh.getMainTagName(mts.getId()) + "-" + mts.getName();

        if (bills.size()>1)
            name += "("+bills.size()+"張)";
        return name;
    }

    int getChargeAmountTotal(Vector<MembrInfoBillRecord> bills, 
        Map<String, Integer> chargeAmountMap, ChargeItem ci) 
    {
        int ret = 0;
        for (int i=0; i<bills.size(); i++) {
            MembrInfoBillRecord bill = bills.get(i);
            Integer amt = chargeAmountMap.get(bill.getTicketId() + "#" + ci.getId());
            if (amt!=null)
                ret += amt.intValue();
        }
        return ret;
    }

    private static SimpleDateFormat sdf_ = new SimpleDateFormat("yyyy-MM-dd");
    String getMonthQueryStr(Date nowMonth)
    {
        // "recordTime<'2009-04-01' and recordTime>='2009-03-01'"
        Calendar c = Calendar.getInstance();
        c.setTime(nowMonth);
        c.add(Calendar.MONTH, 1);
        return "recordTime>='" + sdf_.format(nowMonth) + "' and recordTime<'" + sdf_.format(c.getTime()) + "'";
    }
%>
<%
    JsfAdmin ja=JsfAdmin.getInstance();
    BillRecordInfoMgr bmgr = BillRecordInfoMgr.getInstance();
    DecimalFormat nf = new DecimalFormat("###,##0.00");
    DecimalFormat mnf = new DecimalFormat("###,###,##0");
    DecimalFormat mnf2 = new DecimalFormat("########0");            

    SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM");
    SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd");
    String monstr = request.getParameter("month");

    String o = request.getParameter("o");
    String t = request.getParameter("t");
    MembrInfoBillRecordMgr snbrmgr = MembrInfoBillRecordMgr.getInstance();
    if (o.trim().length()==0) {
       %><script>alert("沒有任何帳單輸出");history.go(-1);</script><%
       return;
    }
    ArrayList<MembrInfoBillRecord> all_bills = snbrmgr.retrieveList("ticketId in (" + o + ")", "order by ticketId asc");
    EzCountingService ezsvc = EzCountingService.getInstance();

    // all members that has 帳單 in this records
    ArrayList<Membr> membrs = new ArrayList<Membr>();

    // membrId
    Map<Integer, Vector<MembrInfoBillRecord>> billMap = 
            new LinkedHashMap<Integer, Vector<MembrInfoBillRecord>>();
    // ticketId
    Map<String, Vector<ChargeItemMembr>> feeMap =
            new LinkedHashMap<String, Vector<ChargeItemMembr>>();
    // chargeKey
    Map<String, Vector<DiscountInfo>> discountMap = 
            new LinkedHashMap<String, Vector<DiscountInfo>>();

    Map<String, Vector<ChargeItemMembr>> feeMap2 =
            new LinkedHashMap<String, Vector<ChargeItemMembr>>();

    ezsvc.getBillNumbers(all_bills, membrs, billMap, feeMap, discountMap, feeMap2);
    Map<String, BillComment> commentMap = getComments(all_bills);

    int type=-1;
    String typeS=request.getParameter("type");
    if(typeS != null) 
        type=Integer.parseInt(typeS);

    Date nowDate = null;
    try { nowDate = sdf1.parse(monstr); } catch (Exception e) {}

    Map<Integer/*membrId*/, Vector<Membr>> membrMap = new SortingMap(membrs).doSort("getId");

    //####### 2009/1/21 by peter, 學生名加主要 tag 名，并且按主要標籤排序 
    String membrIds = new RangeMaker().makeRange(membrs, "getId");
    membrs = MembrMgr.getInstance().retrieveList("id in (" + membrIds + ")", "order by membr.name asc");
    MainTagHelper mh = new MainTagHelper(membrIds, _ws2.getSessionBunitId());

    /*
    ArrayList<MainTagStudent> students = null;
    if (pd2.getPagetype()!=7) {
        students = MainTagStudentMgr.getInstance().retrieveList("membr.id in (" + membrIds + 
            ") and tag.status=" + Tag.STATUS_CURRENT,"group by membr.id");
    }
    else {
        McaFee fee = McaFeeMgr.getInstance().find("id=" + request.getParameter("feeId"));
        ArrayList<Tag> feetags = new McaTagHelper().getFeeTags(fee);
        String tagIds = new RangeMaker().makeRange(feetags, "getId");
        students = MainTagStudentMgr.getInstance().retrieveList("membr.id in (" + membrIds + 
            ") and tag.id in (" + tagIds + ")","group by membr.id");
    }
    */
    // ########################################################

    String exlTitle=t +"  製表人:"+ud2.getUserFullname()+" 製表日期:"+sdf2.format(new Date());

// 建立活頁簿
HSSFWorkbook wb=new HSSFWorkbook();
// 建立工作表
HSSFSheet sheet1=wb.createSheet("sheet1");
sheet1.setGridsPrinted(true);
sheet1.setHorizontallyCenter(false);
sheet1.setVerticallyCenter(false);

short columnWidthUnit = 256; 
sheet1.setMargin(sheet1.TopMargin,(double)0.05);
sheet1.setMargin(sheet1.LeftMargin,(double)0.0);
sheet1.setMargin(sheet1.RightMargin,(double)0.0);
sheet1.setMargin(sheet1.BottomMargin,(double)0.05);

HSSFPrintSetup hps=sheet1.getPrintSetup();
if(type==0)
    hps.setLandscape(false);
else
    hps.setLandscape(true);

hps.setVResolution((short)600);
hps.setHResolution((short)600);
    
HSSFFooter footer = sheet1.getFooter();
footer.setCenter( "頁碼: " + HSSFFooter.page() + " / " + HSSFFooter.numPages() );
   

HSSFFont font=wb.createFont();
font.setFontHeightInPoints((short)10);
font.setColor(HSSFColor.GREY_80_PERCENT.index);

HSSFCellStyle style=wb.createCellStyle();
style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
style.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
style.setFont(font);
style.setWrapText(true);

HSSFCellStyle styleX=wb.createCellStyle();
styleX.setAlignment(HSSFCellStyle.ALIGN_RIGHT);
styleX.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
styleX.setFont(font);
styleX.setWrapText(true);

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

HSSFFont fontPay=wb.createFont();
fontPay.setFontHeightInPoints((short)10);
fontPay.setColor(HSSFColor.WHITE.index);

HSSFCellStyle sPay=wb.createCellStyle();
sPay.setAlignment(HSSFCellStyle.ALIGN_RIGHT);
sPay.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
sPay.setFillForegroundColor(new HSSFColor.ORANGE().getIndex());
sPay.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
sPay.setFont(fontPay); 
sPay.setWrapText(false);

HSSFCellStyle sNotPay=wb.createCellStyle();
sNotPay.setAlignment(HSSFCellStyle.ALIGN_RIGHT);
sNotPay.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
sNotPay.setFillForegroundColor(new HSSFColor.BLUE().getIndex());
sNotPay.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
sNotPay.setFont(fontPay); 
sNotPay.setWrapText(false);


HSSFCellStyle sTitle=wb.createCellStyle();
sTitle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
sTitle.setVerticalAlignment(HSSFCellStyle.VERTICAL_TOP);
sTitle.setFillForegroundColor(new HSSFColor.GREY_25_PERCENT().getIndex());
sTitle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
sTitle.setFont(font2); 
sTitle.setWrapText(false);


// title
HSSFRow row0=sheet1.createRow((short)0);
HSSFCell cell0=null;
HSSFRow row1=null;
HSSFCell cell10=null;        
HSSFCell cell2=null;
HSSFCell cell=null;


if(type==2){
    ArrayList<BillItemInfo> bitems = BillItemInfoMgr.getInstance().retrieveListX("","",_ws2.getBunitSpace("bill.bunitId"));
    Map<Integer, Vector<BillItemInfo>> billitemMap = new SortingMap(bitems).doSort("getId");
    // ticketId#chargeItemId, amount
    Map<String, Integer> chargeAmountMap = new HashMap<String, Integer>();
    ArrayList<ChargeItem> activeCharges = makeChargeReport(feeMap, discountMap, chargeAmountMap);
    // ticketId
    String ticketIds = new RangeMaker().makeRange(all_bills, "getTicketId");
    Map<String, Vector<BillPaidInfo>> paidMap = new SortingMap(BillPaidInfoMgr.getInstance().
        retrieveList("billpaid.ticketId in (" + ticketIds + ")", "")).doSort("getTicketId");

    sheet1.addMergedRegion(new Region(0,(short)0,0,(short)(activeCharges.size()+11)));
    cell0=row0.createCell((short)0);
    cell0.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell0.setCellValue(new BunitHelper().getCompanyNameTitle(_ws2.getSessionBunitId()));
    cell0.setCellStyle(style3);

    sheet1.addMergedRegion(new Region(1,(short)0,1,(short)(activeCharges.size()+11)));
    row1=sheet1.createRow((short)1);
    cell0=row1.createCell((short)0);
    cell0.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell0.setCellValue(exlTitle);
    cell0.setCellStyle(style);


    sheet1.addMergedRegion(new Region(2,(short)2,2,(short)(activeCharges.size()+4)));
    row1=sheet1.createRow((short)2);
    cell0=row1.createCell((short)2);
    cell0.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell0.setCellValue("收 費 項 目");
    cell0.setCellStyle(style);

    sheet1.addMergedRegion(new Region(2,(short)(activeCharges.size()+5),2,(short)(activeCharges.size()+9)));
    cell0=row1.createCell((short)(activeCharges.size()+3));
    cell0.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell0.setCellValue("繳 費 方 式");
    cell0.setCellStyle(style);

    row1=sheet1.createRow((short)3);
    cell2=row1.createCell((short)0);
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue("編號");
    cell2.setCellStyle(sTitle);
    sheet1.setColumnWidth((short) 0, (short) (5 * columnWidthUnit)); 

    cell2=row1.createCell((short)1);
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue("Grade");
    cell2.setCellStyle(sTitle);
    sheet1.setColumnWidth((short) 1, (short) (3 * columnWidthUnit)); 

    cell2=row1.createCell((short)2);
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue("姓名");
    cell2.setCellStyle(sTitle);
    sheet1.setColumnWidth((short) 1, (short) (12 * columnWidthUnit)); 

    Iterator<ChargeItem> iter = activeCharges.iterator();

    int xcol=2;
    while (iter.hasNext()) {
    
        xcol++;

        ChargeItem ci = iter.next();
        Vector<BillItemInfo> vb = billitemMap.get(new Integer(ci.getBillItemId()));
        String name = vb.get(0).getName();

        cell2=row1.createCell((short)xcol);
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        cell2.setCellValue(name);
        cell2.setCellStyle(sTitle);
        sheet1.setColumnWidth((short) xcol, (short) (8* columnWidthUnit)); 
    } 

    xcol++;
    cell2=row1.createCell((short)xcol);
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue("本期小計");
    cell2.setCellStyle(sTitle);
    sheet1.setColumnWidth((short) xcol, (short) (10 * columnWidthUnit)); 

    xcol++;
    cell2=row1.createCell((short)xcol);
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue("前期未繳");
    cell2.setCellStyle(sTitle);
    sheet1.setColumnWidth((short) xcol, (short) (10 * columnWidthUnit)); 

    xcol++;
    cell2=row1.createCell((short)xcol);
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue("應收合計");
    cell2.setCellStyle(sTitle);
    sheet1.setColumnWidth((short) xcol, (short) (10 * columnWidthUnit)); 


    xcol++;
    cell2=row1.createCell((short)xcol);
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue("便利商店");
    cell2.setCellStyle(sTitle);
    sheet1.setColumnWidth((short) xcol, (short) (10 * columnWidthUnit)); 

    xcol++;
    cell2=row1.createCell((short)xcol);
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue("虛擬帳號");
    cell2.setCellStyle(sTitle);
    sheet1.setColumnWidth((short) xcol, (short) (10 * columnWidthUnit)); 

    xcol++;
    cell2=row1.createCell((short)xcol);
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue("現金");
    cell2.setCellStyle(sTitle);
    sheet1.setColumnWidth((short) xcol, (short) (10 * columnWidthUnit)); 

    xcol++;
    cell2=row1.createCell((short)xcol);
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue("支票");
    cell2.setCellStyle(sTitle);
    sheet1.setColumnWidth((short) xcol, (short) (10 * columnWidthUnit)); 

    xcol++;
    cell2=row1.createCell((short)xcol);
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue("信用卡");
    cell2.setCellStyle(sTitle);
    sheet1.setColumnWidth((short) xcol, (short) (10 * columnWidthUnit)); 

    xcol++;
    cell2=row1.createCell((short)xcol);
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue("繳費合計");
    cell2.setCellStyle(sTitle);
    sheet1.setColumnWidth((short) xcol, (short) (10 * columnWidthUnit)); 

    xcol++;
    cell2=row1.createCell((short)xcol);
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue("未繳合計");
    cell2.setCellStyle(sTitle);
    sheet1.setColumnWidth((short) xcol, (short) (10 * columnWidthUnit)); 


    xcol++;
    cell2=row1.createCell((short)xcol);
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue("折扣原因");
    cell2.setCellStyle(sTitle);
    sheet1.setColumnWidth((short) xcol, (short) (25 * columnWidthUnit)); 

    xcol++;
    cell2=row1.createCell((short)xcol);
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue("帳單備註");
    cell2.setCellStyle(sTitle);
    sheet1.setColumnWidth((short) xcol, (short) (25 * columnWidthUnit)); 

    int startrow=4;
    // Iterator<MembrInfoBillRecord> iter2 = all_bills.iterator();
    Iterator<Membr> membr_iterator = membrs.iterator();

    int[] totalNumX=new int[activeCharges.size()];
    int[] totalPayX=new int[5];

    int totalUnpaid=0;
    int startStu=0;

    
    int notpaiedTotal=0;
    while (membr_iterator.hasNext()) {
        Membr mts = membr_iterator.next();        
        Vector<MembrInfoBillRecord> bills = billMap.get(mts.getId());

        row1=sheet1.createRow((short)startrow);
        startrow++;

        startStu++;
        cell2=row1.createCell((short)0);
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        cell2.setCellValue(startStu);
        cell2.setCellStyle(style);

        String tmp = getFullName(mts, bills, mh);
        int cc = tmp.indexOf("-");
        String grade = tmp.substring(0, cc);
        String name = tmp.substring(cc+1);

        cell2=row1.createCell((short)1);
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        cell2.setCellValue(grade);
        cell2.setCellStyle(style);

        cell2=row1.createCell((short)2);
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        cell2.setCellValue(name);
        cell2.setCellStyle(style);

        Iterator<ChargeItem> iter3 = activeCharges.iterator();
        int startcols=3;
        int totalNow=0;
        int nowRunxx=0;
        while (iter3.hasNext()) {
            ChargeItem ci = iter3.next();
            int money = getChargeAmountTotal(bills, chargeAmountMap, ci);
            cell2=row1.createCell((short)startcols);
            cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
            cell2.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
            if(money!=0){
                cell2.setCellValue(money);
                totalNow+=(int)money;
                totalNumX[nowRunxx]+=(int)money;
            }else{
                cell2.setCellValue("");        
            }
            cell2.setCellStyle(styleX);
            startcols++;
            nowRunxx++;
        } 
// ##
        cell2=row1.createCell((short)startcols);
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        cell2.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
        cell2.setCellValue(totalNow);
        cell2.setCellStyle(styleX);

        int unpaidMoney = 0;
        for (int i=0; i<bills.size(); i++)
            unpaidMoney += bills.get(i).getInheritUnpaid();

        startcols++;
        cell2=row1.createCell((short)startcols);
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        cell2.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
        if(unpaidMoney !=0){       
            cell2.setCellValue(unpaidMoney);
            totalUnpaid+=unpaidMoney;
        }else{
            cell2.setCellValue("");            
        }
        cell2.setCellStyle(styleX);


        startcols++;
        cell2=row1.createCell((short)startcols);
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        cell2.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
        cell2.setCellValue(unpaidMoney+totalNow);  
        cell2.setCellStyle(styleX);


        int[] totalX = new int[7]; // pay amount
        int[] totalY = new int[7]; // paid amount
        if (pd2.getPagetype()!=1 || nowDate==null) {
            getPaidInfoForAll(bills, paidMap, totalX, totalY);
        }
        else {
            // 光仁的用現金帳
            Map<String, ArrayList<BillPay>> payMap = new SortingMap(BillPayMgr.getInstance().
                retrieveList(getMonthQueryStr(nowDate), "")).doSortA("getMembrId");
            getPayForAll(mts.getId(), payMap, totalX, totalY);
        }

        startcols++;
        cell2=row1.createCell((short)startcols);
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        cell2.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
        if(totalX[0] !=0){
            cell2.setCellValue(totalX[0]);
            totalPayX[0]+=totalX[0];
        }else{
            cell2.setCellValue("");
        }
        cell2.setCellStyle(style);

        startcols++;
        cell2=row1.createCell((short)startcols);
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        cell2.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
        if(totalX[1] !=0){
            cell2.setCellValue(totalX[1]); 
            totalPayX[1]+=totalX[1];
        }else{
            cell2.setCellValue("");       
        }
        cell2.setCellStyle(styleX);

        startcols++;
        cell2=row1.createCell((short)startcols);
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        cell2.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
        if(totalX[2] !=0){
            cell2.setCellValue(totalX[2]);
            totalPayX[2]+=totalX[2];  
        }else{
            cell2.setCellValue("");      
        }
        cell2.setCellStyle(styleX);

        startcols++;
        cell2=row1.createCell((short)startcols);
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        cell2.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
        if(totalX[3] !=0)
        {
            cell2.setCellValue(totalX[3]); 
            totalPayX[3]+=totalX[3];
        }else{
            cell2.setCellValue("");       
        }
        cell2.setCellStyle(styleX);            

        startcols++;

        cell2=row1.createCell((short)startcols);
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        cell2.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
        if(totalX[4] !=0){
            cell2.setCellValue(totalX[4]); 
            totalPayX[4]+=totalX[4];   
        }else{
            cell2.setCellValue("");    
        }
        cell2.setCellStyle(styleX); 

        startcols++;
        cell2=row1.createCell((short)startcols);
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        cell2.setCellType(HSSFCell.CELL_TYPE_NUMERIC);

        if(totalX[6]==totalNow)
        {
            cell2.setCellValue(totalX[6]);        
            cell2.setCellStyle(sPay);    
        }else if(totalX[6]==0){
            cell2.setCellValue("");        
            cell2.setCellStyle(styleX);
        }else{
            cell2.setCellValue(totalX[6]);        
            cell2.setCellStyle(styleX);
        }

        int notPaied=unpaidMoney+totalNow-totalX[6];
        notpaiedTotal+=notPaied;

        startcols++;
        cell2=row1.createCell((short)startcols);
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        cell2.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
        if (notPaied>0)
            cell2.setCellValue(notPaied);        
        else
            cell2.setCellValue(""); 
        cell2.setCellStyle(styleX);

        startcols++;
        cell2=row1.createCell((short)startcols);
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        cell2.setCellValue(getDiscountInfo(bills, feeMap, discountMap));        
        cell2.setCellStyle(style2);

        startcols++;
        cell2=row1.createCell((short)startcols);
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        cell2.setCellValue(getCommentsForBills(bills, commentMap));        
        cell2.setCellStyle(style2);
    } 

    row1=sheet1.createRow((short)(startrow+1));

    startStu++;
    cell2=row1.createCell((short)2);
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue("合 計");
    cell2.setCellStyle(style);


    Iterator<ChargeItem> iter3 = activeCharges.iterator();
    int totalAll=0;
    int xNow=0;
    while (iter3.hasNext()) {
        ChargeItem ci = iter3.next();
        cell2=row1.createCell((short)(xNow+3));
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        cell2.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
        cell2.setCellValue(totalNumX[xNow]);
        cell2.setCellStyle(styleX);
        //type
        //cell2.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
        totalAll+=totalNumX[xNow];
        xNow++;
    }
    
    xNow ++; 
    cell2=row1.createCell((short)(xNow+2));
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
    cell2.setCellValue(totalAll);
    cell2.setCellStyle(styleX);

    cell2=row1.createCell((short)(xNow+3));
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
    cell2.setCellValue(totalUnpaid);
    cell2.setCellStyle(styleX);

    cell2=row1.createCell((short)(xNow+4));
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
    cell2.setCellValue(totalAll+totalUnpaid);
    cell2.setCellStyle(styleX);

    int totalPayNow=0;
    for(int xx=0;xx<5;xx++)
    {
        cell2=row1.createCell((short)(xNow+5+xx));
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        cell2.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
        cell2.setCellValue(totalPayX[xx]);
        cell2.setCellStyle(styleX);            
        totalPayNow+=totalPayX[xx];
    }


    cell2=row1.createCell((short)(xNow+10));
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
    cell2.setCellValue(totalPayNow);
    cell2.setCellStyle(sPay);

    cell2=row1.createCell((short)(xNow+11));
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
    cell2.setCellValue(notpaiedTotal);
    cell2.setCellStyle(styleX);
}
else if (type==3) {

    ArrayList<BillItemInfo> bitems = BillItemInfoMgr.getInstance().retrieveListX("","",_ws2.getBunitSpace("bill.bunitId"));
    Map<Integer, Vector<BillItemInfo>> billitemMap = new SortingMap(bitems).doSort("getId");
    // ticketId#chargeItemId, amount
    Map<String, Integer> chargeAmountMap = new HashMap<String, Integer>();
    ArrayList<ChargeItem> activeCharges = makeChargeReport(feeMap, discountMap, chargeAmountMap);
    // ticketId
    String ticketIds = new RangeMaker().makeRange(all_bills, "getTicketId");
    Map<String, Vector<BillPaidInfo>> paidMap = new SortingMap(BillPaidInfoMgr.getInstance().
        retrieveList("billpaid.ticketId in (" + ticketIds + ")", "")).doSort("getTicketId");

    sheet1.addMergedRegion(new Region(0,(short)0,0,(short)(activeCharges.size()+11)));
    cell0=row0.createCell((short)0);
    cell0.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell0.setCellValue(new BunitHelper().getCompanyNameTitle(_ws2.getSessionBunitId()));
    cell0.setCellStyle(style3);

    sheet1.addMergedRegion(new Region(1,(short)0,1,(short)(activeCharges.size()+11)));
    row1=sheet1.createRow((short)1);
    cell0=row1.createCell((short)0);
    cell0.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell0.setCellValue(exlTitle);
    cell0.setCellStyle(style);


    sheet1.addMergedRegion(new Region(2,(short)2,2,(short)(activeCharges.size()+4)));
    row1=sheet1.createRow((short)2);
    cell0=row1.createCell((short)2);
    cell0.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell0.setCellValue("收 費 項 目");
    cell0.setCellStyle(style);

    sheet1.addMergedRegion(new Region(2,(short)(activeCharges.size()+5),2,(short)(activeCharges.size()+9)));
    cell0=row1.createCell((short)(activeCharges.size()+3));
    cell0.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell0.setCellValue("繳 費 方 式");
    cell0.setCellStyle(style);

    row1=sheet1.createRow((short)3);
    cell2=row1.createCell((short)0);
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue("編號");
    cell2.setCellStyle(sTitle);
    sheet1.setColumnWidth((short) 0, (short) (5 * columnWidthUnit)); 


    cell2=row1.createCell((short)1);
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue("姓名");
    cell2.setCellStyle(sTitle);
    sheet1.setColumnWidth((short) 1, (short) (12 * columnWidthUnit)); 

    Map<Integer, ArrayList<ChargeItem>> acodecitemMap = new HashMap<Integer, ArrayList<ChargeItem>>();
    ArrayList<Acode> acodes = convertAcodes(activeCharges, _ws2.getSessionBunitId(), acodecitemMap);
    AcodeInfo ainfo = new AcodeInfo(acodes);

    int xcol=1;
    for (int i=0; i<acodes.size(); i++) {
    
        xcol++;

        cell2=row1.createCell((short)xcol);
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        Acode a = acodes.get(i);
        cell2.setCellValue(ainfo.getName(a));
        cell2.setCellStyle(sTitle);
        sheet1.setColumnWidth((short) xcol, (short) (8* columnWidthUnit)); 
    } 

    xcol++;
    cell2=row1.createCell((short)xcol);
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue("本期小計");
    cell2.setCellStyle(sTitle);
    sheet1.setColumnWidth((short) xcol, (short) (10 * columnWidthUnit)); 

    xcol++;
    cell2=row1.createCell((short)xcol);
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue("前期未繳");
    cell2.setCellStyle(sTitle);
    sheet1.setColumnWidth((short) xcol, (short) (10 * columnWidthUnit)); 

    xcol++;
    cell2=row1.createCell((short)xcol);
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue("應收合計");
    cell2.setCellStyle(sTitle);
    sheet1.setColumnWidth((short) xcol, (short) (10 * columnWidthUnit)); 


    xcol++;
    cell2=row1.createCell((short)xcol);
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue("便利商店");
    cell2.setCellStyle(sTitle);
    sheet1.setColumnWidth((short) xcol, (short) (10 * columnWidthUnit)); 

    xcol++;
    cell2=row1.createCell((short)xcol);
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue("虛擬帳號");
    cell2.setCellStyle(sTitle);
    sheet1.setColumnWidth((short) xcol, (short) (10 * columnWidthUnit)); 

    xcol++;
    cell2=row1.createCell((short)xcol);
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue("現金");
    cell2.setCellStyle(sTitle);
    sheet1.setColumnWidth((short) xcol, (short) (10 * columnWidthUnit)); 

    xcol++;
    cell2=row1.createCell((short)xcol);
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue("支票");
    cell2.setCellStyle(sTitle);
    sheet1.setColumnWidth((short) xcol, (short) (10 * columnWidthUnit)); 

    xcol++;
    cell2=row1.createCell((short)xcol);
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue("信用卡");
    cell2.setCellStyle(sTitle);
    sheet1.setColumnWidth((short) xcol, (short) (10 * columnWidthUnit)); 

    xcol++;
    cell2=row1.createCell((short)xcol);
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue("繳費合計");
    cell2.setCellStyle(sTitle);
    sheet1.setColumnWidth((short) xcol, (short) (10 * columnWidthUnit)); 

    xcol++;
    cell2=row1.createCell((short)xcol);
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue("未繳合計");
    cell2.setCellStyle(sTitle);
    sheet1.setColumnWidth((short) xcol, (short) (10 * columnWidthUnit)); 


    xcol++;
    cell2=row1.createCell((short)xcol);
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue("折扣原因");
    cell2.setCellStyle(sTitle);
    sheet1.setColumnWidth((short) xcol, (short) (25 * columnWidthUnit)); 

    xcol++;
    cell2=row1.createCell((short)xcol);
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue("帳單備註");
    cell2.setCellStyle(sTitle);
    sheet1.setColumnWidth((short) xcol, (short) (25 * columnWidthUnit)); 

    int startrow=4;
    // Iterator<MembrInfoBillRecord> iter2 = all_bills.iterator();
    Iterator<Membr> membr_iterator = membrs.iterator();

    int[] totalNumX=new int[activeCharges.size()];
    int[] totalPayX=new int[5];

    int totalUnpaid=0;
    int startStu=0;

    
    int notpaiedTotal=0;
    while (membr_iterator.hasNext()) {
        Membr mts = membr_iterator.next();        
        Vector<MembrInfoBillRecord> bills = billMap.get(mts.getId());

        row1=sheet1.createRow((short)startrow);
        startrow++;

        startStu++;
        cell2=row1.createCell((short)0);
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        cell2.setCellValue(startStu);
        cell2.setCellStyle(style);

        cell2=row1.createCell((short)1);
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        cell2.setCellValue(getFullName(mts, bills, mh));
        cell2.setCellStyle(style);

        int startcols=2;
        int totalNow=0;
        int nowRunxx=0;
        for (int i=0; i<acodes.size(); i++) {
            ArrayList<ChargeItem> citems = acodecitemMap.get(acodes.get(i).getId());
            int money = 0;
            for (int j=0; j<citems.size(); j++) {
                ChargeItem ci = citems.get(j);
                money += getChargeAmountTotal(bills, chargeAmountMap, ci);
            }
            cell2=row1.createCell((short)startcols);
            cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
            if(money!=0){
                cell2.setCellValue(mnf.format(money));
                totalNow+=(int)money;
                totalNumX[nowRunxx]+=(int)money;
            }else{
                cell2.setCellValue("");        
            }
            cell2.setCellStyle(styleX);
            startcols++;
            nowRunxx++;
        } 
// ##
        cell2=row1.createCell((short)startcols);
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        cell2.setCellValue(mnf.format(totalNow));
        cell2.setCellStyle(styleX);

        int unpaidMoney = 0;
        for (int i=0; i<bills.size(); i++)
            unpaidMoney += bills.get(i).getInheritUnpaid();

        startcols++;
        cell2=row1.createCell((short)startcols);
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        if(unpaidMoney !=0){       
            cell2.setCellValue(mnf.format(unpaidMoney));
            totalUnpaid+=unpaidMoney;
        }else{
            cell2.setCellValue("");            
        }
        cell2.setCellStyle(styleX);


        startcols++;
        cell2=row1.createCell((short)startcols);
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        cell2.setCellValue(mnf.format(unpaidMoney+totalNow));  
        cell2.setCellStyle(styleX);


        int[] totalX = new int[7]; // pay amount
        int[] totalY = new int[7]; // paid amount
        if (pd2.getPagetype()!=1 || nowDate==null) {
            getPaidInfoForAll(bills, paidMap, totalX, totalY);
        }
        else {
            // 光仁的用現金帳
            Map<String, ArrayList<BillPay>> payMap = new SortingMap(BillPayMgr.getInstance().
                retrieveList(getMonthQueryStr(nowDate), "")).doSortA("getMembrId");
            getPayForAll(mts.getId(), payMap, totalX, totalY);
        }

        startcols++;
        cell2=row1.createCell((short)startcols);
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        if(totalX[0] !=0){
            cell2.setCellValue(mnf.format(totalX[0]));
            totalPayX[0]+=totalX[0];
        }else{
            cell2.setCellValue("");
        }
        cell2.setCellStyle(style);

        startcols++;
        cell2=row1.createCell((short)startcols);
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        if(totalX[1] !=0){
            cell2.setCellValue(mnf.format(totalX[1])); 
            totalPayX[1]+=totalX[1];
        }else{
            cell2.setCellValue("");       
        }
        cell2.setCellStyle(styleX);

        startcols++;
        cell2=row1.createCell((short)startcols);
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        if(totalX[2] !=0){
            cell2.setCellValue(mnf.format(totalX[2]));
            totalPayX[2]+=totalX[2];  
        }else{
            cell2.setCellValue("");      
        }
        cell2.setCellStyle(styleX);

        startcols++;
        cell2=row1.createCell((short)startcols);
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        if(totalX[3] !=0)
        {
            cell2.setCellValue(mnf.format(totalX[3])); 
            totalPayX[3]+=totalX[3];
        }else{
            cell2.setCellValue("");       
        }
        cell2.setCellStyle(styleX);            

        startcols++;

        cell2=row1.createCell((short)startcols);
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        if(totalX[4] !=0){
            cell2.setCellValue(mnf.format(totalX[4])); 
            totalPayX[4]+=totalX[4];   
        }else{
            cell2.setCellValue("");    
        }
        cell2.setCellStyle(styleX); 

        startcols++;
        cell2=row1.createCell((short)startcols);
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);

        if(totalX[6]==totalNow)
        {
            cell2.setCellValue(mnf.format(totalX[6]));        
            cell2.setCellStyle(sPay);    
        }else if(totalX[6]==0){
            cell2.setCellValue("");        
            cell2.setCellStyle(styleX);
        }else{
            cell2.setCellValue("*"+mnf.format(totalX[6]));        
            cell2.setCellStyle(styleX);
        }

        int notPaied=unpaidMoney+totalNow-totalX[6];
        notpaiedTotal+=notPaied;

        startcols++;
        cell2=row1.createCell((short)startcols);
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        cell2.setCellValue((notPaied==0)?"":mnf.format(notPaied));        
        cell2.setCellStyle(styleX);

        startcols++;
        cell2=row1.createCell((short)startcols);
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        cell2.setCellValue(getDiscountInfo(bills, feeMap, discountMap));        
        cell2.setCellStyle(style2);

        startcols++;
        cell2=row1.createCell((short)startcols);
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        cell2.setCellValue(getCommentsForBills(bills, commentMap));        
        cell2.setCellStyle(style2);
    } 

    row1=sheet1.createRow((short)(startrow+1));

    startStu++;
    cell2=row1.createCell((short)1);
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue("合 計");
    cell2.setCellStyle(style);


    int totalAll=0;
    int xNow=0;
    for (int i=0; i<acodes.size(); i++) {
        cell2=row1.createCell((short)(xNow+2));
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        cell2.setCellValue(mnf.format(totalNumX[xNow]));
        cell2.setCellStyle(styleX);
        //type
        //cell2.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
        totalAll+=totalNumX[xNow];
        xNow++;
    } 
    cell2=row1.createCell((short)(xNow+2));
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue(mnf.format(totalAll));
    cell2.setCellStyle(styleX);

    cell2=row1.createCell((short)(xNow+3));
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue(mnf.format(totalUnpaid));
    cell2.setCellStyle(styleX);

    cell2=row1.createCell((short)(xNow+4));
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue(mnf.format(totalAll+totalUnpaid));
    cell2.setCellStyle(styleX);

    int totalPayNow=0;
    for(int xx=0;xx<5;xx++)
    {
        cell2=row1.createCell((short)(xNow+5+xx));
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        cell2.setCellValue(mnf.format(totalPayX[xx]));
        cell2.setCellStyle(styleX);            
        totalPayNow+=totalPayX[xx];
    }


    cell2=row1.createCell((short)(xNow+10));
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue(mnf.format(totalPayNow));
    cell2.setCellStyle(sPay);

    cell2=row1.createCell((short)(xNow+11));
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue(mnf.format(notpaiedTotal));
    cell2.setCellStyle(styleX);
}


String path=application.getRealPath("/");

Date nowX=new Date();
long nowLong=nowX.getTime();
String creatFile=String.valueOf(nowLong);
// 儲存
FileOutputStream fso=new FileOutputStream(path+"eSystem/exlfile/"+creatFile+".xls");
wb.write(fso);
fso.close();

Iterator<TagType> titer = TagTypeMgr.getInstance().retrieveListX("","",_ws2.getStudentBunitSpace("bunitId")).iterator();
%>
<div class=es02>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b><img src="images/excel2.gif" border=0>&nbsp;匯出Excel報表</b>
</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<center>
<br>
	<table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
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
        <a href="exlfile/<%=creatFile%>.xls"><img src="images/excel2.gif" border=0>下載檔案</a>
        <br>(請選"儲存",以方便編輯及列印)
        </center>
	</td>
	</td>
	</tr>
	</table>
	</td>
	</tr>
	</table>

    <form name="runForm" method="post" action="export_bill.jsp">
        <input type=hidden name="o" value="<%=o%>">
        <input type=hidden name="type" value="<%=type%>">
        <input type=hidden name="t" value="<%=t%>">
        <input type=hidden name="ordr" value="0">
    </form>
    <script>
        function goSubmit(xvalue){
            document.runForm.ordr.value=xvalue;
            document.runForm.submit();
        }
    </script>

    </center>

<%
// #####################################################################
    // billitemId

%>


<%!
    void appendMap(Map<Integer, ArrayList<ChargeItem>> acodecitemMap, int acodeId, ArrayList<ChargeItem> citems)
    {
        ArrayList<ChargeItem> arr = acodecitemMap.get(acodeId);
        if (arr==null) {
            arr = new ArrayList<ChargeItem>();
        }
        for (int i=0; citems!=null&&i<citems.size(); i++) {
            arr.add(citems.get(i));
        }
        acodecitemMap.put(acodeId, arr);
    }

    ArrayList<Acode> convertAcodes(ArrayList<ChargeItem> activeCharges, int bunitId, 
        Map<Integer, ArrayList<ChargeItem>> acodecitemMap) 
        throws Exception
    {
        Map<Integer, ArrayList<ChargeItem>> citemMap = new SortingMap(activeCharges).doSortA("getBillItemId");
        String billItemIds = new RangeMaker().makeRange(activeCharges, "getBillItemId");
        ArrayList<BillItem> bitems = BillItemMgr.getInstance().retrieveList("id in (" + billItemIds + ")", "");
        if (bitems.size()==0)
            return new ArrayList<Acode>();
        VoucherService vsvc = new VoucherService(0, bunitId);
        StringBuffer sb = new StringBuffer();
        for (int i=0; i<bitems.size(); i++) {
            BillItem bi = bitems.get(i);
            VchrItem vi = vsvc.getBillItemInfo(bi, VchrItem.FLAG_CREDIT, VchrHolder.BILLITEM_DEFAULT);
            if (sb.length()>0) sb.append(",");
            sb.append(vi.getAcodeId());
            ArrayList<ChargeItem> mycitems = citemMap.get(bi.getId());
            appendMap(acodecitemMap, vi.getAcodeId(), mycitems);
        }
        return AcodeMgr.getInstance().retrieveList("id in (" + sb.toString() + ")", "order by main asc, sub asc");
    }

    ArrayList<ChargeItem> makeChargeReport(
           // ticketId
        Map<String, Vector<ChargeItemMembr>> feeMap,
           // chargeKey (membrId#chargeItemId)
        Map<String, Vector<DiscountInfo>> discountMap,
           // ticketId#chargeItemId
        Map<String, Integer> chargeAmountMap) throws Exception
    {
        ArrayList<ChargeItem> citems = ChargeItemMgr.getInstance().retrieveList("","");
        Map<Integer, Vector<ChargeItem>> citemMap = new SortingMap(citems).doSort("getId");
        ArrayList<ChargeItem> ret = new ArrayList<ChargeItem>();
        Map<ChargeItem, Object> tmp = new LinkedHashMap<ChargeItem, Object>();

        Set keys = feeMap.keySet();
        Iterator<String> iter = keys.iterator();
        while (iter.hasNext()) {
            String ticketId = iter.next();
            Vector<ChargeItemMembr> charges = feeMap.get(ticketId);
            int money = 0;
            for (int i=0; charges!=null&&i<charges.size(); i++) {
                ChargeItemMembr c = charges.get(i);
                ChargeItem ci = citemMap.get(new Integer(c.getChargeItemId())).get(0);
                tmp.put(ci, "");
                money = c.getMyAmount();
                Vector<DiscountInfo> vd = discountMap.get(c.getMembrId()+"#"+c.getChargeItemId());
                for (int j=0; vd!=null&&j<vd.size(); j++) {
                    DiscountInfo d = vd.get(j);
                    money -= d.getAmount();
                }
                chargeAmountMap.put(ticketId+"#"+c.getChargeItemId(), new Integer(money));
            }
        }
        Set tmpset = tmp.keySet();
        Iterator<ChargeItem> iter2 = tmpset.iterator();
        while (iter2.hasNext())
            ret.add(iter2.next());
        return ret;
    }

    public void getPayForAll(int membrId, 
        Map<String, ArrayList<BillPay>> payMap,
        int[] xtotal, int[] ytotal)
    {
        ArrayList<BillPay> pv = payMap.get(membrId);
        for (int i=0; pv!=null&&i<pv.size(); i++) {
            BillPay p = pv.get(i);
            switch (p.getVia()) {
                case BillPay.VIA_STORE: //ret.append("便利商店"); 
                    xtotal[0]=p.getAmount()+xtotal[0]; // 2008/09/26, robert提出當此繳款的資料應包含前期未繳，所以應該用 getPayAmountAmount 比用 getPaidAmount 來的合理
                    ytotal[0]=p.getAmount()+ytotal[0]; // 2008/11/24, robert又靠腰說看7200銷別張不合理，該張只部分銷450，所以加上ytotal 
                    break;
                case BillPay.VIA_ATM: //ret.append("ATM"); 
                    // xtotal[1]=p.getPaidAmount()+xtotal[1];
                    xtotal[1]=p.getAmount()+xtotal[1];
                    ytotal[1]=p.getAmount()+ytotal[1];
                    break;
                case BillPay.VIA_WIRE:  //ret.append("WIRE"); 
                case BillPay.VIA_INPERSON: //ret.append("臨櫃"); 
                    // xtotal[2]=p.getPaidAmount()+xtotal[2];
                    xtotal[2]=p.getAmount()+xtotal[2];
                    ytotal[2]=p.getAmount()+ytotal[2];
                    break;
                case BillPay.VIA_CHECK: //ret.append("支票"); 
                    // xtotal[3]=p.getPaidAmount()+xtotal[3];
                    xtotal[3]=p.getAmount()+xtotal[3];
                    ytotal[3]=p.getAmount()+ytotal[3];
                    break;
                case BillPay.VIA_CREDITCARD: //ret.append("信用卡"); 
                    // xtotal[4]=p.getPaidAmount()+xtotal[4];
                    xtotal[4]=p.getAmount()+xtotal[4];
                    ytotal[4]=p.getAmount()+ytotal[4];
                    break;
                /*
                case BillPay.VIA_WIRE:  //ret.append("WIRE"); 
                    // xtotal[5]=p.getPaidAmount()+xtotal[5];
                    xtotal[5]=p.getPayAmount()+xtotal[5];
                    ytotal[5]=p.getPaidAmount()+ytotal[5];
                    break;
                */
            }

            // xtotal[6]+=p.getPaidAmount();
            xtotal[6]+=p.getAmount();
            ytotal[6]+=p.getAmount();
        }
    }


    public void getPaidInfoForAll(Vector<MembrInfoBillRecord> bills, 
        Map<String, Vector<BillPaidInfo>> paidMap,
        int[] xtotal, int[] ytotal)
    {
        for (int i=0; i<bills.size(); i++) {
            int[] tmpX = new int[xtotal.length]; // pay amount
            int[] tmpY = new int[ytotal.length]; // paid amount
            getPaidInfo(bills.get(i), paidMap, tmpX, tmpY);
            for (int j=0; j<xtotal.length; j++)
                xtotal[j] += tmpX[j];
            for (int j=0; j<ytotal.length; j++)
                ytotal[j] += tmpY[j];
        }
    }

    public void getPaidInfo(MembrInfoBillRecord bill, Map<String, Vector<BillPaidInfo>> paidMap,
        int[] xtotal, int[] ytotal)
    {                
        StringBuffer ret = new StringBuffer();
        Vector<BillPaidInfo> pv = paidMap.get(bill.getTicketId());
        for (int i=0; pv!=null&&i<pv.size(); i++) {
            BillPaidInfo p = pv.get(i);
            if (ret.length()>0)
                ret.append(",");
            switch (p.getVia()) {
                case BillPay.VIA_STORE: //ret.append("便利商店"); 
                    //xtotal[0]=p.getPaidAmount()+xtotal[0];
                    xtotal[0]=p.getPayAmount()+xtotal[0]; // 2008/09/26, robert提出當此繳款的資料應包含前期未繳，所以應該用 getPayAmountAmount 比用 getPaidAmount 來的合理
                    ytotal[0]=p.getPaidAmount()+ytotal[0]; // 2008/11/24, robert又靠腰說看7200銷別張不合理，該張只部分銷450，所以加上ytotal 
                    break;
                case BillPay.VIA_ATM: //ret.append("ATM"); 
                    // xtotal[1]=p.getPaidAmount()+xtotal[1];
                    xtotal[1]=p.getPayAmount()+xtotal[1];
                    ytotal[1]=p.getPaidAmount()+ytotal[1];
                    break;
                case BillPay.VIA_WIRE:  //ret.append("WIRE"); 
                case BillPay.VIA_INPERSON: //ret.append("臨櫃"); 
                    // xtotal[2]=p.getPaidAmount()+xtotal[2];
                    xtotal[2]=p.getPayAmount()+xtotal[2];
                    ytotal[2]=p.getPaidAmount()+ytotal[2];
                    break;
                case BillPay.VIA_CHECK: //ret.append("支票"); 
                    // xtotal[3]=p.getPaidAmount()+xtotal[3];
                    xtotal[3]=p.getPayAmount()+xtotal[3];
                    ytotal[3]=p.getPaidAmount()+ytotal[3];
                    break;
                case BillPay.VIA_CREDITCARD: //ret.append("信用卡"); 
                    // xtotal[4]=p.getPaidAmount()+xtotal[4];
                    xtotal[4]=p.getPayAmount()+xtotal[4];
                    ytotal[4]=p.getPaidAmount()+ytotal[4];
                    break;
                /*
                case BillPay.VIA_WIRE:  //ret.append("WIRE"); 
                    // xtotal[5]=p.getPaidAmount()+xtotal[5];
                    xtotal[5]=p.getPayAmount()+xtotal[5];
                    ytotal[5]=p.getPaidAmount()+ytotal[5];
                    break;
                */
            }

            // xtotal[6]+=p.getPaidAmount();
            xtotal[6]+=p.getPayAmount();
            ytotal[6]+=p.getPaidAmount();
        }
    }

    public String getDiscountInfo(Vector<MembrInfoBillRecord> bills, 
        Map<String, Vector<ChargeItemMembr>> feeMap, 
        Map<String, Vector<DiscountInfo>> discountMap)
    {
        StringBuffer sb = new StringBuffer();
        for (int i=0; i<bills.size(); i++) {
            MembrInfoBillRecord bill = bills.get(i);
            Vector<ChargeItemMembr> vc = feeMap.get(bill.getTicketId());
            for (int j=0; vc!=null&&j<vc.size(); j++) {
                Vector<DiscountInfo> dv = discountMap.get(bill.getMembrId()+"#"+vc.get(j).getChargeItemId());
                for (int k=0; dv!=null&&k<dv.size(); k++) {
                    if (sb.length()>0) sb.append(',');
                    sb.append(dv.get(k).getDiscountTypeName()+"(" +  dv.get(k).getAmount() + ")");
                }
            }
        }
        return sb.toString();
    }

    public String getCommentsForBills(Vector<MembrInfoBillRecord> bills, Map<String, BillComment> commentMap)
    {
        StringBuffer sb = new StringBuffer();
        for (int i=0; i<bills.size(); i++) {
            BillComment comment = commentMap.get(bills.get(i).getBillKey());
            if (comment!=null && comment.getComment().length()>0) {
                if (sb.length()>0) sb.append("\n");
                sb.append(comment.getComment());
            }
        }
        return sb.toString();
    }
// #####################################################################
%>


