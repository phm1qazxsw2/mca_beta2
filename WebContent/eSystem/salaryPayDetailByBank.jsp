<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>

<%@ include file="jumpTop.jsp"%>

<%

String bankIdS=request.getParameter("bankId");

if(bankIdS==null)
{
	out.println("沒有選擇銀行帳戶"); 
	return;
}



String syear=request.getParameter("year");
String smonth=request.getParameter("month");

JsfAdmin ja=JsfAdmin.getInstance();
JsfTool jt=JsfTool.getInstance();



String seleString="";

if(smonth !=null)
	seleString=smonth;


String[] newdate=jt.getSelectDate();

%>

<script type="text/javascript" src="openWindow.js"></script>
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script type="text/javascript" src="js/check.js"></script>
 	
<blockquote>
<br>

<b><<<依月份查詢匯款紀錄>>></h3>

	<form action="salarySearch.jsp" method="post">
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
	</table>
	
	<%
	if(syear ==null)
	{
		return;	
	}
	
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM");
	Date runDate=sdf.parse(syear+"-"+smonth);
	%>
