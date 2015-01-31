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
        SimpleDateFormat sdf2=new SimpleDateFormat("yyyy/MM/dd");
		String fileName="store"+sdf1.format(da);
		
		filePath=application.getRealPath("/")+"eSystem/storePay/"+fileName+".txt";
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
    
	JsfTool jt=JsfTool.getInstance();
	JsfAdmin ja=JsfAdmin.getInstance();
	JsfFee jf=JsfFee.getInstance();
    JsfPay jp=JsfPay.getInstance();
	
    String line;
	PayStoreMgr psm=PayStoreMgr.getInstance();
	
	Vector status2=new Vector();
	Vector status90=new Vector();

    DecimalFormat mnf = new DecimalFormat("###,###,##0");
	PaySystemMgr em=PaySystemMgr.getInstance();
	PaySystem pSystem=(PaySystem)em.find(1);
    
    StudentMgr sm=StudentMgr.getInstance();
    SimpleDateFormat sdf2=new SimpleDateFormat("yyyy/MM/dd");

    Vector vMessage=new Vector();

	try{
            BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(filePath)));
           
            int ix=0;
            while ((line=br.readLine())!=null)
            {	
                if(line.length()<=0)
                    continue;
		    
                PayStore ps=jf.insertArtificialStore(line.trim(),ud2,pSystem);                
    	        
    			if(ps.getPayStoreStatus()!=90)
                {
                    StringBuffer sb=new StringBuffer();
                                                
                    sb.append("<tr bgcolor=#ffffff align=left  onmouseover=\"this.className='highlight'\"  onmouseout=\"this.className='normal2'\" valign=middle>"+
	            	"<td class=es02>"+ps.getPayStoreSource()+"</td>"+
	            	"<td class=es02>");

                    switch(ps.getPayStoreStatus())
                    {
                        case 1:
                            sb.append("檔案格式有誤");
                            break;
                        case 2:sb.append("系統判斷重複銷單");
                            break;
                        case 3:sb.append("資料庫判斷重複銷單");
                            break;
                        case 4:sb.append("系統帳單處理失敗");
                            break;
                        case 5:sb.append("資料寫入失敗");
                            break;
                    }

					sb.append("</td><td  class=es02>"+ps.getPayStoreException()+"</td></tr>");
                   
    				status2.add(sb.toString());
  				}else{
           
               	    PayFee[] pf=jt.getPayFeeByCategoryAndIdes(3,ps.getId());
                    
                    if(pf !=null)
                    {
                        
                        Feeticket ft=ja.getFeeticketByNumberId(pf[0].getPayFeeFeenumberId());
                        
                        String uName="沒有對應的姓名";
                        Student stu=(Student)sm.find(ft.getFeeticketStuId());

                        if(stu !=null)
                            uName=stu.getStudentName();
                    
                        StringBuffer sb=new StringBuffer();
                                                    
                        sb.append("<tr bgcolor=#ffffff align=left  onmouseover=\"this.className='highlight'\"  onmouseout=\"this.className='normal2'\" valign=middle>");
                        sb.append("<td  class=es02>"+uName+"</td>");
                        sb.append("<td  class=es02>"+sdf2.format(ps.getPayStorePayDate())+"</td>");
                        sb.append("<td class=es02>"+ps.getPayStoreFeeticketId()+"</td>");
                        sb.append("<td  class=es02>"+mnf.format(ps.getPayStorePayMoney())+"</td>");
                        sb.append("<td  class=es02>");

                        int totalPay=0;
                        for(int i=0;i<pf.length;i++)
                        {
                            totalPay+=pf[i].getPayFeeMoneyNumber();
                            sb.append("<a href=\"#\" onClick=\"javascript:openwindow34('");
                            sb.append(pf[i].getPayFeeFeenumberId()+"');return false\">單號:"+pf[i].getPayFeeFeenumberId()+"</a>- "+mnf.format(pf[i].getPayFeeMoneyNumber())+"元<br>");

                            vMessage.add(pf[i]);
                        }
                        
                        sb.append("</td>");
                        sb.append("<td class=es02 align=right>"+mnf.format(totalPay)+"</td>");
                        sb.append("<td><a href=\"listStudentAccount.jsp?studentId="+stu.getId()+"\">學費帳戶</a></td>");
                        sb.append("</tr>");
                        status90.add(sb.toString());  
 
                    }else{
                        
                         StringBuffer sb=new StringBuffer();
                                                    
                        sb.append("<tr bgcolor=#ffffff align=left  onmouseover=\"this.className='highlight'\"  onmouseout=\"this.className='normal2'\" valign=middle>");
                        sb.append("<td  class=es02>未銷單</td>");
                        sb.append("<td  class=es02>"+sdf2.format(ps.getPayStorePayDate())+"</td>");
                        sb.append("<td class=es02>"+ps.getPayStoreFeeticketId()+"</td>");
                        sb.append("<td  class=es02 align=right>"+mnf.format(ps.getPayStorePayMoney())+"</td>");
                        sb.append("<td  class=es02></td>");
                        sb.append("<td  class=es02 align=right>0</td>");
                        sb.append("<td><a href=\"listStudentAccount.jsp?studentId=0\">不明學費帳戶</a></td>");
                        sb.append("</tr>");
                    
                        status90.add(sb.toString()); 
                    }
        	
                }

            }


        	String filePath2=application.getRealPath("/")+"eSystem/storePay.txt";
			SimpleDateFormat sdf1=new SimpleDateFormat("yyyy/MM/dd");    
			String newDate=sdf1.format(new Date());
			try
			{
				BufferedWriter br2 =new BufferedWriter(new FileWriter(filePath2));
				br2.write(newDate);
				br2.close();
	  
			}catch(Exception e)
			{	}  

            status90.trimToSize(); 
            
            if(vMessage !=null && vMessage.size()>0)
            {
                PayFee[] pfs=(PayFee[])vMessage.toArray(new PayFee[vMessage.size()]);		
                jp.sendMultiPayFeeMessage(pfs,pSystem);
            }
            HttpSession session2=request.getSession();            
            session2.setAttribute((String)"status90",(Vector)status90);
            session2.setAttribute((String)"status2",(Vector)status2);
 
            response.sendRedirect("storePayResult.jsp");
        }
        catch (Exception e)
        {
            out.println("<BR><BR>"+e.getMessage());   
        }                   
    
%>
