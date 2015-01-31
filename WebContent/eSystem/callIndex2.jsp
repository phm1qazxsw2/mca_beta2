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
	out.println("<br><br><blockquote>尚未選擇學生!!</blockquote>");
	return;
}

int stuLen=java.lang.reflect.Array.getLength(stuId);
SimpleDateFormat sdfX=new SimpleDateFormat("yyyy/MM/dd");

String[] dayString={"(日)","(一)","(二)","(三)","(四)","(五)","(六)"};

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

// title
HSSFRow row0=sheet1.createRow((short)0);

sheet1.addMergedRegion(new Region(0,(short)0,0,(short)xdate));
HSSFCell cell0=row0.createCell((short)0);
cell0.setEncoding(HSSFCell.ENCODING_UTF_16);
cell0.setCellValue(creatTitle);
cell0.setCellStyle(style2);


// 項目
HSSFRow row1=sheet1.createRow((short)1);

HSSFFont font=wb.createFont();
font.setFontHeightInPoints((short)10);
font.setColor(HSSFColor.GREY_80_PERCENT.index);
HSSFCellStyle style=wb.createCellStyle();
style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
style.setFont(font);
style.setWrapText(true);

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

long startLong=(long)startD.getTime();
long ondateLong=(long)(1000*60*60*24);

for(int i=0;xdate>0 && i<xdate;i++)
{
    long nowlong=startLong+(ondateLong*(long)i); 
    Date nowDate=new Date(nowlong);
    cell2=row1.createCell((short)(i+1));
    cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell2.setCellValue(sdf2.format(nowDate)+"\n"+sdf3.format(nowDate)+"\n"+dayString[nowDate.getDay()]);
    cell2.setCellStyle(style);
    sheet1.setColumnWidth((short)(i+1), (short) (4 * columnWidthUnit)); 
}



StudentMgr sm=StudentMgr.getInstance();
DepartMgr dmz=DepartMgr.getInstance();
ClassesMgr cmz=ClassesMgr.getInstance();
LevelMgr lmz=LevelMgr.getInstance();

for(int i=0;i<stuLen;i++)
{
    HSSFRow row2=sheet1.createRow((short)(i+2));
	Student stu=(Student)sm.find(Integer.parseInt(stuId[i]));
	
    cell=row2.createCell((short)0);
    cell.setEncoding(HSSFCell.ENCODING_UTF_16);
    cell.setCellValue(stu.getStudentName());
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
 <b>&nbsp;&nbsp;&nbsp;<img src="images/excel2.gif">&nbsp;點名表</b> 
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