<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,java.io.*" contentType="text/html;charset=UTF-8"%>
<%@ page import="java.io.*" %>
<%@ include file="jumpTop.jsp"%>
<script type="text/javascript" src="openWindow.js"></script>
<link rel="stylesheet" href="style.css" type="text/css">
<link href=ft02.css rel=stylesheet type=text/css>
<%
	String sFn=request.getParameter("FeenumberId").trim();

	String path=application.getRealPath("/")+"eSystem/pdf_example/";

	File FileDic2 = new File(path+"email");
	File files2[]=FileDic2.listFiles();

	File xF2=null; 

	if(files2 !=null)
	{ 
		for(int j2=0;j2<files2.length;j2++)
		{ 
			if(!files2[j2].isHidden())
				files2[j2].delete();
		} 
	}
	
	JsfAdmin ja=JsfAdmin.getInstance();
	PdfMaker pm=PdfMaker.getInstance();
	JsfPay jp=JsfPay.getInstance();


	PaySystemMgr em=PaySystemMgr.getInstance();
	PaySystem e=(PaySystem)em.find(1);


	Feeticket ft=ja.getFeeticketByNumberId(Integer.parseInt(sFn));

	int status=pm.makeEmailPDF(ft,path);

	StudentMgr stum=StudentMgr.getInstance();
	
	if(status==90)
	{
		Student stu=(Student)stum.find(ft.getFeeticketStuId());
%>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/email.png" border=0>Email 帳單</b> 

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table> 
<br>
<br>
<center>
<form action="makeStudentEmail2.jsp" method="post">

		<table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
		<tr align=left valign=top>
		<td bgcolor="#e9e3de">
	
		<table width="100%" border=0 cellpadding=4 cellspacing=1>
			<tr bgcolor=#f0f0f0  class=es02>
				<td>學生</td>
				<tD bgcolor=ffffff><%=stu.getStudentName()%> (帳單編號:<%=sFn%>)</tD>
			</tr>
			<tr bgcolor=#f0f0f0  class=es02>
				<tD>Email Address</tD>
				<td bgcolor=ffffff>
					<%=jp.getBillEmail(e,stu)%>
				</td>
			</tr>		
	<tr class=es02> 
		<td bgcolor=f0f0f0>
			Email發送形式:
		</tD>
		<td bgcolor=ffffff>
			<input type=radio name="paySystemNoticeEmailType" value="0" checked>純文字
			<input type=radio name="paySystemNoticeEmailType" value="1">HTML格式
		</tD>
	</tr>				
	<tr class=es02> 
		<td bgcolor=f0f0f0>
			Email預設標題
		</td>
		<td bgcolor=ffffff>
			<input type=text name="paySystemNoticeEmailTitle" size=30 value="帳單編號:<%=sFn%>">
		</td>
	</tr>
	<tr class=es02> 
		<td bgcolor=f0f0f0>
			Email發送內容:
		</tD>
		<td bgcolor=ffffff>
			<textarea name="paySystemNoticeEmailText" cols=60 rows=8></textarea><br>
		</tD>
	</tr>				
	<tr class=es02> 
		<td colspan=2 align=middle> 
			 <input type=hidden name="fee" value="<%=sFn%>">
			 <input type=submit value="發送Email內容" onClick="確認發送?">
		</tD>
	</tr>
	</table>
	</tD>
	</tr>
	</table>
		
</center>


<%
	}else{
%>	

		帳單產生錯誤!
<%	
	}
%>	
	