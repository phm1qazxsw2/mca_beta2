<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,java.io.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>

<%@ page import="org.apache.poi.hssf.usermodel.*" %>
<%@ page import="org.apache.poi.hssf.util.HSSFColor" %>
<%@ page import="org.apache.poi.hssf.util.Region" %>
<%
if(!AuthAdmin.authPage(ud2,3))
{
%>    
    <br>
    <br>
    <blockquote>
        <div class=es02>
            權限不足.
        </div>
    </blockquote>  

<%
    return;
}

int soId=Integer.parseInt(request.getParameter("soId"));

SalaryOutMgr som=SalaryOutMgr.getInstance();
SalaryOut so=(SalaryOut)som.find(soId);

SalaryAdmin sa=SalaryAdmin.getInstance();

BankAccountMgr bam=BankAccountMgr.getInstance();
BankAccount ba=(BankAccount)bam.find(so.getSalaryOutBankAccountId());

int banknumber=so.getSalaryOutBanknumber();


SalaryBank[] sb=sa.getAllSalaryBankByBankNum(banknumber);

if(sb ==null)
{
	out.println("尚未加入名單");
	
    return;
}

// 建立活頁簿
HSSFWorkbook wb=new HSSFWorkbook();
// 建立工作表
HSSFSheet sheet1=wb.createSheet("sheet1");
sheet1.setGridsPrinted(true);
sheet1.setHorizontallyCenter(true);

sheet1.setMargin(sheet1.TopMargin,(double)1);
sheet1.setMargin(sheet1.LeftMargin,(double)0.3);
sheet1.setMargin(sheet1.RightMargin,(double)0.3);
sheet1.setMargin(sheet1.BottomMargin,(double)0.3);

HSSFPrintSetup hps=sheet1.getPrintSetup();
hps.setLandscape(true);

HSSFFooter footer = sheet1.getFooter();
footer.setRight( "Page " + HSSFFooter.page() + " of " + HSSFFooter.numPages() );



//title style
HSSFFont font2=wb.createFont();
font2.setFontHeightInPoints((short)10);
font2.setColor(HSSFColor.GREY_80_PERCENT.index);
HSSFCellStyle style2=wb.createCellStyle();
style2.setAlignment(HSSFCellStyle.ALIGN_CENTER);
style2.setFont(font2);

PaySystemMgr em2=PaySystemMgr.getInstance();
PaySystem e=(PaySystem)em2.find(1);

SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM");

String exlTitle=e.getPaySystemCompanyName()+"轉帳明細 月份:"+sdf.format(so.getSalaryOutMonth())+" 匯款單號:"+so.getSalaryOutBanknumber();

// title
HSSFRow row0=sheet1.createRow((short)0);

sheet1.addMergedRegion(new Region(0,(short)0,0,(short)5));
HSSFCell cell0=row0.createCell((short)0);
cell0.setEncoding(HSSFCell.ENCODING_UTF_16);
cell0.setCellValue(exlTitle);
cell0.setCellStyle(style2);


HSSFFont font=wb.createFont();
font.setFontHeightInPoints((short)10);
font.setColor(HSSFColor.GREY_80_PERCENT.index);
HSSFCellStyle style=wb.createCellStyle();
style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
style.setFont(font);


// 項目
HSSFRow row1=sheet1.createRow((short)2);


HSSFCell cell2=row1.createCell((short)0);
cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
cell2.setCellValue("序號");
cell2.setCellStyle(style);


cell2=row1.createCell((short)1);
cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
cell2.setCellValue("收款行庫代號");
cell2.setCellStyle(style);

HSSFCell cell10=row1.createCell((short)2);
cell10.setEncoding(HSSFCell.ENCODING_UTF_16);
cell10.setCellValue("收款人帳號");
cell10.setCellStyle(style);

HSSFCell cell=row1.createCell((short)3);
cell.setEncoding(HSSFCell.ENCODING_UTF_16);
cell.setCellValue("收款人名稱");
cell.setCellStyle(style);

cell=row1.createCell((short)4);
cell.setEncoding(HSSFCell.ENCODING_UTF_16);
cell.setCellValue("身份證字號");
cell.setCellStyle(style);


cell=row1.createCell((short)5);
cell.setEncoding(HSSFCell.ENCODING_UTF_16);
cell.setCellValue("匯款金額");
cell.setCellStyle(style);


cell=row1.createCell((short)6);
cell.setEncoding(HSSFCell.ENCODING_UTF_16);
cell.setCellValue("附言");
cell.setCellStyle(style);


		int payTotal=0;
		 
		SalaryTicket[] st=new SalaryTicket[sb.length];
		
		TeacherMgr tm=TeacherMgr.getInstance();
		for(int i=0;i<sb.length;i++)
		{
			
			
			st[i]=sa.getSalaryTicketBySanumber(sb[i].getSalaryBankSanumber());
			int ticketPay=st[i].getSalaryTicketTotalMoney()-st[i].getSalaryTicketPayMoney();
			
			payTotal+=ticketPay ;
			
			Teacher tea=(Teacher)tm.find(st[i].getSalaryTicketTeacherId());
			
			HSSFRow rowX=sheet1.createRow((short)(3+i));		

			HSSFCell cellX=rowX.createCell((short)0);
			cellX.setEncoding(HSSFCell.ENCODING_UTF_16);
			cellX.setCellValue(String.valueOf(i+1));
			cellX.setCellStyle(style);	
				


			cellX=rowX.createCell((short)1);
			cellX.setEncoding(HSSFCell.ENCODING_UTF_16);
			if(tea.getTeacherAccountDefaut()==1)
				cellX.setCellValue(tea.getTeacherBank1());
			else
				cellX.setCellValue(tea.getTeacherBank2()); 
			cellX.setCellStyle(style);	

			cellX=rowX.createCell((short)2);
			cellX.setEncoding(HSSFCell.ENCODING_UTF_16);
			if(tea.getTeacherAccountDefaut()==1)
				cellX.setCellValue(tea.getTeacherAccountNumber1());
			else
				cellX.setCellValue(tea.getTeacherAccountNumber2()); 
			cellX.setCellStyle(style);	

			cellX=rowX.createCell((short)3);
			cellX.setEncoding(HSSFCell.ENCODING_UTF_16);
			cellX.setCellValue(tea.getTeacherFirstName()+tea.getTeacherLastName());
			cellX.setCellStyle(style);	
		
			cellX=rowX.createCell((short)4);
			cellX.setEncoding(HSSFCell.ENCODING_UTF_16);
			cellX.setCellValue(tea.getTeacherIdNumber());
			cellX.setCellStyle(style);	

		
			cellX=rowX.createCell((short)5);
			cellX.setEncoding(HSSFCell.ENCODING_UTF_16);
			cellX.setCellValue(String.valueOf(ticketPay));
			cellX.setCellStyle(style);	

			cellX=rowX.createCell((short)6);
			cellX.setEncoding(HSSFCell.ENCODING_UTF_16);
			cellX.setCellValue("Jain Sheng "+sdf.format(so.getSalaryOutMonth()));
			cellX.setCellStyle(style);	

		}
		 

int nowRow=sb.length+4;
		 
// 項目
String dateString=ba.getBankAccountPayDate();
if(dateString.length()==1)
	  dateString="0"+dateString ;

HSSFRow rowF=sheet1.createRow((short)(nowRow+1));
  
cell=rowF.createCell((short)0);
cell.setEncoding(HSSFCell.ENCODING_UTF_16);
cell.setCellValue("企業編號:");
cell.setCellStyle(style);
  

cell=rowF.createCell((short)1);
cell.setEncoding(HSSFCell.ENCODING_UTF_16);
cell.setCellValue(ba.getBankAccount2client());
cell.setCellStyle(style);   


rowF=sheet1.createRow((short)(nowRow+2));
 
 
cell=rowF.createCell((short)0);
cell.setEncoding(HSSFCell.ENCODING_UTF_16);
cell.setCellValue("委辦帳號:");
cell.setCellStyle(style);
  
cell=rowF.createCell((short)1);
cell.setEncoding(HSSFCell.ENCODING_UTF_16);
cell.setCellValue(ba.getBankAccountAccount());
cell.setCellStyle(style);      

rowF=sheet1.createRow((short)(nowRow+3));

cell=rowF.createCell((short)0);
cell.setEncoding(HSSFCell.ENCODING_UTF_16);
cell.setCellValue("匯款總筆數");
cell.setCellStyle(style);
  

cell=rowF.createCell((short)1);
cell.setEncoding(HSSFCell.ENCODING_UTF_16);
cell.setCellValue(String.valueOf(sb.length));
cell.setCellStyle(style);   

rowF=sheet1.createRow((short)(nowRow+4));

cell=rowF.createCell((short)0);
cell.setEncoding(HSSFCell.ENCODING_UTF_16);
cell.setCellValue("匯款總金額");
cell.setCellStyle(style);
  

cell=rowF.createCell((short)1);
cell.setEncoding(HSSFCell.ENCODING_UTF_16);
cell.setCellValue(String.valueOf(payTotal));
cell.setCellStyle(style);   



rowF=sheet1.createRow((short)(nowRow+5));
cell=rowF.createCell((short)0);
cell.setEncoding(HSSFCell.ENCODING_UTF_16);
cell.setCellValue("匯款日期");
cell.setCellStyle(style);

Date payMonth=so.getSalaryOutMonth();

int yearInt=payMonth.getYear() +1900-1911;
int intMonth= payMonth.getMonth()+2;
if(intMonth==13)
{
	intMonth=1;
	yearInt++;		
}

String month="";
if(intMonth >=10)
  	month=String.valueOf(intMonth);
else
	month="0"+String.valueOf(intMonth);	
cell=rowF.createCell((short)1);
cell.setEncoding(HSSFCell.ENCODING_UTF_16);
cell.setCellValue(String.valueOf(yearInt)+"-"+month+"-"+dateString);
cell.setCellStyle(style);


String path=application.getRealPath("/");

Date nowX=new Date();
long nowLong=nowX.getTime();
String creatFile=String.valueOf(nowLong);
// 儲存
FileOutputStream fso=new FileOutputStream(path+"eSystem/exlfile/"+creatFile+".xls");
wb.write(fso);
fso.close();

ExlMgr em=ExlMgr.getInstance();

Exl ee=new Exl();
ee.setExlFileName("report");
ee.setExlTitle("財務報表");
ee.setExlPs(exlTitle);

int eeId=em.createWithIdReturned(ee);
Exl es=(Exl)em.find(eeId);
%>

<html>
<title></title>
<meta http-equiv="Expires" content="0">


<blockquote>
<font size=2 color=blue>檔案已產生!</font><br><br>

<font size=2 color=red>注意:</font>此為機密資訊,下載後請妥善保存.
<br>
<br>


<table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

		<table width="100%" border=0 cellpadding=4 cellspacing=1>
			<tr bgcolor="ffffff" class=es02>
                <td bgcolor="#f0f0f0">檔名</td>
                <td><%=creatFile%>.xls</td>
            </tr>
            <tr bgcolor="ffffff" class=es02>
                <td bgcolor="#f0f0f0" >標題</td>
                <td><%=es.getExlTitle()%></td>
            </tr>
            <tr bgcolor="ffffff" class=es02>
                <td bgcolor="#f0f0f0"> 備註</td>
                <td><%=es.getExlPs()%></td>
            </tr>
            <tr bgcolor="ffffff" class=es02>
            <td colspan=2>
            <center><a href="exlfile/<%=creatFile%>.xls"><img src="images/excel2.gif" border=0>下載檔案</a></center>
            </td>
            </td>
            </tr>
            </table>
        </td>
    </tr>
</table>
<br><br>

</blockquote>

</head><body>
</body></html>


