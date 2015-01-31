<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=5;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu5.jsp"%>


<br>
<br>

<%
if(!AuthAdmin.authPage(ud2,3))
{
    response.sendRedirect("authIndex.jsp?page=5&info=1");
}


SalaryTypeMgr stm=SalaryTypeMgr.getInstance();

String syear=request.getParameter("year");
String smonth=request.getParameter("month");

JsfAdmin ja=JsfAdmin.getInstance();
JsfTool jt=JsfTool.getInstance();

String seleString="";

if(smonth !=null)
	seleString=smonth;

String[] newdate=jt.getSalaryDate();

SalaryAdmin sa=SalaryAdmin.getInstance();


%>

<br>
	<form action="listSalaryOut.jsp" method="post">
<table>
	<tr>
		<td valign=middle>月份</td>
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
	<input type=submit value="查詢"> 
	
	</td>
	</tr>
	</table>
	</form>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<blockquote>

<%

if(syear==null)
{ 
	syear=newdate[0];
	smonth=newdate[1];
}

SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM");
Date runDate=sdf.parse(syear+"-"+smonth);

SalaryOut[] so=sa.getAllSalaryOutByDate(runDate);

if(so==null)
{
	out.println("本月份尚未產生任何匯款單<br><br>"); 
%>
<a href="addSalaryOut.jsp?year=<%=syear%>&month=<%=smonth%>"><img src="pic/add.gif" border=0>產生新的匯款單</a>
  
  <%@ include file="bottom.jsp"%>

<%	
	return;
}
%> 
<br>
<table width="" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>
<tr bgcolor=#ffffff align=left valign=middle>

<td bgcolor=#f0f0f0 class=es02>匯款單流水號</td>
<td bgcolor=#f0f0f0 class=es02>匯出銀行</td>
<td bgcolor=#f0f0f0 class=es02>狀態</td>
<td bgcolor=#f0f0f0 class=es02>已加入筆數</td>
<td bgcolor=#f0f0f0 class=es02>備註</td>
<td bgcolor=#f0f0f0 class=es02></td></tr>
<%
SalaryAdmin sdmin=SalaryAdmin.getInstance();
BankAccountMgr bam=BankAccountMgr.getInstance();
for(int i=0;i<so.length;i++)
{
	int sBankLength=0;
	SalaryBank[] sn=sdmin.getAllSalaryBankByBankNum(so[i].getSalaryOutBanknumber());
	
	if(sn!=null) 
		 sBankLength=sn.length;
	

	BankAccount ba=(BankAccount)bam.find(so[i].getSalaryOutBankAccountId());
%>
<tr bgcolor=#ffffff align=left valign=middle>
	<td class=es02><%=so[i].getSalaryOutBanknumber()%></td>
	<td class=es02><a href="#" onClick="javascript:openwindow551('<%=so[i].getSalaryOutBankAccountId()%>');return false"><%=ba.getBankAccountName()%></a></td>
	<td class=es02>
	<%
		int status=so[i].getSalaryOutStatus();  
		
		switch(status) 
		{ 
			case 90:
				out.println("可編輯");	
				break;
			case 1:
				out.println("匯款中");	
				break; 
			case 2:
				out.println("匯款完成");	
				break; 		
		} 
	%> 
		
  	</td> 
	<td class=es02 align=right>
	<%=sBankLength%> 
	</td>
	<td class=es02><%=so[i].getSalaryOutPs()%></td>
	<td class=es02>
		<a href="modifySalaryOutList.jsp?soId=<%=so[i].getId()%>">編輯名單</a>
	</td> 
</tr>
<%
}
%>
	</table>
	
	</td>
	</tr>
	</table> 
	<br>
	<br>
<a href="addSalaryOut.jsp?year=<%=syear%>&month=<%=smonth%>"><img src="pic/add.gif" border=0>產生新的匯款單</a>
</blockquote>
<%@ include file="bottom.jsp"%>