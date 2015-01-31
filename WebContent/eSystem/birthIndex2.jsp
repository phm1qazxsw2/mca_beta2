<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.io.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ page import="org.apache.poi.hssf.usermodel.*" %>
<%@ page import="org.apache.poi.hssf.util.HSSFColor" %>
<%@ page import="org.apache.poi.hssf.util.Region" %>
<%
    int topMenu=4;
    int leftMenu=4;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu4.jsp"%>

<%
request.setCharacterEncoding("UTF-8");
String[] stuId=request.getParameterValues("stuId");

if(stuId==null)
{
	out.println("<br><br><blockquote><div class=es02>尚未選擇學生!</div></blockquote>");
%>
    <%@ include file="bottom.jsp"%>

<%
	return;
}

int stuLen=java.lang.reflect.Array.getLength(stuId);
SimpleDateFormat sdfX=new SimpleDateFormat("yyyy/MM/dd");

String creatFile=request.getParameter("creatFile");
String creatTitle=request.getParameter("creatTitle");
String exlPs=request.getParameter("exlPs");

short columnWidthUnit = 256; 
JsfTool jt=JsfTool.getInstance();

// 建立活頁簿
HSSFWorkbook wb=new HSSFWorkbook();
// 建立工作表
HSSFSheet sheet1=wb.createSheet("sheet1");

//title style
HSSFFont font2=wb.createFont();
font2.setFontHeightInPoints((short)12);
font2.setColor(HSSFColor.GREY_80_PERCENT.index);

HSSFCellStyle style2=wb.createCellStyle();
style2.setAlignment(HSSFCellStyle.ALIGN_CENTER);
style2.setFont(font2);
style2.setWrapText(true);


HSSFFont font=wb.createFont();
font.setFontHeightInPoints((short)10);
font.setColor(HSSFColor.GREY_80_PERCENT.index);
HSSFCellStyle style=wb.createCellStyle();
style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
style.setFont(font);
style.setWrapText(true);


HSSFCellStyle style3=wb.createCellStyle();
style3.setAlignment(HSSFCellStyle.ALIGN_RIGHT);
style3.setFont(font);
style3.setWrapText(true);


// title
HSSFRow row0=sheet1.createRow((short)0);

sheet1.addMergedRegion(new Region(0,(short)0,0,(short)3));
HSSFCell cell0=row0.createCell((short)0);
cell0.setEncoding(HSSFCell.ENCODING_UTF_16);
cell0.setCellValue(creatTitle);
cell0.setCellStyle(style2);


// 項目
HSSFRow row1=sheet1.createRow((short)1);



int rl=0;

HSSFCell cell2=null;
HSSFCell cell=row1.createCell((short)rl);
cell.setEncoding(HSSFCell.ENCODING_UTF_16);
if(pZ2.getCustomerType()==0){   
cell.setCellValue("姓名");
}else{
cell.setCellValue("客戶名稱");
}
cell.setCellStyle(style);
sheet1.setColumnWidth((short)0, (short) (10 * columnWidthUnit)); 

cell2=row1.createCell((short)(rl+1));
cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
cell2.setCellValue("生日日期");
cell2.setCellStyle(style);
sheet1.setColumnWidth((short)(rl+1), (short) (10* columnWidthUnit)); 

cell2=row1.createCell((short)(rl+2));
cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
cell2.setCellValue("歲 數");
cell2.setCellStyle(style);
sheet1.setColumnWidth((short)(rl+2), (short) (10* columnWidthUnit)); 



StudentMgr sm=StudentMgr.getInstance();
DepartMgr dmz=DepartMgr.getInstance();
ClassesMgr cmz=ClassesMgr.getInstance();
LevelMgr lmz=LevelMgr.getInstance();

Date now=new Date();

int nowyear=now.getYear();

for(int i=0;i<stuLen;i++)
{

	Student stu=(Student)sm.find(Integer.parseInt(stuId[i]));

    Date stBirth=stu.getStudentBirth();
    
    if(stBirth ==null)
        continue;

    int old=nowyear-stBirth.getYear()+1;
 
    HSSFRow row2=sheet1.createRow((short)(i+2));


    cell=row2.createCell((short)0);
    cell.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell.setCellValue(stu.getStudentName());

    cell=row2.createCell((short)1);
    cell.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell.setCellValue(JsfTool.showDate(stBirth));

    cell=row2.createCell((short)2);
    cell.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell.setCellValue(old+"歲");
    cell.setCellStyle(style3);
}


String path=application.getRealPath("/");
// 儲存
FileOutputStream fso=new FileOutputStream(path+"eSystem/exlfile/"+creatFile+".xls");
wb.write(fso);
fso.close();

ExlMgr em=ExlMgr.getInstance();

Exl ee=new Exl();
ee.setExlFileName(creatFile);
ee.setExlTitle(creatTitle);
ee.setExlPs("");

int eeId=em.createWithIdReturned(ee);


Exl es=(Exl)em.find(eeId);
%>
<br>
<div class=es02>
 <b>&nbsp;&nbsp;&nbsp;<img src="images/excel2.gif">&nbsp;壽星名單</b> 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href="formIndex.jsp"><img src="pic/last.gif" border=0>&nbsp;回表單中心</a>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<br>
<blockquote>
<div class=es02>
<font size=2 color=red>檔案已產生!!</font><br>
</div>
<br>
	<table width="50%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#f0f0f0 class=es02>
		<td>檔名</td>
		<td bgcolor=ffffff><%=es.getExlFileName()%>.xls</td>
		</tr>
		<tr bgcolor=#f0f0f0 class=es02>
		<td>標題</td>
		<td bgcolor=ffffff><%=es.getExlTitle()%></td>
		</tr>
		<tr>
		<td colspan=2 bgcolor=ffffff class=es02>
		<center><a href="exlfile/<%=creatFile%>.xls"><img src="images/excel2.gif" border=0>下載檔案</a></center>
		</td>
		</td>
		</tr>
	</table>
	</td>
	</tr>
	</table>
    <%@ include file="bottom.jsp"%>	