<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=7;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu7.jsp"%>
<%
    request.setCharacterEncoding("UTF-8");
	int incomeLimit=Integer.parseInt(request.getParameter("incomeLimit")); 
	int costLimit=Integer.parseInt(request.getParameter("costLimit")); 
	int stuPage=Integer.parseInt(request.getParameter("stuPage"));
	int teaPage=Integer.parseInt(request.getParameter("teaPage"));
	String dbFile=request.getParameter("dbFile");
	String dbName=request.getParameter("dbName");
	String dbBirany=request.getParameter("dbBirany");
	String mysqlFile=request.getParameter("mysqlFile");
	int dateType=Integer.parseInt(request.getParameter("dateType"));


	EsystemMgr em=EsystemMgr.getInstance();
	Esystem e=(Esystem)em.find(1);
	int esystemLogMins=e.getEsystemLogMins();

    try{
        int esystemLogMins2=Integer.parseInt(request.getParameter("esystemLogMins"));
        if(esystemLogMins2 >0)
            esystemLogMins=esystemLogMins2;

    }catch(Exception ex){}

	int esystemShowCash=Integer.parseInt(request.getParameter("esystemShowCash"));

	
	e.setEsystemIncomeVerufy(incomeLimit);
	e.setEsystemCostVerufy(costLimit);
	e.setEsystemDBfile(dbFile);
	e.setEsystemMysqlName(dbName);
	e.setEsystemMysqlBinary(dbBirany);
	e.setEsystemMySqlfile(mysqlFile);
	e.setEsystemStupage(stuPage);
	e.setEsystemTeapage(teaPage); 
	e.setEsystemShowCash(esystemShowCash);
	
    e.setEsystemDateType(dateType);
    e.setEsystemLogMins(esystemLogMins);
	em.save(e);

	response.sendRedirect("modifySystem.jsp?m=1");
%>



