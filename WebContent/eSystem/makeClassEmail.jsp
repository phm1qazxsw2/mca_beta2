<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,java.io.*" contentType="text/html;charset=UTF-8"%>
<%@ page import="java.io.*" %>
<%@ include file="jumpTop.jsp"%>
<script type="text/javascript" src="openWindow.js"></script>
<link rel="stylesheet" href="style.css" type="text/css">
<link href=ft02.css rel=stylesheet type=text/css>
<SCRIPT LANGUAGE="JavaScript">
<!-- Modified By:  Steve Robison, Jr. (stevejr@ce.net) -->

<!-- This script and many more are available free online at -->
<!-- The JavaScript Source!! http://javascript.internet.com -->

<!-- Begin
var checkflag = "false";
function check(field) {
if (checkflag == "false") {
for (i = 0; i < field.length; i++) {
field[i].checked = true;}
checkflag = "true";
return "Uncheck All"; }
else {
for (i = 0; i < field.length; i++) {
field[i].checked = false; }
checkflag = "false";
return "Check All"; }
}
//  End -->
</script>

<%
try{
	String sclassId=request.getParameter("classId").trim();
	String parsedate=request.getParameter("date").trim();
	String type2=request.getParameter("type").trim();
	String cmIdS=request.getParameter("cmIdI").trim();
	String statusS=request.getParameter("statusS").trim();
	String puS=request.getParameter("pu").trim();
	
	int classId=Integer.parseInt(sclassId);

	int cmNewfeenumber=Integer.parseInt(type2);
	int cmId=Integer.parseInt(cmIdS);
	int status2=Integer.parseInt(statusS);
	
	int pu=Integer.parseInt(puS);
	
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM");
	Date runDate=sdf.parse(parsedate);

	JsfAdmin ja=JsfAdmin.getInstance();	
	JsfTool jt=JsfTool.getInstance();
	

	String path=application.getRealPath("/")+"eSystem/pdf_example/";

	File FileDic2 = new File(path+"email");
	File files2[]=FileDic2.listFiles();

	if(files2 !=null)
	{ 
		for(int j2=0;j2<files2.length;j2++)
		{ 
			if(!files2[j2].isHidden())
				files2[j2].delete();
		} 
	}

	
	Feeticket[] ticket=null;
	
	if(pu==999)
	{
		ticket=jt.getFeeticketByType(runDate,classId,cmNewfeenumber,cmId,status2);
	}
	
	StudentMgr stu=StudentMgr.getInstance();
  
 	PdfMaker pm=PdfMaker.getInstance();
	
	Hashtable ha=new Hashtable();
	if(ticket !=null)
	{
		for(int j=0;j<ticket.length;j++)
		{
			if((ticket[j].getFeeticketTotalMoney()-ticket[j].getFeeticketPayMoney()) >0)
			{ 
			
				int status=pm.makeEmailPDF(ticket[j],path);
				
				if(status==90)
  				{
 					int stuId=ticket[j].getFeeticketStuId();
					String stuIdS=String.valueOf(stuId);
					
					Vector v=(Vector)ha.get(stuIdS);
					
					if(v==null)
						v=new Vector();
					
					v.add((Feeticket)ticket[j]); 				
					ha.put((String)stuIdS,(Vector)v); 
				}
			}
		}	
	}else{
		out.println("沒有資料");
		return;
	}
	
	DecimalFormat mnf = new DecimalFormat("###,###,##0"); 
%>

<b>&nbsp;&nbsp;&nbsp;<img src="pic/email.png" border=0>Email 帳單</b>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<br>

<form action="makeClassEmail2.jsp" method="post">
<center>
		<table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
		<tr align=left valign=top>
		<td bgcolor="#e9e3de">
	
		<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#f0f0f0  class=es02>
			<tD>班級</td>
			<td>學生<input type="checkbox" onClick="this.value=check(this.form.stuID)">全選</tD> 
			<tD>Email Address</tD>
			<td>帳單筆數</td><tD>繳款截止日期</tD><td>未繳合計金額</tD> 
		</tr>
<%
	PaySystemMgr em=PaySystemMgr.getInstance();
	PaySystem e=(PaySystem)em.find(1);
	ClassesMgr clam=ClassesMgr.getInstance();
	StudentMgr smx=StudentMgr.getInstance();
	
	SimpleDateFormat sdfXX=new SimpleDateFormat("yyyy/MM/dd");
 
	SimpleDateFormat sdfXX2=new SimpleDateFormat("MM/dd");

	JsfPay jp=JsfPay.getInstance();
	
	Enumeration keys=ha.keys();
	Enumeration elements=ha.elements();

	while(elements.hasMoreElements())
	{
		String key=(String)keys.nextElement();
		Vector feeV=(Vector)elements.nextElement();
		
		int stuId=Integer.parseInt(key);
 
		Student stu2=(Student)smx.find(stuId); 
 
		Classes cla=(Classes)clam.find(stu2.getStudentClassId()); 
		
%>		
		<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
			<td class=es02><%=(cla==null)?"未定":cla.getClassesName()%></tD>
			<td class=es02><input type=checkbox name="stuID" value="<%=stu2.getId()%>" checked><%=stu2.getStudentName()%></tD>
			<td class=es02>
				<%=jp.getBillEmail(e,stu2)%>
			</td>		
			<tD class=es02><%=feeV.size()%></tD>
			<td class=es02>
				<%  
					int total=0; 
					Date payDate=null;
					
					String feeid="";
					for(int i=0;i<feeV.size();i++)
					{ 
						Feeticket ft=(Feeticket)feeV.get(i);
  						int nowtotal=ft.getFeeticketTotalMoney()-ft.getFeeticketPayMoney();
  						total+=nowtotal;
  						payDate=ft.getFeeticketEndPayDate();
  						feeid+=String.valueOf(ft.getFeeticketFeenumberId())+"###";
  					}
				%>		
				<%=(payDate !=null)?sdf.format(payDate):""%>
			</td> 
			<td class=es02 align=right>
				<%=mnf.format(total)%> 
				<input type=hidden name="feeid<%=stu2.getId()%>" value="<%=feeid%>"> 
				<input type=hidden name="num<%=stu2.getId()%>" value="<%=total%>">
				<input type=hidden name="edate<%=stu2.getId()%>" value="<%=sdfXX2.format(payDate)%>">
			</td>
		</tr> 
<%
	}
%>  
	<tr class=es02> 
		<td colspan=2 bgcolor=f0f0f0>
			Email發送形式:
		</tD>
		<td colspan=4 bgcolor=ffffff>
			<input type=radio name="paySystemNoticeEmailType" value="0" <%=(e.getPaySystemNoticeEmailType()==0)?"checked":""%>>純文字
			<input type=radio name="paySystemNoticeEmailType" value="1" <%=(e.getPaySystemNoticeEmailType()==1)?"checked":""%>>HTML格式
		</tD>
	</tr>				
	<tr class=es02> 
		<td colspan=2 bgcolor=f0f0f0>
			Email預設標題
		</td>
		<td colspan=4 bgcolor=ffffff>
			<input type=text name="paySystemNoticeEmailTitle" size=30 value="<%=(e.getPaySystemNoticeEmailTitle()!=null)?e.getPaySystemNoticeEmailTitle():""%>">
		</td>
	</tr>
	<tr class=es02> 
	<td colspan=2 bgcolor=f0f0f0>
			Email發送內容:
		</tD>
		<td colspan=4 bgcolor=ffffff>
			<textarea name="paySystemNoticeEmailText" cols=60 rows=8><%=(e.getPaySystemNoticeEmailText()!=null)?e.getPaySystemNoticeEmailText():""%></textarea><br>
			代號規則:以 XXX=學童姓名  YYY=繳款截止日期 ZZZ=未繳金額 FFF=帳單編號 MMM=帳單月份
		</tD>
	</tr>				

	<tr class=es02> 
		<td colspan=6 align=middle>
			 <input type=hidden name="runmonth" value="<%=parsedate%>">
			 <input type=submit value="發送Email內容" onClick="確認發送?">
		</tD>
	</tr>
	</table>
	</tD>
	</tr>
	</table>
<%

}catch(Exception e){

	out.println("檔案產生錯誤!!<br><br>"+e.getMessage());
}

 %>
	
	