<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,java.io.*" contentType="text/html;charset=UTF-8"%>
<%@ page import="org.apache.poi.hssf.usermodel.*" %>
<%@ page import="org.apache.poi.hssf.util.HSSFColor" %>
<%@ page import="org.apache.poi.hssf.util.Region" %>

<%
String parseDate=request.getParameter("date");
int classId=Integer.parseInt(request.getParameter("classId"));
int level=Integer.parseInt(request.getParameter("level"));
int status=Integer.parseInt(request.getParameter("status"));

SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM");
SimpleDateFormat sdf2=new SimpleDateFormat("yyyy-MM-dd");
Date runDate=sdf.parse(parseDate);
JsfAdmin ja=JsfAdmin.getInstance();
JsfTool jt=JsfTool.getInstance();
FeeAdmin fa=FeeAdmin.getInstance();
Feeticket[] ticket=ja.getFeeticketByClassStatus(runDate,3,status,classId,level);
ClassesMoney[] cm=ja.getAllClassesMoney(999);
DiscountType[] dt=ja.getAllDiscountType();

ClassesMgr claM=ClassesMgr.getInstance();
LevelMgr levM=LevelMgr.getInstance();

String claString="全部";
if(classId !=999)
{
	Classes cla=(Classes)claM.find(classId);
	claString=cla.getClassesName();
}
String levString="全部";

if(level !=999)
{
	Level lev=(Level)levM.find(level);
	levString=lev.getLevelName();
}

%>


<%
	String sType="";
	
	switch(status){
		case 0:
			sType="全部";
			break;
		case 1:
			sType="尚未繳款";
			break;
		case 90:
			sType="已繳清";
			break;
	}
%>

<%

Hashtable cmHa=new Hashtable();
Hashtable incomeItemHa=new Hashtable();
Hashtable cfdHa=new Hashtable();

for(int dti=0;dti<dt.length;dti++)
{
        cfdHa.put((String)String.valueOf(dt[dti].getId()),(String)dt[dti].getDiscountTypeName());
}

int[] cmTotal=new int[cm.length];
for(int j=0;j<cm.length;j++)
{
        incomeItemHa.put((String)String.valueOf(cm[j].getId()),(String)String.valueOf(cm[j].getClassesMoneyIncomeItem()));
	cmHa.put(String.valueOf(cm[j].getId()),cm[j].getClassesMoneyName());
	cmTotal[j]=0;
}






int allTotal=0;
int notpayTotal=0;
int[] allPayWay={0,0,0,0};

Hashtable stuHa=new Hashtable();
for(int i=0;i<ticket.length;i++)
{
	int stuId=ticket[i].getFeeticketStuId();
	
	if(stuHa.get(String.valueOf(stuId))==null)
	{
		
		Hashtable incomeHa=new Hashtable();
		stuHa.put((String)String.valueOf(stuId),(Hashtable)incomeHa);
	}	
	
	ClassesFee[] cf=ja.getClassesFeeByNumber(ticket[i].getFeeticketFeenumberId());
	
	if(cf ==null)
		continue;
	for(int i2=0;i2<cf.length;i2++)
	{
		Hashtable incomeHa=(Hashtable)stuHa.get(String.valueOf(stuId));
		String incomeSmallItem=(String)incomeItemHa.get(String.valueOf(cf[i2].getClassesFeeCMId()));

		if(!incomeHa.containsKey(incomeSmallItem))
		{
			Vector v=new Vector();
			v.add((ClassesFee)cf[i2]);
			
			
			incomeHa.put((String)incomeSmallItem,(Vector)v);
			stuHa.put((String)String.valueOf(stuId),(Hashtable)incomeHa);
			
			
		}else{
				
			Vector v=(Vector)incomeHa.get(incomeSmallItem);
			v.add((ClassesFee)cf[i2]);
			incomeHa.put((String)incomeSmallItem,(Vector)v);
			stuHa.put((String)String.valueOf(stuId),(Hashtable)incomeHa);
		}	
	
	}
}

IncomeSmallItem[] si=ja.getAllIncomeSmallItemByBID(1);

String exlTitle="財務報表  月份"+parseDate+" 班級: "+claString+"  年級:"+levString+" 形式:"+sType+" 製表日期:"+sdf2.format(new Date());




// 建立活頁簿
HSSFWorkbook wb=new HSSFWorkbook();
// 建立工作表
HSSFSheet sheet1=wb.createSheet("sheet1");
sheet1.setGridsPrinted(true);
sheet1.setHorizontallyCenter(true); 
sheet1.setVerticallyCenter(true);

sheet1.setMargin(sheet1.TopMargin,(double)0.2);
sheet1.setMargin(sheet1.LeftMargin,(double)0.05);
sheet1.setMargin(sheet1.RightMargin,(double)0.05);
sheet1.setMargin(sheet1.BottomMargin,(double)0.1);

HSSFPrintSetup hps=sheet1.getPrintSetup();
hps.setLandscape(true); 

 
HSSFFooter footer = sheet1.getFooter(); 

footer.setCenter( "page: " + HSSFFooter.page() + " of " + HSSFFooter.numPages() );
   

HSSFFont font=wb.createFont();
font.setFontHeightInPoints((short)8);
font.setColor(HSSFColor.GREY_80_PERCENT.index);

HSSFCellStyle style=wb.createCellStyle();
style.setAlignment(HSSFCellStyle.ALIGN_LEFT); 
style.setVerticalAlignment(HSSFCellStyle.VERTICAL_TOP);

style.setFont(font);
style.setWrapText(true);


//title style
HSSFFont font2=wb.createFont();
font2.setFontHeightInPoints((short)8);
font2.setColor(HSSFColor.GREY_80_PERCENT.index);
HSSFCellStyle style2=wb.createCellStyle();
style2.setAlignment(HSSFCellStyle.ALIGN_LEFT);
style2.setVerticalAlignment(HSSFCellStyle.VERTICAL_TOP);

style2.setFont(font2); 
style2.setWrapText(true);
// title
HSSFRow row0=sheet1.createRow((short)0);

sheet1.addMergedRegion(new Region(0,(short)0,0,(short)(si.length+1)));
HSSFCell cell0=row0.createCell((short)0);
cell0.setEncoding(HSSFCell.ENCODING_UTF_16);
cell0.setCellValue(exlTitle);
cell0.setCellStyle(style2);


// 項目
HSSFRow row1=sheet1.createRow((short)1);




HSSFCell cell2=row1.createCell((short)0);
cell2.setEncoding(HSSFCell.ENCODING_UTF_16);
cell2.setCellValue("姓名");
cell2.setCellStyle(style);

HSSFCell cell10=row1.createCell((short)1);
cell10.setEncoding(HSSFCell.ENCODING_UTF_16);
cell10.setCellValue("繳款日期");
cell10.setCellStyle(style);
			
for(int rl2=0;rl2<si.length;rl2++)
{
	int rl=rl2+2;
	HSSFCell cell=row1.createCell((short)rl);
	cell.setEncoding(HSSFCell.ENCODING_UTF_16);
	cell.setCellValue(si[rl2].getIncomeSmallItemName());
	cell.setCellStyle(style);
}

HSSFCell cell11=row1.createCell((short)(si.length+2));
cell11.setEncoding(HSSFCell.ENCODING_UTF_16);
cell11.setCellValue("合計");
cell11.setCellStyle(style);

HSSFCell cell3=row1.createCell((short)(si.length+3));
cell3.setEncoding(HSSFCell.ENCODING_UTF_16);
cell3.setCellValue("繳款明細");
cell3.setCellStyle(style);

HSSFCell cell4=row1.createCell((short)(si.length+4));
cell4.setEncoding(HSSFCell.ENCODING_UTF_16);
cell4.setCellValue("未繳款明細");
cell4.setCellStyle(style);




	Enumeration keys=stuHa.keys();
	Enumeration elements=stuHa.elements();
	StudentMgr sm=StudentMgr.getInstance();
	int i=0;
	while(elements.hasMoreElements())
	{
		int[] stuSum={0,0,0,0};
		int stuPayTotal=0;
		int stuFeeNumber=0;
		String key=(String)keys.nextElement();
		Hashtable data2Ha=(Hashtable)elements.nextElement();
		Student stu=(Student)sm.find(Integer.parseInt(key));	
		
		HSSFRow row2=sheet1.createRow((short)(i+2)); 
		
		i++;
		
		HSSFCell cell=row2.createCell((short)0);
		cell.setEncoding(HSSFCell.ENCODING_UTF_16);
		cell.setCellValue(stu.getStudentName());	
		cell.setCellStyle(style2);

		Feeticket[] ticket1=ja.getFeeticketByStuID(runDate,stu.getId(),status);

		
		String payDateString="";
		String payDetail="";		
		if(ticket1 !=null)
		{
			if(ticket[0].getFeeticketPayDate()!=null)
				payDateString=jt.ChangeDateToString(ticket[0].getFeeticketPayDate());
		
			for(int yo=0;yo<ticket1.length;yo++)
			{
				
				PayFee[] pfx=fa.getAllPayFeeByFeenumber(ticket1[yo].getFeeticketFeenumberId());
				if(pfx!=null)
				{
					payDetail+=fa.translateFeePay(pfx);
					stuPayTotal+=fa.sumFeePay(pfx);
					stuSum=fa.sumPayWay(pfx);
				
					for(int ol=0;ol<4;ol++) 
					{ 
						allPayWay[ol]+=stuSum[ol];
				
						if(ol==2)	
							System.out.println(stuSum[2]);	
					}

				} 
			}
		}
		
		
			
		HSSFCell cell7=row2.createCell((short)1);
		cell7.setEncoding(HSSFCell.ENCODING_UTF_16);
		cell7.setCellValue(payDateString);	
		cell7.setCellStyle(style2);

		for(int kz=0;kz<si.length;kz++)
		{
			int kz2=kz+2;
			String incomeItemId=String.valueOf(si[kz].getId());
		
			String showAll="";
			if(data2Ha.get(incomeItemId)!=null)
			{
				Vector vx=(Vector)data2Ha.get(incomeItemId);
				vx.trimToSize();
				Object[] classFeeV=vx.toArray();
				
				ClassesFee[] cfz=new ClassesFee[classFeeV.length];
				
				
				
				for(int op=0;op<classFeeV.length;op++)
				{
					cfz[op]=(ClassesFee)classFeeV[op];
					
					//add CM Name
					String cmName=(String)cmHa.get(String.valueOf(cfz[op].getClassesFeeCMId()));
					
					int feeTotal=cfz[op].getClassesFeeShouldNumber()-cfz[op].getClassesFeeTotalDiscount();
					
					showAll+=cmName+":"+feeTotal;
					
					if(cfz[op].getClassesFeeTotalDiscount() !=0)
					{
						showAll+="(應收-"+cfz[op].getClassesFeeShouldNumber()+";折扣-";
						CfDiscount[] cda=ja.getCfDiscountByCfid(cfz[op].getId());
						if(cda !=null)
						{
							for(int cdai=0;cdai<cda.length;cdai++)
							{
								String cfdType=(String)cfdHa.get(String.valueOf(cda[cdai].getCfDiscountTypeId()));
								String cfdNumber=String.valueOf(cda[cdai].getCfDiscountNumber());
								showAll+=cfdType+":"+cfdNumber+" ";
							}	
						}
						showAll +=")";
					}


					cmTotal[kz]+=feeTotal;
					allTotal +=feeTotal;
					stuFeeNumber+=feeTotal;
				}
			}
			cell4=row2.createCell((short)kz2);
			cell4.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell4.setCellValue(showAll+" ");
			
			HSSFCellStyle hcss=cell4.getCellStyle(); 
			hcss.setWrapText(true);
			cell4.setCellStyle(style2);
		}
		
		
		
		HSSFCell cell5=row2.createCell((short)(si.length+2));
		cell5.setEncoding(HSSFCell.ENCODING_UTF_16);
		cell5.setCellValue(String.valueOf(stuFeeNumber));
		cell5.setCellStyle(style2);

		
		HSSFCell cell13=row2.createCell((short)(si.length+3));
		cell13.setEncoding(HSSFCell.ENCODING_UTF_16);
		cell13.setCellValue(payDetail+" 合計:"+stuPayTotal);		
		cell13.setCellStyle(style2);

		int stuNotPay=stuFeeNumber-stuPayTotal;
		notpayTotal+=stuNotPay;
	
		HSSFCell cell16=row2.createCell((short)(si.length+4));
		cell16.setEncoding(HSSFCell.ENCODING_UTF_16);
		cell16.setCellValue("合計:"+stuNotPay);		
		cell16.setCellStyle(style2);
	
	}
	
HSSFRow row3=sheet1.createRow((short)(i+3));	
HSSFCell cell6=row3.createCell((short)(0));
cell6.setEncoding(HSSFCell.ENCODING_UTF_16);
cell6.setCellValue("合計");	
cell6.setCellStyle(style2);
for(int kz3=0;kz3<si.length;kz3++)
{
	int kz4=kz3+2;
	HSSFCell cell7=row3.createCell((short)kz4);
	cell7.setEncoding(HSSFCell.ENCODING_UTF_16);
	cell7.setCellValue(String.valueOf(cmTotal[kz3]));	
	cell7.setCellStyle(style2);
}
HSSFCell cell7=row3.createCell((short)(si.length+2));
cell7.setEncoding(HSSFCell.ENCODING_UTF_16);
cell7.setCellValue(String.valueOf(allTotal));
cell7.setCellStyle(style2);	
String PayString="";
for(int ol2=0;ol2<4;ol2++)
{
	switch(ol2)
	{
		case 2:PayString+="便利商店代收"+allPayWay[2]+" ";
			break;
		//case 1:PayString+="虛擬帳號"+allPayWay[1]+" ";
		//	break;
		case 0:PayString+="虛擬帳號"+allPayWay[0]+" ";
			break;
		case 3:PayString+="機構櫃臺"+allPayWay[3]+" ";
			break;
	}
}	
	


HSSFCell cell9=row3.createCell((short)(si.length+3));
cell9.setEncoding(HSSFCell.ENCODING_UTF_16);
cell9.setCellValue(PayString+" 合計:"+(allTotal-notpayTotal));	
cell9.setCellStyle(style2);	
HSSFCell cell100=row3.createCell((short)(si.length+4));
cell100.setEncoding(HSSFCell.ENCODING_UTF_16);
cell100.setCellValue("尚未收款合計:"+notpayTotal);		
cell100.setCellStyle(style2);	


String path=application.getRealPath("/");

Date nowX=new Date();
long nowLong=nowX.getTime();
String creatFile=String.valueOf(nowLong);
// 儲存
FileOutputStream fso=new FileOutputStream(path+"eSystem/exlfile/"+creatFile+".xls");
wb.write(fso);
fso.close();

%>
<%@ include file="jumpTop.jsp"%> 


<font size=2 color=red>檔案已產生!!</font><br><br>


<center>
<br>
	<table width="85%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
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

<br><br><br><br>

</head><body>
</body></html>


