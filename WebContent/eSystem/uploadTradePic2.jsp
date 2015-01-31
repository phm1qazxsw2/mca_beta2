<%@ page language="java" buffer="32kb" import="jsf.*,jsi.*,java.util.*,java.text.*,web.*" contentType="text/html;charset=UTF-8"%>
<%@page import="java.io.*" %>
<%@page import="java.util.*" %>
<%@page import="org.apache.commons.fileupload.*" %>
<%@ include file='/WEB-INF/jsp/security.jsp'%>
 
<link rel="stylesheet" href="style.css" type="text/css">
<link href=ft02.css rel=stylesheet type=text/css>
<html>
<%

 User ud2 = WebSecurity.getInstance(pageContext).getCurrentUser();
 PaySystemMgr pmx2=PaySystemMgr.getInstance();
 PaySystem pd2=(PaySystem)pmx2.find(1);
 if(ud2==null)
  {
  %>
  	<%@ include file="noUser.jsp"%>
<% 
  	return;
  }
%>
<head>
<title><%=pd2.getPaySystemCompanyName()%></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta http-equiv="imagetoolbar" content="no">

<script type="text/javascript" src="openWindow.js"></script>
<script>

	function henrytest()
	{
		var opener=window.opener; 
		
		opener.goAlert(); 
	}

</script>


</head> 

<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onunload="henrytest()">
<table bgcolor=#ff0000 background=pic/bg01.gif width="100%" height="9" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td class=es02><img src=pic/bg01.gif border=0></td>
</tr>
</table>
<!--- start 水平列書籤式按鈕 01 --->
<table bgcolor=#696A6E width="100%" height="24" border="0" cellpadding="4" cellspacing="0">
<tr align=left valign=middle>
<td class=es02r align=right><%=pd2.getPaySystemCompanyName()%></td>
</tr>
</table>

<%

request.setCharacterEncoding("UTF-8"); 


String outWord="";
String newFile="";
String fileName="";
 
int way=0; 


try{	
    boolean isMultipart = FileUpload.isMultipartContent(request);
    DiskFileUpload upload = new DiskFileUpload();

    upload.setSizeThreshold(1000000);
    upload.setSizeMax(1000000);
    
    List items = upload.parseRequest(request);

    Iterator iter = items.iterator();

	Hashtable ha=new Hashtable();
    

    String filePath = request.getRealPath("./")+"accountAlbum/";   
    String fileTempPath="";
    while (iter.hasNext()) {
        FileItem item = (FileItem) iter.next();
        
        if (!item.isFormField()) {

			int randomInt = 1 + (int)(Math.random() * 10000);
			
			String filename=item.getName(); 
			int fLength=filename.length();


			fileName=String.valueOf(randomInt)+"."+filename.substring(fLength-3);
			fileTempPath=filePath+"temp/"+fileName;
			File uploadedFile = new File(fileTempPath);
			item.write(uploadedFile);

         }else{

         	 if(item.getFieldName().equalsIgnoreCase("ctId")) {
                      
				outWord=item.getString();
				
              }
         }
    }
			

	//mm.setBlogAuthorPhotoActive   	(1);	
   	//xm.save(mm);


	File blogFile=new File(filePath+outWord);

	if(!blogFile.exists())
	{
		blogFile.mkdir();
	}

	newFile=filePath+outWord+"/"+fileName; 
	
	Utility u=Utility.getInstance();

	File srcF=new File(fileTempPath);
	File tarF=new File(newFile);
	u.copyFile(srcF,tarF); 

	srcF.delete();

		out.println("<blockquote>上傳成功</blockquote>");


}catch(Exception e){
 
 	out.println(e.getMessage());   
}



%>



