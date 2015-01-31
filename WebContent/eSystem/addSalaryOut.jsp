<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=5;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%> 
<%@ include file="leftMenu5.jsp"%>
<%

JsfTool jt=JsfTool.getInstance();
String[] newdate=jt.getSelectDate();

String smonth=request.getParameter("month");
String syear=request.getParameter("year");


if(smonth !=null) 
{ 
	newdate[0]=syear;
	newdate[1]=smonth;
} 

SalaryAdmin sa=SalaryAdmin.getInstance();

BankAccount[] ba=sa.getActiveBankAccount();

if(ba==null)
{
	out.println("<br><br><blockquote>尚無設定匯款帳號</blockquote>");
	return;
}
%>



<br>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/add.gif" border=0>新增匯款單</b>  
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>

<blockquote>
<form action="addSalaryOut2.jsp" method="post">

	<table width="50%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
	<td>新增月份</td>
	<td bgcolor=#ffffff>
		<select name="year" size=1>
				<option value="2006" <%=(newdate[0].equals("2006"))?"selected":""%>>2006</option>
				<option value="2007" <%=(newdate[0].equals("2007"))?"selected":""%>>2007</option>
				<option value="2008" <%=(newdate[0].equals("2008"))?"selected":""%>>2008</option>
				<option value="2009" <%=(newdate[0].equals("2009"))?"selected":""%>>2009</option>
				<option value="2010" <%=(newdate[0].equals("2010"))?"selected":""%>>2010</option>
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
		<option value="<%=sValue%>"  <%=(sValue.equals(newdate[1]))?"selected":""%>><%=i+1%></option>
		<%
		}
		%>
		</select>
	</td>
</tr>

<tr bgcolor=#f0f0f0 class=es02>
	<td>匯出帳號</td>
	<td bgcolor=#ffffff>
	<select name=bankAccountId size=1>
	<%
	for(int i=0;i<ba.length;i++)
	{
	%>
		<option value="<%=ba[i].getId()%>"><%=ba[i].getBankAccountName()%></option>
	<%
	}
	%>
	</select>
	</td>
</tr>
<tr bgcolor=#f0f0f0 class=es02>
	<td>備註</td>
	<td bgcolor=#ffffff>
		<textarea name=ps rows=3 cols=20></textarea>
	</td>
</tr>
<tr><td colspan=2><center><input type=submit value="新增"></center></td></tr>

</table> 
</td>
</tr>
</table>
</form>

</blockquote>
