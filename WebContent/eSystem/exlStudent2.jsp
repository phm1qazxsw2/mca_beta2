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

String[] tt=request.getParameterValues("tt");

//### 2009/1/23 by peter, 加上找出這些學生的 tag
StringBuffer sb = new StringBuffer();
for (int i=0; i<stuId.length; i++) {
    if (sb.length()>0) sb.append(",");
    sb.append(stuId[i]);
}
ArrayList<TagStudent> tagstudents = TagStudentMgr.getInstance().retrieveList("student.id in (" + sb.toString() + ")", "");
Map<String, ArrayList<TagStudent>> tagstudnetMap = new SortingMap(tagstudents).doSortA("getStudentTagKey");
//##############################################

//tagstudnetMap.get(studentId + "#" + typeId)

int stuLen=java.lang.reflect.Array.getLength(stuId);
SimpleDateFormat sdfX=new SimpleDateFormat("yyyy/MM/dd");

String[] choice=request.getParameterValues("choice");
if(choice==null)
{
	out.println("<br><br><blockquote>尚未選擇資料項目!!</blockquote>");
	return;
}

int choLen=java.lang.reflect.Array.getLength(choice);
int totalCum=0;
if(tt !=null)
    totalCum=choLen+tt.length;
    


int[] choose=new int[choLen];
for(int j=0;j<choLen;j++)
	choose[j]=Integer.parseInt(choice[j]);


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

// title
HSSFRow row0=sheet1.createRow((short)0);
sheet1.addMergedRegion(new Region(0,(short)0,0,(short)(totalCum-1)));
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

int nowRun=0;			
TagTypeMgr ttm=TagTypeMgr.getInstance();

for(int i=0;tt !=null && i<tt.length;i++){

        TagType ttXX=ttm.find("id='"+tt[i]+"'");

		HSSFCell cell=row1.createCell((short)nowRun);
		cell.setEncoding(HSSFCell.ENCODING_UTF_16);
		cell.setCellValue(ttXX.getName());
        cell.setCellStyle(style);
        sheet1.setColumnWidth((short)nowRun, (short) (12 * columnWidthUnit)); 
        nowRun++;
}

for(int rl=0;rl<choLen;rl++)
{
	if(choose[rl]==1)
	{
			HSSFCell cell=row1.createCell((short)nowRun);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
            if(pZ2.getCustomerType()==0){   
    			cell.setCellValue("姓名");
	        }else{
    			cell.setCellValue("客戶名稱");
            }
		    cell.setCellStyle(style);
            sheet1.setColumnWidth((short)nowRun, (short) (10 * columnWidthUnit)); 
            nowRun++;
	}
	else if(choose[rl]==2)	
	{
		HSSFCell cell=row1.createCell((short)nowRun);
		cell.setEncoding(HSSFCell.ENCODING_UTF_16);
		cell.setCellValue("English Name");
        cell.setCellStyle(style);
        sheet1.setColumnWidth((short)nowRun, (short) (12 * columnWidthUnit)); 
        nowRun++;
	}
	else if(choose[rl]==3)	
	{
		HSSFCell cell=row1.createCell((short)nowRun);
		cell.setEncoding(HSSFCell.ENCODING_UTF_16);
		cell.setCellValue("性別");
        cell.setCellStyle(style);
        sheet1.setColumnWidth((short)nowRun, (short) (4 * columnWidthUnit));
        nowRun++;
	}
	else if(choose[rl]==4)	
	{
		HSSFCell cell=row1.createCell((short)nowRun);
		cell.setEncoding(HSSFCell.ENCODING_UTF_16);
        if(pZ2.getCustomerType()==0)
		    cell.setCellValue("身份證字號");
        else
            cell.setCellValue("統一編號");
        cell.setCellStyle(style);
        sheet1.setColumnWidth((short)nowRun, (short) (15 * columnWidthUnit)); 
        nowRun++;
	}
	else if(choose[rl]==5)	
	{
		HSSFCell cell=row1.createCell((short)nowRun);
		cell.setEncoding(HSSFCell.ENCODING_UTF_16);
		cell.setCellValue("生日");
        cell.setCellStyle(style);
        sheet1.setColumnWidth((short)nowRun, (short) (12 * columnWidthUnit)); 
        nowRun++;
	} 
	else if(choose[rl]==18)	
	{
		HSSFCell cell=row1.createCell((short)nowRun);
		cell.setEncoding(HSSFCell.ENCODING_UTF_16);
		cell.setCellValue("生日");
        cell.setCellStyle(style);
        sheet1.setColumnWidth((short)nowRun, (short) (12 * columnWidthUnit)); 
        nowRun++;
	}
	else if(choose[rl]==6)	
	{
		HSSFCell cell=row1.createCell((short)nowRun);
		cell.setEncoding(HSSFCell.ENCODING_UTF_16);
        if(pZ2.getCustomerType()==0)        
		    cell.setCellValue("父親");
        else
		    cell.setCellValue("負責人");
        cell.setCellStyle(style);
        sheet1.setColumnWidth((short)nowRun, (short) (8 * columnWidthUnit)); 
        nowRun++;
	}
	else if(choose[rl]==7)	
	{
		HSSFCell cell=row1.createCell((short)nowRun);
		cell.setEncoding(HSSFCell.ENCODING_UTF_16);
        if(pZ2.getCustomerType()==0)
    		cell.setCellValue("父親手機1");
        else
            cell.setCellValue("負責人手機");
        cell.setCellStyle(style);
        sheet1.setColumnWidth((short)nowRun, (short) (12 * columnWidthUnit)); 
        nowRun++;
	}
	else if(choose[rl]==8)	
	{
		HSSFCell cell=row1.createCell((short)nowRun);
		cell.setEncoding(HSSFCell.ENCODING_UTF_16);
        if(pZ2.getCustomerType()==0)
    		cell.setCellValue("母親");
        else
    		cell.setCellValue("聯絡人");
        cell.setCellStyle(style);
        sheet1.setColumnWidth((short)nowRun, (short) (8 * columnWidthUnit)); 
        nowRun++;
	}
	else if(choose[rl]==9)	
	{
		HSSFCell cell=row1.createCell((short)nowRun);
		cell.setEncoding(HSSFCell.ENCODING_UTF_16);
        if(pZ2.getCustomerType()==0)
    		cell.setCellValue("母親手機");
        else
            cell.setCellValue("聯絡人手機");
        cell.setCellStyle(style);
        sheet1.setColumnWidth((short)nowRun, (short) (12 * columnWidthUnit)); 
        nowRun++;
	}
	else if(choose[rl]==10)	
	{
		HSSFCell cell=row1.createCell((short)nowRun);
		cell.setEncoding(HSSFCell.ENCODING_UTF_16);
        if(pZ2.getCustomerType()==0)
    		cell.setCellValue("家中電話1");
        else
    		cell.setCellValue("公司電話1");
        cell.setCellStyle(style);
        sheet1.setColumnWidth((short)nowRun, (short) (10 * columnWidthUnit)); 
        nowRun++;
	}
	else if(choose[rl]==11)	
	{
		HSSFCell cell=row1.createCell((short)nowRun);
		cell.setEncoding(HSSFCell.ENCODING_UTF_16);
        if(pZ2.getCustomerType()==0)
		    cell.setCellValue("家中電話2");
		else
		    cell.setCellValue("公司電話2");
        cell.setCellStyle(style);
        sheet1.setColumnWidth((short)nowRun, (short) (10 * columnWidthUnit)); 
        nowRun++;

	}
	else if(choose[rl]==12)	
	{
		HSSFCell cell=row1.createCell((short)nowRun);
		cell.setEncoding(HSSFCell.ENCODING_UTF_16);
		cell.setCellValue("傳真");
        cell.setCellStyle(style);
        sheet1.setColumnWidth((short)nowRun, (short) (10 * columnWidthUnit)); 
        nowRun++;

	}
	else if(choose[rl]==13)	
	{
		HSSFCell cell=row1.createCell((short)nowRun);
		cell.setEncoding(HSSFCell.ENCODING_UTF_16);
		cell.setCellValue("郵遞區號");
        cell.setCellStyle(style);
        sheet1.setColumnWidth((short)nowRun, (short) (8 * columnWidthUnit)); 
        nowRun++;

	}
	else if(choose[rl]==14)	
	{
		HSSFCell cell=row1.createCell((short)nowRun);
		cell.setEncoding(HSSFCell.ENCODING_UTF_16);
		cell.setCellValue("地址");
        cell.setCellStyle(style);
        sheet1.setColumnWidth((short)nowRun, (short) (40 * columnWidthUnit)); 
        nowRun++;
    }
    else if(choose[rl]==15)	
	{
		HSSFCell cell=row1.createCell((short)nowRun);
		cell.setEncoding(HSSFCell.ENCODING_UTF_16);
        if(pZ2.getCustomerType()==0)
		    cell.setCellValue("父親email");
		else
		    cell.setCellValue("負責人email");
        cell.setCellStyle(style);
        sheet1.setColumnWidth((short)nowRun, (short) (30 * columnWidthUnit)); 
        nowRun++;
	}
    else if(choose[rl]==16)	
	{
		HSSFCell cell=row1.createCell((short)nowRun);
		cell.setEncoding(HSSFCell.ENCODING_UTF_16);
        if(pZ2.getCustomerType()==0)
		    cell.setCellValue("母親email");
		else
		    cell.setCellValue("聯絡人email");
        cell.setCellStyle(style);
        sheet1.setColumnWidth((short)nowRun, (short) (30 * columnWidthUnit)); 
        nowRun++;
    }
}

StudentMgr sm=StudentMgr.getInstance();
DepartMgr dmz=DepartMgr.getInstance();
ClassesMgr cmz=ClassesMgr.getInstance();
LevelMgr lmz=LevelMgr.getInstance();

for(int i=0;i<stuLen;i++)
{
    HSSFRow row2=sheet1.createRow((short)(i+2));
	Student stu=(Student)sm.find(Integer.parseInt(stuId[i]));

    int rightNow2=0;        
    for(int k=0;tt !=null && k<tt.length;k++){

            ArrayList<TagStudent> ts=tagstudnetMap.get(stu.getId() + "#" + tt[k]);
            String tagValue="";
            for(int k2=0;ts !=null && k2 <ts.size();k2++){
                TagStudent tss=ts.get(k2);
                tagValue +=tss.getTagName()+" ";
            }

            HSSFCell cell=row2.createCell((short)rightNow2);
            cell.setEncoding(HSSFCell.ENCODING_UTF_16);
            cell.setCellValue(tagValue);
            rightNow2++;
    }
	
	for(int k=0;k<choose.length;k++)
	{
		if(choose[k]==1)
		{
			HSSFCell cell=row2.createCell((short)rightNow2);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(stu.getStudentName());
            rightNow2++;
		}
		else if(choose[k]==2)
		{
			HSSFCell cell=row2.createCell((short)rightNow2);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(stu.getStudentNickname());
            rightNow2++;
		}
		else if(choose[k]==3)
		{
			if(stu.getStudentSex()==1)
			{
				HSSFCell cell=row2.createCell((short)rightNow2);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue("男");
			}
			else
			{
				HSSFCell cell=row2.createCell((short)rightNow2);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue("女");
			}
            rightNow2++;
		}
		else if(choose[k]==4)
		{
			HSSFCell cell=row2.createCell((short)rightNow2);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(stu.getStudentIDNumber());
            rightNow2++;
		}
		else if(choose[k]==5)
		{
			HSSFCell cell=row2.createCell((short)rightNow2);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
	        if(stu.getStudentBirth() !=null)
    	    	cell.setCellValue(jt.ChangeDateToStringXX(stu.getStudentBirth()));
            else
    	    	cell.setCellValue("");

            rightNow2++;
		} 
		else if(choose[k]==18)
		{
			HSSFCell cell=row2.createCell((short)rightNow2);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
            if(stu.getStudentBirth() !=null)
    			cell.setCellValue(sdfX.format(stu.getStudentBirth()));
            else
    	    	cell.setCellValue("");

            rightNow2++;
		}
		
        else if(choose[k]==6)
		{
			HSSFCell cell=row2.createCell((short)rightNow2);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(stu.getStudentFather());
            rightNow2++;
		}
		else if(choose[k]==7)
		{
			HSSFCell cell=row2.createCell((short)rightNow2);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(stu.getStudentFatherMobile());
            rightNow2++;
		}
		else if(choose[k]==8)
		{
			HSSFCell cell=row2.createCell((short)rightNow2);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(stu.getStudentMother());
            rightNow2++;
		}
		else if(choose[k]==9)
		{
			HSSFCell cell=row2.createCell((short)rightNow2);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(stu.getStudentMotherMobile());
            rightNow2++;
		}
		else if(choose[k]==10)
		{
			HSSFCell cell=row2.createCell((short)rightNow2);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(stu.getStudentPhone());
            rightNow2++;
		}
		else if(choose[k]==11)
		{
			HSSFCell cell=row2.createCell((short)rightNow2);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(stu.getStudentPhone2());
            rightNow2++;
		}
		else if(choose[k]==12)
		{
			HSSFCell cell=row2.createCell((short)rightNow2);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(stu.getStudentPhone3());
            rightNow2++;
		}
		else if(choose[k]==13)
		{
			HSSFCell cell=row2.createCell((short)rightNow2);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(stu.getStudentZipCode());
            rightNow2++;
		}
		else if(choose[k]==14)
		{
			HSSFCell cell=row2.createCell((short)rightNow2);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(stu.getStudentAddress());
            rightNow2++;
		}
		else if(choose[k]==15)
		{
			HSSFCell cell=row2.createCell((short)rightNow2);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(stu.getStudentFatherEmail());
            rightNow2++;
		}
		else if(choose[k]==16)
		{
			HSSFCell cell=row2.createCell((short)rightNow2);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(stu.getStudentMotherEmail());
            rightNow2++;
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
    <%@ include file="bottom.jsp"%>	