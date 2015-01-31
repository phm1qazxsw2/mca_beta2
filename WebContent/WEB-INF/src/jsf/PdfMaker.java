package jsf;

import java.util.*;
import jsi.*;
import java.text.*;
import java.io.*;
import com.lowagie.text.*;
import com.lowagie.text.pdf.PdfWriter;
import com.lowagie.text.pdf.PdfContentByte;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.Barcode39;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.Chunk;
import com.lowagie.text.pdf.*;
import com.lowagie.text.Chapter;

public class PdfMaker
{
    private static PdfMaker instance;
    
    PdfMaker() {}
    
    public synchronized static PdfMaker getInstance()
    {
		try{
    		JsfAuth jax=JsfAuth.getInstance();
    		if(!jax.getCouldWork())
				return null;

		}catch(Exception e){}

        if (instance==null)
        {
            instance = new PdfMaker();
        }
        return instance;
    }
    
    private int runNowPDF=0;
    private int totalNumPDF=0;
    private String PDFFileString="";
    

    public int makeTagPage(String path,String[] showContent,int widNum,int heiNum,int grid,int[] marge,String fileName,int fsize)
    {
        try{

            String fontPath=path+"/font/simsun.ttc,0";
			BaseFont bfComic = BaseFont.createFont(fontPath,BaseFont.IDENTITY_H,BaseFont.NOT_EMBEDDED);
			Font font14b = new Font(bfComic, 14,Font.BOLD);
			Font font14 = new Font(bfComic, 14,Font.NORMAL);
			Font font12b = new Font(bfComic, 12,Font.BOLD);
			Font font12 = new Font(bfComic, 12,Font.NORMAL);
			Font font10 = new Font(bfComic, 10,Font.NORMAL);
			Font font10b = new Font(bfComic, 10,Font.BOLD);
			Font font8 = new Font(bfComic, 8,Font.NORMAL);

            Font defaultF=null;

            if(fsize==1)
                defaultF=new Font(bfComic, 10,Font.BOLD);
            else if(fsize==2)
                defaultF=new Font(bfComic, 12,Font.BOLD);
            else
                defaultF=new Font(bfComic, 14,Font.BOLD);

            JsfAdmin ja=JsfAdmin.getInstance();

            Document document=new Document(PageSize.A4,marge[0],marge[1],marge[2],marge[3]);
            String path2=path+"tag";

            File f=new File(path2);
            
            if(!f.exists())
            {
                f.mkdir();	
            }      

			// step 4

            float width = (float)594-(float)marge[0]-(float)marge[1]; //document.getPageSize().getWidth();
			float height = (float)840-(float)marge[2]-(float)marge[3]; //document.getPageSize().getHeight();

            float widEach=(float)100/(float)widNum;

			float[] columnDefinitionSize =new float[widNum]; 

            for(int k=0;k<columnDefinitionSize.length;k++)
            {
                columnDefinitionSize[k]=widEach;
            }

			float pos = (float)(height / (float)heiNum);
     
            path2=path2+"/"+fileName+".pdf";            
           
            PdfWriter writer2=PdfWriter.getInstance(document, new FileOutputStream(path2));
            
            document.open();

            PdfPTable table = new PdfPTable(columnDefinitionSize);
			if(grid==0)
                table.getDefaultCell().setBorder(0);
			table.setHorizontalAlignment(0);
			table.setTotalWidth(width);
			table.setLockedWidth(true);

            int totalEach=widNum*heiNum;
            
            if(showContent.length > totalEach)
                  totalEach=showContent.length;
       
            PdfPCell cell2=null;

            for(int i=0;i<totalEach;i++)
            {

                if(i < showContent.length){
    			    cell2= new PdfPCell(new Paragraph(showContent[i],defaultF));
                }else{
    			    cell2= new PdfPCell(new Paragraph("",defaultF));
                }
			    if(grid==0)
                    cell2.setBorder(0);
                cell2.setFixedHeight(pos);
                cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
                cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
                table.addCell(cell2);
            }                
       			
			table.setWidthPercentage(100);
			document.add(table);

			//table.writeSelectedRows(0, -1, 0, 200, writer2.getDirectContent());

            document.close();
    }
    catch(Exception e)
    {
        
    }	

    return 90;	
    	
    }
    
     public int makePDFsPage(int feenumber[],String path,int classid,boolean isFa)
    {
    	
	    	try{
	    		JsfAdmin ja=JsfAdmin.getInstance();
		    	String fileMonth=String.valueOf(feenumber[0]).substring(0,4);
		    	Document document=new Document(PageSize.A4,15,15,10,10);
				String path2=path+fileMonth;
			
				File f=new File(path);
				
				if(!f.exists())
				{
					f.mkdir();	
				}
				
				if(isFa)
                {
					path2=path2+"/"+String.valueOf(classid)+"a.pdf";
				    PDFFileString=fileMonth+"/"+String.valueOf(classid)+"a.pdf";;    
                }else{
					path2=path2+"/"+String.valueOf(classid)+"b.pdf";
                    PDFFileString=fileMonth+"/"+String.valueOf(classid)+"b.pdf";;    
                }


                
                totalNumPDF=feenumber.length;

				PdfWriter writer2=PdfWriter.getInstance(document, new FileOutputStream(path2));
				
				writer2.setViewerPreferences(PdfWriter.PageModeUseOutlines);
				
				document.open();
			
				
	            //	writer2.setPageEvent(new Bookmarks());						
				PaySystemMgr psm=PaySystemMgr.getInstance();
				PaySystem pSystem=(PaySystem)psm.find(1); 
				
				for(int i=0;i<feenumber.length;i++)
				{
					if(i!=0)
					{
					document.newPage();
					}
				
					Feeticket ft=ja.getFeeticketByNumberId(feenumber[i]);
					
					if(ft==null)
					{
						return 0;
					}
					
					makePageContent2(ft,writer2,document,path,pSystem,i+1);
					setFeeticketStatusAfterPrint(ft);
		    	
                    runNowPDF=i+1;
				}
				document.close();
		}
		catch(Exception e)
		{
			
		}	
	
		return 90;	
    	
    }
    
    public int getTotalNumPDF()
    {
        return totalNumPDF;
    }
    

    public int getRunNow()
    {
        return runNowPDF;
    }

    public String getPDFFileString()
    { 
            
        return PDFFileString;
    }
  /*  
    
    public int makePDFsPageX(int feenumber[],String path,int classid,boolean isFa,String filename)
    {
    	
    	try{
    		JsfAdmin ja=JsfAdmin.getInstance();
	    	String fileMonth=String.valueOf(feenumber[0]).substring(0,4);
	    	Document document=new Document(PageSize.A4,15,15,10,10);
		String path2=path+fileMonth;
		
		File f=new File(path);
		
		if(!f.exists())
		{
			f.mkdir();	
		}
		
		if(isFa)
			path2=path2+"/"+String.valueOf(classid)+filename+".pdf";
		else
			path2=path2+"/"+String.valueOf(classid)+filename+".pdf";
					
		PdfWriter writer2=PdfWriter.getInstance(document, new FileOutputStream(path2));
		document.open();
		
		for(int i=0;i<feenumber.length;i++)
		{
			if(i!=0)
			{
			document.newPage();
			}
		
			Feeticket ft=ja.getFeeticketByNumberId(feenumber[i]);
			
			if(ft==null)
			{
				return 0;
			}
			makePageContent(ft,writer2,document,path);
			
			setFeeticketStatusAfterPrint(ft);
    	
		}
		document.close();
		
	}
	catch(Exception e)
	{
		
	}	
	return 90;	
    	
    }
*/

	public int makeEmailPDF(Feeticket fee,String path)
    {
    	try{
    		
            String fontPath=path+"/font/simsun.ttc,0";
	    	Document document=new Document(PageSize.A4,15,15,10,10);
			String path2=path+"email/"+String.valueOf(fee.getFeeticketFeenumberId())+".pdf";		
			
			PdfWriter writer2=PdfWriter.getInstance(document, new FileOutputStream(path2));
			document.open();
			JsfAdmin ja=JsfAdmin.getInstance();

			PaySystemMgr psm=PaySystemMgr.getInstance();
			PaySystem pSystem=(PaySystem)psm.find(1); 
			int status=makePageContent2(fee,writer2,document,path,pSystem,1);
    	
    		setFeeticketStatusAfterPrint(fee);
    	
    		document.close();
    		
    		return status;
    	}catch(Exception e)
    	{
    		System.out.println("error:"+e.getMessage());	
    	}
    	
    	return 90;	
    }
    
    public int makePDFSinglePage(int feenumber,String path,boolean isF1)
    {
    	try{
    		
	    	String fileMonth=String.valueOf(feenumber).substring(0,4);
	    	
	    	Document document=new Document(PageSize.A4,15,15,10,10);

			String path2=path+fileMonth;
			
			File f=new File(path2);
			
			if(!f.exists())
			{
				f.mkdir();	
			}
		
			if(isF1){
				path2=path2+"/"+String.valueOf(feenumber)+"1.pdf";		
			}else{
				path2=path2+"/"+String.valueOf(feenumber)+"2.pdf";		
			}
			PdfWriter writer2=PdfWriter.getInstance(document, new FileOutputStream(path2));
			
			document.open();
			
			JsfAdmin ja=JsfAdmin.getInstance();
		
			Feeticket ft=ja.getFeeticketByNumberId(feenumber);
			
			if(ft==null)
			{
				return 0;
			}
			
			PaySystemMgr psm=PaySystemMgr.getInstance();
			PaySystem pSystem=(PaySystem)psm.find(1); 
			int status=makePageContent2(ft,writer2,document,path,pSystem,1);
    	
    		setFeeticketStatusAfterPrint(ft);
    	
    		document.close();
    		
    		return status;
    	}catch(Exception e)
    	{
    		System.out.println("error:"+e.getMessage());	
    	}
    	
    	return 90;	
    }
    
    public int makePDFFinanceDaily(String path,Date sDate,Date eDate,boolean isF1,User ud3)
    {
    	try{
	    	
			File f=new File(path);
			
			if(!f.exists())
			{
				f.mkdir();	
			}
		
			String filePath="";
			if(isF1){
				filePath=path+"/daily/1.pdf";		
			}else{
				filePath=path+"/daily/2.pdf";		
			}

			Document document=new Document(PageSize.A4,15,15,10,10);
			PdfWriter writer2=PdfWriter.getInstance(document, new FileOutputStream(filePath));
			
			document.open();
			
			PaySystemMgr psm=PaySystemMgr.getInstance();
			PaySystem pSystem=(PaySystem)psm.find(1); 
			
			makeDailyContent(document,writer2,path,pSystem,sDate,eDate,ud3);  //損益表	
    	
    		document.close();
    		

    	}catch(Exception e)
    	{
    		System.out.println("error:"+e.getMessage());	
    	}
    	
    	return 90;	
    }
  	
  	public boolean makeDailyContent(Document document,PdfWriter writer2,String path,PaySystem e,Date sDate,Date eDate,User ud3)	
  	{
  		  	try{

    		PdfContentByte cb = writer2.getDirectContent();
		
			String fontPath=path+"/font/simsun.ttc,0";
			String logoImge=path+"/font/logo.tif";
	
			String henryImgeS=path+"/font/bg.tif";
			Image henryI2=Image.getInstance(henryImgeS);
			henryI2.setAbsolutePosition(200,400);
			document.add(henryI2);
			
			
			henryImgeS=path+"/font/confidential.tif";
			henryI2=Image.getInstance(henryImgeS);
			henryI2.setAbsolutePosition(420,100);
			document.add(henryI2);
			
	
			BaseFont bfComic = BaseFont.createFont(fontPath,BaseFont.IDENTITY_H,BaseFont.NOT_EMBEDDED);
			Font font14b = new Font(bfComic, 14,Font.BOLD);
			Font font14 = new Font(bfComic, 14,Font.NORMAL);
			Font font12b = new Font(bfComic, 12,Font.BOLD);
			Font font12 = new Font(bfComic, 12,Font.NORMAL);
			Font font10 = new Font(bfComic, 10,Font.NORMAL);
			Font font10b = new Font(bfComic, 10,Font.BOLD);
			Font font8 = new Font(bfComic, 8,Font.NORMAL);
			
			SimpleDateFormat sdfX2=new SimpleDateFormat("yyyy/MM/01"); 
			SimpleDateFormat sdfX3=new SimpleDateFormat("yyyy/MM/dd"); 

			String strTitle=e.getPaySystemCompanyName()+"\n";
			Paragraph parag1=new Paragraph(strTitle,font14b);
			parag1.setAlignment(Element.ALIGN_CENTER);
			document.add(parag1);
			
			
			SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM");
			SimpleDateFormat sdf2=new SimpleDateFormat("yyyy/MM/01");
			SimpleDateFormat sdf3=new SimpleDateFormat("yyyy/MM/dd");

			
			strTitle="日記帳";
			parag1=new Paragraph(strTitle,font10);
			parag1.setAlignment(Element.ALIGN_CENTER);
			document.add(parag1);
			
			strTitle=sdf3.format(sDate)+"-"+sdf3.format(eDate)+"\n\n\n";
			parag1=new Paragraph(strTitle,font10);
			parag1.setAlignment(Element.ALIGN_CENTER);
			document.add(parag1);
			
			Image  logoI= Image.getInstance(logoImge);
	        logoI.setAbsolutePosition(10,770);
			document.add(logoI);
			
			
						
			
			
			JsfPay jp=JsfPay.getInstance();
			
			Costpay[] cps=jp.getReportCostpay(sDate,eDate);
			
			
			
			if(cps==null)
			{
				strTitle="\n\n沒有資料";
				parag1=new Paragraph(strTitle,font10);
				parag1.setAlignment(Element.ALIGN_CENTER);
				document.add(parag1);
				
				return false;
			}
			
			DecimalFormat mnf = new DecimalFormat("###,###,##0");
			
			Hashtable ha=jp.getOrderDateByCostpay(cps); 
			long duringDateL=((long)eDate.getTime()-(long)sDate.getTime())/(long)(1000*60*60*24);


				
			float[] widths2 = {0.12f, 0.05f,0.05f,0.2f,0.38f,0.2f,0.2f};
			
			
			PdfPTable table2 = new PdfPTable(widths2);
			PdfPCell cell2 = new PdfPCell(new Paragraph("製表日期:"+sdfX3.format(new Date()),font10b));
			cell2.setColspan(7);
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			cell2 = new PdfPCell(new Paragraph("交易日期 ",font8));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("",font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);

			cell2 = new PdfPCell(new Paragraph("",font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
						
			cell2 = new PdfPCell(new Paragraph("科目內容",font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
		
			cell2 = new PdfPCell(new Paragraph("摘要",font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("借方金額",font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("貸方金額",font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
		
			int total=0;
			for(int i=0;i<(int)duringDateL+1;i++)
			{ 
				long startlong=(long)sDate.getTime()+(long)(1000*60*60*24)*i;
			  
			   	Date runDate=new Date(startlong);
			   
			   	Hashtable dataha=(Hashtable)ha.get(sdf3.format(runDate)); 	
			   	
			   	boolean haveDate=false;
			   	
			   	if(dataha !=null)
			   	{
					Vector v1=(Vector)dataha.get((String)"1");
					
					if(v1 !=null)	
					{
						if(!haveDate)
						{
							cell2 = new PdfPCell(new Paragraph(sdf3.format(runDate),font8));
							cell2.setFixedHeight(20f);
							cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
							cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
							table2.addCell(cell2);
							
							cell2 = new PdfPCell(new Paragraph("",font8));
							cell2.setColspan(6);
							cell2.setFixedHeight(20f);
							cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
							cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
							table2.addCell(cell2);
				
				
							haveDate =true;
						} 

					cell2 = new PdfPCell(new Paragraph("",font8));
					cell2.setFixedHeight(20f);
					cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
					cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
					table2.addCell(cell2);
					
					cell2 = new PdfPCell(new Paragraph("支出",font8));
					cell2.setFixedHeight(20f);
					cell2.setColspan(6);
					cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
					cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
					table2.addCell(cell2);
					

					v1.trimToSize();
					Costpay[] cpCost=(Costpay[])v1.toArray(new Costpay[v1.size()]);
		
					int totalCost=0;
					for(int j=0;j<cpCost.length;j++)	
					{		
						totalCost += cpCost[j].getCostpayCostNumber() ;
		 
						total += cpCost[j].getCostpayCostNumber() ;
 
						cell2 = new PdfPCell(new Paragraph("",font8));
						//cell2.setFixedHeight(20f);
						cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
						cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
						table2.addCell(cell2);
						
						
						cell2 = new PdfPCell(new Paragraph("借",font8));
						//cell2.setFixedHeight(20f);
						cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
						cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
						table2.addCell(cell2);
						
						
						cell2 = new PdfPCell(new Paragraph("",font8));
						//cell2.setFixedHeight(20f);
						cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
						cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
						table2.addCell(cell2);

						cell2 = new PdfPCell(new Paragraph(jp.getCostpayContentForPDF(cpCost[j]),font8));
						cell2.setColspan(2);
						//cell2.setFixedHeight(20f);
						cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
						cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
						table2.addCell(cell2);	
						
						cell2 = new PdfPCell(new Paragraph(mnf.format(cpCost[j].getCostpayCostNumber()),font8));
						
						//cell2.setFixedHeight(20f);
						cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
						cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
						table2.addCell(cell2);	
						
						cell2 = new PdfPCell(new Paragraph("",font8));
						//cell2.setFixedHeight(20f);
						cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
						cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
						table2.addCell(cell2);	
					}
					
						cell2 = new PdfPCell(new Paragraph("",font8));
						//cell2.setFixedHeight(20f);
						cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
						cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
						table2.addCell(cell2);
						
						
						cell2 = new PdfPCell(new Paragraph("",font8));
						//cell2.setFixedHeight(20f);
						cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
						cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
						table2.addCell(cell2);
						
						
						cell2 = new PdfPCell(new Paragraph("貸",font8));
						//cell2.setFixedHeight(20f);
						cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
						cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
						table2.addCell(cell2);

						cell2 = new PdfPCell(new Paragraph("         現金",font8));
						cell2.setColspan(2);
						//cell2.setFixedHeight(20f);
						cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
						cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
						table2.addCell(cell2);	
						
							cell2 = new PdfPCell(new Paragraph("",font8));
						//cell2.setFixedHeight(20f);
						cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
						cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
						table2.addCell(cell2);	
						
						cell2 = new PdfPCell(new Paragraph(mnf.format(totalCost),font8));
						//cell2.setFixedHeight(20f);
						cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
						cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
						table2.addCell(cell2);	
						
				}
				
				Vector v0=(Vector)dataha.get((String)"0");
		
				if(v0 !=null)	
				{
		
			if(!haveDate)
			{
				cell2 = new PdfPCell(new Paragraph(sdf3.format(runDate),font8));
				//cell2.setFixedHeight(20f);
				cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
				table2.addCell(cell2);
				
				cell2 = new PdfPCell(new Paragraph("",font8));
				cell2.setColspan(6);
				//cell2.setFixedHeight(20f);
				cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
				table2.addCell(cell2);
	
				haveDate =true;
			} 
			v0.trimToSize();
			Costpay[] cpIncome=(Costpay[])v0.toArray(new Costpay[v0.size()]);

			int totalIncome=0;

			StringBuffer outString=new StringBuffer();
			
			for(int j=0;j<cpIncome.length;j++)	
			{
				 totalIncome +=cpIncome[j].getCostpayIncomeNumber();
			}
			
			total += totalIncome ;
			
			
			cell2 = new PdfPCell(new Paragraph("",font8));
			//cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("收入",font8));
			//cell2.setFixedHeight(20f);
			cell2.setColspan(6);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
					
			
			cell2 = new PdfPCell(new Paragraph("",font8));
			//cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);

			cell2 = new PdfPCell(new Paragraph("借",font8));
			//cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);

			cell2 = new PdfPCell(new Paragraph("",font8));
			//cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("現金",font8));
			cell2.setColspan(2);
			//cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);

			cell2 = new PdfPCell(new Paragraph(mnf.format(totalIncome),font8));
			//cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			cell2 = new PdfPCell(new Paragraph("",font8));
			//cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			for(int j=0;j<cpIncome.length;j++)	
			{
 
					cell2 = new PdfPCell(new Paragraph("",font8));
					//cell2.setFixedHeight(20f);
					cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
					cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
					table2.addCell(cell2);
					
					
					cell2 = new PdfPCell(new Paragraph("",font8));
					//cell2.setFixedHeight(20f);
					cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
					cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
					table2.addCell(cell2);
					
					
					cell2 = new PdfPCell(new Paragraph("貸",font8));
					//cell2.setFixedHeight(20f);
					cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
					cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
					table2.addCell(cell2);

					cell2 = new PdfPCell(new Paragraph("     "+jp.getCostpayContentForPDF(cpIncome[j]),font8));
					cell2.setColspan(2);
					//cell2.setFixedHeight(20f);
					cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
					cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
					table2.addCell(cell2);	
					
					cell2 = new PdfPCell(new Paragraph("",font8));
					//cell2.setFixedHeight(20f);
					cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
					cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
					table2.addCell(cell2);	
					
					cell2 = new PdfPCell(new Paragraph(mnf.format(cpIncome[j].getCostpayIncomeNumber()),font8));
					//cell2.setFixedHeight(20f);
					cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
					cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
					table2.addCell(cell2);		
					
			}
 
			
			}	
		}
	}
		
		cell2 = new PdfPCell(new Paragraph("合計",font8));
		cell2.setColspan(5);
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);	
		
		cell2 = new PdfPCell(new Paragraph(mnf.format(total),font12b));
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);	
		
		
		cell2 = new PdfPCell(new Paragraph(mnf.format(total),font12b));
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);	

		
		
			cell2 = new PdfPCell(new Paragraph("製表日期:"+sdfX3.format(new Date())+"  製表人:"+ud3.getUserFullname(),font10));
			cell2.setColspan(7);
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);

			table2.setWidthPercentage(90);
			document.add(table2);
			
		}catch(Exception ex){
			return false;			
		}
		
		return true;

  	}
    public int makePDFFinancePage(String path,Date runDate,boolean isF1,int[] fiReport,User ud3)
    {
    	try{
	    	
			File f=new File(path);
			
			if(!f.exists())
			{
				f.mkdir();	
			}
		
			String filePath="";
			if(isF1){
				filePath=path+"/finance/1.pdf";		
			}else{
				filePath=path+"/finance/2.pdf";		
			}

			Document document=new Document(PageSize.A4,15,15,10,10);
			PdfWriter writer2=PdfWriter.getInstance(document, new FileOutputStream(filePath));
			
			document.open();
			
			PaySystemMgr psm=PaySystemMgr.getInstance();
			PaySystem pSystem=(PaySystem)psm.find(1); 
			
			for(int i=0;i<fiReport.length;i++)
			{
				if(i!=0)
				{
					document.newPage();
				}
				switch(fiReport[i]){
					
					case 1:
						makeType1Content(document,writer2,path,pSystem,runDate,ud3);  //損益表	
						break;
					case 2:
						makeType2Content(document,writer2,path,pSystem,runDate,ud3);  //資產負債表		
						break;
					case 3:
						makeType3Content(document,writer2,path,pSystem,runDate,ud3);  //現金調節表		
						break;
					case 4:
						makeType4Content(document,writer2,path,pSystem,runDate,ud3);  //現金分佈表		
						break;
					case 5:
					
						SimpleDateFormat sdf2=new SimpleDateFormat("yyyy/MM/01");
						SimpleDateFormat sdf3=new SimpleDateFormat("yyyy/MM/dd");
						
						String startDateS=sdf2.format(runDate);
						Date sDate=sdf2.parse(startDateS);
						
						Utility u=Utility.getInstance();
						String endStringS=u.getLastDateInMonth(runDate);
					 	Date eDate=sdf3.parse(endStringS);

						makeDailyContent(document,writer2,path,pSystem,sDate,eDate,ud3);
						break;
					case 6:
						makeType6Content(document,writer2,path,pSystem,runDate,ud3);  //股東權益變動
						break;	
				}
			}    		
    	
    		document.close();
    		

    	}catch(Exception e)
    	{
    		System.out.println("error:"+e.getMessage());	
    	}
    	
    	return 90;	
    }
    
    public int makeDotradePage(String path,boolean isF1,int[] dotradeId,User ud3)
    {
    	try{
	    	
			File f=new File(path);
			
			if(!f.exists())
			{
				f.mkdir();	
			}
		
			String filePath="";
			if(isF1){
				filePath=path+"/dotrade/1.pdf";		
			}else{
				filePath=path+"/dotrade/2.pdf";		
			}

			Document document=new Document(PageSize.A4,15,15,10,10);
			PdfWriter writer2=PdfWriter.getInstance(document, new FileOutputStream(filePath));
			
			document.open();
			
			makeDotradeContent(document,writer2,dotradeId,ud3,path);
    	
    		document.close();
    		

    	}catch(Exception e)
    	{
    		System.out.println("error:"+e.getMessage());	
    	}
    	
    	return 90;	
    }
    
    public boolean makeDotradeContent(Document document,PdfWriter writer2,int[] dotradeId,User ud3,String path)	
    {
    		
    	try{
    		PdfContentByte cb = writer2.getDirectContent();
		
			String fontPath=path+"/font/simsun.ttc,0";
			String logoImge=path+"/font/logo.tif";
	
			Image  logoI= Image.getInstance(logoImge);
	        logoI.setAbsolutePosition(10,770);
			document.add(logoI);
				
			String henryImgeS=path+"/font/bg.tif";
			Image henryI2=Image.getInstance(henryImgeS);
			henryI2.setAbsolutePosition(200,400);
			document.add(henryI2);
			
	
			BaseFont bfComic = BaseFont.createFont(fontPath,BaseFont.IDENTITY_H,BaseFont.NOT_EMBEDDED);
			Font font14b = new Font(bfComic, 14,Font.BOLD);
			Font font14 = new Font(bfComic, 14,Font.NORMAL);
			Font font12b = new Font(bfComic, 12,Font.BOLD);
			Font font12 = new Font(bfComic, 12,Font.NORMAL);
			Font font10 = new Font(bfComic, 10,Font.NORMAL);
			Font font10b = new Font(bfComic, 10,Font.BOLD);
			Font font8 = new Font(bfComic, 8,Font.NORMAL);
			
			SimpleDateFormat sdfX3=new SimpleDateFormat("yyyy/MM/dd"); 

			PaySystemMgr em=PaySystemMgr.getInstance();
			PaySystem e=(PaySystem)em.find(1);

				
			String strTitle=e.getPaySystemCompanyName()+"\n";
			Paragraph parag1=new Paragraph(strTitle,font14b);
			parag1.setAlignment(Element.ALIGN_CENTER);
			document.add(parag1);
			
			strTitle="匯款單\n\n\n";
			parag1=new Paragraph(strTitle,font10);
			parag1.setAlignment(Element.ALIGN_CENTER);
			document.add(parag1);
			
			float[] widths2 = {0.15f, 0.20f,0.15f,0.15f,0.15f,0.20f};

			PdfPTable table2 =null;
			PdfPCell cell2=null;
			
			TradeaccountMgr tmx2=TradeaccountMgr.getInstance();
			BankAccountMgr bam2=BankAccountMgr.getInstance();
			CostpayMgr cpm=CostpayMgr.getInstance();
			CostbookMgr cbm=CostbookMgr.getInstance();
			ClientAccountMgr cam=ClientAccountMgr.getInstance();
			DoTradeMgr dtm=DoTradeMgr.getInstance();
			UserMgr um=UserMgr.getInstance(); 
 
			int payTotal=0;
			
			for(int i=0;i<dotradeId.length;i++)
			{
				DoTrade dt=(DoTrade)dtm.find(dotradeId[i]);				
				Costpay cp=(Costpay)cpm.find(dt.getDoTradeCostpayId());
				
				payTotal+=cp.getCostpayCostNumber();
				int xId=0;
				String tradeType="";	
				String tradeTitle="";
				if(cp.getCostpayCostbookId()!=0)
				{
					tradeType="雜費支出";
					
					xId=cp.getCostpayCostbookId();
					Costbook cb2=(Costbook)cbm.find(xId);
					tradeTitle=cb2.getCostbookName()+"(傳票號碼:"+cb2.getCostbookCostcheckId()+" 付款序號:"+cp.getId()+")";
				}
				
				User u=(User)um.find(dt.getDoTradeUserId()); 
				ClientAccount ca=(ClientAccount)cam.find(dt.getDoTradeClientAccountId());
				
				
				int j=i+1;
				String strTitle2="序號: "+ j+"  入帳項目:"+tradeTitle+" 登入人:"+u.getUserFullname()+"\n\n";
				
				parag1=new Paragraph(strTitle2,font10);
				parag1.setAlignment(Element.ALIGN_LEFT);
				document.add(parag1);
				
				table2=new PdfPTable(widths2);
				cell2 = new PdfPCell(new Paragraph("解款行庫",font10));
				cell2.setFixedHeight(20f);
				cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
				table2.addCell(cell2);
	
				cell2 = new PdfPCell(new Paragraph(ca.getClientAccountBankName(),font10b));
				cell2.setFixedHeight(20f);
				cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
				cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
				table2.addCell(cell2);
				
				cell2 = new PdfPCell(new Paragraph("代號",font10));
				cell2.setFixedHeight(20f);
				cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
				table2.addCell(cell2);
	
				cell2 = new PdfPCell(new Paragraph(ca.getClientAccountBankNum(),font10b));
				cell2.setFixedHeight(20f);
				cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
				cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
				table2.addCell(cell2);
				
				cell2 = new PdfPCell(new Paragraph("分行",font10));
				cell2.setFixedHeight(20f);
				cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
				table2.addCell(cell2);
	
				cell2 = new PdfPCell(new Paragraph(ca.getClientAccountBankBranchName(),font10b));
				cell2.setFixedHeight(20f);
				cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
				cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
				table2.addCell(cell2);
				
				cell2 = new PdfPCell(new Paragraph("金額",font10));
				cell2.setColspan(2);
				cell2.setFixedHeight(20f);
				cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
				cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
				table2.addCell(cell2);
	
				String chineseNum=getChineseNum(cp.getCostpayCostNumber());
	
				cell2 = new PdfPCell(new Paragraph(chineseNum+"整  "+String.valueOf(cp.getCostpayCostNumber())+".-",font10));
				cell2.setFixedHeight(20f);
				cell2.setColspan(4);
				cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
				table2.addCell(cell2);


				cell2 = new PdfPCell(new Paragraph("收款人帳號",font10));
				cell2.setColspan(2);
				cell2.setFixedHeight(20f);
				cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
				cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
				table2.addCell(cell2);
	
				cell2 = new PdfPCell(new Paragraph(ca.getClientAccountAccountNum(),font10b));
				cell2.setFixedHeight(20f);
				cell2.setColspan(4);
				cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
				table2.addCell(cell2);
				
				
				cell2 = new PdfPCell(new Paragraph("收款人戶名",font10));
				cell2.setColspan(2);
				cell2.setFixedHeight(20f);
				cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
				cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
				table2.addCell(cell2);
	
				cell2 = new PdfPCell(new Paragraph(ca.getClientAccountAccountName(),font10b));
				cell2.setFixedHeight(20f);
				cell2.setColspan(4);
				cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
				table2.addCell(cell2);
				
				
				cell2 = new PdfPCell(new Paragraph("取款方式",font10));
				cell2.setFixedHeight(20f);
				cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
				cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
				table2.addCell(cell2);
				
				String payWayX="";
				if(cp.getCostpayAccountType()==1)
					payWayX="現金";
				else
					payWayX="銀行帳戶";	
	
				cell2 = new PdfPCell(new Paragraph(payWayX,font10b));
				cell2.setFixedHeight(20f);
				cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
				cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
				table2.addCell(cell2);
				
				cell2 = new PdfPCell(new Paragraph("取款帳戶",font10));
				cell2.setFixedHeight(20f);
				cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
				cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
				table2.addCell(cell2);
				
				String payAccount="";
				BankAccount ba=null;
				if(cp.getCostpayAccountType()==1)	
				{
					Tradeaccount  td=(Tradeaccount)tmx2.find(cp.getCostpayAccountId()); 
					payAccount+=td.getTradeaccountName();
				
				}else if(cp.getCostpayAccountType()==2){
					ba=(BankAccount)bam2.find(cp.getCostpayAccountId()); 
					payAccount+=ba.getBankAccountName();
				}		
	
				cell2 = new PdfPCell(new Paragraph(payAccount,font10b));
				cell2.setColspan(3);
				cell2.setFixedHeight(20f);
				cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
				table2.addCell(cell2);
				
				if(cp.getCostpayAccountType()==2)	
				{
					cell2 = new PdfPCell(new Paragraph("取款帳號",font10));
					cell2.setColspan(2);
					cell2.setFixedHeight(20f);
					cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
					cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
					table2.addCell(cell2);
		
					cell2 = new PdfPCell(new Paragraph(ba.getBankAccountAccount(),font10b));
					cell2.setFixedHeight(20f);
					cell2.setColspan(4);
					cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
					cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
					table2.addCell(cell2);
					
					
					cell2 = new PdfPCell(new Paragraph("取款戶名",font10));
					cell2.setColspan(2);
					cell2.setFixedHeight(20f);
					cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
					cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
					table2.addCell(cell2);
		
					cell2 = new PdfPCell(new Paragraph(ba.getBankAccountAccountName(),font10b));
					cell2.setFixedHeight(20f);
					cell2.setColspan(4);
					cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
					cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
					table2.addCell(cell2);
				}
				
						
				table2.setWidthPercentage(90);
				document.add(table2);
				
				strTitle="\n\n";
				parag1=new Paragraph(strTitle,font10);
				parag1.setAlignment(Element.ALIGN_CENTER);
				document.add(parag1);
			}
			
			String strTitleX="總金額: "+payTotal+"\n";
			parag1=new Paragraph(strTitleX,font12);
			parag1.setAlignment(Element.ALIGN_CENTER);
			document.add(parag1);	

				
			strTitleX="製單人:"+ud3.getUserFullname()+" 製單日期:"+sdfX3.format(new Date());
			parag1=new Paragraph(strTitleX,font10);
			parag1.setAlignment(Element.ALIGN_RIGHT);
			document.add(parag1);	

		}catch(Exception ex){
			
			return false;			
		}	
    
    	return true;		
   }	 
   
   public String getChineseNum(int num)
   {
   		
   		if(num==0)
   			return "零";
   			
   		String numString=String.valueOf(num);
   		
   		String endString="";
   		for(int i=0;i<numString.length();i++)
   		{
   			
   			int k=i+1;
			String dollarS=getDollarString(k);

			int j=numString.length()-i-1;
   			String nownum=numString.substring(j,j+1);
   			
   	
   			String numS=getNumString(Integer.parseInt(nownum));	
   			
   			endString=numS+dollarS+endString;
   		}
		return endString;
	}
	
	public String getNumString(int num)
	{
		switch(num)
		{
			case 0:
				return "零";
			case 1:
				return "壹";
			case 2:
				return "貳";	
			case 3:
				return "參";
			case 4:
				return "肆";
			case 5:
				return "伍";
			case 6:
				return "陸";
			case 7:
				return "柒";
			case 8:
				return "捌";
			case 9:
				return "玖";
			default:
				return "";
		}	
	}
	public String getDollarString(int num)
	{
		switch(num)
		{
			case 1:
				return "元";
			case 2:
				return "拾";	
			case 3:
				return "佰";
			case 4:
				return "仟";
			case 5:
				return "萬";
			case 6:
				return "拾";
			case 7:
				return "佰";
			case 8:
				return "仟";
			case 9:
				return "億";
			default:
				return "";
		}
				
	}
    
    public boolean makeType6Content(Document document,PdfWriter writer2,String path,PaySystem e,Date runDate,User ud3)	
    {
    		
    	try{
    		PdfContentByte cb = writer2.getDirectContent();
		
			String fontPath=path+"/font/simsun.ttc,0";
			String logoImge=path+"/font/logo.tif";
	
			String henryImgeS=path+"/font/bg.tif";
			Image henryI2=Image.getInstance(henryImgeS);
			henryI2.setAbsolutePosition(200,400);
			document.add(henryI2);
			
			
			
			henryImgeS=path+"/font/confidential.tif";
			henryI2=Image.getInstance(henryImgeS);
			henryI2.setAbsolutePosition(420,100);
			document.add(henryI2);
			
	
			BaseFont bfComic = BaseFont.createFont(fontPath,BaseFont.IDENTITY_H,BaseFont.NOT_EMBEDDED);
			Font font14b = new Font(bfComic, 14,Font.BOLD);
			Font font14 = new Font(bfComic, 14,Font.NORMAL);
			Font font12b = new Font(bfComic, 12,Font.BOLD);
			Font font12 = new Font(bfComic, 12,Font.NORMAL);
			Font font10 = new Font(bfComic, 10,Font.NORMAL);
			Font font10b = new Font(bfComic, 10,Font.BOLD);
			Font font8 = new Font(bfComic, 8,Font.NORMAL);
			
			SimpleDateFormat sdfX2=new SimpleDateFormat("yyyy/MM/01"); 
			SimpleDateFormat sdfX3=new SimpleDateFormat("yyyy/MM/dd"); 

			String strTitle=e.getPaySystemCompanyName()+"\n";
			Paragraph parag1=new Paragraph(strTitle,font14b);
			parag1.setAlignment(Element.ALIGN_CENTER);
			document.add(parag1);
			
			strTitle="股東權益變動表\n\n\n";
			parag1=new Paragraph(strTitle,font10);
			parag1.setAlignment(Element.ALIGN_CENTER);
			document.add(parag1);
			
			Image  logoI= Image.getInstance(logoImge);
	        logoI.setAbsolutePosition(10,770);
			document.add(logoI);


						
			DecimalFormat nf = new DecimalFormat("###,##0.00");
	  		DecimalFormat mnf = new DecimalFormat("###,###,##0");
	 
            if (1==1)
                throw new RuntimeException("obsolete!");

			JsfPay jp=JsfPay.getInstance();
			Owner[] ow=jp.getAllOwner(null);

			if(ow==null)
			{
		
				String strTitle2="目前沒有股東帳戶\n\n\n";
				parag1=new Paragraph(strTitle2,font10);
				parag1.setAlignment(Element.ALIGN_CENTER);
				document.add(parag1);
				
				return false;
				
			}
			
			Utility u=Utility.getInstance();				
			
			String endString=u.getLastDateInMonth(runDate);
		
			Ownertrade[] ot=jp.getOwnertradeBeforeDate(sdfX3.parse(endString));
			
			if(ot==null)
			{
				String strTitle2="目前交易資料\n\n\n";
				parag1=new Paragraph(strTitle2,font10);
				parag1.setAlignment(Element.ALIGN_CENTER);
				document.add(parag1);
				return false;
			}
		
			Hashtable ha=new Hashtable();
			
			int totalAll=0;
			for(int i=0;i<ot.length;i++)
			{
				String otIdS=String.valueOf(ot[i].getOwnertradeOwnerId());
				String total=(String)ha.get(otIdS);
				
				
				int nowNum=0;
				if(ot[i].getOwnertradeInOut()==1)
					nowNum=ot[i].getOwnertradeNumber();
				else if(ot[i].getOwnertradeInOut()==0)
					nowNum=ot[i].getOwnertradeNumber()*-1;
				
				totalAll +=nowNum ;
				
				if(total==null)
				{
					ha.put(otIdS,String.valueOf(nowNum));
				}else{
				
					int oldTotal=Integer.parseInt(total);
					int nowTotal=oldTotal+nowNum;
					ha.put(otIdS,String.valueOf(nowTotal));
				}
			}
	 		
	 		
	 		
			parag1=new Paragraph("結算截止日期:"+endString+"\n\n\n",font10);
			parag1.setAlignment(Element.ALIGN_LEFT);
			document.add(parag1);
			
			float[] widths2 = {0.40f, 0.30f,0.30f};

			PdfPTable table2 = new PdfPTable(widths2);
			PdfPCell cell2 = new PdfPCell(new Paragraph("帳戶名稱",font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);

			cell2 = new PdfPCell(new Paragraph("提取總額",font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			cell2 = new PdfPCell(new Paragraph("比例",font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			for(int i=0;i<ow.length;i++)
			{
				int accountNum=0;
				
				String numS=(String)ha.get(String.valueOf(ow[i].getId()));
				
				if(numS!=null)
					accountNum=Integer.parseInt(numS);
				float percentX=(float)accountNum/(float)totalAll;
				
			
				cell2 = new PdfPCell(new Paragraph(ow[i].getOwnerName(),font10));
				cell2.setFixedHeight(20f);
				cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
				table2.addCell(cell2);
				
				cell2 = new PdfPCell(new Paragraph(mnf.format(accountNum),font10b));
				cell2.setFixedHeight(20f);
				cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
				cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
				table2.addCell(cell2);
	
				cell2 = new PdfPCell(new Paragraph(nf.format(percentX)+"%",font10b));
				cell2.setFixedHeight(20f);
				cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
				cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
				table2.addCell(cell2);
			}
			
			
			cell2 = new PdfPCell(new Paragraph("製表日期:"+sdfX3.format(new Date())+"  製表人:"+ud3.getUserFullname(),font10));
			cell2.setColspan(3);
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			table2.setWidthPercentage(90);
			document.add(table2);

            if (1==1){
                throw new RuntimeException("obsolete!");
            }	
	
			Ownertrade[] ot2=jp.getAllOwnertrade(null);

			if(ot2==null)
			{
				parag1=new Paragraph("沒有交易資料",font10);
				parag1.setAlignment(Element.ALIGN_LEFT);
				document.add(parag1);
				
				return false;
			}
			
				parag1=new Paragraph("\n\n",font10);
				parag1.setAlignment(Element.ALIGN_LEFT);
				document.add(parag1);
			
			OwnerMgr om=OwnerMgr.getInstance();
			UserMgr um=UserMgr.getInstance();

			float[] widths3 = {0.2f, 0.15f,0.25f,0.15f,0.15f,0.1f};

			table2 = new PdfPTable(widths3);
			cell2 = new PdfPCell(new Paragraph("股東挹注/提取交易明細            至:"+sdfX3.format(new Date()),font10b));
			cell2.setColspan(6);
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);

			cell2 = new PdfPCell(new Paragraph("入帳日期",font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("股東名稱",font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("交易帳戶",font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("支出",font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("存入",font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("登入人",font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
				
			int allTotal=0;
			for(int i=0;i<ot2.length;i++)
			{
				if(ot2[i].getOwnertradeInOut()==1)
					allTotal-=ot2[i].getOwnertradeNumber();
				
				if(ot[i].getOwnertradeInOut()==0)	
					allTotal+=ot2[i].getOwnertradeNumber();		
			
				cell2 = new PdfPCell(new Paragraph(sdfX3.format(ot2[i].getOwnertradeAccountDate()),font10));
				cell2.setFixedHeight(20f);
				cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
				table2.addCell(cell2);

				Owner ow2=(Owner)om.find(ot2[i].getOwnertradeOwnerId());
			
				cell2 = new PdfPCell(new Paragraph(ow2.getOwnerName(),font10));
				cell2.setFixedHeight(20f);
				cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
				table2.addCell(cell2);

				String accountName="";
				if(ot2[i].getOwnertradeAccountType()==1)
					accountName="零用金帳戶-";
				else
					accountName="銀行帳戶-";

				if(ot2[i].getOwnertradeAccountType()==1)	
				{
					TradeaccountMgr tmx2=TradeaccountMgr.getInstance();
					Tradeaccount  td=(Tradeaccount)tmx2.find(ot[i].getOwnertradeAccountId()); 
					accountName+=td.getTradeaccountName();

				}else if(ot2[i].getOwnertradeAccountType()==2){
					BankAccountMgr bam2=BankAccountMgr.getInstance();
					BankAccount ba=(BankAccount)bam2.find(ot[i].getOwnertradeAccountId()); 
					accountName+=ba.getBankAccountName();
				}		

				cell2 = new PdfPCell(new Paragraph(accountName,font10));
				cell2.setFixedHeight(20f);
				cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
				table2.addCell(cell2);

				if(ot2[i].getOwnertradeInOut()==1)
				{
					cell2 = new PdfPCell(new Paragraph(mnf.format(ot2[i].getOwnertradeNumber()),font10));
					cell2.setFixedHeight(20f);
					cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
					cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
					table2.addCell(cell2);

					cell2 = new PdfPCell(new Paragraph("",font10));
					cell2.setFixedHeight(20f);
					cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
					cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
					table2.addCell(cell2);
				}else{
					
					cell2 = new PdfPCell(new Paragraph("",font10));
					cell2.setFixedHeight(20f);
					cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
					cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
					table2.addCell(cell2);

					cell2 = new PdfPCell(new Paragraph(mnf.format(ot2[i].getOwnertradeNumber()),font10));
					cell2.setFixedHeight(20f);
					cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
					cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
					table2.addCell(cell2);
						
				}

				User u2=(User)um.find(ot2[i].getOwnertradeLogId());

				cell2 = new PdfPCell(new Paragraph(u2.getUserFullname(),font10));
				cell2.setFixedHeight(20f);
				cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
				cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
				table2.addCell(cell2);
		}	
		
			cell2 = new PdfPCell(new Paragraph("合計",font10b));
			cell2.setColspan(4);
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
	
			cell2 = new PdfPCell(new Paragraph(mnf.format(allTotal),font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("",font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);	
	
			cell2 = new PdfPCell(new Paragraph("製表日期:"+sdfX3.format(new Date())+"  製表人:"+ud3.getUserFullname(),font10));
			cell2.setColspan(6);
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			table2.setWidthPercentage(90);
			document.add(table2);

	
	
		}catch(Exception ex){
			
			return false;			
		}	
    
    	return true;		
   }	 
    public boolean makeType4Content(Document document,PdfWriter writer2,String path,PaySystem e,Date runDate,User ud3)	
    {
    		
    	try{
    		PdfContentByte cb = writer2.getDirectContent();
		
			String fontPath=path+"/font/simsun.ttc,0";
			String logoImge=path+"/font/logo.tif";
	
			String henryImgeS=path+"/font/bg.tif";
			Image henryI2=Image.getInstance(henryImgeS);
			henryI2.setAbsolutePosition(200,400);
			document.add(henryI2);
			
			
			henryImgeS=path+"/font/confidential.tif";
			henryI2=Image.getInstance(henryImgeS);
			henryI2.setAbsolutePosition(420,100);
			document.add(henryI2);
			
	
			BaseFont bfComic = BaseFont.createFont(fontPath,BaseFont.IDENTITY_H,BaseFont.NOT_EMBEDDED);
			Font font14b = new Font(bfComic, 14,Font.BOLD);
			Font font14 = new Font(bfComic, 14,Font.NORMAL);
			Font font12b = new Font(bfComic, 12,Font.BOLD);
			Font font12 = new Font(bfComic, 12,Font.NORMAL);
			Font font10 = new Font(bfComic, 10,Font.NORMAL);
			Font font10b = new Font(bfComic, 10,Font.BOLD);
			Font font8 = new Font(bfComic, 8,Font.NORMAL);
			
			SimpleDateFormat sdfX2=new SimpleDateFormat("yyyy/MM/01"); 
			SimpleDateFormat sdfX3=new SimpleDateFormat("yyyy/MM/dd"); 

			String strTitle=e.getPaySystemCompanyName()+"\n";
			Paragraph parag1=new Paragraph(strTitle,font14b);
			parag1.setAlignment(Element.ALIGN_CENTER);
			document.add(parag1);
			
			strTitle="現金帳戶分佈\n\n\n";
			parag1=new Paragraph(strTitle,font10);
			parag1.setAlignment(Element.ALIGN_CENTER);
			document.add(parag1);
			
			Image  logoI= Image.getInstance(logoImge);
	        logoI.setAbsolutePosition(10,770);
			document.add(logoI);


						
			DecimalFormat nf = new DecimalFormat("###,##0.00");
	  		DecimalFormat mnf = new DecimalFormat("###,###,##0");
	 
			SalaryAdmin sa=SalaryAdmin.getInstance();

            if (1==1)
                throw new RuntimeException("obsolete!");

			JsfPay jp=JsfPay.getInstance();
			Tradeaccount[] tradeA=jp.getAllTradeaccount(null);
	
			//SalarybankAuth[] sa1=jp.getSalarybankAuthByUserId(ud2); 
	
			int totalTrade=tradeA.length;
		
			
			Costpay[] cp=jp.getAccountType1Costpay();
	 
			if(cp==null)
	  		{
	  			document.add(new Paragraph("\n\n沒有零用金交易資料",font10b));
				
	  			return false;
	  		}

					
			Costpay[] bcp=jp.getAccountType2Costpay();
	 
			
			if(bcp==null)
	  		{
	  			document.add(new Paragraph("\n\n沒有銀行交易資料",font10b));
	  			return false;
	  		}
			
	 		
	 		Hashtable allTrade=jp.getTradeAcccountNum(cp);		
			Hashtable incomeHa=(Hashtable)allTrade.get("in"); 
			Hashtable costHa=(Hashtable)allTrade.get("co"); 
			
			
			float[] widths2 = {0.15f, 0.18f,0.18f,0.24f,0.25f};
			
			
			PdfPTable table2 = new PdfPTable(widths2);
			PdfPCell cell2 = new PdfPCell(new Paragraph("日期:"+sdfX3.format(new Date()),font10b));
			cell2.setColspan(5);
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			


			cell2 = new PdfPCell(new Paragraph("",font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
		
			cell2 = new PdfPCell(new Paragraph("帳戶名稱",font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);

			cell2 = new PdfPCell(new Paragraph("支出",font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			cell2 = new PdfPCell(new Paragraph("存入",font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			cell2 = new PdfPCell(new Paragraph("帳戶餘額",font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("零用金帳戶",font10b));
			cell2.setColspan(5);
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
		int costTotal=0;
		int  incomeTotal=0;
		
		int tradeNum[]=new int[tradeA.length]; 
		for(int tI=0;tI<tradeA.length;tI++)
		{
			tradeNum[tI]=0; 
		}	
		int total2=0;	
		int totalAccountNum=0;
		for(int j=0;j<tradeA.length;j++)
		{
			cell2 = new PdfPCell(new Paragraph("",font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
		
			cell2 = new PdfPCell(new Paragraph(tradeA[j].getTradeaccountName(),font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);

			
			int cost=0; 
			if(costHa.get(String.valueOf(tradeA[j].getId()))==null)
			{
				cost=0;
					//out.println(income);
			}else{
				String costS=(String)costHa.get(String.valueOf(tradeA[j].getId()));
				
				cost=Integer.parseInt(costS);
			}
				
			costTotal += cost;


			cell2 = new PdfPCell(new Paragraph(mnf.format(cost),font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);

			int income=0; 
			
			if(incomeHa.get(String.valueOf(tradeA[j].getId()))==null)
			{
				income=0;
			}else{
				String incomeS=(String)incomeHa.get(String.valueOf(tradeA[j].getId()));
			
				income=Integer.parseInt(incomeS);
			}
			
			incomeTotal +=income; 
			tradeNum[j]=income-cost;
			
			cell2 = new PdfPCell(new Paragraph(mnf.format(income),font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			cell2 = new PdfPCell(new Paragraph(mnf.format(income-cost),font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
		}	
	
			cell2 = new PdfPCell(new Paragraph("零用金合計",font10b));
			cell2.setColspan(2);
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);


			cell2 = new PdfPCell(new Paragraph(mnf.format(costTotal),font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);

			cell2 = new PdfPCell(new Paragraph(mnf.format(incomeTotal),font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			cell2 = new PdfPCell(new Paragraph(mnf.format(incomeTotal-costTotal),font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);		
			
			total2=incomeTotal-costTotal;
			
			cell2 = new PdfPCell(new Paragraph("銀行帳戶",font10b));
			cell2.setColspan(5);
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);

            if (1==1)
                throw new RuntimeException("obsolete!");

			BankAccount[] ba=sa.getAllBankAccount(null);
	
			int btotalTrade=ba.length;
	 		
			Hashtable bincomeHa=new Hashtable();
			Hashtable bcostHa=new Hashtable();
			
			for(int i=0;i<bcp.length;i++)
			{
				if(bcp[i].getCostpayNumberInOut()==1)
				{
					if(bcostHa.get(String.valueOf(bcp[i].getCostpayAccountId()))==null)
					{
						bcostHa.put(String.valueOf(bcp[i].getCostpayAccountId()),String.valueOf(bcp[i].getCostpayCostNumber()));
						
					}else{
						
						String oldCost=(String)bcostHa.get(String.valueOf(bcp[i].getCostpayAccountId())); 
						
						int nowTotal=bcp[i].getCostpayCostNumber()+Integer.parseInt(oldCost);
						
						bcostHa.put(String.valueOf(bcp[i].getCostpayAccountId()),String.valueOf(nowTotal));
					}
				}else{
					if(bincomeHa.get(String.valueOf(bcp[i].getCostpayAccountId()))==null)
					{
						bincomeHa.put(String.valueOf(bcp[i].getCostpayAccountId()),String.valueOf(bcp[i].getCostpayIncomeNumber()));
						
					}else{
						
						String oldCost=(String)bincomeHa.get(String.valueOf(bcp[i].getCostpayAccountId()));
						int nowTotal=bcp[i].getCostpayIncomeNumber()+Integer.parseInt(oldCost);
						
						bincomeHa.put(String.valueOf(bcp[i].getCostpayAccountId()),String.valueOf(nowTotal));
					}
				
				}
			}
			int baNum[] =null;
		
			
			int bcostTotal=0;
			int  bincomeTotal=0;
			
			baNum=new int[ba.length]; 
			for(int bI=0;bI<ba.length;bI++)
			{
				baNum[bI]=0; 
			}	
			
			for(int j=0;j<ba.length;j++)
			{
				cell2 = new PdfPCell(new Paragraph("",font10));
				cell2.setFixedHeight(20f);
				cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
				table2.addCell(cell2);
			
				cell2 = new PdfPCell(new Paragraph(ba[j].getBankAccountName(),font10));
				cell2.setFixedHeight(20f);
				cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
				cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
				table2.addCell(cell2);
	
			
				int cost=0; 
				if(bcostHa.get(String.valueOf(ba[j].getId()))==null)
				{
					cost=0;
					//out.println(income);
				}else{
					String costS=(String)bcostHa.get(String.valueOf(ba[j].getId()));
					
					cost=Integer.parseInt(costS);
				}
					
				bcostTotal += cost; 
				costTotal += cost;
	
				cell2 = new PdfPCell(new Paragraph(mnf.format(cost),font10));
				cell2.setFixedHeight(20f);
				cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
				cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
				table2.addCell(cell2);
				
				int income=0; 
				
				if(bincomeHa.get(String.valueOf(ba[j].getId()))==null)
				{
					income=0;
					//out.println(income);
				}else{
					String incomeS=(String)bincomeHa.get(String.valueOf(ba[j].getId()));
					
					income=Integer.parseInt(incomeS);
				}
					
				bincomeTotal +=income;
				baNum[j]=income-cost;			
			
				cell2 = new PdfPCell(new Paragraph(mnf.format(income),font10));
				cell2.setFixedHeight(20f);
				cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
				cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
				table2.addCell(cell2);
				
				
				cell2 = new PdfPCell(new Paragraph(mnf.format(income-cost),font10));
				cell2.setFixedHeight(20f);
				cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
				cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
				table2.addCell(cell2);
			}
		
			cell2 = new PdfPCell(new Paragraph("銀行帳戶合計",font10b));
			cell2.setColspan(2);
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);


			cell2 = new PdfPCell(new Paragraph(mnf.format(bcostTotal),font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);

			cell2 = new PdfPCell(new Paragraph(mnf.format(bincomeTotal),font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			cell2 = new PdfPCell(new Paragraph(mnf.format(bincomeTotal-bcostTotal),font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);		
				
			total2+=bincomeTotal-bcostTotal;

					
			cell2 = new PdfPCell(new Paragraph("現金合計",font10b));
			cell2.setColspan(4);
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph(mnf.format(total2),font12b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
					
						
			cell2 = new PdfPCell(new Paragraph("製表日期:"+sdfX3.format(new Date())+"  製表人:"+ud3.getUserFullname(),font10));
			cell2.setColspan(4);
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);


			table2.setWidthPercentage(90);
			document.add(table2);

			
		}catch(Exception ex){
			
			return false;
		}
			
		return true;			
    }
    public boolean makeType3Content(Document document,PdfWriter writer2,String path,PaySystem e,Date runDate,User ud3)	
    {
    		
    	try{
    		PdfContentByte cb = writer2.getDirectContent();
		
			String fontPath=path+"/font/simsun.ttc,0";
			String logoImge=path+"/font/logo.tif";
	
	
			String henryImgeS=path+"/font/bg.tif";
			Image henryI2=Image.getInstance(henryImgeS);
			henryI2.setAbsolutePosition(200,400);
			document.add(henryI2);
			
			
			henryImgeS=path+"/font/confidential.tif";
			henryI2=Image.getInstance(henryImgeS);
			henryI2.setAbsolutePosition(420,100);
			document.add(henryI2);
			
		
			BaseFont bfComic = BaseFont.createFont(fontPath,BaseFont.IDENTITY_H,BaseFont.NOT_EMBEDDED);
			Font font14b = new Font(bfComic, 14,Font.BOLD);
			Font font14 = new Font(bfComic, 14,Font.NORMAL);
			Font font12b = new Font(bfComic, 12,Font.BOLD);
			Font font12 = new Font(bfComic, 12,Font.NORMAL);
			Font font10 = new Font(bfComic, 10,Font.NORMAL);
			Font font10b = new Font(bfComic, 10,Font.BOLD);
			Font font8 = new Font(bfComic, 8,Font.NORMAL);
			
			JsfPay jp=JsfPay.getInstance();
	
			SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM");
			SimpleDateFormat sdf2=new SimpleDateFormat("yyyy-MM-dd");
			SimpleDateFormat sdf3=new SimpleDateFormat("yyyy-MM-dd HH:mm");
			
			DecimalFormat nf = new DecimalFormat("###,##0.00");
			DecimalFormat mnf = new DecimalFormat("###,###,##0");
		
			
			Closemonth[] cm=jp.getClosemonth(runDate);
			
			if(cm ==null)
			{ 
				String strTitle=e.getPaySystemCompanyName()+"\n現金調節表\n";
				Paragraph parag1=new Paragraph(strTitle,font14b);
				parag1.setAlignment(Element.ALIGN_CENTER);
				document.add(parag1);
			
				strTitle="目前沒有結帳的月份";
				parag1=new Paragraph(strTitle,font10);
				parag1.setAlignment(Element.ALIGN_CENTER);
				document.add(parag1);
			
				
				return true;
			} 
		 
			
			int oldCase=0;
			int oldShould=0;
			int paySum =0; 
		  
		  
		 	int oldIncomeCase=0;
			int oldIncomeShould=0;
			int incomeSum =0; 
		
			if(cm.length>1)
			{
				for(int i=1;i<cm.length;i++)	
				{
		 	 
		 	 	 	oldIncomeCase +=cm[i].getClosemonthIncomeNum();
				 	oldIncomeShould +=cm[i].getClosemonthIncomeNotNum();
		
					oldCase +=cm[i].getClosemonthFeesNum();
				 	oldShould +=cm[i].getClosemonthFeesNotNum();
				}
		 
				
				paySum=jp.closefeeBeforeMonth(runDate);	
				incomeSum=jp.closeincomeBeforeMonth(runDate);	
			}		
			int closeX1=cm[0].getClosemonthFeesNum()+oldCase+paySum;
			int closeX2=cm[0].getClosemonthFeesNotNum()+oldShould-paySum; 
			
		
		 
			int getFeetotal=0;
			int getSalaryTotal=0; 
			int salarytotalCash=0; 
			int salarytotalNotCash=0; 
		
			
			int incomeCash=0;
			int incomeShould=0;
			int costCash=0;
			int costShould=0;  
			
			int costtotalCash=0;  
			int costtotalNotCash=0;
		
			if(cm!=null)
			{ 
				for(int i=0;i<cm.length;i++)
				{
		
				incomeCash+=cm[i].getClosemonthIncomeNum();
				incomeShould+=cm[i].getClosemonthIncomeNotNum();
				costCash+=cm[i].getClosemonthCostNum();
				costShould+=cm[i].getClosemonthCostNotNum();
		
				
					getFeetotal+=cm[i].getClosemonthFeesNum()+cm[i].getClosemonthFeesNotNum();
		
					getSalaryTotal += cm[i].getClosemonthSalaryNum() + cm[i].getClosemonthSalaryNotNum ();
				
					if(i!=0)
					{ 
						salarytotalCash+=cm[i].getClosemonthSalaryNum(); 
						salarytotalNotCash += cm[i].getClosemonthSalaryNotNum(); 
					
						costtotalCash+=cm[i].getClosemonthCostNum();
						costtotalNotCash+=cm[i].getClosemonthCostNotNum();				
					}	
				}
			}	
		
			Utility u=Utility.getInstance();
			
			SimpleDateFormat sdfX3=new SimpleDateFormat("yyyy/MM/dd"); 
			String endString=u.getLastDateInMonth(runDate);
			
			int closeIncomeX1=cm[0].getClosemonthIncomeNum()+oldIncomeCase+incomeSum;
			int closeIncomeX2=cm[0].getClosemonthIncomeNotNum()+oldIncomeShould-incomeSum;
		
			int preSalaryPay=jp.closesalaryBeforeMonth(runDate);
			int salaryTotalCash=cm[0].getClosemonthSalaryNum()+salarytotalCash+preSalaryPay;
		
			int preCostPay=jp.closecostBeforeMonth(runDate); 
			
			
			int ownerTotal=jp.getOwnertradeBeforeRundate(sdfX3.parse(endString)) ;
			int costTotalCash=cm[0].getClosemonthCostNum()+costtotalCash+preCostPay;
		 
			
			
			
			Costpay[] cp2=jp.getFeeticketByAfterFeecoloseDate(cm[0]);
			int caseAllModifiedAfter=0; 
			if(cp2!=null)
			{ 
				caseAllModifiedAfter=jp.totalCostpayFeenumber(cp2);
			}
			
			int caseModifiedAfter=caseAllModifiedAfter-closeX1;
			
			
			Costpay[] cp=jp.getFeeticketByBeforeFeecoloseDate(cm[0]);
			int caseModified=0; 
			if(cp!=null)
			{ 
				caseModified=jp.totalCostpayFeenumber(cp);
			}
			
			int finalFee=caseModifiedAfter+closeX1+caseModified ;

		 
			
			String strTitle=e.getPaySystemCompanyName()+"\n";
			Paragraph parag1=new Paragraph(strTitle,font14b);
			parag1.setAlignment(Element.ALIGN_CENTER);
			document.add(parag1);
			
			strTitle="現金調節表\n\n\n";
			parag1=new Paragraph(strTitle,font10);
			parag1.setAlignment(Element.ALIGN_CENTER);
			document.add(parag1);
			
			Image  logoI= Image.getInstance(logoImge);
	        logoI.setAbsolutePosition(10,770);
			document.add(logoI);
			
			float[] widths2 = {0.12f, 0.33f,0.25f,0.2f,0.2f};
		
			PdfPTable table2 = new PdfPTable(widths2);
			PdfPCell cell2 = new PdfPCell(new Paragraph("日期:"+sdfX3.format(new Date()),font10b));
			cell2.setColspan(5);
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("",font12b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);

			cell2 = new PdfPCell(new Paragraph("",font12b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);

			cell2 = new PdfPCell(new Paragraph("結帳時間點",font12b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
				
			cell2 = new PdfPCell(new Paragraph("支出",font12b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("存入",font12b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			
			cell2 = new PdfPCell(new Paragraph("學費收入",font10b));
			cell2.setColspan(2);
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			cell2 = new PdfPCell(new Paragraph(sdf3.format(cm[0].getClosemonthFeeDate()),font10b));
			
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("",font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			cell2 = new PdfPCell(new Paragraph(mnf.format(finalFee),font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			cell2 = new PdfPCell(new Paragraph("",font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("累計學費金額",font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("累計至結帳點,已結帳",font8));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("",font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			cell2 = new PdfPCell(new Paragraph(mnf.format(closeX1),font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
		
		
			cell2 = new PdfPCell(new Paragraph("",font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("預收學費",font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("結帳點之前,尚未結帳",font8));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("",font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			cell2 = new PdfPCell(new Paragraph(mnf.format(caseModifiedAfter),font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
				
				
			cell2 = new PdfPCell(new Paragraph("",font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("結帳點之後學費收入",font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("結帳點之後,尚未結帳",font8));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("",font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			cell2 = new PdfPCell(new Paragraph(mnf.format(caseModified),font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
				
			Costpay[] cp3=jp.getCostpayByAfterIncomecoloseDate(cm[0]);
			int caseAllModifiedAfterIncome=0; 
			if(cp3!=null)
			{ 
				caseAllModifiedAfterIncome=jp.totalCostpayFeenumber(cp3);
			}
			
			int caseModifiedAfterIncome=caseAllModifiedAfterIncome-closeIncomeX1;
			
			cp=jp.getCostpayByBeforeIncomecoloseDate(cm[0]);
			int caseIncomeModified=0; 
			if(cp!=null)
			{ 
				caseIncomeModified=jp.totalCostpayFeenumber(cp);
			}
			
			int finalIncome=closeIncomeX1+caseModifiedAfterIncome+caseIncomeModified ;
	
			
			cell2 = new PdfPCell(new Paragraph("雜費收入",font10b));
			cell2.setColspan(2);
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			cell2 = new PdfPCell(new Paragraph(sdf3.format(cm[0].getClosemonthIncomeDate()),font10b));
			
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("",font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			cell2 = new PdfPCell(new Paragraph(mnf.format(finalIncome),font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
							
			cell2 = new PdfPCell(new Paragraph("",font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("累計雜費金額",font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("累計至結帳點,已結帳 ",font8));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("",font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			cell2 = new PdfPCell(new Paragraph(mnf.format(closeIncomeX1),font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			cell2 = new PdfPCell(new Paragraph("",font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("預收雜費",font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("結帳點之前,尚未結帳",font8));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("",font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			cell2 = new PdfPCell(new Paragraph(mnf.format(caseModifiedAfterIncome),font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("",font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("結帳點之後雜費收入",font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("結帳點之後,尚未結帳",font8));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("",font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			cell2 = new PdfPCell(new Paragraph(mnf.format(caseIncomeModified),font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cp2=jp.getCostpayByAfterSalarycoloseDate(cm[0]);
			int cashAllModifiedAfterSalary=0; 
			if(cp2!=null)
			{ 
			cashAllModifiedAfterSalary=jp.totalCostpayFeenumberCost(cp2);
			}
			
			int caseModifiedAfterSalary=cashAllModifiedAfterSalary-salaryTotalCash;
			
				
			cp=jp.getSalaryticketByBeforeFeecoloseDate(cm[0]);
			int caseSalaryModified=0; 
			if(cp!=null)
			{ 
			caseSalaryModified=jp.totalCostpayFeenumberCost(cp);
			}
			
			int finalSalary=caseModifiedAfterSalary+caseSalaryModified+salaryTotalCash ;

			
			cell2 = new PdfPCell(new Paragraph("薪資支出",font10b));
			cell2.setColspan(2);
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			cell2 = new PdfPCell(new Paragraph(sdf3.format(cm[0].getClosemonthSalaryDate()),font10b));
			
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph(mnf.format(finalSalary),font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			cell2 = new PdfPCell(new Paragraph("",font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			cell2 = new PdfPCell(new Paragraph("",font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("累計薪資金額",font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("累計至結帳點,已結帳 ",font8));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph(mnf.format(salaryTotalCash),font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			cell2 = new PdfPCell(new Paragraph("",font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
		
			
			cell2 = new PdfPCell(new Paragraph("",font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("預支薪資",font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("結帳點之前,尚未結帳 ",font8));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph(mnf.format(caseModifiedAfterSalary),font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			cell2 = new PdfPCell(new Paragraph("",font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("",font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("結帳點之後薪資支出",font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("結帳點之後,尚未結帳 ",font8));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph(mnf.format(caseSalaryModified),font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			cell2 = new PdfPCell(new Paragraph("",font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cp2=jp.getCostpayByAfterCostcloseDate(cm[0]);
			int cashAllModifiedAfterCost=0; 
			if(cp2!=null)
			{ 
				cashAllModifiedAfterCost=jp.totalCostpayFeenumberCost(cp2);
			}
			
			int caseModifiedAfterCost=cashAllModifiedAfterCost-costTotalCash;
			
			cp=jp.getCostpayByBeforeCostcoloseDate(cm[0]);
			int caseCostModified=0; 
			if(cp!=null)
			{ 
				caseCostModified=jp.totalCostpayFeenumberCost(cp);
			}
			
			int finalCost=costTotalCash+caseModifiedAfterCost+caseCostModified ;
			
			cell2 = new PdfPCell(new Paragraph("雜費支出",font10b));
			cell2.setColspan(2);
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			cell2 = new PdfPCell(new Paragraph(sdf3.format(cm[0].getClosemonthCostDate()),font10b));
			
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph(mnf.format(finalCost),font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			cell2 = new PdfPCell(new Paragraph("",font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);			

			cell2 = new PdfPCell(new Paragraph("",font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);


			cell2 = new PdfPCell(new Paragraph("累計雜費金額",font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("累計至結帳點,已結帳 ",font8));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph(mnf.format(costTotalCash),font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			cell2 = new PdfPCell(new Paragraph("",font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			
			cell2 = new PdfPCell(new Paragraph("",font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("預支雜費支出",font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("結點之前,尚未結帳  ",font8));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph(mnf.format(caseModifiedAfterCost),font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			cell2 = new PdfPCell(new Paragraph("",font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("",font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("結帳點之後雜費支出",font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("結帳點之後,尚未結帳 ",font8));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph(mnf.format(caseCostModified),font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			cell2 = new PdfPCell(new Paragraph("",font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
		int preFeebefore=cm[0].getClosemonthFeePrepay();
		int preFeeAfter=jp.getAfterNumberStudentAccount(cm[0].getClosemonthFeeDate());
		int preFeetotal=preFeebefore+preFeeAfter;
		
		String prefeeDateString=sdf3.format(cm[0].getClosemonthFeeDate());

			cell2 = new PdfPCell(new Paragraph("學生逾繳學費",font10b));
			cell2.setColspan(2);
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			
			cell2 = new PdfPCell(new Paragraph(prefeeDateString,font10b));
			
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("",font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			cell2 = new PdfPCell(new Paragraph(mnf.format(preFeetotal),font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);			
			
			cell2 = new PdfPCell(new Paragraph("",font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph(prefeeDateString+"之前",font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("",font8));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("",font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			cell2 = new PdfPCell(new Paragraph(mnf.format(preFeebefore),font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("",font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph(prefeeDateString+"之後",font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("",font8));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("",font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			cell2 = new PdfPCell(new Paragraph(mnf.format(preFeeAfter),font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);

			
			
			int afterOwner=jp.getOwnertradeAfterRundate(sdfX3.parse(endString)); 
			int finalOwner= afterOwner+ownerTotal;

			cell2 = new PdfPCell(new Paragraph("股東權益變更",font10b));
			cell2.setColspan(2);
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			
			cell2 = new PdfPCell(new Paragraph(endString,font10b));
			
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("",font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			cell2 = new PdfPCell(new Paragraph(mnf.format(finalOwner),font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);			
			
			cell2 = new PdfPCell(new Paragraph("",font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph(endString+"之前",font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("",font8));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("",font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			cell2 = new PdfPCell(new Paragraph(mnf.format(ownerTotal),font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("",font10b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph(endString+"之後",font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("",font8));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("",font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			cell2 = new PdfPCell(new Paragraph(mnf.format(afterOwner),font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
				
			
			cell2 = new PdfPCell(new Paragraph("合計:",font12b));
			cell2.setColspan(3);
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
	
			
			cell2 = new PdfPCell(new Paragraph("",font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph(mnf.format(finalFee+finalIncome-finalSalary-finalCost+finalOwner+preFeetotal),font12b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("製表日期:"+sdfX3.format(new Date())+"  製表人:"+ud3.getUserFullname(),font10));
			cell2.setColspan(5);
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);


			table2.setWidthPercentage(90);
			document.add(table2);

			
			
		}catch(Exception ex){
			return false;
		}

		return true;
	}
    
    public boolean makeType2Content(Document document,PdfWriter writer2,String path,PaySystem e,Date runDate,User ud3)	
    {
    		
    	try{
    		PdfContentByte cb = writer2.getDirectContent();


		
			String fontPath=path+"/font/simsun.ttc,0";
			String logoImge=path+"/font/logo.tif";
	
			String henryImgeS=path+"/font/bg.tif";
			Image henryI2=Image.getInstance(henryImgeS);
			henryI2.setAbsolutePosition(200,400);
			document.add(henryI2);
			
			
			henryImgeS=path+"/font/confidential.tif";
			henryI2=Image.getInstance(henryImgeS);
			henryI2.setAbsolutePosition(420,100);
			document.add(henryI2);
			
	
			BaseFont bfComic = BaseFont.createFont(fontPath,BaseFont.IDENTITY_H,BaseFont.NOT_EMBEDDED);
			Font font14b = new Font(bfComic, 14,Font.BOLD);
			Font font14 = new Font(bfComic, 14,Font.NORMAL);
			Font font12b = new Font(bfComic, 12,Font.BOLD);
			Font font12 = new Font(bfComic, 12,Font.NORMAL);
			Font font10 = new Font(bfComic, 10,Font.NORMAL);
			Font font10b = new Font(bfComic, 10,Font.BOLD);
			Font font8 = new Font(bfComic, 8,Font.NORMAL);

			
			SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM");
			SimpleDateFormat sdf2=new SimpleDateFormat("yyyy-MM-dd");
			SimpleDateFormat sdf3=new SimpleDateFormat("yyyy-MM-dd HH:mm");
			DecimalFormat nf = new DecimalFormat("###,##0.00");
			DecimalFormat mnf = new DecimalFormat("###,###,##0");
			
			
			JsfPay jp=JsfPay.getInstance();	
			JsfAdmin ja=JsfAdmin.getInstance();
			Utility u=Utility.getInstance(); 
			PaySystemMgr em=PaySystemMgr.getInstance();
			ClassesMoneyMgr cmm=ClassesMoneyMgr.getInstance();	
			
			SimpleDateFormat sdfX2=new SimpleDateFormat("yyyy/MM/01"); 
			SimpleDateFormat sdfX3=new SimpleDateFormat("yyyy/MM/dd"); 
			String  startS=sdfX2.format(runDate); 
			String endString=u.getLastDateInMonth(runDate);
			
			
			Closemonth[] cm=jp.getClosemonth(runDate);
			
			if(cm ==null)
			{ 
				String strTitle=e.getPaySystemCompanyName()+"\n資產負債表\n";
				Paragraph parag1=new Paragraph(strTitle,font14b);
				parag1.setAlignment(Element.ALIGN_CENTER);
				document.add(parag1);
			
				strTitle="目前沒有結帳的月份";
				parag1=new Paragraph(strTitle,font10);
				parag1.setAlignment(Element.ALIGN_CENTER);
				document.add(parag1);
			
				
				return true;
			} 
			
			int salarytotalNotCash=0; 	
			int costtotalNotCash =0 ;
			
			
			int totalThisIncome=cm[0].getClosemonthFeesNum()+cm[0].getClosemonthFeesNotNum()+cm[0].getClosemonthIncomeNum()+cm[0].getClosemonthIncomeNotNum();
			int totalThisCost=cm[0].getClosemonthSalaryNum()+cm[0].getClosemonthSalaryNotNum()+cm[0].getClosemonthCostNum()+cm[0].getClosemonthCostNotNum();
			int totalThisClose=totalThisIncome-totalThisCost;
			int totalPreClose=0;
			int salarytotalCash=0 ;
			
			
			int oldFeeCash=0;  
			int oldFeeShould=0; 
			
			
			int oldIncomeCash=0;
			int oldIncomeShould=0;
			
			int oldCoshCash=0;
			if(cm.length>1)
			{
			for(int i=1;i<cm.length;i++)	
			{ 
				oldFeeCash+=cm[i].getClosemonthFeesNum();
				oldFeeShould+=cm[i].getClosemonthFeesNotNum();
			
				
				oldIncomeCash +=cm[i].getClosemonthIncomeNum();
			 	oldIncomeShould +=cm[i].getClosemonthIncomeNotNum();
				
				
				int oldIncome=cm[i].getClosemonthFeesNum()+cm[i].getClosemonthFeesNotNum()+cm[i].getClosemonthIncomeNum()+cm[i].getClosemonthIncomeNotNum();
			 	int oldCost=cm[i].getClosemonthSalaryNum()+cm[i].getClosemonthSalaryNotNum()+cm[i].getClosemonthCostNum()+cm[i].getClosemonthCostNotNum();
				
				totalPreClose +=oldIncome - oldCost ; 
				
				salarytotalNotCash += cm[i].getClosemonthSalaryNotNum(); 
			
				costtotalNotCash+=cm[i].getClosemonthCostNotNum();	
				salarytotalCash+=cm[i].getClosemonthSalaryNum(); 
				oldCoshCash+=cm[i].getClosemonthCostNum();
				
			
			}	
			} 
			
			
			int ownerTotal=jp.getOwnertradeBeforeRundate(sdfX3.parse(endString)) ;
			int preCostPay=jp.closecostBeforeMonth(runDate);
			int preSalaryPay=jp.closesalaryBeforeMonth(runDate);
			int payFeeSum=jp.closefeeBeforeMonth(runDate);	
			int preIncomeSum=jp.closeincomeBeforeMonth(runDate);	
			
			int notSalaryFinish= salarytotalNotCash-preSalaryPay; 
			int notCostFinish=costtotalNotCash - preCostPay ; 
			
			int thisCashFinish=cm[0].getClosemonthFeesNum()+cm[0].getClosemonthIncomeNum()- cm[0].getClosemonthSalaryNum ()- cm[0].getClosemonthCostNum (); 
			int thisNotCashFinish=cm[0].getClosemonthFeesNotNum()+cm[0].getClosemonthIncomeNotNum();
			

		
	
			String strTitle=e.getPaySystemCompanyName()+"\n";
			Paragraph parag1=new Paragraph(strTitle,font14b);
			parag1.setAlignment(Element.ALIGN_CENTER);
			document.add(parag1);
			
			strTitle="資產負債表\n\n\n";
			parag1=new Paragraph(strTitle,font10);
			parag1.setAlignment(Element.ALIGN_CENTER);
			document.add(parag1);
			
			Image  logoI= Image.getInstance(logoImge);
	        logoI.setAbsolutePosition(10,770);
			document.add(logoI);
			
			float[] widths2 = {0.4f, 0.05f,0.25f,0.05f,0.25f};
		
			PdfPTable table2 = new PdfPTable(widths2);
			PdfPCell cell2 = new PdfPCell(new Paragraph("日期:"+endString,font10b));
			cell2.setColspan(5);
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
		
			cell2 = new PdfPCell(new Paragraph("資    產",font12));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);

			cell2 = new PdfPCell(new Paragraph("=",font12));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);

			cell2 = new PdfPCell(new Paragraph("負  債",font12));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);

			cell2 = new PdfPCell(new Paragraph("+",font12));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);

			cell2 = new PdfPCell(new Paragraph("業主權益",font12));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);

			int oldCashFinish=oldFeeCash+payFeeSum-salarytotalCash-preSalaryPay+oldIncomeCash+preIncomeSum-oldCoshCash-preCostPay;
			int oldNotCashFinish=oldFeeShould-payFeeSum+oldIncomeShould-preIncomeSum;
	

		//content
			String content1="現金.........................."+mnf.format(thisCashFinish+oldCashFinish+ownerTotal+cm[0].getClosemonthFeePrepay())+"\n\n";
			
			String contnet2="   本期新增:"+getSpace(mnf.format(thisCashFinish),17)+"\n"+
							"   前期累計現金:"+getSpace(mnf.format(oldCashFinish),13)+"\n"+
							"   學生逾繳學費:"+getSpace(mnf.format(cm[0].getClosemonthFeePrepay()),13)+"\n"+
							"   股東權益變更:"+getSpace(mnf.format(ownerTotal),13)+"\n\n\n"; 
							

			String content3="應收帳款......................"+mnf.format(thisNotCashFinish+oldNotCashFinish)+"\n\n";
			String content4="   本期應收:"+getSpace(mnf.format(thisNotCashFinish),17)+"\n"+
							"   前期累計應收:"+getSpace(mnf.format(oldNotCashFinish),13)+"\n";
						

			cell2 = new PdfPCell(new Paragraph(content1+contnet2+content3+content4,font10));
			cell2.setFixedHeight(200f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_TOP);
			table2.addCell(cell2);

			cell2 = new PdfPCell(new Paragraph("=",font12));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);


			content1="應付薪資........"+mnf.format(cm[0].getClosemonthSalaryNotNum()+notSalaryFinish)+"\n\n";
			
			contnet2=" 本期新增:"+getSpace(mnf.format(cm[0].getClosemonthSalaryNotNum()),11)+"\n"+
							" 前期累計應付:"+getSpace(mnf.format(notSalaryFinish),7)+"\n\n\n\n";
						

			content3="應付雜費........"+mnf.format(cm[0].getClosemonthCostNotNum()+notCostFinish)+"\n\n";
			content4=" 本期新增:"+getSpace(mnf.format(cm[0].getClosemonthCostNotNum()),11)+"\n"+
							" 前期累計應付:"+getSpace(mnf.format(notCostFinish),7)+"\n\n";
			
			String content5XX="學生逾繳學費...."+mnf.format(cm[0].getClosemonthFeePrepay())+"\n";

			cell2 = new PdfPCell(new Paragraph(content1+contnet2+content3+content4+content5XX,font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_TOP);
			table2.addCell(cell2);

			cell2 = new PdfPCell(new Paragraph("+",font12));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);

			
			content1="本期損益........"+mnf.format(totalThisClose)+"\n\n";
			
			String content2="前期累計損益...."+mnf.format(totalPreClose)+"\n\n";
			
			content3="股東權益變更...."+mnf.format(ownerTotal)+"\n\n";


			cell2 = new PdfPCell(new Paragraph(content1+content2+content3,font10));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_TOP);
			table2.addCell(cell2);



			cell2 = new PdfPCell(new Paragraph("資產總額: "+mnf.format(thisCashFinish+thisNotCashFinish+oldCashFinish+oldNotCashFinish+ownerTotal+cm[0].getClosemonthFeePrepay()),font12b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);

			cell2 = new PdfPCell(new Paragraph("=",font12));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);

			cell2 = new PdfPCell(new Paragraph("負債總額: "+mnf.format(cm[0].getClosemonthSalaryNotNum()+cm[0].getClosemonthCostNotNum()+notSalaryFinish+notCostFinish+cm[0].getClosemonthFeePrepay()),font12b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);

			cell2 = new PdfPCell(new Paragraph("+",font12));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);

			cell2 = new PdfPCell(new Paragraph("權益總額: "+mnf.format(totalThisClose+totalPreClose+ownerTotal),font12b));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);

			
			cell2 = new PdfPCell(new Paragraph("製表日期:"+sdfX3.format(new Date())+"  製表人:"+ud3.getUserFullname(),font10));
			cell2.setColspan(5);
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);



			table2.setWidthPercentage(90);
			document.add(table2);

			
  		}catch(Exception ex){
  			
  			return false;
  		}
  		
  		return true;		
	}  			
  		
  	public String getSpace(String showString,int allLength){
  		
  		
		int wordString=0;
		
		if(showString !=null)
				wordString=showString.length();
		
		String outWord="";

		if(allLength>wordString)
		{
			for(int i=0;i<(allLength-wordString);i++)
			{
				outWord+=" ";
			}
		}
		return outWord+showString;
  	}	
  		
  	public boolean makeType1Content(Document document,PdfWriter writer2,String path,PaySystem e,Date runDate,User ud3)	
    {
    		
    	try{
    		PdfContentByte cb = writer2.getDirectContent();
		
			String fontPath=path+"/font/simsun.ttc,0";
			String logoImge=path+"/font/logo.tif";
	
			String henryImgeS=path+"/font/bg.tif";
			Image henryI2=Image.getInstance(henryImgeS);
			henryI2.setAbsolutePosition(200,400);
			document.add(henryI2);
			
			
			henryImgeS=path+"/font/confidential.tif";
			henryI2=Image.getInstance(henryImgeS);
			henryI2.setAbsolutePosition(420,100);
			document.add(henryI2);
			
			

	
			BaseFont bfComic = BaseFont.createFont(fontPath,BaseFont.IDENTITY_H,BaseFont.NOT_EMBEDDED);
			Font font14b = new Font(bfComic, 14,Font.BOLD);
			Font font14 = new Font(bfComic, 14,Font.NORMAL);
			Font font12b = new Font(bfComic, 12,Font.BOLD);
			Font font12 = new Font(bfComic, 12,Font.NORMAL);
			Font font10 = new Font(bfComic, 10,Font.NORMAL);
			Font font10b = new Font(bfComic, 10,Font.BOLD);
			Font font8 = new Font(bfComic, 8,Font.NORMAL);

			
			SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM");
			SimpleDateFormat sdf2=new SimpleDateFormat("yyyy-MM-dd");
			SimpleDateFormat sdf3=new SimpleDateFormat("yyyy-MM-dd HH:mm");
	
			String strTitle=e.getPaySystemCompanyName();
			Paragraph parag1=new Paragraph(strTitle,font14b);
			parag1.setAlignment(Element.ALIGN_CENTER);
			document.add(parag1);
			
					
			strTitle=sdf.format(runDate)+"損益表\n\n\n";
			parag1=new Paragraph(strTitle,font10);
			parag1.setAlignment(Element.ALIGN_CENTER);
			document.add(parag1);
			
			
			
			Image  logoI= Image.getInstance(logoImge);
	        logoI.setAbsolutePosition(10,770);
			document.add(logoI);
			
			
					
		
			
			DecimalFormat nf = new DecimalFormat("###,##0.00");
			DecimalFormat mnf = new DecimalFormat("###,###,##0");
			
			JsfPay jp=JsfPay.getInstance();	
			JsfAdmin ja=JsfAdmin.getInstance();
			Utility u=Utility.getInstance(); 
			PaySystemMgr em=PaySystemMgr.getInstance();
			 
			ClassesMoneyMgr cmm=ClassesMoneyMgr.getInstance();	

						
			SimpleDateFormat sdfX2=new SimpleDateFormat("yyyy/MM/01"); 
			 
			SimpleDateFormat sdfX3=new SimpleDateFormat("yyyy/MM/dd"); 
			
			String  startS=sdfX2.format(runDate); 
			String endString=u.getLastDateInMonth(runDate);
			 
			 

			Costbook[] income=jp.getCostbooks(0,0,0,sdfX3.parse(startS),sdfX3.parse(endString));
			
			int allIncomeTotal=0;
		
			Hashtable incomeHa=new Hashtable();
		
		
			if(income !=null)
			{
				for(int i=0;i<income.length;i++)	
				{
					Cost[] co=jp.getCostByCBId(income[i]);
					if(co !=null)
					{
						for(int j=0;j<co.length;j++)
						{
							String bigItem=String.valueOf(co[j].getCostBigItem());
							String smallItem=String.valueOf(co[j].getCostSmallItem());
							if(incomeHa.get(bigItem)==null)
							{
								Hashtable insideHa=new Hashtable();
								insideHa.put((String)smallItem,(String)String.valueOf(co[j].getCostMoney()));
								
								incomeHa.put(bigItem,insideHa);
								
								allIncomeTotal += co[j].getCostMoney();
							}else{
								
								Hashtable insideHa=(Hashtable)incomeHa.get(bigItem);
								
								if(insideHa.get(smallItem)==null)
								{
									insideHa.put((String)smallItem,(String)String.valueOf(co[j].getCostMoney()));
									incomeHa.put((String)bigItem,(Hashtable)insideHa);
			
									allIncomeTotal += co[j].getCostMoney(); 
								}else{
								
									String moneyString=(String)insideHa.get(smallItem);
									int money=Integer.parseInt(moneyString)+co[j].getCostMoney();
									
									insideHa.put((String)smallItem,(String)String.valueOf(money));
									incomeHa.put((String)bigItem,(Hashtable)insideHa);
									
									allIncomeTotal += co[j].getCostMoney(); 
									
								}				
							}
						}
					}
				}	
			}		
				
				
			int costTotalFinal=0;
			
			int costbookCosttotal=0;		
			Costbook[] cost=jp.getCostbooks(1,0,0,sdfX3.parse(startS),sdfX3.parse(endString));
			
			Hashtable costHa=new Hashtable();
		
			if(cost !=null)
			{
					
				for(int i=0;i<cost.length;i++)	
				{
					Cost[] co=jp.getCostByCBId(cost[i]);
					if(co !=null)
					{
						for(int j=0;j<co.length;j++)
						{
							String bigItem=String.valueOf(co[j].getCostBigItem());
							String smallItem=String.valueOf(co[j].getCostSmallItem());
							if(costHa.get(bigItem)==null)
							{
								Hashtable insideHa=new Hashtable();
								insideHa.put((String)smallItem,(String)String.valueOf(co[j].getCostMoney()));
								
								costHa.put(bigItem,insideHa);
			 
								
								costbookCosttotal +=co[j].getCostMoney();
							}else{
								
								Hashtable insideHa=(Hashtable)costHa.get(bigItem);
								
								if(insideHa.get(smallItem)==null)
								{
									insideHa.put((String)smallItem,(String)String.valueOf(co[j].getCostMoney()));
									costHa.put((String)bigItem,(Hashtable)insideHa);
			 
									
									costbookCosttotal +=co[j].getCostMoney();
								}else{
								
									String moneyString=(String)insideHa.get(smallItem);
									int money=Integer.parseInt(moneyString)+co[j].getCostMoney();
									
									insideHa.put((String)smallItem,(String)String.valueOf(money));
									costHa.put((String)bigItem,(Hashtable)insideHa);
			 
									
									costbookCosttotal +=co[j].getCostMoney();
								}				
							
							}
						}
					}
					
				} 
			}	
			costTotalFinal +=costbookCosttotal ;
			
			ClassesFee[] cf=ja.getAllClassesFee(runDate);
			
			int allTotalItem=0;
			int shouldTotalItem=0;
			int discountTotalItem=0;
			Hashtable haItem=new Hashtable();
			
			
			int totalNumItem=0;  
			int incomeTotalFinial=0;


	
		float[] widths2 = {0.1f, 0.5f, 0.2f,0.2f};
		
		PdfPTable table2 = new PdfPTable(widths2);
		
		PdfPCell cell2 = new PdfPCell(new Paragraph("日期區間:"+startS+"-"+endString,font10b));
		cell2.setColspan(4);
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);
		

		
		if(cf==null)
		{ 
			
			cell2 = new PdfPCell(new Paragraph("學費收入",font12));
			cell2.setColspan(4);
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
				
			cell2 = new PdfPCell(new Paragraph("",font12));
			cell2.setFixedHeight(20f);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph("沒有資料",font12));
			cell2.setColspan(3);
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
		
		}else{
			
		for(int i=0;i<cf.length;i++)
  		{
  		String cmIdS=String.valueOf(cf[i].getClassesFeeCMId());
  		int totalPay=cf[i].getClassesFeeShouldNumber()-cf[i].getClassesFeeTotalDiscount();
  		
  		shouldTotalItem +=cf[i].getClassesFeeShouldNumber() ;
		discountTotalItem += cf[i].getClassesFeeTotalDiscount();
  		allTotalItem +=totalPay;
  		if(haItem.get(cmIdS)==null)	
  		{
			haItem.put((String)cmIdS,(String)String.valueOf(totalPay));	
  		}else{
  		  	String oldPay=(String)haItem.get(cmIdS);
  		  	
  		  	int nowPay=totalPay +Integer.parseInt(oldPay);
  		  	haItem.put((String)cmIdS,(String)String.valueOf(nowPay));
  		} 
  	}

	incomeTotalFinial=allTotalItem+allIncomeTotal;

	
	Enumeration keysItem=haItem.keys();
	Enumeration elementsItem=haItem.elements();

	Hashtable allItemHa=new Hashtable();
  	while(elementsItem.hasMoreElements())
	{
		String key=(String)keysItem.nextElement();
		String incomeFee=(String)elementsItem.nextElement();
		
		ClassesMoney cm=(ClassesMoney)cmm.find(Integer.parseInt(key));
		int itemId=cm.getClassesMoneyIncomeItem(); 
		
		String itenIdS=String.valueOf(itemId);
		
		if(allItemHa.get(itenIdS)==null)
 
		{ 
			allItemHa.put((String)itenIdS,(String)incomeFee);	
		}else{
			String oldIncome=(String)allItemHa.get(itenIdS);
			
			int newIncome=Integer.parseInt(oldIncome)+Integer.parseInt(incomeFee); 
 
			allItemHa.put((String)itenIdS,(String)String.valueOf(newIncome));		
		}
	}
 
	
 
		Enumeration keysItem2=allItemHa.keys();
		Enumeration elementsItem2=allItemHa.elements();
	
		IncomeSmallItemMgr isim=IncomeSmallItemMgr.getInstance();


		cell2 = new PdfPCell(new Paragraph("學費收入",font12));
		cell2.setColspan(2);
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);
		
		cell2 = new PdfPCell(new Paragraph(mnf.format(allTotalItem),font12b));
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);
		
		cell2 = new PdfPCell(new Paragraph((allTotalItem!=0)?nf.format(((float)allTotalItem/(float)incomeTotalFinial)*100)+"%":"0.00%",font12b));
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);
		
			
		while(keysItem2.hasMoreElements())
		{ 
			String key=(String)keysItem2.nextElement();
			String incomeFee=(String)elementsItem2.nextElement();
 
			IncomeSmallItem  isi=(IncomeSmallItem)isim.find(Integer.parseInt(key)); 

			cell2 = new PdfPCell(new Paragraph("",font12));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			cell2 = new PdfPCell(new Paragraph(isi.getIncomeSmallItemName(),font12));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			cell2 = new PdfPCell(new Paragraph(mnf.format(Integer.parseInt(incomeFee)),font12));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			
			int incomeX=Integer.parseInt(incomeFee);
			
			cell2 = new PdfPCell(new Paragraph(nf.format(((float)incomeX/(float)incomeTotalFinial)*100)+"%",font12));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table2.addCell(cell2);
			
			totalNumItem++;	
		}	
	}
		
		//allTotalItem
		
		
		incomeTotalFinial=allTotalItem+allIncomeTotal;
		
		cell2 = new PdfPCell(new Paragraph("雜費收入",font12));
		cell2.setColspan(2);
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);
		
		cell2 = new PdfPCell(new Paragraph(mnf.format(allIncomeTotal),font12b));
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);
		
		
		cell2 = new PdfPCell(new Paragraph((allIncomeTotal!=0)?nf.format(((float)allIncomeTotal/(float)incomeTotalFinial)*100)+"%":"0.00%",font12b));
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);
			
		BigItemMgr bim=BigItemMgr.getInstance();
		SmallItemMgr sim=SmallItemMgr.getInstance();

		Enumeration keys=incomeHa.keys();
		Enumeration elements=incomeHa.elements();
		int i=0;
		int allTotal=0;
		
		while(elements.hasMoreElements())
		{
	
		String key=(String)keys.nextElement();
		Hashtable data2Ha=(Hashtable)elements.nextElement();
		
		BigItem bi=(BigItem)bim.find(Integer.parseInt(key));

		String row1=""; 
		
		cell2 = new PdfPCell(new Paragraph("",font12));
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);
		
		
		cell2 = new PdfPCell(new Paragraph(bi.getBigItemName(),font12));
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);
		
		
		Enumeration keys2=data2Ha.keys();
		Enumeration elements2=data2Ha.elements();
		
		int ai=0;
		int rowTotal=0;
		while(elements2.hasMoreElements())
		{
			String key2=(String)keys2.nextElement();
			String num=(String)elements2.nextElement();	
			
			rowTotal +=Integer.parseInt(num);
		} 

 		cell2 = new PdfPCell(new Paragraph(mnf.format(rowTotal),font12));
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);
		
		
		
		
		String outXX="";
		
		if(rowTotal==incomeTotalFinial)
 
			outXX="100.00";	
		else
			outXX=nf.format(((float)rowTotal/(float)incomeTotalFinial)*100); 	
			

		cell2 = new PdfPCell(new Paragraph(outXX+"%",font12));
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);

 		allTotal+=rowTotal;	
	}
 
 	cell2 = new PdfPCell(new Paragraph("************[營業收入總計]",font12b));
 	cell2.setColspan(2);
	cell2.setFixedHeight(20f);
	cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
	cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
	table2.addCell(cell2);
	
	cell2 = new PdfPCell(new Paragraph(mnf.format(allTotal+allTotalItem),font12b));
	cell2.setFixedHeight(20f);
	cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
	cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
	table2.addCell(cell2);
		
	cell2 = new PdfPCell(new Paragraph("",font12b));
	cell2.setFixedHeight(20f);
	cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
	cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
	table2.addCell(cell2);
		
	int[] salary=jp.getSalaryByDate(runDate);
	int[] salaryPartime=jp.getSalaryByParttime(runDate);
	
	costTotalFinal +=salary[0] ;

	
	
	cell2 = new PdfPCell(new Paragraph("薪資支出",font12));
	cell2.setColspan(2);
	cell2.setFixedHeight(20f);
	cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
	cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
	table2.addCell(cell2);
	
	cell2 = new PdfPCell(new Paragraph(mnf.format(salary[0]),font12b));
	cell2.setFixedHeight(20f);
	cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
	cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
	table2.addCell(cell2);
	
	cell2 = new PdfPCell(new Paragraph(nf.format(((float)salary[0]/(float)costTotalFinal)*100)+"%",font12b));
	cell2.setFixedHeight(20f);
	cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
	cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
	table2.addCell(cell2);
	
	cell2 = new PdfPCell(new Paragraph("",font12));
	cell2.setFixedHeight(20f);
	cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
	cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
	table2.addCell(cell2);
	
	
	cell2 = new PdfPCell(new Paragraph("薪資-正職員工",font12));
	cell2.setFixedHeight(20f);
	cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
	cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
	table2.addCell(cell2);
	
		
	
	cell2 = new PdfPCell(new Paragraph(mnf.format(salaryPartime[0]),font12));
	cell2.setFixedHeight(20f);
	cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
	cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
	table2.addCell(cell2);
		
		
		
	cell2 = new PdfPCell(new Paragraph(nf.format(((float)salaryPartime[0]/(float)costTotalFinal)*100)+"%",font12));
	cell2.setFixedHeight(20f);
	cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
	cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
	table2.addCell(cell2);
	
		cell2 = new PdfPCell(new Paragraph("",font12));
	cell2.setFixedHeight(20f);
	cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
	cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
	table2.addCell(cell2);
	
	
	cell2 = new PdfPCell(new Paragraph("薪資-課內才藝",font12));
	cell2.setFixedHeight(20f);
	cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
	cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
	table2.addCell(cell2);
	
		
	
	cell2 = new PdfPCell(new Paragraph(mnf.format(salaryPartime[1]),font12));
	cell2.setFixedHeight(20f);
	cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
	cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
	table2.addCell(cell2);
		
		
		
	cell2 = new PdfPCell(new Paragraph(nf.format(((float)salaryPartime[1]/(float)costTotalFinal)*100)+"%",font12));
	cell2.setFixedHeight(20f);
	cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
	cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
	table2.addCell(cell2);


		cell2 = new PdfPCell(new Paragraph("",font12));
	cell2.setFixedHeight(20f);
	cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
	cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
	table2.addCell(cell2);
	
	
	cell2 = new PdfPCell(new Paragraph("薪資-課後才藝",font12));
	cell2.setFixedHeight(20f);
	cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
	cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
	table2.addCell(cell2);
	
		
	
	cell2 = new PdfPCell(new Paragraph(mnf.format(salaryPartime[2]),font12));
	cell2.setFixedHeight(20f);
	cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
	cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
	table2.addCell(cell2);
		
		
		
	cell2 = new PdfPCell(new Paragraph(nf.format(((float)salaryPartime[2]/(float)costTotalFinal)*100)+"%",font12));
	cell2.setFixedHeight(20f);
	cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
	cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
	table2.addCell(cell2);



	
	cell2 = new PdfPCell(new Paragraph("雜費支出",font12));
	cell2.setColspan(2);
	cell2.setFixedHeight(20f);
	cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
	cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
	table2.addCell(cell2);
	
	cell2 = new PdfPCell(new Paragraph(mnf.format(costTotalFinal-salary[0]),font12b));
	cell2.setFixedHeight(20f);
	cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
	cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
	table2.addCell(cell2);
	
	cell2 = new PdfPCell(new Paragraph(nf.format(((float)costbookCosttotal/(float)costTotalFinal)*100)+"%",font12b));
	cell2.setFixedHeight(20f);
	cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
	cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
	table2.addCell(cell2);
	


	keys=costHa.keys();
	elements=costHa.elements();
	
	int allCostTotal=0;
	while(elements.hasMoreElements())
	{
	
		String key=(String)keys.nextElement();
		Hashtable data2Ha=(Hashtable)elements.nextElement();
		
		BigItem bi=(BigItem)bim.find(Integer.parseInt(key));

		
		
		cell2 = new PdfPCell(new Paragraph("",font12));
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);
		
		
		cell2 = new PdfPCell(new Paragraph(bi.getBigItemName(),font12));
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);
		
		Enumeration keys2=data2Ha.keys();
		Enumeration elements2=data2Ha.elements();
		
		int ai=0;
		int rowTotal=0;
		while(elements2.hasMoreElements())
		{
			String key2=(String)keys2.nextElement();
			String num=(String)elements2.nextElement();	
			
			rowTotal +=Integer.parseInt(num);
		} 
	

 		cell2 = new PdfPCell(new Paragraph(mnf.format(rowTotal),font12));
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);
	
	
	
		cell2 = new PdfPCell(new Paragraph(nf.format(((float)rowTotal/(float)costTotalFinal)*100)+"%",font12));
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table2.addCell(cell2);
		
 		allCostTotal+=rowTotal;	
	}
		

	cell2 = new PdfPCell(new Paragraph("************[營業支出總計]",font12b));
 	cell2.setColspan(2);
	cell2.setFixedHeight(20f);
	cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
	cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
	table2.addCell(cell2);
	
	cell2 = new PdfPCell(new Paragraph(mnf.format(allCostTotal+salary[0]),font12b));
	cell2.setFixedHeight(20f);
	cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
	cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
	table2.addCell(cell2);
		
	cell2 = new PdfPCell(new Paragraph("",font12b));
	cell2.setFixedHeight(20f);
	cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
	cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
	table2.addCell(cell2);

	cell2 = new PdfPCell(new Paragraph("************本期損益",font12b));
 	cell2.setColspan(2);
	cell2.setFixedHeight(20f);
	cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
	cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
	table2.addCell(cell2);
	
	cell2 = new PdfPCell(new Paragraph(mnf.format(allTotalItem+allTotal-allCostTotal-salary[0]),font12b));
	cell2.setFixedHeight(20f);
	cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
	cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
	table2.addCell(cell2);
		
	cell2 = new PdfPCell(new Paragraph("",font12b));
	cell2.setFixedHeight(20f);
	cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
	cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
	table2.addCell(cell2);

	cell2 = new PdfPCell(new Paragraph("製表日期:"+sdfX3.format(new Date())+"  製表人:"+ud3.getUserFullname(),font10));
	cell2.setColspan(4);
	cell2.setFixedHeight(20f);
	cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
	cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
	table2.addCell(cell2);
			
	table2.setWidthPercentage(90);
	document.add(table2);
		
	        
	    }catch(Exception ex){
	    	
	    	return false;
	    }    
	    
	   return true; 
    }
  
    
    public void setFeeticketStatusAfterPrint(Feeticket ft)
    {
    	FeeticketMgr fmx=FeeticketMgr.getInstance();
		ft.setFeeticketLock(1);  
		ft.setFeeticketPrintUpdate(1);  
		fmx.save(ft);
    	
    }	
    public int makePDFSingleConfirmPage(int feenumber,String path,boolean isF1)
    {
    	try{
    		
	    	String fileMonth=String.valueOf(feenumber).substring(0,4);
	    	
	    	Document document=new Document(PageSize.A4,15,15,10,10);

		String path2=path+fileMonth;
		
		
		File f=new File(path2);
		
		if(!f.exists())
		{
			f.mkdir();	
		}
		
		if(isF1){
			path2=path2+"/"+String.valueOf(feenumber)+"3.pdf";		
		}else{
			path2=path2+"/"+String.valueOf(feenumber)+"4.pdf";		
		}
		

		PdfWriter writer2=PdfWriter.getInstance(document, new FileOutputStream(path2));
		
		document.open();
	
		int status=makeConfirmPageContent(feenumber,writer2,document,path);
    	
    		document.close();
    		
    		return status;
    	}catch(Exception e)
    	{
    		System.out.println("error:"+e.getMessage());	
    	}
    	
    	return 90;	
    }
    
     public int makePageContent2(Feeticket ft,PdfWriter writer2,Document document,String path,PaySystem pSystem,int nowPage)
    {
    	DecimalFormat mnf = new DecimalFormat("###,###,##0");      	
		StudentMgr smx=StudentMgr.getInstance();
		Student stu=(Student)smx.find(ft.getFeeticketStuId());	
        FeeAdmin fa=FeeAdmin.getInstance();

        Feeticket[] notpayFeeticket=fa.getNotpayFeeticket(pSystem,ft);
      
	 	String[] code=makeCode(ft,pSystem,notpayFeeticket);
		String[] listDate=makeListDate2(ft,stu,pSystem,notpayFeeticket);

for (int i=0; i<code.length; i++)
    System.out.println("code" + i + "#" + code[i]);
for (int i=0; i<listDate.length; i++)
    System.out.println("listDate" + i + "#" + listDate[i]);

    	try{
	
	
		int payMoneyNumber=Integer.parseInt(listDate[10]);
		
		PdfContentByte cb = writer2.getDirectContent();
		
		float barcodeN=(float)1.7;
		float barcodeFontSize=(float)10.0;
		float barcodeHieght=(float)30.0;
		float barcodeHieght2=(float)24.0;
		float barcodeN2=(float)1.7; 
		float barcodeN3=(float)2.0;
 
		
		
		String fontPath=path+"font/simsun.ttc,0";
		String logoImge=path+"font/logo.tif";
		
		BaseFont bfComic = BaseFont.createFont(fontPath,BaseFont.IDENTITY_H,BaseFont.NOT_EMBEDDED);
		Font font14b = new Font(bfComic, 14,Font.BOLD);
		Font font14 = new Font(bfComic, 14,Font.NORMAL);
		Font font12 = new Font(bfComic, 12,Font.NORMAL);
		Font font10 = new Font(bfComic, 10,Font.NORMAL);
		Font font10b = new Font(bfComic, 10,Font.BOLD);
		Font font8 = new Font(bfComic, 8,Font.NORMAL);
		Font font1 = new Font(bfComic,1,Font.NORMAL);

		
		Paragraph cTitle = new Paragraph(listDate[3]+"-"+listDate[4],font1);
		cTitle.setAlignment(Element.ALIGN_RIGHT);
		Chapter chapter = new Chapter(cTitle,nowPage);
		document.add(chapter);
		
		String strTitle="學雜費通知單        "+listDate[12];
		Paragraph parag1=new Paragraph(strTitle,font14b);
		parag1.setAlignment(Element.ALIGN_CENTER);
		document.add(parag1);
		
		
		
		Image  logoI= Image.getInstance(logoImge);
		//logoI.setAlignment(Image.LEFT | Image.UNDERLYING);
        logoI.setAbsolutePosition(5,770);
        document.add(logoI);

		
		String henryImge=path+"font/bg.tif";
		Image henryI=Image.getInstance(henryImge);
		henryI.setAbsolutePosition(200,400);
		document.add(henryI);


		Paragraph paragX=new Paragraph("\n\n",font12);
		paragX.setAlignment(Element.ALIGN_LEFT);
		document.add(paragX);	

		String space="     ";
		String space2="                       ";
        String space3="                                                      ";
		String space4="                                      ";
		
		String outName=listDate[4]+" "+listDate[15]+" "+listDate[3]+"  收";
		
		String needSpace="";
		
		
		int allLength=listDate[3].length()*2+listDate[4].length()*2+listDate[15].length()*1+5;			
		
		int xLoop=48-allLength;
		for(int lp=0;lp<xLoop;lp++)
			needSpace+=" ";
		
		String showWord=space+outName+needSpace+listDate[0]+"\n"+space3+"地址: "+listDate[1]+"\n"+space3+"電話: "+listDate[2];
		Paragraph parag6=new Paragraph(showWord,font12);
		parag6.setAlignment(Element.ALIGN_LEFT);
		document.add(parag6);
		
		
		Barcode39 codeFeeticketId = new Barcode39();
		codeFeeticketId.setCode(code[0]);
		codeFeeticketId.setStartStopText(true);
		codeFeeticketId.setSize(barcodeFontSize);
        codeFeeticketId.setN(barcodeN);
		codeFeeticketId.setBarHeight(barcodeHieght2);

		Image imageFtId = codeFeeticketId.createImageWithBarcode(cb, null, null);
		//imageFtId.setAlignment(Element.ALIGN_CENTER);
		imageFtId.setAbsolutePosition(45,718);
		document.add(imageFtId);



		parag6=new Paragraph("\n",font12);
		parag6.setAlignment(Element.ALIGN_LEFT);
		document.add(parag6);
		
		int notPay=Integer.parseInt(listDate[16]);
		int payed=Integer.parseInt(listDate[17]);

	    if(notPay==0 && payed==0)
		{
            parag6=new Paragraph(space+"                                  本期應繳金額         繳款截止日",font10b);
            parag6.setAlignment(Element.ALIGN_LEFT);
            document.add(parag6);
            
            
            parag6=new Paragraph("\n",font8);
            parag6.setAlignment(Element.ALIGN_LEFT);
            document.add(parag6);
            
            parag6=new Paragraph(space+"                               "+mnf.format(Integer.parseInt(listDate[10]))+"          "+listDate[11]+"\n",font12);
            parag6.setAlignment(Element.ALIGN_LEFT);
            document.add(parag6);
            
            parag6=new Paragraph("\n",font8);
            parag6.setAlignment(Element.ALIGN_LEFT);
            document.add(parag6);
            
            String menuImge=path+"font/menu2.tif";
            Image  menuI= Image.getInstance(menuImge);
            //logoI.setAlignment(Image.LEFT | Image.UNDERLYING);
            menuI.setAbsolutePosition(200,644);
            document.add(menuI);		
			
		}else{
			
            parag6=new Paragraph(space+"    本期新增金額         前期未繳金額        本期已繳金額           本期應繳金額         繳款截止日",font10);
            parag6.setAlignment(Element.ALIGN_LEFT);
            document.add(parag6);
            
            
            parag6=new Paragraph("\n",font8);
            parag6.setAlignment(Element.ALIGN_LEFT);
            document.add(parag6);
            
            parag6=new Paragraph(space+"     "+listDate[14]+"          "+listDate[11]+"\n",font12);
            parag6.setAlignment(Element.ALIGN_LEFT);
            document.add(parag6);
            
            parag6=new Paragraph("\n",font8);
            parag6.setAlignment(Element.ALIGN_LEFT);
            document.add(parag6);
            
            String menuImge=path+"font/menu.tif";
            Image  menuI= Image.getInstance(menuImge);
            //logoI.setAlignment(Image.LEFT | Image.UNDERLYING);
            menuI.setAbsolutePosition(50,644);
            document.add(menuI);		
		}



		if(pSystem.getPaySystemBirthActive()==1)
		{
			Date stuBirth=stu.getStudentBirth();
			
			if(stuBirth!=null)
			{
					
				int stuMonth=stuBirth.getMonth();
				if(stuMonth==ft.getFeeticketMonth().getMonth())
				{
					String showBirth=pSystem.getPaySystemBirthWord();
					String replaceWord=replaceBirth(showBirth,stu);
					
					document.add(new Paragraph("        "+replaceWord,font10b)); 
			
					String menuImgePath=path+"font/birth.tif";
					Image  menuBirth= Image.getInstance(menuImgePath);
					menuBirth.setAbsolutePosition(220,710);
					document.add(menuBirth);	
				}	
			}
		}

		if(payMoneyNumber >pSystem.getPaySystemLimitMoney())
		{	
			parag6=new Paragraph(space4+"*由於應繳金額超過"+pSystem.getPaySystemLimitMoney()+"元,本單請於 "+listDate[0]+" 櫃臺繳納.",font10);
			parag6.setAlignment(Element.ALIGN_LEFT);
			document.add(parag6);
		}else{
			
			if(pSystem.getPaySystemStoreActive()==0 ||pSystem.getPaySystemStoreActive()==9)
			{	
				parag6=new Paragraph(space4+"  本單請於 "+listDate[0]+" 櫃臺繳納.",font10);
				parag6.setAlignment(Element.ALIGN_LEFT);
				document.add(parag6);
				
			}else{
				parag6=new Paragraph(space4+"    *如超過繳費期限,請至"+listDate[0]+"櫃臺繳納.",font10);
				parag6.setAlignment(Element.ALIGN_LEFT);
				document.add(parag6);
			}
		}

		parag6=new Paragraph("\n",font8);
		parag6.setAlignment(Element.ALIGN_LEFT);
		document.add(parag6);
		
		float[] widths = {0.12f, 0.38f, 0.15f, 0.35f};
		PdfPTable table = new PdfPTable(widths);
	
		PdfPCell cell = new PdfPCell(new Paragraph("學雜費繳費明細 (收執聯)",font12));
		cell.setColspan(4);
		cell.setFixedHeight(20f);
		cell.setHorizontalAlignment(Element.ALIGN_CENTER);
		cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table.addCell(cell);
		
		cell= new PdfPCell(new Paragraph("項目                     應收      折扣     小計",font10));
		cell.setColspan(2);
		cell.setFixedHeight(20f);
		cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table.addCell(cell);
	
		cell= new PdfPCell(new Paragraph("項目                     應收      折扣     小計",font10));
		cell.setColspan(2);
		cell.setFixedHeight(20f);
		cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table.addCell(cell);
		
		
		cell = new PdfPCell(new Paragraph(listDate[5],font12));
		cell.setColspan(2);
		cell.setFixedHeight(118f);
		table.addCell(cell);
		
		
		cell = new PdfPCell(new Paragraph(listDate[6],font12));
		cell.setColspan(2);
		cell.setFixedHeight(118f);
		table.addCell(cell);
		table.setWidthPercentage(90);
		document.add(table);
	
		document.add(new Paragraph(listDate[13],font10));  //ps
	
	
	
	
	
	
		parag6=new Paragraph("\n",font10);
		parag6.setAlignment(Element.ALIGN_LEFT);
		document.add(parag6);
	
	
		String atmTitle="";
		String atmContent="";
		String acceptString="";
		
		JsfPay jp=JsfPay.getInstance();
		if(pSystem.getPaySystemATMActive()==1)
		{
			atmTitle="銀行帳號轉帳";
			atmContent="步驟 1:插入金融卡並輸入密碼\n"
					+"步驟 2:選擇 [繳費]\n"
					+"步驟 3:輸入"+listDate[7]+"代號 [ "+listDate[8]+" ]\n"
					+"步驟 4:輸入轉入帳號     [ "+listDate[9]+" ]\n"
					+"步驟 5:輸入轉帳金額     [ "+mnf.format(Integer.parseInt(listDate[10]))+" ]\n"
					+"步驟 6:確認\n\n"
					+"註1:繳費上限須依各家銀行規定\n";
					//+"註2:你亦可持以上帳號至台新國際商業銀行全國任一分行填寫[存款單]繳款\n";
					
			if(payMoneyNumber >pSystem.getPaySystemLimitMoney() || pSystem.getPaySystemStoreActive()==0 || pSystem.getPaySystemStoreActive()==9)
			{
				acceptString="櫃臺繳款經收人蓋章";	
			}else{
				acceptString="便利商店/櫃臺繳款經收人蓋章";
			}
		}else if(pSystem.getPaySystemATMActive()==0 || pSystem.getPaySystemATMActive()==9){
			atmTitle="貼心叮嚀";
			atmContent=pSystem.getPaySystemReplaceWord();
			acceptString="櫃臺繳款經收人蓋章";
		}else if(pSystem.getPaySystemATMActive()==2){
				
			atmTitle="自動櫃員機轉帳";
			
			if(pSystem.getPaySystemATMAccountId()==0)
			{
				atmContent="系統尚未設定	匯款銀行帳戶\n";	
			}else{
				BankAccountMgr bam=BankAccountMgr.getInstance();
				BankAccount baATM=(BankAccount)bam.find(pSystem.getPaySystemATMAccountId());	
				
				atmContent="\n\n銀行代號: "+baATM.getBankAccountId();
				
				if(baATM.getBankAccountRealName()!=null && baATM.getBankAccountRealName().length()>0)
				{
					atmContent+="  銀行名稱:"+baATM.getBankAccountRealName()+" "+baATM.getBankAccountBranchName()+"分行";	
				}
				
				atmContent+="\n\n";
				atmContent+="帳    號: "+baATM.getBankAccountAccount()+"\n\n";

				if(baATM.getBankAccountAccountName() !=null && baATM.getBankAccountAccountName().length()>0)
					atmContent+="帳戶名稱: "+baATM.getBankAccountAccountName()+"\n";
			
				acceptString="櫃臺繳款經收人蓋章";		
			}
			
		}else if(pSystem.getPaySystemATMActive()==3){
		
				atmTitle="虛擬帳號轉帳";
			
				String  accountString=jp.getStuFixAccount(pSystem,stu,true);
				
				atmContent="\n 匯款銀行: [ "+listDate[7]+" ] 代號 [ "+listDate[8]+" ]\n"
					+" 匯款帳號: [ "+accountString+ "]\n"
					+" 轉帳金額: [ "+mnf.format(Integer.parseInt(listDate[10]))+" ] 元\n"
					+"\n *本帳號為你與"+listDate[0]+"專屬的交易帳號,\n  你亦可設定為約定轉帳帳號,以方便之後的繳款作業.\n";
					
					
				acceptString="櫃臺繳款經收人蓋章";	
		}

		float[] widths2 = {0.05f, 0.60f, 0.35f};
		PdfPTable table2 = new PdfPTable(widths2);
	
		PdfPCell cell2 = new PdfPCell(new Paragraph(atmTitle,font12));
		cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
		cell2.setFixedHeight(110f);
		
		//cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
		
		table2.addCell(cell2);
		
		
		
		String cellContent="";
		cellContent="\n\n\n繳款超過"+mnf.format(pSystem.getPaySystemLimitMoney())+"元,請至"+listDate[0]+"櫃臺繳納.";
		
					
		cell2= new PdfPCell(new Paragraph(atmContent,font10));
		table2.addCell(cell2);
		
	
		PdfPTable nested2 = new PdfPTable(1);
		cell2= new PdfPCell(new Paragraph(acceptString,font10));
		cell2.setFixedHeight(20f);
		cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
		cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
	        nested2.addCell(cell2);
	        cell2= new PdfPCell(new Paragraph("",font12));
	        nested2.addCell(cell2);
	
		nested2.setWidthPercentage(100);
		table2.addCell(nested2);
		
		
		table2.setWidthPercentage(90);
		document.add(table2);
		
		Paragraph parag10=new Paragraph("\n.....................................................................................................................裁切線",font8);
		parag10.setAlignment(Element.ALIGN_CENTER);
		document.add(parag10);
		
		
	
				
		
		if(payMoneyNumber >pSystem.getPaySystemLimitMoney() || pSystem.getPaySystemStoreActive()==0 || pSystem.getPaySystemStoreActive()==9)
		{
			parag6=new Paragraph("\n",font10);
			parag6.setAlignment(Element.ALIGN_LEFT);
			document.add(parag6);
		
				
			float[] widths3 = {0.3f,0.35f, 0.35f};
			table2 = new PdfPTable(widths3);
		
			cell2 = new PdfPCell(new Paragraph("櫃臺繳款收訖戳記",font12));
			cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell2.setFixedHeight(200f);
			
			//cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
			
			table2.addCell(cell2);
			
				
			cell2= new PdfPCell(new Paragraph("帳單條碼",font12));
			cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
			table2.addCell(cell2);
			
			String sContentX="\n帳單月份:"+listDate[12]+"\n\n"
							+"繳款人:\n\n"+"      "+listDate[3]+" "+listDate[4]+" "+listDate[15]+"\n\n"
							+"繳款金額:"+mnf.format(Integer.parseInt(listDate[10]))+"\n\n"
							+"繳款日期:";
			
			cell2= new PdfPCell(new Paragraph(sContentX,font10));
			table2.addCell(cell2);
			
			table2.setWidthPercentage(90);
			document.add(table2);
	
			imageFtId.setAbsolutePosition(235,150);
			document.add(imageFtId);

            parag10=new Paragraph("\n\n(本單請於 "+listDate[0]+" 櫃臺繳款.)",font8);
            parag10.setAlignment(Element.ALIGN_CENTER);
            document.add(parag10);
		
			return 90;
		}
		
		
		Barcode39 code1 = new Barcode39();
		code1.setCode(code[1]);
		code1.setStartStopText(true);
		code1.setSize(barcodeFontSize);
		code1.setN(barcodeN);
		code1.setBarHeight(barcodeHieght);
		Image imageCode1 = code1.createImageWithBarcode(cb, null, null);
		imageCode1.setAbsolutePosition(210,175);
		document.add(imageCode1);
		
		Barcode39 code2 = new Barcode39();
		code2.setCode(code[2]);
		code2.setStartStopText(true);
		code2.setSize(barcodeFontSize);
		code2.setN(barcodeN);
		code2.setBarHeight(barcodeHieght);
		Image imageCode2 = code2.createImageWithBarcode(cb, null, null);
		imageCode2.setAbsolutePosition(210,125);
		document.add(imageCode2);
		
		Barcode39 code3 = new Barcode39();
		code3.setCode(code[3]);
		code3.setStartStopText(true);
		code3.setSize(barcodeFontSize);
		code3.setN(barcodeN);
		code3.setBarHeight(barcodeHieght);
		Image imageCode3 = code3.createImageWithBarcode(cb, null, null);
		imageCode3.setAbsolutePosition(210,75);
		document.add(imageCode3);
		
		
		String cellContent2="\n       便利商店繳款(7-ELEVEN,全家,萊爾富,OK)                         *便利商店收據請保留六個月";
		document.add(new Paragraph(cellContent2,font10));
		document.add(new Paragraph("\n",font8));
		
		float[] widths3 = {0.3f,0.4f, 0.3f};
		table2 = new PdfPTable(widths3);
	
		cell2 = new PdfPCell(new Paragraph("便利商店/櫃臺繳款收訖戳記",font10));
		cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
		cell2.setFixedHeight(200f);
		
		//cell2.setHorizontalAlignment(Element.ALIGN_CENTER);

		table2.addCell(cell2);
		
			
		cell2= new PdfPCell(new Paragraph("帳單條碼",font10));
		cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
		table2.addCell(cell2);
		
	
		String sContent4="繳款期限:"+listDate[11]+" \n\n"
			+"繳款人:\n\n    "+listDate[3]+" "+listDate[4]+" "+listDate[15]+"\n\n"
			+"繳款金額:"+mnf.format(Integer.parseInt(listDate[10]))+"元\n\n\n\n\n"
			+"開單機構:"+listDate[0]+"\n\n"
			+"帳單流水號:"+code[0];
		
		cell2= new PdfPCell(new Paragraph(sContent4,font10));
		table2.addCell(cell2);
		
		table2.setWidthPercentage(90);
		document.add(table2);
	    	
        return 90;
    	}
		catch(Exception e)
		{
            System.out.println(e.getMessage());
			return 1;	
		}		
    }	
   
   	public String replaceBirth(String showBirth,Student stu)
   	{
   		StringBuffer sb=new StringBuffer();
   		
   		SimpleDateFormat sdf=new SimpleDateFormat("MM月dd日");
   		showBirth=showBirth.replace("XXX",sdf.format(stu.getStudentBirth()));	
   		showBirth=showBirth.replace("YYY",stu.getStudentName());	
   		
   		return 	showBirth;
   	}
   	
   
 public int makeConfirmPageContent(int feenumber,PdfWriter writer2,Document document,String path)
    {
    	

	
		String[] listDate=makeConfirmListDate(feenumber);
		
		PaySystemMgr psm=PaySystemMgr.getInstance();
		PaySystem pSystem=(PaySystem)psm.find(1); 
		
	    	try{
			
			int payMoneyNumber=Integer.parseInt(listDate[10]);
			
			PdfContentByte cb = writer2.getDirectContent();
			
			float barcodeN=(float)1.7;
			float barcodeFontSize=(float)10.0;
			float barcodeHieght=(float)15.0;
			float barcodeHieght2=(float)10.0;
		
		
			String fontPath=path+"font/simsun.ttc,0";
			
			String logoImge=path+"font/logo.tif";
			
			BaseFont bfComic = BaseFont.createFont(fontPath,BaseFont.IDENTITY_H,BaseFont.NOT_EMBEDDED);
			
			Font font14b = new Font(bfComic, 14,Font.BOLD);
			Font font14 = new Font(bfComic, 14,Font.NORMAL);
			Font font12 = new Font(bfComic, 12,Font.NORMAL);
			Font font10 = new Font(bfComic, 10,Font.NORMAL);
			
			
			String strTitle="學雜費收款確認單 "+listDate[12];
			Paragraph parag1=new Paragraph(strTitle,font14b);
			parag1.setAlignment(Element.ALIGN_CENTER);
			document.add(parag1);
		
			Image  logoI= Image.getInstance(logoImge);
			logoI.setAlignment(Image.LEFT | Image.UNDERLYING);
	            	document.add(logoI);

			Paragraph parag2=new Paragraph("           "+listDate[0],font12);
			parag2.setAlignment(Element.ALIGN_LEFT);
			document.add(parag2);
			
			Paragraph parag3=new Paragraph("           地址: "+listDate[1],font12);
			parag3.setAlignment(Element.ALIGN_LEFT);
			document.add(parag3);
			
			
			Paragraph parag4=new Paragraph("           電話: "+listDate[2],font12);
			parag4.setAlignment(Element.ALIGN_LEFT);
			document.add(parag4);
			
			String space="                               ";
			Paragraph parag5=new Paragraph(space+"     "+listDate[3]+" "+listDate[4],font12);
			parag5.setAlignment(Element.ALIGN_LEFT);
			document.add(parag5);
			
			Barcode39 codeFeeticketId = new Barcode39();
			codeFeeticketId.setCode(String.valueOf(feenumber));
			codeFeeticketId.setStartStopText(true);
			codeFeeticketId.setSize(barcodeFontSize);
			codeFeeticketId.setN(barcodeN);
			codeFeeticketId.setBarHeight(barcodeHieght);
			Image imageFtId = codeFeeticketId.createImageWithBarcode(cb, null, null);
			imageFtId.setAlignment(Element.ALIGN_CENTER);
			document.add(imageFtId);
			
			float[] widths = {0.15f, 0.35f, 0.15f, 0.35f};
			PdfPTable table = new PdfPTable(widths);
		
			PdfPCell cell = new PdfPCell(new Paragraph("學雜費明細",font12));
			cell.setColspan(4);
			cell.setFixedHeight(20f);
			cell.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table.addCell(cell);
			
			cell= new PdfPCell(new Paragraph("項目                     應收      折扣     小計",font10));
			cell.setColspan(2);
			cell.setFixedHeight(20f);
			cell.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
			cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table.addCell(cell);
		
			cell= new PdfPCell(new Paragraph("項目                     應收      折扣     小計",font10));
			cell.setColspan(2);
			cell.setFixedHeight(20f);
			cell.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table.addCell(cell);
			
			
			cell = new PdfPCell(new Paragraph(listDate[5],font12));
			cell.setColspan(2);
			cell.setFixedHeight(80f);
			table.addCell(cell);
			
			
			cell = new PdfPCell(new Paragraph(listDate[6],font12));
			cell.setColspan(2);
			cell.setFixedHeight(80f);
			table.addCell(cell);
			
			cell= new PdfPCell(new Paragraph("狀態",font12));
			cell.setFixedHeight(20f);
			cell.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table.addCell(cell);
			
			cell= new PdfPCell(new Paragraph(listDate[14],font12));
			cell.setFixedHeight(20f);
			cell.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table.addCell(cell);
			
			cell= new PdfPCell(new Paragraph("已繳金額",font12));
			cell.setFixedHeight(20f);
			cell.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table.addCell(cell);
			
			cell= new PdfPCell(new Paragraph(listDate[15],font12));
			cell.setFixedHeight(20f);
			cell.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table.addCell(cell);
			
			table.setWidthPercentage(90);
			document.add(table);
		
			Paragraph paragv1=new Paragraph("\n",font14);
			paragv1.setAlignment(Element.ALIGN_LEFT);
			document.add(paragv1);
		
			float[] widths2 = {0.05f, 0.50f, 0.45f};
			PdfPTable table2 = new PdfPTable(widths2);
		
			PdfPCell cell2 = new PdfPCell(new Paragraph("繳款明細",font12));
			cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell2.setFixedHeight(100f);
			
			//cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
			
			table2.addCell(cell2);
			
			String cellContent=listDate[16];
			
						
			cell2= new PdfPCell(new Paragraph(cellContent,font12));
			table2.addCell(cell2);
			
		
			PdfPTable nested2 = new PdfPTable(1);
			cell2= new PdfPCell(new Paragraph(listDate[0]+"蓋章",font12));
			cell2.setFixedHeight(20f);
			cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell2.setVerticalAlignment(Element.ALIGN_MIDDLE);
		        nested2.addCell(cell2);
		        cell2= new PdfPCell(new Paragraph("",font12));
		        nested2.addCell(cell2);
		
			nested2.setWidthPercentage(100);
			table2.addCell(nested2);
			
			
			table2.setWidthPercentage(90);
			document.add(table2);
			
		    return 90;
	    	
	    }catch(Exception e){
			return 1;	
		}		
    }
   
  /* 
    public String[] makeListDate(Feeticket ft)
    {
    	
	    JsfAdmin ja=JsfAdmin.getInstance();
		JsfTool jt=JsfTool.getInstance();
		FeeAdmin fa=FeeAdmin.getInstance();
		
		PaySystemMgr psm=PaySystemMgr.getInstance();
		
		PaySystem pSystem=(PaySystem)psm.find(1); 
			  		
		
		String[] listDate=new String[15];
		
		try{
		
			//make code1
			Date eDate=ft.getFeeticketEndPayDate();
			int eyear=eDate.getYear()+1900-1911;
			int emonth=eDate.getMonth()+1;
			int eday=eDate.getDate()-pSystem.getPaySystemBeforeLimitDate();
			String sEndMonth="";
			
			if(emonth <10)
				  sEndMonth="0"+String.valueOf(emonth);
			else
				  sEndMonth=String.valueOf(emonth);
			
			String sEndDay="";
			
			if(eday <10)
				  sEndDay="0"+String.valueOf(eday);
			else
				  sEndDay=String.valueOf(eday);
		
			String sEndDate=String.valueOf(eyear)+sEndMonth+sEndDay;
			
		
		
			StudentMgr smx=StudentMgr.getInstance();
			Student stu=(Student)smx.find(ft.getFeeticketStuId());	
		
		
			ClassesMgr cmx=ClassesMgr.getInstance();
			Classes cla=(Classes)cmx.find(stu.getStudentClassId());
			
			String claName="";
			if(stu.getStudentClassId()==0)
				claName="未定";
			else
				claName=cla.getClassesName();
			
			
			ClassesFee[] fc=ja.getClassesFeeByNumber(ft.getFeeticketFeenumberId());
			String[] listData2=new String[12];
			
			String block1="";
			String block2="";	
			
			ClassesMoneyMgr cfmx=ClassesMoneyMgr.getInstance();
			
			for(int i=0;i<fc.length;i++)
			{
				
				ClassesMoney cma=(ClassesMoney)cfmx.find(fc[i].getClassesFeeCMId());	
				
				int claNamex=10-cma.getClassesMoneyName().length();
				String sclaName="";
				for(int j=0;j<claNamex;j++)
					sclaName+="  ";	
				
				int shouldNumber=8-String.valueOf(fc[i].getClassesFeeShouldNumber()).length();
				String sshouldNumber="";
				for(int k=0;k<shouldNumber;k++)
					sshouldNumber+=" ";
					
				int totalDiscount=7-String.valueOf(fc[i].getClassesFeeTotalDiscount()).length();
				String stotalDiscount="";
				for(int k=0;k<totalDiscount;k++)
					stotalDiscount+=" ";
				
				int xTotal=fc[i].getClassesFeeShouldNumber()-fc[i].getClassesFeeTotalDiscount();
				
				int totalNumber=8-String.valueOf(xTotal).length();
				String stotalNumber="";
				for(int k=0;k<totalNumber;k++)
					stotalNumber+=" ";			
				
				listData2[i]=cma.getClassesMoneyName()+sclaName+fc[i].getClassesFeeShouldNumber()+sshouldNumber+fc[i].getClassesFeeTotalDiscount()+stotalDiscount+xTotal+stotalNumber;
			
				if(i !=5 || i !=11)
					listData2[i] +="\n";
			}		 
			
			int notPay=fa.getAllNotPayNumber(ft);
			int nowTotalMoney=ft.getFeeticketTotalMoney();
			int nowShould=nowTotalMoney-ft.getFeeticketPayMoney();
			int payed=ft.getFeeticketPayMoney();
			
			int payActual=nowShould+notPay;
			for(int j=0;j<12;j++)
			{
				if(listData2[j]==null)
				{
					listData2[j]="\n";
					
				}
				if(j<=5)
				{	
					block1+=listData2[j];
				}
				else if(j>=6 && j<=9)
				{
					block2+=listData2[j];
				}
				else if(j==10)
				{
					block2+="**前期未繳金額***                   "+notPay+"\n";
				}
				else if(j==11)
				{
					block2+="**本期已繳金額***                   "+payed;
					
				}
			}   
			
			
			listDate[0]=pSystem.getPaySystemCompanyName();
			listDate[1]=pSystem.getPaySystemCompanyAddress();
			listDate[2]=pSystem.getPaySystemCompanyPhone();
			listDate[3]=claName;
			
			String nickName="";
			if(stu.getStudentNickname().length()>1)
				nickName=stu.getStudentNickname().substring(0,1).toUpperCase()+stu.getStudentNickname().substring(1).toLowerCase();
			
			listDate[4]=stu.getStudentName()+" "+nickName;
			listDate[5]=block1;
			listDate[6]=block2;
			listDate[7]=pSystem.getPaySystemBankName();
			listDate[8]=pSystem.getPaySystemBankId();
			listDate[9]=pSystem.getPaySystemFirst5().trim()+String.valueOf(ft.getFeeticketFeenumberId());
			
			listDate[10]=String.valueOf(payActual);
			listDate[11]=String.valueOf(eyear)+"/"+sEndMonth+"/"+sEndDay;
			listDate[12]=String.valueOf(eyear)+"年"+sEndMonth+"月";
		
			String specialCharge="";
			
			String ftPs=ft.getFeeticketPs().trim();
			if(ftPs!=null && ftPs.length() >0)
				specialCharge="        "+ft.getFeeticketPs()+"\n";
			
			if(notPay>0)
					specialCharge+="        "+fa.getAllNotPayNumberString(ft)+"\n";
					
			listDate[13]=specialCharge;
			listDate[14]=payActual+" (本期:"+String.valueOf(nowTotalMoney)+"+前期:"+String.valueOf(notPay)+"-已繳:"+String.valueOf(payed)+")";	
		
		}catch(Exception e){
			
			System.out.println("error:"+e.getMessage());	
		}
		
		return listDate;
    	
    }

    */
    public int countStringLength(String word)
    {
        if(word.length()==0)
            return 0;
        int totalLength=0;
        for(int i=0;i<word.length();i++)
        {
            char x=word.charAt(i);
            
            if(x >256)
                totalLength=totalLength+2;
            else
               totalLength++; 
        }
        
        return totalLength;
    }

    public String[] makeListDate2(Feeticket ft,Student stu,PaySystem pSystem,Feeticket[] notpayFeeticket)
    {
        
        DecimalFormat mnf = new DecimalFormat("###,###,##0");      	

	    JsfAdmin ja=JsfAdmin.getInstance();
		JsfTool jt=JsfTool.getInstance();
		FeeAdmin fa=FeeAdmin.getInstance();
		
		String[] listDate=new String[18];
		
		try{
		
			//make code1
			Date eDate=ft.getFeeticketEndPayDate();
			int eyear=eDate.getYear()+1900-1911;
			int emonth=eDate.getMonth()+1;
			int eday=eDate.getDate()-pSystem.getPaySystemBeforeLimitDate();
			String sEndMonth="";
			
			if(emonth <10)
				  sEndMonth="0"+String.valueOf(emonth);
			else
				  sEndMonth=String.valueOf(emonth);
			
			String sEndDay="";
			
			if(eday <10)
				  sEndDay="0"+String.valueOf(eday);
			else
				  sEndDay=String.valueOf(eday);
		
			String sEndDate=String.valueOf(eyear)+sEndMonth+sEndDay;
		
			ClassesMgr cmx=ClassesMgr.getInstance();
			Classes cla=(Classes)cmx.find(stu.getStudentClassId());
			
			String claName="";
			if(stu.getStudentClassId()==0)
				claName="未定";
			else
				claName=cla.getClassesName();
			
			
			ClassesFee[] fc=ja.getClassesFeeByNumber(ft.getFeeticketFeenumberId());
			String[] listData2=new String[20];
			
			String block1="";
			String block2="";	
			
            int notPay=fa.countNotpayFeeticket(notpayFeeticket);
            int nowTotalMoney=ft.getFeeticketTotalMoney();
            int nowShould=nowTotalMoney-ft.getFeeticketPayMoney();
            int payed=ft.getFeeticketPayMoney();
            int payActual=nowShould+notPay;
            
			ClassesMoneyMgr cfmx=ClassesMoneyMgr.getInstance();

			for(int i=0;i<fc.length;i++)
			{
				
				ClassesMoney cma=(ClassesMoney)cfmx.find(fc[i].getClassesFeeCMId());	
				
				int claNamex=20-countStringLength(cma.getClassesMoneyName());
				String sclaName="";
				for(int j=0;j<claNamex;j++)
					sclaName+=" ";	
				
				int shouldNumber=6-countStringLength(mnf.format(fc[i].getClassesFeeShouldNumber()));
				String sshouldNumber="";
				for(int k=0;k<shouldNumber;k++)
					sshouldNumber+=" ";
					
				int totalDiscount=7-countStringLength(mnf.format(fc[i].getClassesFeeTotalDiscount()));
				String stotalDiscount="";
				for(int k=0;k<totalDiscount;k++)
					stotalDiscount+=" ";
				
				int xTotal=fc[i].getClassesFeeShouldNumber()-fc[i].getClassesFeeTotalDiscount();
				
				int totalNumber=8-countStringLength(mnf.format(xTotal));
				String stotalNumber="";
				for(int k=0;k<totalNumber;k++)
					stotalNumber+=" ";			
				
				listData2[i]=cma.getClassesMoneyName()+sclaName+sshouldNumber+mnf.format(fc[i].getClassesFeeShouldNumber())+stotalDiscount+mnf.format(fc[i].getClassesFeeTotalDiscount())+stotalNumber+mnf.format(xTotal);
			
				if(i !=9)
					listData2[i] +="\n";
			}		 
            
            int shouldLength=mnf.format(nowShould).length();
            int shouldSpace=24-shouldLength;
            String sSpaceString="";
            for(int vv=0;vv<shouldSpace;vv++)    
                sSpaceString+=" ";
            
            listData2[fc.length]="\n";
            listData2[fc.length+1]="*本期新增金額小計"+sSpaceString+mnf.format(nowShould);					

            if(notpayFeeticket !=null)
            {
                int goA=0;
                int startArray=fc.length+3;
                
                listData2[startArray]="  ";                
                if(startArray !=9)
					listData2[startArray] +="\n";

                listData2[startArray+1]="   *********前期未繳帳單***********";
                 if((startArray+1) !=9)
					listData2[startArray+1] +="\n";        


                for(int x=0;x<notpayFeeticket.length;x++)
                {
                    goA=startArray+x+2;
                    
                    if(goA <18)
                    {

                        int payFt=notpayFeeticket[x].getFeeticketTotalMoney()-notpayFeeticket[x].getFeeticketPayMoney();
                        String feenumber=String.valueOf(notpayFeeticket[x].getFeeticketFeenumberId());
                        
                        int notPatLength=11-mnf.format(payFt).length();
                        String xSpaces="";
                        for(int y=0;y<notPatLength;y++)            
                                 xSpaces+=" ";       
                    
                        if(goA <=17)
                            listData2[goA]="月份:"+feenumber.substring(0,4)+"("+notpayFeeticket[x].getFeeticketFeenumberId()+") 未繳金額:"+xSpaces+mnf.format(payFt);
                        
                        if(goA !=10)
					        listData2[goA] +="\n";
                    }                    
                }                                             
                goA++;
                
                if(goA <=17)
                    listData2[goA]="";
    
                if(goA !=9)
			        listData2[goA] +="\n";

                int npLength=24-mnf.format(notPay).length();
                String npString="";
                
                for(int lo=0;lo<npLength;lo++)
                    npString+=" ";
            }
    
    		for(int j=0;j<18;j++)
			{
				if(listData2[j]==null)
				{
					listData2[j]="\n";
				}

				if(j<9)
				{	
					block1+=listData2[j];
				}else if(j>=9 && j<18){
					block2+=listData2[j];
				}
			}   
			
			
			listDate[0]=pSystem.getPaySystemCompanyName();
			listDate[1]=pSystem.getPaySystemCompanyAddress();
			listDate[2]=pSystem.getPaySystemCompanyPhone();
			listDate[3]=claName;
			
			String nickName="";
			if(stu.getStudentNickname().length()>1)
				nickName=stu.getStudentNickname().substring(0,1).toUpperCase()+stu.getStudentNickname().substring(1).toLowerCase();
			
			listDate[4]=stu.getStudentName();
			listDate[15]=nickName;
			listDate[5]=block1;
			listDate[6]=block2;
			listDate[7]=pSystem.getPaySystemBankName();
			listDate[8]=pSystem.getPaySystemBankId();
			listDate[9]=pSystem.getPaySystemFirst5().trim()+String.valueOf(ft.getFeeticketFeenumberId());
			
			listDate[10]=String.valueOf(payActual);
			listDate[11]=String.valueOf(eyear)+"/"+sEndMonth+"/"+sEndDay;
			listDate[12]=String.valueOf(eyear)+"年"+sEndMonth+"月";
		
			String specialCharge="";
			
			String ftPs=ft.getFeeticketPs().trim();
			if(ftPs!=null && ftPs.length() >0)
				specialCharge="        "+ft.getFeeticketPs()+"\n";
			
			if(notPay>0)    
					specialCharge+=fa.getAllNotPayNumberString(notpayFeeticket);
					
			listDate[13]=specialCharge;
			
			String xSpace="";
			int notpayLength=mnf.format(notPay).length();
			int xLoop=17;
			if(notpayLength>1)
			{
				xLoop=17-notpayLength;
			}	
			for(int lp=0;lp<xLoop;lp++)
					xSpace+=" ";

			String ySpace="";			
			int payedLength=mnf.format(payed).length();
			int yLoop=15;
			if(payedLength>1)
			{
				yLoop=15-payedLength;
			}	
			for(int lp=0;lp<yLoop;lp++)
					ySpace+=" ";
			
			String zSpace="";			
			int payActualLength=mnf.format(payActual).length();
			int zLoop=19;
			if(payActualLength>1)
			{
				zLoop=19-payActualLength;
			}	
			for(int lp=0;lp<zLoop;lp++)
					zSpace+=" ";

			listDate[14]=mnf.format(nowTotalMoney)+xSpace+mnf.format(notPay)+ySpace+mnf.format(payed)+zSpace+mnf.format(payActual);
			listDate[16]=String.valueOf(notPay);
			listDate[17]=String.valueOf(payed);
		
		}catch(Exception e){
			
			System.out.println("error:"+e.getMessage());	
		}
		
		return listDate;
    	
    }
    public String[] makeConfirmListDate(int feenumber)
    {
    	
    	JsfAdmin ja=JsfAdmin.getInstance();
	JsfTool jt=JsfTool.getInstance();
	PaySystemMgr psm=PaySystemMgr.getInstance();
	
	PaySystem pSystem=(PaySystem)psm.find(1); 
		  		
	Feeticket ft=ja.getFeeticketByNumberId(feenumber);
	if(ft==null)
	{
		return null;
	}
	
	String[] listDate=new String[17];
	
	try{
	
	//make code1
	Date eDate=ft.getFeeticketEndPayDate();
	int eyear=eDate.getYear()+1900-1911;
	int emonth=eDate.getMonth()+1;
	int eday=eDate.getDate()-pSystem.getPaySystemBeforeLimitDate();
	String sEndMonth="";
	
	if(emonth <10)
		  sEndMonth="0"+String.valueOf(emonth);
	else
		  sEndMonth=String.valueOf(emonth);
	
	String sEndDay="";
	
	if(eday <10)
		  sEndDay="0"+String.valueOf(eday);
	else
		  sEndDay=String.valueOf(eday);

	String sEndDate=String.valueOf(eyear)+sEndMonth+sEndDay;
	


	StudentMgr smx=StudentMgr.getInstance();
	Student stu=(Student)smx.find(ft.getFeeticketStuId());	


	ClassesMgr cmx=ClassesMgr.getInstance();
	Classes cla=(Classes)cmx.find(stu.getStudentClassId());
	
	String claName="";
	if(stu.getStudentClassId()==0)
		claName="未定";
	else
		claName=cla.getClassesName();
	
	
	ClassesFee[] fc=ja.getClassesFeeByNumber(feenumber);
	String[] listData2=new String[12];
	
	String block1="";
	String block2="";	
	
	ClassesMoneyMgr cfmx=ClassesMoneyMgr.getInstance();
	
	for(int i=0;i<fc.length;i++)
	{
	
	ClassesMoney cma=(ClassesMoney)cfmx.find(fc[i].getClassesFeeCMId());	
	
	int claNamex=10-cma.getClassesMoneyName().length();
	String sclaName="";
	for(int j=0;j<claNamex;j++)
		sclaName+="  ";	
	
	int shouldNumber=8-String.valueOf(fc[i].getClassesFeeShouldNumber()).length();
	String sshouldNumber="";
	for(int k=0;k<shouldNumber;k++)
		sshouldNumber+=" ";
		
	int totalDiscount=7-String.valueOf(fc[i].getClassesFeeTotalDiscount()).length();
	String stotalDiscount="";
	for(int k=0;k<totalDiscount;k++)
		stotalDiscount+=" ";
	
	int xTotal=fc[i].getClassesFeeShouldNumber()-fc[i].getClassesFeeTotalDiscount();
	
	int totalNumber=8-String.valueOf(xTotal).length();
	String stotalNumber="";
	for(int k=0;k<totalNumber;k++)
		stotalNumber+=" ";			
	
	listData2[i]=cma.getClassesMoneyName()+sclaName+fc[i].getClassesFeeShouldNumber()+sshouldNumber+fc[i].getClassesFeeTotalDiscount()+stotalDiscount+xTotal+stotalNumber;
	
	if(i !=5 || i !=11)
	listData2[i] +="\n";
	}		 
	
	int payActual=ft.getFeeticketTotalMoney()-ft.getFeeticketPayMoney();
	int payed=ft.getFeeticketPayMoney();
	
	
	
	for(int j=0;j<12;j++)
	{
		if(listData2[j]==null)
		{
			listData2[j]="\n";
			
		}
		if(j<=5)
		{	
			block1+=listData2[j];
		}
		else if(j>=6 && j<=9)
		{
			block2+=listData2[j];
		}
		else if(j==10)
		{
			block2+="\n";
		}
		else if(j==11)
		{
			block2+="\n";
		}
	}   
	
	
	listDate[0]=pSystem.getPaySystemCompanyName();
	listDate[1]=pSystem.getPaySystemCompanyAddress();
	listDate[2]=pSystem.getPaySystemCompanyPhone();
	listDate[3]=claName;
	String nickName="";
	if(stu.getStudentNickname().length()>1)
		nickName=stu.getStudentNickname().substring(0,1).toUpperCase()+stu.getStudentNickname().substring(1).toLowerCase();
	listDate[4]=stu.getStudentName()+" "+nickName;
	listDate[5]=block1;
	listDate[6]=block2;
	listDate[7]=pSystem.getPaySystemBankName();
	listDate[8]=pSystem.getPaySystemBankId();
	listDate[9]=pSystem.getPaySystemFirst5().trim()+String.valueOf(feenumber);
	
	listDate[10]=String.valueOf(payActual);
	listDate[11]=String.valueOf(eyear)+"/"+sEndMonth+"/"+sEndDay;
	listDate[12]=String.valueOf(eyear)+"年"+sEndMonth+"月";
	
	String specialCharge="";
	
	String ftPs=ft.getFeeticketPs().trim();
	if(ftPs!=null && ftPs.length() >0)
	{
		specialCharge="        "+ft.getFeeticketPs()+"\n";
	}	
	listDate[13]=specialCharge;
	
	if(ft.getFeeticketStatus()==1)
		listDate[14]="尚未繳款";
	else if(ft.getFeeticketStatus()==2)
		listDate[14]="已繳款,尚未繳清";
	else if(ft.getFeeticketStatus()==91)
		listDate[14]="已繳清";
	else if(ft.getFeeticketStatus()==92)
		listDate[14]="超繳";
	
	listDate[15]=String.valueOf(ft.getFeeticketPayMoney());
	
	PayFee[] pfx=ja.getPayFeeByNumberId(ft.getFeeticketFeenumberId());
	
	listDate[16]="  繳費時間   金 額  付款方式 \n";
	
	for(int y=0;y<pfx.length;y++)
	{
		String payWay="";	
		switch(pfx[y].getPayFeeSourceCategory())
		{
				case 3:payWay="便利商店代收";
					break;
				case 2:payWay="約定帳號";
					break;
				case 1:payWay="虛擬帳號";
					break;
				case 4:payWay="櫃臺繳款";
					break; 
				case 5:payWay="指定匯款帳號";
					break;		
		}
		listDate[16]+="* "+jt.ChangeDateToString(pfx[y].getPayFeeLogPayDate())+"  "+pfx[y].getPayFeeMoneyNumber()+"  "+payWay+"\n";
		
	}
	
	}catch(Exception e){
	System.out.println("error:"+e.getMessage());	
	}
	return listDate;
    	
    }
    public String[] makeCode(Feeticket ft,PaySystem pSystem,Feeticket[] notpayFeeticket)
    {
    	JsfAdmin ja=JsfAdmin.getInstance();
		JsfTool jt=JsfTool.getInstance();

		String[] code=new String[4];
		
		//make fnCode
		code[0]=String.valueOf(ft.getFeeticketFeenumberId());
		
		//make code1
		Date eDate=ft.getFeeticketEndPayDate();
		int eyear=eDate.getYear()+1900-1911;
		int emonth=eDate.getMonth()+1;
		int eday=eDate.getDate();
		String sEndMonth="";
		
		if(emonth <10)
			  sEndMonth="0"+String.valueOf(emonth);
		else
			  sEndMonth=String.valueOf(emonth);
		
		String sEndDay="";
		
		if(eday <10)
			  sEndDay="0"+String.valueOf(eday);
		else
			  sEndDay=String.valueOf(eday);
	
		String sEndDate=String.valueOf(eyear)+sEndMonth+sEndDay;
		
		code[1]=String.valueOf(sEndDate)+pSystem.getPaySystemBankStoreNickName().trim();
		
		//make code2
		code[2]=pSystem.getPaySystemCompanyStoreNickName().trim()+"0000"+String.valueOf(ft.getFeeticketFeenumberId());
		
		
		//make code3

		int nowshould=ft.getFeeticketTotalMoney()-ft.getFeeticketPayMoney();		
		
		FeeAdmin fa=FeeAdmin.getInstance(); 

		int notPay=fa.countNotpayFeeticket(notpayFeeticket);
		
		int nowShould=ft.getFeeticketTotalMoney()-ft.getFeeticketPayMoney();
		int money=notPay+nowShould;
		
		String sMoney=String.valueOf(money);
		int sMonthLength=sMoney.length();
		if(sMonthLength !=9)
		{
			int needzero=9-sMonthLength;
			for(int i=0;i<needzero;i++)
			{
				sMoney="0"+sMoney;
			}
		}
		String payMonth=code[0].substring(0,4);
		String tempCode3=payMonth+sMoney;
		
		int[] sumCode1=jt.checkCode(code[1]);
		int[] sumCode2=jt.checkCode(code[2]);
		int[] sumCode3=jt.checkCode(tempCode3);
		
		int checkSum1=sumCode1[0]+sumCode2[0]+sumCode3[0];
		int checkSum2=sumCode1[1]+sumCode2[1]+sumCode3[1];
	
		String checkCode1;
		String checkCode2;
	
		int xcode1=checkSum1%11;
	
		if(xcode1==0)
			checkCode1="A";
		else if(xcode1==10)
			checkCode1="B";
		else
			checkCode1=String.valueOf(xcode1);
			
		int xcode2=checkSum2%11;
	
		if(xcode2==0)
			checkCode2="X";
		else if(xcode2==10)
			checkCode2="Y";
		else
			checkCode2=String.valueOf(xcode2);	
	
		StudentMgr smx=StudentMgr.getInstance();
		Student stu=(Student)smx.find(ft.getFeeticketStuId());	
	
		ClassesMgr cmx=ClassesMgr.getInstance();
		Classes cla=(Classes)cmx.find(stu.getStudentClassId());
		
		code[3]=payMonth+checkCode1+checkCode2+sMoney;
		
		return code;
	    	
    }
    
    public int makePDFSalaryPage(String path,boolean isF1,int stId)
    {
    	try{
	    	
	    	Document document=new Document(PageSize.A4,15,15,10,10);

			String path2=path+"salary";
			
			File f=new File(path2);
			
			if(!f.exists())
			{
				f.mkdir();	
			}
		
			if(isF1){
				path2=path2+"/1.pdf";		
			}else{
				path2=path2+"/2.pdf";		
			}
			PdfWriter writer2=PdfWriter.getInstance(document, new FileOutputStream(path2));
			
			document.open();

			int status=makeSalaryContent(writer2,document,path,stId);
    	
    		document.close();
    		
    		return status;
    	}catch(Exception e)
    	{
    		System.out.println("error:"+e.getMessage());	
    	}
    	
    	return 90;	
    }
    
    
    public int makeSalaryContent(PdfWriter writer2,Document document,String path,int stId)
    {
    	
    	DecimalFormat mnf = new DecimalFormat("###,###,##0");
    			
    	SalaryTicketMgr stm=SalaryTicketMgr.getInstance();
    	
    	SalaryTicket st=(SalaryTicket)stm.find(stId);
    	JsfTool jt=JsfTool.getInstance();
		PositionMgr pm=PositionMgr.getInstance();
		ClassesMgr cm=ClassesMgr.getInstance();
		DepartMgr dm=DepartMgr.getInstance();
		SalaryAdmin sa=SalaryAdmin.getInstance();


    	TeacherMgr tm=TeacherMgr.getInstance();
		Teacher tea=(Teacher)tm.find(st.getSalaryTicketTeacherId());
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM");
 
 		PaySystemMgr em=PaySystemMgr.getInstance();
		PaySystem eX=(PaySystem)em.find(1);
	
 
		int stNumber=st.getSalaryTicketSanumberId();
		boolean type1show=false;
		boolean type2show=false;
		boolean type3show=false;
		
		int numberType1=0;
		int numberType2=0;
		int numberType3=0;
	
		SalaryTypeMgr stm2=SalaryTypeMgr.getInstance();
		SalaryFee[] sfs=sa.getSalaryFeeBySanumber(stNumber);
	
		
    	try{
		
		PdfContentByte cb = writer2.getDirectContent();
		
		float barcodeN=(float)1.7;
		float barcodeFontSize=(float)10.0;
		float barcodeHieght=(float)30.0;
		float barcodeHieght2=(float)24.0;
		float barcodeN2=(float)1.7;
		
		String fontPath=path+"font/simsun.ttc,0";
		String logoImge=path+"font/logo.tif";
		

		BaseFont bfComic = BaseFont.createFont(fontPath,BaseFont.IDENTITY_H,BaseFont.NOT_EMBEDDED);
		Font font14b = new Font(bfComic, 12,Font.NORMAL);
		Font font14T = new Font(bfComic, 14,Font.BOLD);
		Font font12 = new Font(bfComic, 12,Font.NORMAL);
		Font font10 = new Font(bfComic, 10,Font.NORMAL);
		
		Image  logoI= Image.getInstance(logoImge);
		logoI.setAlignment(Image.LEFT | Image.UNDERLYING);
        document.add(logoI);

		
		String classString="";		
		if(st.getSalaryTicketClassesId()==0)
		{ 
			classString="跨班";
		}else{
			
			Classes cla=(Classes)cm.find(st.getSalaryTicketClassesId()); 
			classString=cla.getClassesName();
		}
		
		String strTitle=eX.getPaySystemCompanyName()+"  月份:"+sdf.format(st.getSalaryTicketMonth())+" 薪資明細   班級:"+classString;;
		Paragraph parag1=new Paragraph(strTitle,font14b);
		parag1.setAlignment(Element.ALIGN_CENTER);
		document.add(parag1);


		strTitle="姓名:"+tea.getTeacherFirstName()+tea.getTeacherLastName();
		parag1=new Paragraph(strTitle,font14T);
		parag1.setAlignment(Element.ALIGN_CENTER);
		document.add(parag1);
		
		
		strTitle="............................................................................\n";
		parag1=new Paragraph(strTitle,font14b);
		parag1.setAlignment(Element.ALIGN_CENTER);
		document.add(parag1);
		
		
		
		strTitle="     薪資明細:\n\n"; 
		parag1=new Paragraph(strTitle,font14b);
		parag1.setAlignment(Element.ALIGN_LEFT);
		document.add(parag1);

		
		Hashtable ha=new Hashtable();
		
		for(int i=0;i<sfs.length;i++)
		{
			int typeNumber=sfs[i].getSalaryFeeType();
			String typeNumString=String.valueOf(typeNumber);
			Vector v=(Vector)ha.get(typeNumString);
						
			if(v==null)	
				v=new Vector();
			
			v.add(sfs[i]);
			
			ha.put((String)typeNumString,(Vector)v);					
		}
	
		
		float[] widths = {0.15f, 0.35f, 0.15f, 0.35f};
		PdfPTable table = new PdfPTable(widths);
		
		PdfPCell cell = new PdfPCell(new Paragraph("加 項 薪 資",font12));
		cell.setColspan(2);
		cell.setFixedHeight(20f);
		cell.setHorizontalAlignment(Element.ALIGN_CENTER);
		cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table.addCell(cell); 
		
		cell = new PdfPCell(new Paragraph("減 項 薪 資",font12));
		cell.setColspan(2);
		cell.setFixedHeight(20f);
		cell.setHorizontalAlignment(Element.ALIGN_CENTER);
		cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table.addCell(cell);  

		StringBuffer sb=new StringBuffer();
		StringBuffer sb2=new StringBuffer();


		for(int iRun=0;iRun<5;iRun++)	
		{
			Vector v2=null;
			String titleWord="";
			
			if(iRun==0) 
			{ 	
				titleWord="◎應領所得\n";
				v2=(Vector)ha.get("1");
			}else if(iRun==1){ 
				titleWord="\n◎課後才藝鐘點費\n";
				v2=(Vector)ha.get("4");	
			}else if(iRun==2){
				titleWord="\n◎課內才藝鐘點費\n";
				v2=(Vector)ha.get("5");	
			}else if(iRun==3){
				titleWord="◎代扣\n";
				v2=(Vector)ha.get("2");	
			}else if(iRun==4){
				titleWord="\n◎應扣薪資\n";
				v2=(Vector)ha.get("3");	
			}	
						
			String spaceTitle="         ";
			if(v2 !=null)
  			{ 	
				if(iRun==0) {
					sb.append(titleWord); 	
				}else if(iRun==1){
					sb.append(titleWord); 	
				}else if(iRun==2){
					sb.append(titleWord); 	
				}else if(iRun==3){
					sb2.append(titleWord); 	
				}else if(iRun==4){
					sb2.append(titleWord);
				}	
				
	  			for(int j=0;j<v2.size();j++) 
	  			{  
	  				StringBuffer nowBuffer=new StringBuffer(); 
	  				
	  				SalaryFee  sf=(SalaryFee)v2.get(j); 
	  				SalaryType sts=(SalaryType)stm2.find(sf.getSalaryFeeTypeId());
	  				String typeName=sts.getSalaryTypeName();	
	  				int wordLength=0;		
	  				if(typeName!=null) 
	  					wordLength= typeName.length();
  				
	  				StringBuffer spaceNumber=new StringBuffer();
	  					
	  				int runSpace=14-wordLength;
	  					
	  				for(int k=0;k<runSpace ;k++) 
	  						spaceNumber.append("  ");	
				
					String numString=mnf.format(sf.getSalaryFeeNumber());
					
					int runSpace2=9-numString.length();
					
					for(int k=0;k<runSpace2;k++)
	  						spaceNumber.append(" ");	
					
					  						
					nowBuffer.append(spaceTitle+sts.getSalaryTypeName()+":"+spaceNumber.toString()+numString+"\n");		  			
					
					if(sf.getSalaryFeePrintNeed()==1) 
						nowBuffer.append(spaceTitle+"        (* 註記:"+sf.getSalaryFeeLogPs()+")\n");
										
					if(iRun==0) 
					{ 	
						sb.append(nowBuffer);
					}else if(iRun==1){ 
						sb.append(nowBuffer);
					}else if(iRun==2){
						sb.append(nowBuffer);
					}else if(iRun==3){
						sb2.append(nowBuffer);
					}else if(iRun==4){
						sb2.append(nowBuffer);
					}	
  				}  
  			} 	
 		}
 		
		cell = new PdfPCell(new Paragraph(sb.toString(),font10));
		cell.setColspan(2);
		cell.setHorizontalAlignment(Element.ALIGN_LEFT);
		cell.setVerticalAlignment(Element.ALIGN_TOP);
		table.addCell(cell); 

   		cell = new PdfPCell(new Paragraph(sb2.toString(),font10));
		cell.setColspan(2);
		cell.setFixedHeight(20f);
		cell.setHorizontalAlignment(Element.ALIGN_LEFT);
		cell.setVerticalAlignment(Element.ALIGN_TOP);
		table.addCell(cell); 
 
		
		cell = new PdfPCell(new Paragraph("加項合計(a):",font12));
		cell.setFixedHeight(20f);
		cell.setHorizontalAlignment(Element.ALIGN_CENTER);
		cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table.addCell(cell); 

		cell = new PdfPCell(new Paragraph("                 "+mnf.format(st.getSalaryTicketMoneyType1()),font12));
		cell.setFixedHeight(20f);
		cell.setHorizontalAlignment(Element.ALIGN_CENTER);
		cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table.addCell(cell); 
		
		cell = new PdfPCell(new Paragraph("減項合計(b):",font12));
		cell.setFixedHeight(20f);
		cell.setHorizontalAlignment(Element.ALIGN_CENTER);
		cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table.addCell(cell); 

		cell = new PdfPCell(new Paragraph("                 "+mnf.format(st.getSalaryTicketMoneyType2()+st.getSalaryTicketMoneyType3()),font12));
		cell.setFixedHeight(20f);
		cell.setHorizontalAlignment(Element.ALIGN_CENTER);
		cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table.addCell(cell); 

		
		cell = new PdfPCell(new Paragraph("                                                    實發金額 (a)-(b):  "+mnf.format(st.getSalaryTicketMoneyType1()-st.getSalaryTicketMoneyType2()-st.getSalaryTicketMoneyType3()),font12));
		cell.setColspan(4);
		cell.setFixedHeight(20f);
		cell.setHorizontalAlignment(Element.ALIGN_CENTER);
		cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table.addCell(cell); 

		table.setWidthPercentage(90);
		document.add(table);		
		
		SalaryBank[] sbx=sa.getSalaryBankBySanunmber(st); 
		
		if(sbx ==null) 
		{ 
			return 90;		
		} 

		
		strTitle="     薪資發放明細:\n\n"; 
		parag1=new Paragraph(strTitle,font14b);
		parag1.setAlignment(Element.ALIGN_LEFT);
		document.add(parag1);
		
		SimpleDateFormat sdf5=new SimpleDateFormat("yyyy/MM/dd"); 
		
		float[] widths2 = {0.15f, 0.15f,0.30f, 0.20f, 0.20f};
		table = new PdfPTable(widths2);
		
		cell = new PdfPCell(new Paragraph("發放日期",font12));
		cell.setFixedHeight(20f);
		cell.setHorizontalAlignment(Element.ALIGN_CENTER);
		cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table.addCell(cell); 
		
		cell = new PdfPCell(new Paragraph("發放方式",font12));
		cell.setFixedHeight(20f);
		cell.setHorizontalAlignment(Element.ALIGN_CENTER);
		cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table.addCell(cell); 
   		
   		
		cell = new PdfPCell(new Paragraph("交易帳戶",font12));
		cell.setFixedHeight(20f);
		cell.setHorizontalAlignment(Element.ALIGN_CENTER);
		cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table.addCell(cell); 
  
		cell = new PdfPCell(new Paragraph("發放金額",font12));
		cell.setFixedHeight(20f);
		cell.setHorizontalAlignment(Element.ALIGN_CENTER);
		cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table.addCell(cell); 

		cell = new PdfPCell(new Paragraph("經手人",font12));
		cell.setFixedHeight(20f);
		cell.setHorizontalAlignment(Element.ALIGN_CENTER);
		cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		table.addCell(cell); 

		TradeaccountMgr tmx2=TradeaccountMgr.getInstance();
		BankAccountMgr bam2=BankAccountMgr.getInstance();
		
		int  payTotal =0;
		for(int i=0;i<sbx.length;i++)	
		{
		 	payTotal +=sbx[i].getSalaryBankMoney() ;

			String outWord2="";
			if(sbx[i].getSalaryBankStatus()==0)
				outWord2="尚未處理";
			else		
				outWord2=sdf5.format(sbx[i].getSalaryBankPayDate());
					
			cell = new PdfPCell(new Paragraph(outWord2,font10));
			cell.setFixedHeight(20f);
			cell.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table.addCell(cell); 
		
			int payWay=sbx[i].getSalaryBankPayWay();  
			
			switch(payWay)
			{
				case 1:
					cell = new PdfPCell(new Paragraph("現金",font10));
					break; 
				case 2: 
					cell = new PdfPCell(new Paragraph("支票",font10));
					break; 
				case 3:
					cell = new PdfPCell(new Paragraph("薪資轉帳",font10));
					break; 		
				case 4: 
					cell = new PdfPCell(new Paragraph("其他",font10));
					break; 				
			}
			cell.setFixedHeight(20f);
			cell.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table.addCell(cell); 
		
			String bankAccount=""; 
			
			if(sbx[i].getSalaryBankPayAccountType()==1)	
			{
				bankAccount="零用金帳戶-";
				Tradeaccount  td=(Tradeaccount)tmx2.find(sbx[i].getSalaryBankPayAccountId()); 
				bankAccount+=td.getTradeaccountName();
	
			}else if(sbx[i].getSalaryBankPayAccountType()==2){
				
				BankAccount ba=(BankAccount)bam2.find(sbx[i].getSalaryBankPayAccountId()); 
				//bankAccount="銀行代號:"+ba.getBankAccountId();
				bankAccount+="帳號:"+ba.getBankAccountAccount()+" 轉出";
			}	
			cell = new PdfPCell(new Paragraph(bankAccount,font10));
			cell.setFixedHeight(20f);
			cell.setHorizontalAlignment(Element.ALIGN_LEFT);
			cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table.addCell(cell); 
		
			cell = new PdfPCell(new Paragraph(mnf.format(sbx[i].getSalaryBankMoney()),font10));
			cell.setFixedHeight(20f);
			cell.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table.addCell(cell); 
			
			UserMgr uma=UserMgr.getInstance();
			User u0=(User)uma.find(sbx[i].getSalaryBankLogId());
			
			if(u0 ==null)
				cell = new PdfPCell(new Paragraph("尚未登入",font10));
			else
				cell = new PdfPCell(new Paragraph(u0.getUserFullname(),font10)); 
				
			cell.setFixedHeight(20f);
			cell.setHorizontalAlignment(Element.ALIGN_CENTER);
			cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table.addCell(cell); 
		}
		
		table.setWidthPercentage(90);
		document.add(table);		

	    return 90;
	   	}catch(Exception e){
			return 1;	
		}		
	}	
   
    public int makeSalaryPDFsPage(String path,String pathF1,SalaryTicket[] st)
    {
	    	try{
	    		JsfAdmin ja=JsfAdmin.getInstance();
		
		    	Document document=new Document(PageSize.A4,15,15,10,10);
				PdfWriter writer2=PdfWriter.getInstance(document, new FileOutputStream(pathF1));
				document.open();
				
				for(int i=0;i<st.length;i++)
				{
					if(i!=0)
					{
						document.newPage();
					}
					makeSalaryContent(writer2,document,path,st[i].getId());
				}
				document.close();
		}
		catch(Exception e)
		{
			
		}	
	
		return 90;	
    }
}