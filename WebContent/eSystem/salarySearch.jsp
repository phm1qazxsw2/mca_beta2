<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=5;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu5.jsp"%>
<%

DecimalFormat mnf = new DecimalFormat("###,###,##0"); 


SalaryTypeMgr stm=SalaryTypeMgr.getInstance();

String syear=request.getParameter("year");
String smonth=request.getParameter("month");

JsfAdmin ja=JsfAdmin.getInstance();
JsfTool jt=JsfTool.getInstance();

String seleString="";

if(smonth !=null)
	seleString=smonth;

String[] newdate=jt.getSalaryDate();

%>

<script type="text/javascript" src="openWindow.js"></script>
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script type="text/javascript" src="js/check.js"></script>
 	

<br>

<b>&nbsp;&nbsp;&nbsp;<img src="pic/salaryOut.png" border=0>每月薪資查詢</b>

<%

SalaryAdmin sa=SalaryAdmin.getInstance();

Date xa=new Date();


	Position[] po=ja.getAllPosition();
	Classes[] cl=ja.getAllActiveClasses();
	
	if(po==null)
	{
		out.println("<br><br><blockquote>尚未設定職位</blockquote>");
%>
		<%@ include file="bottom.jsp"%>
<%		
		return;
	}
	
	int userRole=ud2.getUserRole();
	
	int departId=999;
	int poId=999;
	int claId=999;
	int partTime=999;
	
	if(userRole>2) 
		partTime=1;	
	
	String departIdS=request.getParameter("depart");
	String poIdS=request.getParameter("poId");
	String claIdS=request.getParameter("classId"); 
	String partTimeS=request.getParameter("partTime");
  
	if(departIdS !=null)
		departId=Integer.parseInt(departIdS); 	 
	
	if(poIdS !=null)
		poId=Integer.parseInt(poIdS); 

	if(claIdS !=null)
		claId=Integer.parseInt(claIdS);  
		
	if(partTimeS !=null)	
		partTime=Integer.parseInt(partTimeS);	
		
	

%> 

<form action="salarySearch.jsp" method="get">
<blockquote>
<table class=es02>
	<tr>
	<td>月份</td>
	<td valign=top>
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
		聘僱方式:
	</tD> 
	<td>
		<select name="partTime" size=1> 
			 <% 
			  if(userRole<=3)
			  {
			%> 	 	
			<option value="999" <%=(partTime==999)?"selected":""%>>全部</option> 
			<option value="0" <%=(partTime==0)?"selected":""%>>教職員工</option> 
			<%
				}
			%>		
			<option value="1" <%=(partTime==1)?"selected":""%>>課內才藝</option> 
			<option value="2" <%=(partTime==2)?"selected":""%>>課後才藝</option> 
		</select>
	</td> 
	<td> 
		部門:
	</tD> 
	<td>
<%
		Depart[] de=ja.getAllDepart();
%>
		<select name="depart" size=1>
			<option value="999" <%=departId==999?"selected":""%>>全部</option>
		<% 
		if(de!=null) 
		{ 
		
			for(int i=0;i<de.length;i++)
			{
		%>
			<option value="<%=de[i].getId()%>" <%=(de[i].getId()==departId)?"selected":""%>><%=de[i].getDepartName()%></option>
		<%
			}
		}
		%> 
			<option value="0" <%=(departId==0)?"selected":""%>>跨部門</option>
		</select>
	</td>
 
	
	
	<td> 
	職稱: 
	</tD>
	<td>

	<select name=poId size=1>
	<option value=999 <%=(poId==999)?"selected":""%>>全部</option>
<%		
	for(int i=0;i<po.length;i++)
	{
%>
	<option value=<%=po[i].getId()%> <%=(poId==po[i].getId())?"selected":""%>><%=po[i].getPositionName()%></option>
<%
	}
%>
		<option value=0 <%=(poId==0)?"selected":""%>>未定</option>
	</select>	
	</tD>
	<td>
	班級: 
	</tD>
	<tD>
	
	<select name="classId" size=1>
	<option value="999" <%=(claId==999)?"selected":""%>>全部</option>
	<option value="0" <%=(claId==0)?"selected":""%>>跨班</option>
<%
  	for(int i=0;cl!=null && i<cl.length;i++)
  	{
%>
	  	<option value=<%=cl[i].getId()%> <%=(claId==cl[i].getId())?"selected":""%>><%=cl[i].getClassesName()%></option>
<%
	}
%>
	</select> 
	</td>
	<td>		
	<input type=submit value="搜尋">
	</td>
	</tr>
	</table>	
	</form>
</blockquote>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
	
	<blockquote> 
	
	<%
	if(ud2.getUserRole()>3)
	{  
		if(partTime==0 || partTime==999)	
		{	 
%> 
		<br>
				<br>
				<font color=red>權限不足!</font>
 				<br>
				<br>
				由於本薪資含有非鐘點費的薪資,必須以<font color=blue>經營者</font>或<font color=blue>會計人員</font>的身份來編輯.
		</blockquote>				
		<%@ include file="bottom.jsp"%>	
<% 
		return;
		}
	}
	
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM");
	Date runDate;
	
	if(syear==null)
	{ 
		runDate = sdf.parse(newdate[0]+"-"+newdate[1]);
		syear=newdate[0];
		smonth=newdate[1];
	}else{
		runDate=sdf.parse(syear+"-"+smonth);
	}

	SalaryTicket[] st=sa.getSalaryTicketAdvence(runDate,partTime,departId,poId,claId); 
	
	boolean SalaryStatus= JsfPay.SALARYStatus(runDate);

	if(!SalaryStatus)
	{ 
		out.println("<font color=red><img src=\"pic/warning.gif\" border=0>本月已結算,不得修改</font>");
	}

if(st==null)
{
	out.println("<br><b>已加入的名單:</b><blockquote><div class=es02><font color=blue>尚無資料!</font></div></blockquote>"); 
			
}else{

	String goYear= "";
	String gomonth="";
	
	if(smonth==null) 
		gomonth=newdate[1];
	else 
		gomonth=smonth;
		  
	if(syear==null)
		goYear=newdate[0];
	else
		goYear=syear;
			  
%> 
&nbsp;&nbsp;&nbsp; 
<a href="#" onClick="javascript:openwindow75('<%=gomonth%>','<%=goYear%>','<%=poId%>','<%=claId%>','<%=departId%>','<%=partTime%>');return false"><img src="pic/pdf.gif" border=0>產生全部薪資條</a>  
|
<a href="#"	onClick="javascript:openwindow73a('<%=gomonth%>','<%=goYear%>','<%=poId%>','<%=claId%>','<%=departId%>','<%=partTime%>');return false"><img src="images/excel2.gif" border=0>產生薪資報表</a>
<div align=right>共計: <font color=blue><%=st.length%></font> 筆</div>
<table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
<table width="100%" border=0 cellpadding=4 cellspacing=1>

<tr bgcolor=#ffffff align=left valign=middle>
		<td bgcolor=#f0f0f0 class=es02>流水號</td>	
		<td bgcolor=#f0f0f0 class=es02>姓名</td>
		<td bgcolor=#f0f0f0 class=es02>狀態</td>
		<td bgcolor=#f0f0f0 class=es02 width=58>應領所得</td> 
		<td bgcolor=#f0f0f0 class=es02 width=58>代扣</td>
		<td bgcolor=#f0f0f0 class=es02 width=58>應扣薪資</td>
		<td bgcolor=#f0f0f0 class=es02 width=58>薪資合計</td>
		<td bgcolor=#f0f0f0 class=es02>付款次數</td>
		<td bgcolor=#f0f0f0 class=es02 width=58>已付金額</td>
		<td bgcolor=#f0f0f0 class=es02 width=58>未付金額</td>
		<td bgcolor=#f0f0f0 class=es02></td>
	</tr>
<%
 
	int totalType1=0;
	int totalType2=0;
	int totalType3=0;
 
	int payTotal=0;
	int shouldTotal=0;
	TeacherMgr tm=TeacherMgr.getInstance();
	for(int i=0;i<st.length;i++)
	{
		totalType1+=st[i].getSalaryTicketMoneyType1();
		totalType2+=st[i].getSalaryTicketMoneyType2();
		totalType3+=st[i].getSalaryTicketMoneyType3(); 
		payTotal += st[i].getSalaryTicketPayMoney();  
		shouldTotal+=st[i].getSalaryTicketTotalMoney()-st[i].getSalaryTicketPayMoney();
		Teacher tea=(Teacher)tm.find(st[i].getSalaryTicketTeacherId());
%>
	<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
		<td class=es02><%=st[i].getSalaryTicketSanumberId()%></td>
		<td class=es02><%=tea.getTeacherFirstName()%><%=tea.getTeacherLastName()%></td>
		<td class=es02>
<%
		switch(st[i].getSalaryTicketStatus())
		{
			case 1:
				out.println("<font color=red>尚未支付</font>");
 
				break;
			case 2:
				out.println("<font color=blue>金額已更新</font>");
  				break;
  			case 3:
  				out.println("<font color=blue>支付部分</font>");
  				break;
			case 90:
  				out.println("已付清");
  				break;
  			case 91:
  				out.println("超付");
  				break;
  			default:
  				out.println("其他");
  				break;		
 		}
			
%></td>
		<td class=es02 align=right><%=mnf.format(st[i].getSalaryTicketMoneyType1())%></td>
		<td class=es02 align=right><%=mnf.format(st[i].getSalaryTicketMoneyType2())%>
		<td class=es02 align=right><%=mnf.format(st[i].getSalaryTicketMoneyType3())%></td>
		<td class=es02 align=right><%=mnf.format(st[i].getSalaryTicketTotalMoney())%></td>
		<td class=es02 align=right><%=st[i].getSalaryTicketPayTimes()%></td>
		<td class=es02 align=right><%=mnf.format(st[i].getSalaryTicketPayMoney())%></td>
		<td class=es02 align=right><%=mnf.format(st[i].getSalaryTicketTotalMoney()-st[i].getSalaryTicketPayMoney())%></td>
		<td class=es02> 
			
			<a href="salaryTicketDetailX.jsp?stNumber=<%=st[i].getSalaryTicketSanumberId()%>">薪資明細</a>
			|
			<a href="#" onClick="javascript:openwindow76('<%=st[i].getId()%>');return false;">薪資條</a>
			|
			<a href="#" onClick="javascript:openwindow16b('<%=tea.getId()%>');return false">歷史明細</a>
		</td>
		
	</tr>
	<%
	}
	%>
 
	
	<tr class=es02>
		<td>合計</td>
		<td colspan=2></td>
		<td align=right><%=mnf.format(totalType1)%></td>
		<td align=right><%=mnf.format(totalType2)%></td>
 
		<td align=right><%=mnf.format(totalType3)%></td>
		<td align=right><b><%=mnf.format(totalType1-totalType2-totalType3)%></b></td>
		<td align=right></td>
		<td align=right><%=mnf.format(payTotal)%></td> 
		<td align=right><%=mnf.format(shouldTotal)%></td>
	</tr>	
	</table>
</td></tr></table>
 
<%
} 

		Hashtable ha=new Hashtable();
		
		if(st !=null)
 
		{ 
			for(int l=0;l<st.length;l++)
			{
				ha.put((String)String.valueOf(st[l].getSalaryTicketTeacherId()),"1");			
			}
		}		
		
		Teacher[] tea=ja.getActiveTeacherAdvanced(partTime,departId,poId,claId);

		if(tea==null)
		{
%>
			<%@ include file="bottom.jsp"%>	
<%
			return;
		}			 
%>  

<div align=left>
	<br>
	<b>尚未加入名單:</b>
 
	<blockquote>
	<%  
		int runX=0;
		for(int xl=0;xl<tea.length;xl++)	
		{ 
			if(ha.get(String.valueOf(tea[xl].getId()))==null)
			{  
				 runX++; 
				   
				 int teaParttime=tea[xl].getTeacherParttime();  
				 
				 if(teaParttime==0)
  			     {
 	%>
					<a href="addSalaryByPerson.jsp?year=<%=syear%>&month=<%=smonth%>&poId=999&classId=999&teaId=<%=tea[xl].getId()%>"><%=tea[xl].getTeacherFirstName()%><%=tea[xl].getTeacherLastName()%></a> ,	
	<%
				}else{
	%>
					<a href="modifySalary4.jsp"><%=tea[xl].getTeacherFirstName()%><%=tea[xl].getTeacherLastName()%></a> ,	
	<%								
				}
			}
		} 
		
		if(runX==0)
		{
			out.println("<div class=es02>無</div>");		
		}  			
 	%>  
	</blockquote>
</div>
	</center>

	
<%@ include file="bottom.jsp"%>	

