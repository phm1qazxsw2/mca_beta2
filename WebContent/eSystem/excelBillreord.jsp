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
<%@ include file="topMenuAdvanced.jsp"%>
<%@ include file="leftMenu1.jsp"%>
<%!
    public IncomeSmallItem[] getActiveSmallItem(Map<String/*ticketId*/, Vector<ChargeItemMembr>> feeMap)
        throws Exception
    {
        ArrayList<ChargeItemMembr> all_fees = new ArrayList<ChargeItemMembr>();
        Set<String> keys = feeMap.keySet();
        Iterator<String> iter = keys.iterator();
        while (iter.hasNext()) {
            Vector<ChargeItemMembr> vc = feeMap.get(iter.next());
            for (int i=0; i<vc.size(); i++)
                all_fees.add(vc.get(i));
        }

        Map<Integer/*smallItemId*/, Vector<ChargeItemMembr>>  feeMap2 = 
            new SortingMap(all_fees).doSort("getSmallItemId");
        
        // 會計科目的東東
        Object[] objs = IncomeSmallItemMgr.getInstance().retrieve("","");
        Map<Integer, IncomeSmallItem> smallitemMap = new HashMap<Integer, IncomeSmallItem>();
        for (int i=0; objs!=null && i<objs.length; i++)
            smallitemMap.put(new Integer(((IncomeSmallItem)objs[i]).getId()), (IncomeSmallItem)objs[i]);

        IncomeSmallItem[] ret = new IncomeSmallItem[feeMap2.size()];
        Set<Integer> keys2 = feeMap2.keySet();
        Iterator<Integer> iter2 = keys2.iterator();
        int i = 0;
        while (iter2.hasNext()) {
            IncomeSmallItem is = smallitemMap.get(iter2.next());
            ret[i++] = is;
        }
        return ret;
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
    if (monstr==null)
        monstr = "";

     ArrayList<BillRecordInfo> targetRecords = 
        bmgr.retrieveList("month='" + monstr + "' and billType="+Bill.TYPE_BILLING, "");
     
    EzCountingService ezsvc = EzCountingService.getInstance();

    // all members that has 帳單 in this records
    ArrayList<Membr> membrs = new ArrayList<Membr>();

    // membrId
    Map<Integer, Vector<MembrInfoBillRecord>> billMap = 
            new LinkedHashMap<Integer, Vector<MembrInfoBillRecord>>();
    // ticketId
    Map<String, Vector<ChargeItemMembr>> feeMap =
            new LinkedHashMap<String, Vector<ChargeItemMembr>>();
    // chargeItemId
    Map<String, Vector<DiscountInfo>> discountMap = 
            new LinkedHashMap<String, Vector<DiscountInfo>>();
    // membrId#SmallItemId
    Map<String, Vector<ChargeItemMembr>> feeMap2 =
            new LinkedHashMap<String, Vector<ChargeItemMembr>>();

    ezsvc.getNumbers(targetRecords, membrs, billMap, feeMap, discountMap, feeMap2);
    
    int type=-1;
    String typeS=request.getParameter("type");
    if(typeS != null)
        type=Integer.parseInt(typeS);
    Date nowDate=sdf2.parse(monstr);
    String nowMonth=sdf1.format(nowDate);

    int ordr = -1;
    try { ordr = Integer.parseInt(request.getParameter("ordr")); } catch (Exception e) {}
    Iterator<TagType> titer = TagTypeMgr.getInstance().retrieveList("","",_ws2.getStudentBunitSpace("bunitId")).iterator();

    ArrayList<TagMembrInfo> ordered_membrs = null;
    ArrayList<Tag> tags = TagMgr.getInstance().retrieveList("typeId=" + ordr, "");
    if (tags.size()>0) {
        String tagIds = new RangeMaker().makeRange(tags, "getId");
        ordered_membrs = TagMembrInfoMgr.getInstance().retrieveList("tagId in (" + tagIds + ")", "");
    }
 
    if (ordered_membrs==null) 
        ordered_membrs = TagMembrInfoMgr.getInstance().retrieveList("", "group by membrId",_ws2.getStudentBunitSpace("tag.bunitId"));

    Map<Integer/*membrId*/, Vector<Membr>> membrMap = new SortingMap(membrs).doSort("getId");


    // feeMap2
    // Vector<ChargeItemMembr>   feeMap2.get(membrId + "#" + smallItemId);
    // IncomeSmallItem[] si=ja.getAllIncomeSmallItemByBID(1);
    IncomeSmallItem[] si = getActiveSmallItem(feeMap);
System.out.println("## si.size=" + si.length);

    String exlTitle = new BunitHelper().getCompanyNameTitle(_ws.getSessionBunitId()) 
        +" 月份:"+nowMonth+" 帳單明細  製表人:"+ud2.getUserFullname()+" 製表日期:"+sdf2.format(new Date());
%>
<%
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

sheet1.addMergedRegion(new Region(0,(short)0,0,(short)(si.length+4)));
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
sheet1.setColumnWidth((short) 0, (short) (20 * columnWidthUnit)); 

HSSFCell cell10=row1.createCell((short)1);
cell10.setEncoding(HSSFCell.ENCODING_UTF_16);
cell10.setCellValue("繳款狀態");
cell10.setCellStyle(style);
sheet1.setColumnWidth((short) 1, (short) (10 * columnWidthUnit)); 

cell10=row1.createCell((short)2);
cell10.setEncoding(HSSFCell.ENCODING_UTF_16);
cell10.setCellValue("應收");
cell10.setCellStyle(style);
sheet1.setColumnWidth((short) 2, (short) (10 * columnWidthUnit)); 

cell10=row1.createCell((short)3);
cell10.setEncoding(HSSFCell.ENCODING_UTF_16);
cell10.setCellValue("已收");
cell10.setCellStyle(style);
sheet1.setColumnWidth((short) 3, (short) (10 * columnWidthUnit)); 



cell10=row1.createCell((short)4);
cell10.setEncoding(HSSFCell.ENCODING_UTF_16);
cell10.setCellValue("帳單名稱");
cell10.setCellStyle(style);
sheet1.setColumnWidth((short) 4, (short) (20 * columnWidthUnit)); 
	
if(si==null)
{
    out.println("尚未設定會計科目");
    return;
}


int[] siTotal=new int[si.length];		
for(int rl2=0;rl2<si.length;rl2++)
{
	int rl=rl2+5;
	HSSFCell cell=row1.createCell((short)rl);
	cell.setEncoding(HSSFCell.ENCODING_UTF_16);
	cell.setCellValue(si[rl2].getIncomeSmallItemName());
	cell.setCellStyle(style);
    sheet1.setColumnWidth((short)rl, (short) (20 * columnWidthUnit)); // 12個單位寬度，會自動折行 
}


Iterator<TagMembrInfo> tmiter = ordered_membrs.iterator();
int a=0, b=0;
TagMembrInfo emptyInfo = new TagMembrInfo();
emptyInfo.setTagName("未定");

    int totalPay=0;
    int totalShould=0;
    int totalNeed=0;

    int xxx=0;
    while (tmiter.hasNext() || membrMap.size()>0) {
                TagMembrInfo tmembr = null;
                Membr membr = null;
                if (tmiter.hasNext()) {
                    tmembr = tmiter.next();
                    Vector<Membr> mv = membrMap.get(new Integer(tmembr.getMembrId()));
                    if (mv==null) {
                        b ++;
                        continue;
                    }
                    a ++;
                    membr = mv.get(0);
                }
                else {
                    Set<Integer> s = membrMap.keySet();
                    Iterator<Integer> kiter = s.iterator();
                    Vector<Membr> mv = membrMap.get(kiter.next());
                    tmembr = emptyInfo;
                    membr = mv.get(0);
                }
                membrMap.remove(new Integer(membr.getId()));
                Vector<MembrInfoBillRecord> vbills = billMap.get(new Integer(membr.getId()));

    
    for (int i=0; vbills!=null && i<vbills.size(); i++) {
        MembrInfoBillRecord bill = vbills.get(i);
        int subtotal = (int) 0;
        Vector<ChargeItemMembr> fees = feeMap.get(bill.getTicketId());
         
        Hashtable feeMap3=new Hashtable();         
        for(int cix=0;cix<fees.size();cix++)
        {
                ChargeItemMembr cim=(ChargeItemMembr)fees.get(cix);
                    
                Vector v3=(Vector)feeMap3.get((Integer)cim.getSmallItemId());
                if(v3==null){  
                    v3=new Vector();
                    v3.add((ChargeItemMembr)cim);
                    feeMap3.put(Integer.valueOf(cim.getSmallItemId()),(Vector)v3);  
                }else{
                    v3.add((ChargeItemMembr)cim);
                    feeMap3.put(Integer.valueOf(cim.getSmallItemId()),(Vector)v3);  
                }
        }
          
        HSSFRow row2=sheet1.createRow((short)(xxx+2));        
        xxx++;

        String xPage="";
        if(vbills.size()>1)
            xPage="\n(第"+(i+1)+"張)";
        

		HSSFCell cell=row2.createCell((short)0);
		cell.setEncoding(HSSFCell.ENCODING_UTF_16);
		cell.setCellValue(tmembr.getTagName()+"-"+membr.getName()+xPage);	
		cell.setCellStyle(style2);


        //String nowWord="應收："+mnf.format(bill.getReceivable())+"- 已付："+mnf.format(bill.getReceived());
        int nowTotalX=bill.getReceivable()-bill.getReceived();        
        String nowWord="";
        if(nowTotalX >0){
            nowWord="尚未繳清";            
        }else{
            nowWord="已繳清";
        }

        totalShould+=bill.getReceivable();
        totalPay+=bill.getReceived();
        totalNeed+=nowTotalX;


        HSSFCell cell7=row2.createCell((short)1);
		cell7.setEncoding(HSSFCell.ENCODING_UTF_16);
		cell7.setCellValue(nowWord);	
		cell7.setCellStyle(style2);


        cell7=row2.createCell((short)2);
		cell7.setEncoding(HSSFCell.ENCODING_UTF_16);
		cell7.setCellValue(mnf.format(bill.getReceivable()));	
		cell7.setCellStyle(styleX);

        cell7=row2.createCell((short)3);
		cell7.setEncoding(HSSFCell.ENCODING_UTF_16);
		cell7.setCellValue(mnf.format(bill.getReceived()));	
		cell7.setCellStyle(styleX);

        
        String payDateString=String.valueOf(bill.getTicketId())+"\n"+bill.getBillRecordName();
        cell7=row2.createCell((short)4);
		cell7.setEncoding(HSSFCell.ENCODING_UTF_16);
		cell7.setCellValue(payDateString);	
		cell7.setCellStyle(style2);

        for(int rl2=0;rl2<si.length;rl2++)
        {
            //Vector v2=feeMap.get(membr.getId()+"#"+ si[rl2].getId());
            Vector v2=(Vector)feeMap3.get((Integer)si[rl2].getId());
            String outWord="";                
            for(int vi=0;v2 !=null &&vi<v2.size();vi++)
            {
                ChargeItemMembr c = (ChargeItemMembr)v2.get(vi);
                int item_discount = 0;
                Vector<DiscountInfo> discounts = discountMap.get(c.getChargeKey());
                for (int k=0; discounts!=null && k<discounts.size(); k++) {
                    item_discount += discounts.get(k).getAmount();
                } 
                if(vi !=0)
                    outWord+="\n";
                outWord+=c.getChargeName()+":"+mnf.format(c.getMyAmount()-item_discount)+"\n(應收:"+mnf.format(c.getMyAmount())+",折扣:"+mnf.format(item_discount)+")";

                siTotal[rl2]+=c.getMyAmount()-item_discount;
            }

            int rl=rl2+5;
            cell=row2.createCell((short)rl);
            cell.setEncoding(HSSFCell.ENCODING_UTF_16);
            cell.setCellValue(outWord);
            cell.setCellStyle(style2);
        }
    }
}

    HSSFRow row2=sheet1.createRow((short)(xxx+4)); 
    
    HSSFCell cell=row2.createCell((short)0);
    cell.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell.setCellValue("小計");	
    cell.setCellStyle(style2);
/*          
    String outFinal="應收小計:"+mnf.format(totalShould)+" 元 \n";
    outFinal+="已收小計:"+mnf.format(totalPay)+" 元 \n"; 
    outFinal+="未付小計:"+mnf.format(totalNeed)+" 元 \n";        
*/
    String outFinal="未收小計:\n"+mnf.format(totalNeed)+" 元";

    cell=row2.createCell((short)1);
    cell.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell.setCellValue(outFinal);	
    cell.setCellStyle(style);

    cell=row2.createCell((short)2);
    cell.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell.setCellValue("應收小計:\n"+mnf.format(totalShould));	
    cell.setCellStyle(style);

    cell=row2.createCell((short)3);
    cell.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell.setCellValue("已收小計:\n"+mnf.format(totalPay));	
    cell.setCellStyle(style);

    for(int rl2=0;rl2<si.length;rl2++)
    {
        int rl=rl2+5;
        cell=row2.createCell((short)rl);
        cell.setEncoding(HSSFCell.ENCODING_UTF_16);
        cell.setCellValue(mnf.format(siTotal[rl2]));
        cell.setCellStyle(style);
    }


    row2=sheet1.createRow((short)(xxx+5)); 
    cell=row2.createCell((short)7);
    cell.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell.setCellValue("主管簽核");	
    cell.setCellStyle(style);
          
    cell=row2.createCell((short)9);
    cell.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell.setCellValue("日期");	
    cell.setCellStyle(style);


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
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b><img src="images/excel2.gif" border=0>&nbsp;<%=sdf1.format(nowDate)%> 帳單明細</b> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" onClick="javascript:history.go(-1)"><img src="pic/last.gif" border=0>&nbsp;回上頁
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
		<td>名單排序方式</td>
		<td  bgcolor=ffffff>
                <select name="ordr" onChange="window.location='excelBillreord.jsp?month=<%=monstr%>&type=0&ordr='+this.value">
                <option value=-1>無</option>
            <%  while (titer.hasNext()) { 
                    TagType tp = titer.next(); %>
                <option value=<%=tp.getId()%> <%=(tp.getId()==ordr)?"selected":""%>><%=tp.getName()%></option>
            <%  }  %>
            </select>  
        </td>
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




        