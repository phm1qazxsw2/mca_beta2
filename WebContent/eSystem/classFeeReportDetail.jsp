<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>

<%
	int cmId=Integer.parseInt(request.getParameter("cmId"));
	String syear=request.getParameter("year");
	JsfAdmin ja=JsfAdmin.getInstance();
	JsfTool jt=JsfTool.getInstance();
	
	ClassesMoneyMgr cmm=ClassesMoneyMgr.getInstance();
	ClassesMoney cm=(ClassesMoney)cmm.find(cmId);

	ClassesMgr cmx=ClassesMgr.getInstance();
	
	
	String smonth=request.getParameter("month");
	String seleString="";
	
	if(smonth !=null)
		seleString=smonth;
	
	
	
	String[] newdate=jt.getSelectDate();
	int cmCategory=cm.getClassesMoneyCategory();
	
	Classes[] cla=ja.getAllClasses();
	Level[] le=ja.getAllLevel();	
	
	String classIdString=request.getParameter("classesId");
	String levelIdString=request.getParameter("level");
	int classIdint=999;
	int levelIdint=999;
	
	if(classIdString !=null)
		classIdint=Integer.parseInt(classIdString);
	
	if(levelIdString !=null)
		levelIdint=Integer.parseInt(levelIdString);
		
	%>
	
	<%

	StudentMgr sm=StudentMgr.getInstance();
	
	if(syear ==null)
		return;

	Date runDate=new Date();
	SimpleDateFormat sdf1=new SimpleDateFormat("yyyy-MM");
	String parseDate=syear+"-"+smonth;
	runDate=sdf1.parse(parseDate);
	
	int totalShould=0;
	int totalDiscount=0;
	ClassesFee[] cf=ja.getClassesFeeByClassLevel(runDate,cmId,classIdint,999);
	
	
	
	
	if(cf==null)
	{
		out.println("沒有資料");
		return;
	}
	
	ClassesMgr cma=ClassesMgr.getInstance();
	Classes claz=(Classes)cma.find(classIdint);
	
	%>
	
	
	
	月份:<b><%=sdf1.format(runDate)%></b> <br> 
	收費類別:<b><%=cm.getClassesMoneyName()%></b> 班級:<b><%=claz.getClassesName()%></b> 學生名單  
	
	<div align=right>資料共<font color=red><%=cf.length%></font>筆</div> 
	
	<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
	<br> 
	<blockquote>
	<table width="" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
		<td>姓名</td><td>狀態</td><td align=right>應收金額</td><td>折扣</td><td>小計</td>
	</tr>

	<%
	
		
	for(int i=0;i<cf.length;i++){
		totalShould +=cf[i].getClassesFeeShouldNumber();
		totalDiscount +=cf[i].getClassesFeeTotalDiscount();
	
		Student stu=(Student)sm.find(cf[i].getClassesFeeStudentId());
	%>
	<tr bgcolor=#ffffff class=es02>
	<td><%=stu.getStudentName()%></td>
	<td><%=(cf[i].getClassesFeeStatus()<90)?"尚未繳款":"已繳"%></td>
	<td align=right><%=cf[i].getClassesFeeShouldNumber()%></td>
	<td align=right><%=cf[i].getClassesFeeTotalDiscount()%></td>
	<td align=right><%=cf[i].getClassesFeeShouldNumber()-cf[i].getClassesFeeTotalDiscount()%></td>
	</tr>
	
	<%
	}
	%>	
	
	<tr><td colspan=2><b>總計</b></td><td align=right><%=totalShould%></td><td align=right><%=totalDiscount%></td>
	<td align=right><b><%=totalShould-totalDiscount%></b></td>
	</tr>
	</table>

	</td>
	</tr>
	</table>
	</blockquote>