<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ page import="java.io.*" %>
<%@page import="org.apache.commons.fileupload.*" %>
<%@ include file="jumpTop.jsp"%>
<blockquote>
<%
    if (1==1)
        throw new Exception("obsolete!");

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
		String fileName="stu"+sdf1.format(da);
		
		filePath=request.getRealPath("")+"stuData/"+fileName+".txt";
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
	SimpleDateFormat sdfX=new SimpleDateFormat("yyyy/MM/dd");
	String line;
	StudentMgr sm=StudentMgr.getInstance();
	try{
            BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(filePath)));
           
            while ((line=br.readLine())!=null)
            { 
            	 try
            	 {
	
                    String[] stuData=line.split("\t"); 
					if(stuData.length<=3) 
						continue;
					Student stu=new Student(); 

					stu.setStudentName(stuData[0]);
					stu.setStudentNickname  (stuData[1]);
					
					String sexS=stuData[2].trim();
					int sex=0;
					if(sexS.equals("男"))
						sex=1;
					
					if(sexS.equals("女"))
						sex=2;
					stu.setStudentSex   	(sex);

					stu.setStudentIDNumber   	(stuData[3]);
					
					Date xDate=new Date();
					if(stuData.length>4) 
						xDate = jt.ChangeToDate(stuData[4].trim());
					stu.setStudentBirth   	(xDate);
					
					if(stuData.length>5)
						stu.setStudentFather   	(stuData[5]);
					
					if(stuData.length>6)
						stu.setStudentFatherMobile(stuData[6]); 
					
					if(stuData.length>7)
						stu.setStudentMother   	(stuData[7]);
					
					if(stuData.length>8)
						stu.setStudentMotherMobile   	(stuData[8]);
					stu.setStudentMobileDefault   	(1);

					if(stuData.length>9)
						stu.setStudentPhone   	(stuData [9]);
					
					if(stuData.length>10)
						stu.setStudentPhone2   	(stuData [10]);
					
					if(stuData.length>11)
						stu.setStudentPhone3   	(stuData [11]);
					
					if(stuData.length>12)
						stu.setStudentZipCode   	(stuData [12]);
					
					if(stuData.length>13)
						stu.setStudentAddress   	(stuData [13]);

					stu.setStudentStatus   	(4);
					stu.setStudentDepart   	(0);
					stu.setStudentClassId   	(0);
					stu.setStudentLevel   	(0);
                    stu.setStudentEmailDefault(1);
					stu.setStudentPs   	("本資料由excel匯入");
					sm.createWithIdReturned(stu);
				
				}catch (Exception ex){
					ex.printStackTrace();
				}
			}
    }
    catch (Exception e)
    {
        out.println("<BR><BR>"+e.getMessage());   
    }                   
    
%>
	上傳成功!!
</blockquote> 


