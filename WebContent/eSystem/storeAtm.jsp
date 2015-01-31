<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ page import="java.io.*" %>
<%@page import="org.apache.commons.fileupload.*" %>
<link rel="stylesheet" href="style.css" type="text/css">
<link href=ft02.css rel=stylesheet type=text/css>
<%
    int topMenu=1;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu1.jsp"%>

<%

	DecimalFormat mnf = new DecimalFormat("###,###,##0");
    SimpleDateFormat sdf2=new SimpleDateFormat("yyyy/MM/dd");
    JsfFee jf=JsfFee.getInstance();	

	String filePath="";
	try{	
		boolean isMultipart = FileUpload.isMultipartContent(request);
		DiskFileUpload upload = new DiskFileUpload();
		upload.setSizeThreshold(1000000);
		upload.setSizeMax(1000000);
		
		List items = upload.parseRequest(request);
		
		Iterator iter = items.iterator();
		Date da=new Date();
		SimpleDateFormat sdf1=new SimpleDateFormat("yyyyMMddkkmmss");
		String fileName="atm"+sdf1.format(da);
		
		filePath=application.getRealPath("/")+"eSystem/atmPay/"+fileName+".txt";
		while (iter.hasNext()) {
		FileItem item = (FileItem) iter.next();
			if (!item.isFormField()) 
			{
				Date now=new Date();
				long nowlong=now.getTime();
				File uploadedFile = new File(filePath);
				item.write(uploadedFile);
			}
		}
	
	}
	catch(Exception e)
	{
		out.println("上傳失敗");
	}

    JsfPay jp=JsfPay.getInstance();    		
    Vector vMessage=new Vector();     	
		
    StudentMgr sm=StudentMgr.getInstance();


	JsfTool jt=JsfTool.getInstance();
	JsfAdmin ja=JsfAdmin.getInstance();
	
	String line;
	PayAtmMgr pam=PayAtmMgr.getInstance();
	
	Vector status2=new Vector();
	Vector status90=new Vector();
	
	PaySystemMgr em=PaySystemMgr.getInstance();
	PaySystem pSystem=(PaySystem)em.find(1);

	
	try{
            BufferedReader br = 
                new BufferedReader(new InputStreamReader(new FileInputStream(filePath)));
           
            while ((line=br.readLine())!=null)
            {
				PayAtm pa=jf.insertArtificialATM(line.trim(),ud2,pSystem);                
               		 
                if(pa.getPayAtmStatus()==90)
                {
                    PayFee[] pf=jt.getPayFeeByCategoryOnlyATM(pa.getId());
           			
                    StringBuffer sb=new StringBuffer();
            		if(pf !=null)
            		{ 
            		
                        Feeticket ft=ja.getFeeticketByNumberId(pf[0].getPayFeeFeenumberId());
                         
                        String uName="沒有對應的姓名";
                        Student stu=(Student)sm.find(ft.getFeeticketStuId());

                        if(stu !=null)
                            uName=stu.getStudentName();

                   
            	        sb.append("<tr bgcolor=#ffffff align=left  onmouseover=\"this.className='highlight'\"  onmouseout=\"this.className='normal2'\" valign=middle>");
                        sb.append("<td  class=es02>"+uName+"</td>");
                        sb.append("<td  class=es02>"+sdf2.format(pa.getPayAtmPayDate())+"</td>");
                        sb.append("<td class=es02>"+pa.getPayAtmFeeticketId()+"</td>");
                        sb.append("<td  class=es02>"+mnf.format(pa.getPayAtmPayMoney())+"</td>");
                        sb.append("<td  class=es02>");

                        int totalPay=0;
                        for(int i=0;i<pf.length;i++)
                        {
                            totalPay+=pf[i].getPayFeeMoneyNumber();
                            sb.append("<a href=\"#\" onClick=\"javascript:openwindow34('");
                            sb.append(pf[i].getPayFeeFeenumberId()+"');return false\">單號:"+pf[i].getPayFeeFeenumberId()+"</a>- "+mnf.format(pf[i].getPayFeeMoneyNumber())+"元<br>");
                            
                            vMessage.add(pf[i]);  //準備發送簡訊
                        }
                        
                        sb.append("</td>");
                        sb.append("<td class=es02 align=right>"+mnf.format(totalPay)+"</td>");
                        sb.append("<td><a href=\"listStudentAccount.jsp?studentId="+stu.getId()+"\">學費帳戶</a></td>");
                        sb.append("</tr>");
                        status90.add(sb.toString());  

                    }else{
                                                    
                        sb.append("<tr bgcolor=#ffffff align=left  onmouseover=\"this.className='highlight'\"  onmouseout=\"this.className='normal2'\" valign=middle>");
                        sb.append("<td  class=es02>未銷單</td>");
                        sb.append("<td  class=es02>"+sdf2.format(pa.getPayAtmPayDate())+"</td>");
                        sb.append("<td class=es02>"+pa.getPayAtmFeeticketId()+"</td>");
                        sb.append("<td  class=es02 align=right>"+mnf.format(pa.getPayAtmPayMoney())+"</td>");
                        sb.append("<td  class=es02></td>");
                        sb.append("<td  class=es02>0</td>");
                        sb.append("<td  class=es02 align=right><a href=\"listStudentAccount.jsp?studentId=0\">不明學費帳戶</a></td>");    
                        sb.append("</tr>");

                        
                        status90.add(sb.toString());                        

             	  	} 

                }else{
                        
                    StringBuffer sb=new StringBuffer();
           
                    sb.append("<tr bgcolor=#ffffff align=left  onmouseover=\"this.className='highlight'\"  onmouseout=\"this.className='normal2'\" valign=middle>"+
            	            "<td class=es02>"+pa.getPayAtmSource()+"</td><td class=es02>");
                    switch(pa.getPayAtmStatus())
                    {
                        case 1:
                            sb.append("檔案格式有誤");
                            break;
                        case 2:
                            sb.append("系統判斷重複銷單");
                            break;
                        case 3:
                            sb.append("資料庫判斷重複銷單(Unique Key)");
                            break;
                        case 4:
                            sb.append("系統帳單處理失敗");
                            break;
                        case 5:sb.append("資料寫入失敗");
                            break;	
                    }
				    sb.append("</td><td class=es02>"+pa.getPayAtmException()+"</td></tr>");	
                    status2.add(sb.toString());
                }    
            }
            
            String filePath2 =  application.getRealPath("/")+"eSystem/atmPay.txt";
			SimpleDateFormat sdf1=new SimpleDateFormat("yyyy/MM/dd");    
			String newDate=sdf1.format(new Date());
			try
			{
				BufferedWriter br2 =new BufferedWriter(new FileWriter(filePath2));
				br2.write(newDate);
				br2.close();
			  
			}catch(Exception e)
			{	}  

            
            if(pSystem.getPaySystemMessageActive()==1)
            {
                if(vMessage !=null && vMessage.size()>0)
                {
                    PayFee[] pfs=(PayFee[])vMessage.toArray(new PayFee[vMessage.size()]);
                    jp.sendMultiPayFeeMessage(pfs,pSystem);
                }
            }

            HttpSession session2=request.getSession();
            
            session2.setAttribute((String)"atmstatus90",(Vector)status90);
 
            session2.setAttribute((String)"atmstatus2",(Vector)status2);
 
            response.sendRedirect("atmPayResult.jsp");
        }
        catch (Exception e)
        {
            out.println(e.getMessage());   
        }                   
   
%>
