<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,java.io.*,java.util.*,java.util.zip.*" buffer="32kb"
contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=9;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu9.jsp"%>
<%
    request.setCharacterEncoding("UTF-8");
	int dmId=Integer.parseInt(request.getParameter("dmId"));

	String syspath=application.getRealPath("/");
	EsystemMgr em2=EsystemMgr.getInstance();
	Esystem e2=(Esystem)em2.find(1);
	
	String fPath=syspath+"eSystem/"+e2.getEsystemDBfile();

	//System.out.println(fPath);
	
	String mysqlPath=e2.getEsystemMySqlfile().trim();
	String mysqlName=e2.getEsystemMysqlName().trim();
	String mysqlBFName=e2.getEsystemMysqlBinary().trim();

	DbbackupMgr dmX=DbbackupMgr.getInstance();
	
	Dbbackup dk=(Dbbackup)dmX.find(dmId);
	
	File dbFile=new File(fPath+"/"+dk.getDbbackupFileName());

	if(!dbFile.createNewFile())
	{
		out.println("未能產生壓縮檔!!");
		return;
	}	
	

	try
	{	
		// 將想要的檔案壓縮到 ZIP 檔案裡
		String fn=fPath+"\\"+dk.getDbbackupFileName();
		ZipOutputStream zout=new ZipOutputStream(new FileOutputStream(fn));
		
		String targetFile3=mysqlPath+"/"+mysqlBFName;
		String targetFile4=mysqlBFName;
		BufferedInputStream bis2=new BufferedInputStream(new FileInputStream(targetFile3));
		ZipEntry entry2=new ZipEntry(targetFile4);
		zout.putNextEntry(entry2);
		byte[] buf2=new byte[1024];
		int count2;
		// 讀取檔案寫入 ZIP 檔裡
		while((count2=bis2.read(buf2,0,1024))!= -1)
		{
			zout.write(buf2,0,count2);
		}
		bis2.close();
		zout.closeEntry();	
	
		File mysqlFiles=new File(mysqlPath+mysqlName);
		String[] fileList=mysqlFiles.list();

		for(int i=0;i<fileList.length;i++)
		{
			String targetFile=mysqlPath+mysqlName+"\\"+fileList[i];
			String targetFile2=mysqlName+"/"+fileList[i];
			
			// 從這裡到 * 為止，重複寫幾次，就可以壓縮幾個檔案進去
			BufferedInputStream bis=new BufferedInputStream(new FileInputStream(targetFile));
			// 新增一個 entry
			ZipEntry entry=new ZipEntry(targetFile2);
			zout.putNextEntry(entry);
			byte[] buf=new byte[1024];
			int count;
			// 讀取檔案寫入 ZIP 檔裡
			while((count=bis.read(buf,0,1024))!= -1)
			{
				zout.write(buf,0,count);
			}
			bis.close();
			zout.closeEntry();	
		}
		zout.close();

	}
	catch (IOException ez)
	{
		out.println("錯誤："+ez.getMessage()+"<p>");
		//ez.printStackTrace(out);
	}
	

	response.sendRedirect("backupLog.jsp");	
	
%>

