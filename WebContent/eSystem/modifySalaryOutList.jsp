<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=5;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu5.jsp"%>
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

<blockquote>
<br>
<br>
<% 
DecimalFormat mnf = new DecimalFormat("###,###,##0"); 

 

int soId=Integer.parseInt(request.getParameter("soId"));
SalaryOutMgr som=SalaryOutMgr.getInstance();
SalaryOut so=(SalaryOut)som.find(soId);

Date runDate=so.getSalaryOutMonth();

SalaryAdmin sa=SalaryAdmin.getInstance();
SalaryTicket[] st=sa.getAllSalaryTicketByDate(runDate);
 

SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM");
SimpleDateFormat sdf2=new SimpleDateFormat("yyyy/MM/dd");

BankAccountMgr bam=BankAccountMgr.getInstance();
BankAccount ba=(BankAccount)bam.find(so.getSalaryOutBankAccountId());

//SalaryBank[] sbs=sa.getSalaryBankByDate(runDate);


SalaryBank[] sbs=sa.getSalaryBankByDateNot90(runDate);

Hashtable ha=new Hashtable();

if(sbs !=null)
{
	for(int i=0;i<sbs.length;i++)
		ha.put(String.valueOf(sbs[i].getSalaryBankSanumber()),sbs[i]);
} 
TeacherMgr tm=TeacherMgr.getInstance();

%>


<table width="600" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>
<tr align=left valign=middle>
	<td bgcolor=#ffffff class=es02 colspan=4><b>匯款單資訊</b></td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
	<td bgcolor=#f0f0f0 class=es02 width=40>狀態</td>
	<td  bgcolor=#ffffff  colspan=3 class=es02> 
	
		<%
		int status=so.getSalaryOutStatus();
 
 	 	if(status !=2)
 		{ 
	%>
		<form action="modifySalaryOut.jsp" method="post">			
			<input type="radio" name="outSatus" value="90" <%=(status==90)?"checked":""%>>可編輯
			<input type="radio" name="outSatus" value="1" <%=(status==1)?"checked":""%>>匯款中
			<input type="radio" name="outSatus" value="2" <%=(status==2)?"checked":""%>>匯款完成
	<%
		}else{
		
			out.println("匯款完成");
		} 
		
	%>		
		
	</td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
	<td bgcolor=#f0f0f0 class=es02>流水號</td><td><%=so.getSalaryOutBanknumber()%></td><td bgcolor=#f0f0f0 class=es02>月份</td><td><%=sdf.format(runDate)%></td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
	<td bgcolor=#f0f0f0 class=es02>註記</td>
	<td  bgcolor=#ffffff colspan=2>
	
	<textarea rows=3 cols=20 name="ps"><%=so.getSalaryOutPs()%></textarea></td>
	<td bgcolor=#ffffff class=es02> 
		<% if(status !=2){ %>
		<input type=hidden name="soId" value="<%=so.getId()%>">
		<input type="submit" value="修改">
		</form>
		<% } %>	
	</td> 
</tr> 
<%
if(status==2) {  
%> 

<tr>
	<td>匯款人</tD> 
	<td bgcolor=#ffffff class=es02>
	<%
		UserMgr um2=UserMgr.getInstance();
		User uz=(User)um2.find(so.getSalaryOutPayUser()); 	
			
		out.println(uz.getUserFullname());
	%>
	</td> 
	<td> 
		匯款日期
	</tD>
  	<td bgcolor=#ffffff class=es02>
		<%=sdf2.format(so.getSalaryOutPayDate())%>
  	</td>
 </tr>
 <tr>
 	<td>匯款備註</td>
 	<td bgcolor=#ffffff colspan=3>
 	   	<%=so.getSalaryOutPayPs()%>
  	 </td>  
 </tR>
<%
}
%>
<tr bgcolor=#ffffff align=left valign=middle>
	<td colspan=4 bgcolor="ffffff" class=es02><b>匯款銀行資訊</b></td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>名稱</td><td><%=ba.getBankAccountName()%></td><td bgcolor=#f0f0f0 class=es02>銀行代碼</td><td><%=ba.getBankAccountId()%></td></tr>
<tr bgcolor=#ffffff align=left valign=middle class=es02>
<td bgcolor=#f0f0f0 class=es02>帳戶號碼</td><td><%=ba.getBankAccountAccount()%></td><td bgcolor=#f0f0f0 class=es02>戶名</td><td><%=ba.getBankAccountAccountName()%></td>
</tr>

</table>
</td>
</tr>
</table>

<br>
<%
if(status==2) 
{  

		SalaryBank[] sb2=sa.getSalaryBankByBanknumber(so); 

		if(sb2 ==null)
  		{
  			out.println("沒有匯款帳戶");		
  			return;	
  		}
%> 


<table width="" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr>
		<td  bgcolor=#ffffff colspan=8 class=es02><b>付款明細</b></td>
	</tr>
	<tr bgcolor=#ffffff align=left valign=middle>
		<td bgcolor=#f0f0f0 class=es02>payid</td>
		<td bgcolor=#f0f0f0 class=es02>姓名</td> 
		<td bgcolor=#f0f0f0 class=es02>薪資條流水號</td> 
		<td bgcolor=#f0f0f0 class=es02>狀態</td>
		<td bgcolor=#f0f0f0 class=es02>匯款日期</td> 
		<td bgcolor=#f0f0f0 class=es02>已匯金額</td> 
		<td bgcolor=#f0f0f0 class=es02>銀行代碼</td>
		<td bgcolor=#f0f0f0 class=es02>帳號</td>
		
	</tr> 
	
	<% 
		int totalX=0; 
		
		for(int q=0;q< sb2.length;q++)
		{ 
			Teacher tea=(Teacher)tm.find(sb2[q].getSalaryBankTeacherId());
	%>
	<tr bgcolor=#ffffff align=left valign=middle>
		<td class=es02><%=sb2[q].getId()%></td> 
		
		<td class=es02><%=tea.getTeacherFirstName()%><%=tea.getTeacherLastName()%></td>
		<td class=es02>
		<a href="salaryTicketDetailX.jsp?stNumber=<%=sb2[q].getSalaryBankSanumber()%>"><%=sb2[q].getSalaryBankSanumber()%></a></td> 
		<td class=es02><%=(sb2[q].getSalaryBankStatus()==90)?"完成":""%></td> 
		<td class=es02>
			<%=sdf2.format(sb2[q].getSalaryBankPayDate())%>
		</td>
		<td class=es02 align=right width=70>
		<%
			totalX+=sb2[q].getSalaryBankMoney(); 
			
			out.println(mnf.format(sb2[q].getSalaryBankMoney()));
		%></td> 
		<td class=es02  align=right><%=sb2[q].getSalaryBankToId()%></td>
		<td class=es02  align=left width=100><%=sb2[q].getSalaryBankToAccount()%></td>
	</tr>

	<%
		}
	%>  
	<tr>
		<td colspan=5>合計</td>
		<td align=right><b><%=mnf.format(totalX)%></b></tD>
		<td colspan=2></td>
	</table>
	
	</td>
	</tr>
	</table>
    <br>
    <br>
    <%@ include file="bottom.jsp"%>
		
<%
return;
} 
%>


編輯詳細名單 
| <a href="#" onClick="javascript:openwindow77('<%=soId%>');return false">匯款批次檔</a>(僅限台新銀行薪資轉帳企業客戶) 
| <a href="#" onClick="javascript:openwindow78('<%=soId%>');return false"><img src="images/excel2.gif" border=0>匯款名單Excel檔</a>(印兩份供銀行轉帳使用)<br> 
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<%
if(st==null)
{
	out.println("沒有帳單資料");
	return;
}



%> 

<br> 

<form action=addSalaryBank.jsp method=post>

<table width="" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#ffffff align=left valign=middle>
	<td bgcolor=#f0f0f0 class=es02>
	
	姓名
	<input type="checkbox" onClick="this.value=check(this.form.sanumberid)"><font color=blue>全選</font>
	</td>
	<td bgcolor=#f0f0f0 class=es02>狀態</td>
	<td bgcolor=#f0f0f0 class=es02>流水號</td>
	<td bgcolor=#f0f0f0 class=es02>應發金額</td>
	<td bgcolor=#f0f0f0 class=es02>已付金額</td> 
	<td bgcolor=#f0f0f0 class=es02>應付餘額</td>
	<td bgcolor=#f0f0f0 class=es02>預計匯款</td> 
	<td bgcolor=#f0f0f0 class=es02>已匯金額</td> 
	<td bgcolor=#f0f0f0 class=es02>銀行代碼</td>
	<td bgcolor=#f0f0f0 class=es02>帳號</td>
	<td bgcolor=#f0f0f0 class=es02>戶名</td> 
	<td bgcolor=#f0f0f0 class=es02></td>
</tr>

<%
SalaryBankMgr sbm=SalaryBankMgr.getInstance(); 

int shouldTotal=0;
int payTotal=0;

int paiedTotal=0;
for(int i=0;i<st.length;i++){

	Teacher tea=(Teacher)tm.find(st[i].getSalaryTicketTeacherId());

	int payWay=tea.getTeacherAccountPayWay();
	
	int bank=tea.getTeacherAccountDefaut();
	int sanumber=st[i].getSalaryTicketSanumberId();
	
	boolean haveNumber=false;
	if(ha.get(String.valueOf(sanumber))!=null)
		haveNumber=true;

	SalaryBank sbx=new SalaryBank();
	if(haveNumber)
		sbx=(SalaryBank)ha.get(String.valueOf(sanumber));
	
	boolean bankStatus=false;
	if(sbx.getSalaryBankStatus()==0)
		bankStatus=true; 
		
	int nowTotal=st[i].getSalaryTicketTotalMoney()-st[i].getSalaryTicketPayMoney(); 
		
%>
<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
<td class=es02>
<%if(payWay==1 && !haveNumber &&bankStatus && status>=90 &&nowTotal>0){%>
	<input type=checkbox name="sanumberid" value="<%=st[i].getSalaryTicketSanumberId()%>">
	<%=tea.getTeacherFirstName()%><%=tea.getTeacherLastName()%>
	
	</td>
<%
}else{
%>
	<%=tea.getTeacherFirstName()%><%=tea.getTeacherLastName()%></td>
<%
}
%>

<td class=es02>
<%
if(payWay==0){
	out.println("櫃臺領取");

}else if(sbx!=null && sbx.getSalaryBankStatus()<90 && sbx.getSalaryBankStatus()!=0){
	out.println("匯出鎖定");
}else if(haveNumber){
	
	int banknumberX=sbx.getSalaryBankBankNumberId();
	
	if(sbx.getSalaryBankBankNumberId()==so.getSalaryOutBanknumber())
		out.println("<font color=blue>本次匯款</font>");
	else
		out.println("其他匯款");

}else if(nowTotal<=0) { 

	out.println("已付清");
}else{ 
	if(status >=90) 
		out.println("<font color=red>可加入</font>");
	else
		out.println("");
}
%>	
</td>
<td class=es02>

<a href="salaryTicketDetailX.jsp?stNumber=<%=sanumber%>"><%=sanumber%></a></td>
<td align=right class=es02><%

int temp1=st[i].getSalaryTicketTotalMoney(); 


if(haveNumber  && sbx.getSalaryBankBankNumberId()==so.getSalaryOutBanknumber() )
{ 
	out.println(mnf.format(temp1));
	shouldTotal += temp1;
}else{
	out.println(mnf.format(temp1));
} 
%></td>
<td align=right class=es02><% 

int temp2=st[i].getSalaryTicketPayMoney() ;
if(haveNumber  && sbx.getSalaryBankBankNumberId()==so.getSalaryOutBanknumber() )
{ 
	out.println(mnf.format(temp2));
	payTotal +=temp2;
}else{
	out.println(mnf.format(temp2));
}
%></td> 
<td align=right class=es02> 
<%=mnf.format(temp1-temp2)%>
</td>
<td align=right>
<%


if(haveNumber  && sbx.getSalaryBankBankNumberId()==so.getSalaryOutBanknumber() )
{ 
	out.println("<font color=blue>"+mnf.format(nowTotal)+"</font>");
}
%>
</td> 

<td align=right class=es02>
<%
if(sbx.getSalaryBankBankNumberId()==so.getSalaryOutBanknumber() )
{  
	paiedTotal+=sbx.getSalaryBankMoney();
  	out.println(mnf.format(sbx.getSalaryBankMoney()));
}
%> 
	
</td>
<%if(payWay==1){%>
	<td class=es02><%=(bank==1)?tea.getTeacherBank1():tea.getTeacherBank2()%></td>
	<td class=es02><%=(bank==1)?tea.getTeacherAccountNumber1():tea.getTeacherAccountNumber2()%></td>
	<td class=es02><%=(bank==1)?tea.getTeacherAccountName1():tea.getTeacherAccountName2()%></td>
<%}else{%>
	<td colspan=3 class=es02></td>
<%}%>

	<td class=es02>
		<%
			if(haveNumber && sbx.getSalaryBankBankNumberId()==so.getSalaryOutBanknumber() && bankStatus) { 
				 if(status==90)
				 { 
				 
		%> 
			<a href="deleteSalaryBank.jsp?sbId=<%=sbx.getId()%>&soId=<%=soId%>">不加入此筆</a>	
		<%    
				}
			}
		%>
	</td>
</tr>

<%
}
%>
<tr>
	<td colspan=3>合計</td>
	<td align=right><%=mnf.format(shouldTotal)%></td>
	<td align=right><%=mnf.format(payTotal)%></td>
	<td></td>
	<td align=right><b><font color=blue><%=mnf.format(shouldTotal-payTotal)%></font></b></tD>  
	
	<td align=right><b><font color=red><%=mnf.format(paiedTotal)%></font></b></td>
 	<td colspan=3></td>
</tR>


<%
if(status >=90){
%>
<tr><td colspan=9>
<center>
	<input type=hidden name=soId value="<%=soId%>">
	<input type=submit value="新增">
</center>
</td>
</tr>
<%
}
%>
	</table>

</td>
</tr>
</table>
</form>
</blockquote>

<br>
<br>
<%@ include file="bottom.jsp"%>


















