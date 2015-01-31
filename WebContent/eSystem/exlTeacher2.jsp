<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.io.*" contentType="text/html;charset=UTF-8"%>
<%@ page import="org.apache.poi.hssf.usermodel.*" %>
<%@ page import="org.apache.poi.hssf.util.HSSFColor" %>
<%@ page import="org.apache.poi.hssf.util.Region" %>
<%
    int topMenu=6;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu6.jsp"%>

<%
request.setCharacterEncoding("UTF-8");
String[] stuId=request.getParameterValues("teaId");

if(stuId==null)
{
	out.println("尚未選擇名單");
	return;
}

int stuLen=java.lang.reflect.Array.getLength(stuId);
String[] choice=request.getParameterValues("choice");
if(choice==null)
{
	out.println("尚未選擇資料項目");
	return;
}
int choLen=java.lang.reflect.Array.getLength(choice);
int[] choose=new int[choLen];
for(int j=0;j<choLen;j++)
	choose[j]=Integer.parseInt(choice[j]);


String creatFile=request.getParameter("creatFile");
String creatTitle=request.getParameter("creatTitle");
String exlPs=request.getParameter("exlPs");


JsfTool jt=JsfTool.getInstance();

// 建立活頁簿
HSSFWorkbook wb=new HSSFWorkbook();
// 建立工作表
HSSFSheet sheet1=wb.createSheet("sheet1");


//title style
HSSFFont font2=wb.createFont();
font2.setFontHeightInPoints((short)20);
font2.setColor(HSSFColor.GREY_80_PERCENT.index);
HSSFCellStyle style2=wb.createCellStyle();
style2.setAlignment(HSSFCellStyle.ALIGN_CENTER);
style2.setFont(font2);

// title
HSSFRow row0=sheet1.createRow((short)0);

sheet1.addMergedRegion(new Region(0,(short)0,0,(short)(choLen-1)));
HSSFCell cell0=row0.createCell((short)0);
cell0.setEncoding(HSSFCell.ENCODING_UTF_16);
cell0.setCellValue(creatTitle);
cell0.setCellStyle(style2);


// 項目
HSSFRow row1=sheet1.createRow((short)1);

HSSFFont font=wb.createFont();
font.setFontHeightInPoints((short)14);
font.setColor(HSSFColor.GREY_80_PERCENT.index);
HSSFCellStyle style=wb.createCellStyle();
style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
style.setFont(font);

			
for(int rl=0;rl<choLen;rl++)
{
	if(choose[rl]==1)
	{
			HSSFCell cell=row1.createCell((short)rl);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue("姓名");
			cell.setCellStyle(style);
	}
	else if(choose[rl]==2)	
	{
		HSSFCell cell=row1.createCell((short)rl);
		cell.setEncoding(HSSFCell.ENCODING_UTF_16);
		cell.setCellValue("身份證字號");
					cell.setCellStyle(style);
	}
	else if(choose[rl]==3)	
	{
		HSSFCell cell=row1.createCell((short)rl);
		cell.setEncoding(HSSFCell.ENCODING_UTF_16);
		cell.setCellValue("生日");
					cell.setCellStyle(style);
	}
	else if(choose[rl]==4)	
	{
		HSSFCell cell=row1.createCell((short)rl);
		cell.setEncoding(HSSFCell.ENCODING_UTF_16);
		cell.setCellValue("部門");
					cell.setCellStyle(style);
	}
	else if(choose[rl]==5)	
	{
		HSSFCell cell=row1.createCell((short)rl);
		cell.setEncoding(HSSFCell.ENCODING_UTF_16);
		cell.setCellValue("職位");
					cell.setCellStyle(style);
	}
	else if(choose[rl]==6)	
	{
		HSSFCell cell=row1.createCell((short)rl);
		cell.setEncoding(HSSFCell.ENCODING_UTF_16);
		cell.setCellValue("班別");
					cell.setCellStyle(style);
	}
	else if(choose[rl]==7)	
	{
		HSSFCell cell=row1.createCell((short)rl);
		cell.setEncoding(HSSFCell.ENCODING_UTF_16);
		cell.setCellValue("年級");
					cell.setCellStyle(style);
	}
	else if(choose[rl]==8)	
	{
		HSSFCell cell=row1.createCell((short)rl);
		cell.setEncoding(HSSFCell.ENCODING_UTF_16);
		cell.setCellValue("班別");
					cell.setCellStyle(style);
	}
	else if(choose[rl]==9)	
	{
		HSSFCell cell=row1.createCell((short)rl);
		cell.setEncoding(HSSFCell.ENCODING_UTF_16);
		cell.setCellValue("手機");
					cell.setCellStyle(style);
	}
	else if(choose[rl]==10)	
	{
		HSSFCell cell=row1.createCell((short)rl);
		cell.setEncoding(HSSFCell.ENCODING_UTF_16);
		cell.setCellValue("Email");
					cell.setCellStyle(style);
	}
	else if(choose[rl]==11)	
	{
		HSSFCell cell=row1.createCell((short)rl);
		cell.setEncoding(HSSFCell.ENCODING_UTF_16);
		cell.setCellValue("家中電話1");
					cell.setCellStyle(style);
	}
	else if(choose[rl]==12)	
	{
		HSSFCell cell=row1.createCell((short)rl);
		cell.setEncoding(HSSFCell.ENCODING_UTF_16);
		cell.setCellValue("家中電話2");
					cell.setCellStyle(style);
	}
	else if(choose[rl]==13)	
	{
		HSSFCell cell=row1.createCell((short)rl);
		cell.setEncoding(HSSFCell.ENCODING_UTF_16);
		cell.setCellValue("家中電話3");
					cell.setCellStyle(style);
	}
	else if(choose[rl]==14)	
	{
		HSSFCell cell=row1.createCell((short)rl);
		cell.setEncoding(HSSFCell.ENCODING_UTF_16);
		cell.setCellValue("郵遞區號");
					cell.setCellStyle(style);
	}
	else if(choose[rl]==15)	
	{
		HSSFCell cell=row1.createCell((short)rl);
		cell.setEncoding(HSSFCell.ENCODING_UTF_16);
		cell.setCellValue("地址");
					cell.setCellStyle(style);
	}
	else if(choose[rl]==16)	
	{
		HSSFCell cell=row1.createCell((short)rl);
		cell.setEncoding(HSSFCell.ENCODING_UTF_16);
		cell.setCellValue("畢業學校");
					cell.setCellStyle(style);
	}
	else if(choose[rl]==17)	
	{
		HSSFCell cell=row1.createCell((short)rl);
		cell.setEncoding(HSSFCell.ENCODING_UTF_16);
		cell.setCellValue("性別");
		cell.setCellStyle(style);
	}
	
}




TeacherMgr sm=TeacherMgr.getInstance();
DepartMgr dmz=DepartMgr.getInstance();
PositionMgr pm=PositionMgr.getInstance();
ClassesMgr cmz=ClassesMgr.getInstance();
LevelMgr lmz=LevelMgr.getInstance();

for(int i=0;i<stuLen;i++)
{
	
// 建立橫行
HSSFRow row2=sheet1.createRow((short)(i+2));

// 中文的儲存格


	Teacher tea=(Teacher)sm.find(Integer.parseInt(stuId[i]));
	
	for(int k=0;k<choose.length;k++)
	{
		if(choose[k]==1)
		{
			HSSFCell cell=row2.createCell((short)k);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(tea.getTeacherFirstName()+tea.getTeacherLastName());
		}
		else if(choose[k]==2)
		{
			HSSFCell cell=row2.createCell((short)k);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(tea.getTeacherIdNumber());
		}
		else if(choose[k]==3)
		{
			
			HSSFCell cell=row2.createCell((short)k);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(jt.ChangeDateToString(tea.getTeacherBirth()));
		
		}
		else if(choose[k]==4)
		{
			HSSFCell cell=row2.createCell((short)k);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			
			if(tea.getTeacherDepart()==0)
			{
				cell.setCellValue("未定");
			}
			else
			{
				Depart de=(Depart)dmz.find(tea.getTeacherDepart());
				cell.setCellValue(de.getDepartName());
			}

			
		}
		else if(choose[k]==5)
		{
			HSSFCell cell=row2.createCell((short)k);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			
			if(tea.getTeacherPosition()==0)
			{
				cell.setCellValue("未定");
			}
			else
			{
				Position po=(Position)pm.find(tea.getTeacherPosition());
				cell.setCellValue(po.getPositionName());
			}
			
		}
		else if(choose[k]==6)
		{
			HSSFCell cell=row2.createCell((short)k);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			
			if(tea.getTeacherClasses()==0)
			{
				cell.setCellValue("未定");
			}
			else
			{
				Classes cla=(Classes)cmz.find(tea.getTeacherClasses());
				cell.setCellValue(cla.getClassesName());
			}
			
		}
		else if(choose[k]==7)
		{
			HSSFCell cell=row2.createCell((short)k);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			
			if(tea.getTeacherLevel()==0)
			{
				cell.setCellValue("未定");
			}
			else
			{
				Level le=(Level)lmz.find(tea.getTeacherLevel());
				cell.setCellValue(le.getLevelName());
			}
			
		}
		else if(choose[k]==9)
		{
			HSSFCell cell=row2.createCell((short)k);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(tea.getTeacherMobile());
		}
		else if(choose[k]==10)
		{
			HSSFCell cell=row2.createCell((short)k);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(tea.getTeacherEmail());
		}
		else if(choose[k]==11)
		{
			HSSFCell cell=row2.createCell((short)k);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(tea.getTeacherPhone());
		}
		else if(choose[k]==12)
		{
			HSSFCell cell=row2.createCell((short)k);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(tea.getTeacherPhone2());
		}
		else if(choose[k]==13)
		{
			HSSFCell cell=row2.createCell((short)k);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(tea.getTeacherPhone3());
		}
		else if(choose[k]==14)
		{
			HSSFCell cell=row2.createCell((short)k);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(tea.getTeacherZipCode());
		}
		else if(choose[k]==15)
		{
			HSSFCell cell=row2.createCell((short)k);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(tea.getTeacherAddress());
		}
		else if(choose[k]==16)
		{
			HSSFCell cell=row2.createCell((short)k);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(tea.getTeacherSchool());
		}
		else if(choose[k]==17)
		{
			HSSFCell cell=row2.createCell((short)k);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			
			if(tea.getTeacherSex()==1)
				cell.setCellValue("男");
			else if(tea.getTeacherSex()==2)
				cell.setCellValue("女");
		}
	}
	
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
ee.setExlPs(exlPs);

int eeId=em.createWithIdReturned(ee);


Exl es=(Exl)em.find(eeId);
%>

<meta http-equiv="Expires" content="0">

<br>
<blockquote>
<font size=2 color=red>檔案已產生!!</font><br><br>
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
		<tr bgcolor=#f0f0f0 class=es02>
		<td> 備註</td>
		<td bgcolor=ffffff><%=es.getExlPs()%></td>
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

</blockquote>
<!--- end 表單01 --->



<!--- end 主內容 --->


<%@ include file="bottom.jsp"%>	