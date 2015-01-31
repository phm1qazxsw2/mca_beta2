<%@ page language="java"  import="web.*,jsf.*,jsi.*" contentType="text/html;charset=UTF-8"%>

<link rel="stylesheet" href="style.css" type="text/css">
<link href=ft02.css rel=stylesheet type=text/css>
<%
    int topMenu=1;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu1.jsp"%>
<%
	
	JsfAdmin ja=JsfAdmin.getInstance();
	DecimalFormat mnf = new DecimalFormat("###,###,##0");
	JsfTool jt=JsfTool.getInstance();
 	int studentId=Integer.parseInt(request.getParameter("studentId"));
 	
 	SimpleDateFormat sdf1=new SimpleDateFormat("yyyy-MM");
	
	String smonth=request.getParameter("month");
	String seleString="";
	
	if(smonth !=null)
		seleString=smonth;
 	
 	
 	String orderS=request.getParameter("order");
	StudentMgr sm=StudentMgr.getInstance();
	Student stu=(Student)sm.find(studentId); 
	
	Classes[] cl=ja.getAllActiveClasses();	
%>
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script type="text/javascript" src="js/check.js"></script>
	
<script type="text/javascript" src="js/in.js"></script>
<SCRIPT type="text/javascript" language="JavaScript" src="js/area3.js"> </SCRIPT>
<script type="text/javascript" src="openWindow.js"></script>
<script>

	var feenumber='';
	function goAlert()
	{ 
		getFeeticketByFeenumber(feenumber);
 	} 
</script>

<br>
&nbsp;&nbsp;<b>繳費資訊</b>  學生:<b><font color=blue><%=(stu!=null)?stu.getStudentName():"不明帳號"%></font></b><br><br>

<div class=es02> 
<%
	if(stu !=null) 
	{ 
%>
&nbsp;&nbsp;<a href="listHistoryFeeticket.jsp?studentId=<%=stu.getId()%>">帳單查詢</a>
| <a href="listStudentCostpay.jsp?studentId=<%=stu.getId()%>">繳費紀錄</a> 
| <a href="listStudentClassmoney.jsp?studentId=<%=stu.getId()%>">收費項目統計</a> 
 
|  <a href="listStudentPaySteup.jsp?studentId=<%=stu.getId()%>">繳費設定</a>  
| 
<%
	}
%>		
 學費帳戶

</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>

<%@ include file="studentAccountContent.jsp"%>
<%@ include file="bottom.jsp"%>