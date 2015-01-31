package phm.ezcounting;

import java.text.*;
import java.util.*;
import java.io.*;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.hssf.util.Region;

public class CellPrinter
{

    private static CellPrinter instance;
    
    CellPrinter() {}
    
    public synchronized static CellPrinter getInstance()
    {			
        if (instance==null)
        {
            instance = new CellPrinter();
        }
        return instance;
    }  

    public boolean printExcel(String filePath,String title,boolean landscape,Vector alltable){

        try{
            short columnWidthUnit = 256;
            HSSFWorkbook wb=new HSSFWorkbook();
            HSSFSheet sheet1=wb.createSheet("sheet1");

            HSSFPrintSetup hps=sheet1.getPrintSetup();
            hps.setLandscape(landscape);

            HSSFFooter footer = sheet1.getFooter();
            footer.setCenter( "頁碼: " + HSSFFooter.page() + " / " + HSSFFooter.numPages() );


            HSSFFont font12=wb.createFont();
            font12.setFontHeightInPoints((short)12);            
            font12.setColor(HSSFColor.GREY_80_PERCENT.index);

            HSSFFont font10=wb.createFont();
            font10.setFontHeightInPoints((short)10);            
            font10.setColor(HSSFColor.GREY_80_PERCENT.index);

            HSSFCellStyle styleTitle=wb.createCellStyle();
            styleTitle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
            styleTitle.setFont(font12);
            styleTitle.setWrapText(false);

            HSSFCellStyle styleTH=wb.createCellStyle();
            styleTH.setAlignment(HSSFCellStyle.ALIGN_CENTER);
            styleTH.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
            styleTH.setFillForegroundColor(new HSSFColor.GREY_25_PERCENT().getIndex());
            styleTH.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
            styleTH.setFont(font10); 
            styleTH.setWrapText(false);


            HSSFCellStyle styleTd=wb.createCellStyle();
            styleTd.setAlignment(HSSFCellStyle.ALIGN_RIGHT);
            styleTd.setFont(font10);
            styleTd.setWrapText(true);

            HSSFCellStyle styleTd2=wb.createCellStyle();
            styleTd2.setAlignment(HSSFCellStyle.ALIGN_LEFT);
            styleTd2.setFont(font10);
            styleTd2.setWrapText(true);

            int colsCell=0;
            if(alltable !=null && alltable.get(0)!=null){
                Vector vx=(Vector)alltable.get(0);
                colsCell=(int)vx.size()-1;
                int xtotal=0;
                for(int k=0;vx !=null && k<vx.size();k++){

                    StringCell scx=(StringCell)vx.get(k);

                    if(scx.getColspan()>1)
                        xtotal+=scx.getColspan()-1;
                }
                colsCell+=xtotal;
            }

            HSSFRow row0=sheet1.createRow((short)0);
            sheet1.addMergedRegion(new Region(0,(short)0,0,(short)colsCell));
            HSSFCell cell0=row0.createCell((short)0);
            cell0.setEncoding(HSSFCell.ENCODING_UTF_16);
            cell0.setCellValue(title);
            cell0.setCellStyle(styleTitle);

            Hashtable ha=new Hashtable();
            int addRows=0;
            for(int i=0;alltable !=null && i<alltable.size() ; i++){
                int nowrow=i+1;
                row0=sheet1.createRow((short)nowrow);
                Vector cellV=(Vector)alltable.get(i);
                int addCols=0;
                int extraExcel=0;

                for(int j=0; cellV !=null && j<cellV.size();j++){

                    StringCell sc2=(StringCell)cellV.get(j);
                    int startCol=0;
                    int endCol=0;
                    
                    startCol=j+extraExcel;
                    if(sc2.getColspan()>1){
                        extraExcel+=sc2.getColspan()-1;
                        endCol=extraExcel+j;
                        //int endCol=j+sc2.getColspan();
                        sheet1.addMergedRegion(new Region((short)nowrow,(short)startCol,(short)nowrow,(short)endCol));
                    }
                    
                    if(sc2.getRowspan()>1){
                        for(int k=0;k<sc2.getRowspan();k++){
                            int xrow=nowrow+k+1;
                            int xcol=j;
                            String posotion=String.valueOf(xrow)+"##"+String.valueOf(xcol);
                            ha.put((String)posotion,"1");
                        }
                        int endRow=nowrow+sc2.getRowspan()-1;                        
                        sheet1.addMergedRegion(new Region((short)nowrow,(short)j,(short)endRow,(short)j));
                    }
                    
                    String nowPosituin=String.valueOf(nowrow)+"##"+String.valueOf(j);
                    if((String)ha.get(nowPosituin)!=null)
                        addCols++;                        

                    cell0=row0.createCell((short)(startCol));
                    cell0.setEncoding(HSSFCell.ENCODING_UTF_16);
                    cell0.setCellValue(sc2.getCell());
                    if(i==0){
                        cell0.setCellStyle(styleTH);
                    }else{
                        //靠左
                        if(sc2.getExcelAlign()==1)
                            styleTd.setAlignment(HSSFCellStyle.ALIGN_LEFT);
                        else   //靠右                         
                            styleTd.setAlignment(HSSFCellStyle.ALIGN_RIGHT);

                        if(sc2.getExcelVAlign()==1)
                            styleTd.setVerticalAlignment(HSSFCellStyle.VERTICAL_TOP);
                        else
                            styleTd.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
                        cell0.setCellStyle(styleTd);
                    }
                    if(sc2.getColspan()>1){
                        addCols+=sc2.getColspan();
                    }
                    if(i==1 && sc2.getExcelCellattibute()==0)
                        sheet1.setColumnWidth((short)j, (short) (10 * columnWidthUnit)); 

                    if(i==1 && sc2.getExcelCellattibute()!=0)
                        sheet1.setColumnWidth((short)j, (short) (sc2.getExcelCellattibute() * columnWidthUnit));                         
                }
            }

            FileOutputStream fso=new FileOutputStream(filePath);
            wb.write(fso);
            fso.close();
        
        }catch(Exception ex){

            return false;
        }

        return true;
    }
    public String printHTML(String attribute,Vector alltable){

        StringBuffer sb=new StringBuffer();

        sb.append("<table "+attribute+" >");
        for(int i=0;alltable !=null && i<alltable.size();i++){

            Vector trV=(Vector)alltable.get(i);
            sb.append("<tr>");
            for(int j=0; trV !=null && j< trV.size(); j++){

                StringCell sc2=(StringCell)trV.get(j);
                sb.append("<");
                if(i==0)
                    sb.append("th");
                else
                    sb.append("td");

                if(sc2.getColspan()>1){            
                    sb.append(" colspan="+sc2.getColspan());
                }

                if(sc2.getRowspan()>1){            
                    sb.append(" rowspan="+sc2.getRowspan());
                }

                if(sc2.getHtmlCellattibute() !=null && sc2.getHtmlCellattibute().length()>0)
                    sb.append(" "+sc2.getHtmlCellattibute()+" ");

                sb.append(" >");
                sb.append(sc2.getCell());
                if(i==0)
                    sb.append("</th>");
                else
                    sb.append("</td>");
            }
            sb.append("</tr>");
        }            
        sb.append("</table>");

        return sb.toString();
    }
}