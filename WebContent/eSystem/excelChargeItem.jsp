<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,java.io.*" 
    contentType="text/html;charset=UTF-8"%>
<%@ page import="org.apache.poi.hssf.usermodel.*" %>
<%@ page import="org.apache.poi.hssf.util.HSSFColor" %>
<%@ page import="org.apache.poi.hssf.util.Region" %>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=1;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu1.jsp"%>
<%
    //##v2
    if(!AuthAdmin.authPage(ud2,4))
    {
        response.sendRedirect("authIndex.jsp?info=1&page=1");
    }
    int recordId = -1; try { recordId=Integer.parseInt(request.getParameter("rid")); } catch (Exception e) {}
    int bitemId = -1; try { bitemId=Integer.parseInt(request.getParameter("bid")); } catch (Exception e) {}
    int citemId = -1; try { citemId=Integer.parseInt(request.getParameter("cid")); } catch (Exception e) {}
    DecimalFormat mnf = new DecimalFormat("###,###,##0");
    EzCountingService ezsvc = EzCountingService.getInstance();
    BillChargeItem bcitem = null;
    
    if (citemId<0)
        bcitem = BillChargeItemMgr.getInstance().find("billrecord.id=" + recordId + " and billitem.id=" + bitemId);
    else
        bcitem = BillChargeItemMgr.getInstance().find("chargeitem.id=" + citemId);

    ArrayList<ChargeItemMembr> chargedmembrs = ChargeItemMembrMgr.getInstance().
        retrieveList("chargeItemId=" + bcitem.getId(), "");
    JsfAdmin ja = JsfAdmin.getInstance();
    IncomeSmallItem[] si = ja.getActiveIncomeSmallItemByBID(1);
    String backurl = "editChargeItem.jsp?" + request.getQueryString();
    String sdate=request.getParameter("startDate");
    String edate=request.getParameter("endDate");
    SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd"); 
    SimpleDateFormat sdf2=new SimpleDateFormat("MM/");
    SimpleDateFormat sdf3=new SimpleDateFormat("dd");
    Date startD = new Date();
    try { startD = sdf.parse(sdate); } catch (Exception e) {}
    Date endD = new Date();
    try { endD = sdf.parse(edate); } catch (Exception e) {}
    long xtime=(long)endD.getTime()-(long)startD.getTime(); 
    int xdate=(int)(xtime/(long)(1000*60*60*24))+1;

    String exlTitle=bcitem.getName()+"    合計:"+chargedmembrs.size()+"筆  製表人:"+ud2.getUserFullname()+" 製表日期:"+sdf.format(new Date());

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
    // title
    HSSFRow row0=sheet1.createRow((short)0);
    sheet1.addMergedRegion(new Region(0,(short)0,0,(short)(xdate+1)));

    HSSFCell cell0=row0.createCell((short)0);
    cell0.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell0.setCellValue(exlTitle);
    cell0.setCellStyle(style3);

    // 項目
    HSSFRow row1=sheet1.createRow((short)1);

    HSSFCell cell2=row1.createCell((short)0);
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue("姓名");
    cell2.setCellStyle(style);
    sheet1.setColumnWidth((short) 0, (short) (10 * columnWidthUnit)); 

    cell2=row1.createCell((short)1);
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue("收費金額");
    cell2.setCellStyle(style);
    sheet1.setColumnWidth((short) 1, (short) (8 * columnWidthUnit)); 

    long startLong=(long)startD.getTime();
    long ondateLong=(long)(1000*60*60*24);

    String[] dayString={"(日)","(一)","(二)","(三)","(四)","(五)","(六)"};
    for(int i=0;xdate>0 && i<xdate;i++)
    {
        long nowlong=startLong+(ondateLong*(long)i); 
        Date nowDate=new Date(nowlong);
        cell2=row1.createCell((short)(i+2));
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        cell2.setCellValue(sdf2.format(nowDate)+"\n"+sdf3.format(nowDate)+"\n"+dayString[nowDate.getDay()]);
        cell2.setCellStyle(style);
        sheet1.setColumnWidth((short)(i+2), (short) (4 * columnWidthUnit)); 
    }


    Iterator<ChargeItemMembr> iter = chargedmembrs.iterator();
    int runname=0;
    while (iter.hasNext())
    {
        ChargeItemMembr c = iter.next();

        row1=sheet1.createRow((short)(runname+2));

        cell2=row1.createCell((short)0);
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        cell2.setCellValue(c.getMembrName());
        cell2.setCellStyle(style);

        cell2=row1.createCell((short)1);
        cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
        cell2.setCellValue(c.getMyAmount());
        cell2.setCellStyle(style);

        runname++;
    }

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
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b><img src="images/excel2.gif" border=0>&nbsp;匯出Excel報表</b> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" onClick="javascript:history.go(-1)"><img src="pic/last.gif" border=0>&nbsp;回上頁
</a>
</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>


<blockquote>
<br>
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
	<center><a href="exlfile/<%=creatFile%>.xls"><img src="images/excel2.gif" border=0>下載檔案</a></center>
	</td>
	</td>
	</tr>
	</table>
	</td>
	</tr>
	</table>


    </blockquote>
<br><br><br><br>

<%@ include file="bottom.jsp"%>