<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=5;
    int leftMenu=1;
%>
<%@ include file="topMenuAdvanced.jsp"%>
<%@ include file="leftMenu5.jsp"%>

<%



	JsfAdmin ja=JsfAdmin.getInstance();
	JsfPay jp=JsfPay.getInstance(); 
	
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	
	Userlog[] uls=ja.getUserlogById(ud2.getId()); 
	
	Date beforeDate=null;
	
	if(uls.length<2) 
	{
		beforeDate = uls[0].getUserlogDate() ;
	}else{
		beforeDate = uls[1].getUserlogDate() ;
	} 
	
	Date aaa=new Date();
	SimpleDateFormat sdfA=new SimpleDateFormat("yyyy/MM");
	
	String aString=sdfA.format(aaa);

	DecimalFormat nf2 = new DecimalFormat("###,##0.00");
  	DecimalFormat mnf2 = new DecimalFormat("###,###,##0");

	int[] salary=jp.getSalaryByDate(sdfA.parse(aString));


	if(ud2.getUserRole()>2)
	{
		response.sendRedirect("modifySalary4.jsp");
	}
%> 


<br>
<br>
<b>&nbsp;&nbsp;&nbsp;<font color=blue><%=aString%></font><img src="pic/salaryOut.png" border=0> 薪資統計</b>
 
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<blockquote>
	
	<table width="60%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#f0f0f0 class=es02>
			<td></td>
			<td>應付金額</tD>		
			<td>已付金額</tD>	
			<td>未付金額</td>	
			<td></td>
		</tr>		
		<tr bgcolor=#f0f0f0 class=es02>
			
			<td align=center>
				<font color=red>薪資</font>
			</td> 
			<td bgcolor=#ffffff  align=right> 
				<a href="salarySearch.jsp"><%=mnf2.format(salary[0])%></a>
			</td>		
			<td bgcolor=#ffffff  align=right> 
				<%=mnf2.format(salary[1])%>
			</td>		
			<td bgcolor=#ffffff  align=right> 
				<%=mnf2.format(salary[2])%>
			</td>		
			<td bgcolor=#ffffff><a href="salarySearch.jsp?year=<%=sdfA.parse(aString).getYear()+1900%>&month=<%=sdfA.parse(aString).getMonth()+1%>&poId=999&classId=999"><img src="pic/list.gif" border=0>詳細報表</a></td>
		</tr> 
		
	</table>		
	
	</tD>
	</tr>
	</table>
</blockquote>
  
 

<%
	if(ud2.getUserRole()>2 &&ud2.getUserRole()<=3)
	{ 
%> 

<br>
&nbsp;&nbsp;&nbsp;<b>薪資</b><font color=blue><b><%=sdf.format(beforeDate)%></b></font>至<font color=blue><b><%=sdf.format(new Date())%></b></font> 變動記錄<br> 
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<blockquote>

	<%@ include file="salaryTicketBeforeDate.jsp"%>

</blockquote>

<%
	}
%>


<%@ include file="bottom.jsp"%>