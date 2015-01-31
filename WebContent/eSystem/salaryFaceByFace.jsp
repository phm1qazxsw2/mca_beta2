<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=5;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu5.jsp"%>
<%

DecimalFormat mnf = new DecimalFormat("###,###,##0");

String syear=request.getParameter("year");
String smonth=request.getParameter("month");

JsfAdmin ja=JsfAdmin.getInstance();
JsfTool jt=JsfTool.getInstance();



String seleString="";

if(smonth !=null)
	seleString=smonth;


String[] newdate=jt.getSalaryDate();


String m=request.getParameter("m");


if(ud2.getUserRole()>2) 
{  

	response.sendRedirect("modifySalary4.jsp");
}
%>

<script type="text/javascript" src="openWindow.js"></script>
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script type="text/javascript" src="js/check.js"></script>
 	

<br>

<b>&nbsp;&nbsp;支付薪資-櫃臺發放</b>

<blockquote>
	<form action="salaryFaceByFace.jsp" method="post">
<table>
	<tr><td>月份</td>
	<td>
		<select name="year" size=1>
				<option value="2006" <%=(syear==null && newdate[0].equals("2006"))?"selected":""%> <%=(syear !=null &&syear.equals("2006"))?"selected":""%>>2006</option>
				<option value="2007" <%=(syear==null && newdate[0].equals("2007"))?"selected":""%> <%=(syear !=null &&syear.equals("2007"))?"selected":""%>>2007</option>
				<option value="2008" <%=(syear==null && newdate[0].equals("2008"))?"selected":""%> <%=(syear !=null &&syear.equals("2008"))?"selected":""%>>2008</option>
				<option value="2009" <%=(syear==null && newdate[0].equals("2009"))?"selected":""%> <%=(syear !=null &&syear.equals("2009"))?"selected":""%>>2009</option>
				<option value="2010" <%=(syear==null && newdate[0].equals("2010"))?"selected":""%> <%=(syear !=null &&syear.equals("2010"))?"selected":""%>>2010</option>
			</select>	
		-
		<select name="month" size=1>
		<%
		for(int i=0;i<12;i++)
		{
			String sValue="";
			if(i<=8)
				sValue="0"+String.valueOf(i+1);
			else
				sValue=String.valueOf(i+1);
				
		%>
		<option value="<%=sValue%>"  <%=(seleString.length()<=0 &&sValue.equals(newdate[1]))?"selected":""%> <%=(seleString.length()>0 && sValue.equals(seleString))?"selected":""%>><%=i+1%></option>
		<%
		}
		%>
		</select>
	</td>
	<td>
		<input type=submit value="查詢">
 	</td>	
	</table> 
	</blockquote>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<blockquote>

<%
if(m!=null)
 
{ 
%>
<script>

	alert('付款完成,已登入.請填寫支出傳票!');
</script>

<%
	}
	 
	if(syear ==null)
	{ 
		syear=newdate[0];	
		smonth=newdate[1];
	}
	
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM");
	Date runDate=sdf.parse(syear+"-"+smonth);

	SalaryAdmin sa=SalaryAdmin.getInstance();
	SalaryTicket[] st=sa.getAllSalaryTicketByDate(runDate);
	SalaryBank[] sb=sa.getAllSalaryBySatus(runDate);

	Hashtable hano=new Hashtable();
	
	if(sb !=null) {
		for(int i=0;i<sb.length;i++)
			hano.put(String.valueOf(sb[i].getSalaryBankSanumber()),(SalaryBank)sb[i]);
	}
%>
<div class=es02>可櫃臺領取名單:</div>
<br>
<%
if(st==null)
  
{ 
	out.println("<blockquote>沒有資料</blockquote>");
 
%>	
	<%@ include file="bottom.jsp"%>
<%	
	return;
} 

Hashtable haveShow=new Hashtable();
%> 

<table width="" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>

<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>姓名</td>
<td bgcolor=#f0f0f0 class=es02>班級職稱</td>
<td bgcolor=#f0f0f0 class=es02>薪資單序號</td>
<td bgcolor=#f0f0f0 class=es02 width=58>應發金額</td>
<td bgcolor=#f0f0f0 class=es02>付款次數</td>
<td bgcolor=#f0f0f0 class=es02 width=58>已領金額</td>
<td bgcolor=#f0f0f0 class=es02 width=58>可領金額</td>
<td bgcolor=#f0f0f0 class=es02></td>
</tr>
<%

int totalShould=0;
int totalPayed=0; 
int totalPay=0; 
TeacherMgr tmx=TeacherMgr.getInstance();
PositionMgr pm=PositionMgr.getInstance();
ClassesMgr cm=ClassesMgr.getInstance();

for(int i=0;i<st.length;i++)
{   
	if(hano.get(String.valueOf(st[i].getSalaryTicketSanumberId()))!=null)
	{		  
		SalaryBank sb2=(SalaryBank)hano.get(String.valueOf(st[i].getSalaryTicketSanumberId()));
		
		if(st[i].getSalaryTicketStatus()>=90) 
			continue;

		if(sb2.getSalaryBankStatus()!=90)	
			continue;	

	} 
	
	int shouldTotal=st[i].getSalaryTicketTotalMoney(); 
	int payedTotal=st[i]. getSalaryTicketPayMoney();
	int  payTotal=shouldTotal-payedTotal;

	if(payTotal<=0)
	{
		continue;
	}
 


	totalShould +=shouldTotal ;
	totalPayed +=payedTotal ; 
  	totalPay +=payTotal ;
 
	int teaId=st[i].getSalaryTicketTeacherId();
	Teacher tea=(Teacher)tmx.find(teaId);

	haveShow.put(String.valueOf(st[i].getSalaryTicketSanumberId()),"1");
%>

<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
	<td class=es02>
	<%=tea.getTeacherFirstName()%><%=tea.getTeacherLastName()%>
	</td>

	<td class=es02>
<%
	int classxId=st[i].getSalaryTicketClassesId();
	
	if(classxId !=0)
	{
		Classes cla=(Classes)cm.find(classxId);
		out.println(cla.getClassesName()+"-");
	}else{
		out.println("跨班-");
	}
	int positionId=st[i].getSalaryTicketPositionId();
	if(positionId !=0)
	{	
		Position po=(Position)pm.find(positionId);
		out.println(po.getPositionName());
	}else{
		out.println("未定");
	}

%>	
	</td>  
	<td class=es02 align=right>
  		<a href="salaryTicketDetailX.jsp?stNumber=<%=st[i].getSalaryTicketSanumberId()%>"><%=st[i].getSalaryTicketSanumberId()%></a>
  	</td>
	<td class=es02 align=right><%=mnf.format(shouldTotal)%></td>
	<td class=es02 align=right><%=st[i].getSalaryTicketPayTimes()%></td>
	<td class=es02 align=right><%=mnf.format(payedTotal)%></td> 
	<td class=es02 align=right><%=mnf.format(payTotal)%></td>
 
	<td class=es02>
	<a href="salaryFacePay.jsp?stId=<%=st[i].getId()%>">櫃臺領取</a>
	</td>
</tr>


<%
}
%>

<tr>
	<td colspan=3>合計</td>
	<td align=right><%=mnf.format(totalShould)%></td>
	<td></td>
	<td align=right><%=mnf.format(totalPayed)%></td> 
	<td align=right><b><%=mnf.format(totalPay)%></b></td>
 
	<td align=right></td>
</tr>
</table>
  
</td>
</table> 
<br>
<br>


<%@ include file="bottom.jsp"%>
