<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,java.io.*,java.util.*,java.util.zip.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=9;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu9.jsp"%>
<%
	String dbPs=request.getParameter("dbPs");
	int backupPeople=Integer.parseInt(request.getParameter("backupPeople")); 

	JsfTool jt=JsfTool.getInstance();
	JsfAdmin ja=JsfAdmin.getInstance();

	String syspath=application.getRealPath("/");
	EsystemMgr em2=EsystemMgr.getInstance();
	Esystem e2=(Esystem)em2.find(1);
	
	
	String fPath=syspath+"eSystem/"+e2.getEsystemDBfile();
	
	
	//System.out.println(fPath);
	
	String mysqlPath=e2.getEsystemMySqlfile().trim();
	String mysqlName=e2.getEsystemMysqlName().trim();
	String mysqlBFName=e2.getEsystemMysqlBinary().trim();

	Date da=new Date();
	//long fileName=da.getTime();
	SimpleDateFormat sdf1=new SimpleDateFormat("yyyyMMddkkmmss");
	
	String fileName=mysqlName+sdf1.format(da);
	
	
	
	
	DbbackupMgr dm=DbbackupMgr.getInstance();
	Dbbackup d=new Dbbackup();
	d.setDbbackupPs(dbPs);
	d.setDbbackupUserId(backupPeople);
	d.setDbbackupFilePath(e2.getEsystemDBfile());
	d.setDbbackupFileName(fileName+".zip");
	
	int dmId=dm.createWithIdReturned(d);
	
	response.sendRedirect("dbBackup2.jsp?dmId="+dmId);
	
%>