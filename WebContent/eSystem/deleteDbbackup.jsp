<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.io.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=9;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu9.jsp"%>
<%
	
	int eId=Integer.parseInt(request.getParameter("backId"));
	DbbackupMgr cfm=DbbackupMgr.getInstance();
	
	Dbbackup ex=(Dbbackup)cfm.find(eId);
	//cfm.remove(eId);

	String path=application.getRealPath("/")+"eSystem/";
	
	File fso=new File(path+ex.getDbbackupFilePath()+"/"+ex.getDbbackupFileName());
	

	if(fso.delete())
		out.println("資料已刪除!!");
	else
		out.println("刪除失敗!!");

%>
<%@ include file="bottom.jsp"%>