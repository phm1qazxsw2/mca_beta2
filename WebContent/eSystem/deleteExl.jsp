<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.io.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=7;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%
	
	int eId=Integer.parseInt(request.getParameter("eId"));
	ExlMgr cfm=ExlMgr.getInstance();
	
	Exl ex=(Exl)cfm.find(eId);
	cfm.remove(eId);

	String path=application.getRealPath("/");
	
	File fso=new File(path+"eSystem/exlfile/"+ex.getExlFileName()+".xls");
	if(fso.delete())
		out.println("資料已刪除!!");
	else
		out.println("刪除失敗!!");
%>




