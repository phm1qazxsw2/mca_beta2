<%@ page language="java" contentType="text/html;charset=UTF-8"%><% 
	DecimalFormat stmnf = new DecimalFormat("###,###,##0");

    SalaryTicket[] stXX=jp.getSalaryTicketByBeforedate(beforeDate);
	
	if(stXX !=null)
	{
%>
<b><img src="pic/salaryOut.png" border=0> 薪資更動概況:</b><br>

<table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>

<tr bgcolor=#ffffff align=left valign=middle>

		<td bgcolor=#f0f0f0 class=es02>流水號</td>	
		<td bgcolor=#f0f0f0 class=es02>姓名</td>
		<td bgcolor=#f0f0f0 class=es02>狀態</td>
		<td bgcolor=#f0f0f0 class=es02>應領所得</td> 
		<td bgcolor=#f0f0f0 class=es02>代扣</td>
		<td bgcolor=#f0f0f0 class=es02>應扣薪資</td>
		<td bgcolor=#f0f0f0 class=es02>薪資合計</td>
		<td bgcolor=#f0f0f0 class=es02>付款次數</td>
		<td bgcolor=#f0f0f0 class=es02>已付金額</td>
		<td bgcolor=#f0f0f0 class=es02>應付餘額</td>
 
		<td bgcolor=#f0f0f0 class=es02></td>
	</tr>
<%
 
	int totalType1=0;
	int totalType2=0;
	int totalType3=0;
 
	int payTotal=0;
	int shouldTotal=0;
	TeacherMgr tm=TeacherMgr.getInstance();
	for(int i=0;i<stXX.length;i++)
	{
 
		totalType1+=stXX[i].getSalaryTicketMoneyType1();
		totalType2+=stXX[i].getSalaryTicketMoneyType2();
		totalType3+=stXX[i].getSalaryTicketMoneyType3(); 
		payTotal += stXX[i].getSalaryTicketPayMoney();  
		shouldTotal+=stXX[i].getSalaryTicketTotalMoney()-stXX[i].getSalaryTicketPayMoney();
		Teacher tea=(Teacher)tm.find(stXX[i].getSalaryTicketTeacherId());
%>
	<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
		<td class=es02><%=stXX[i].getSalaryTicketSanumberId()%></td>
		<td class=es02><%=tea.getTeacherFirstName()%><%=tea.getTeacherLastName()%></td>
		<td class=es02>
<%
		switch(stXX[i].getSalaryTicketStatus())
		{
			case 1:
				out.println("尚未支付");
 
				break;
			case 2:
				out.println("<font color=red>金額已更新</font>");
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
		<td class=es02 align=right><%=stmnf.format(stXX[i].getSalaryTicketMoneyType1())%></td>
		<td class=es02 align=right><%=stmnf.format(stXX[i].getSalaryTicketMoneyType2())%>
		<td class=es02 align=right><%=stmnf.format(stXX[i].getSalaryTicketMoneyType3())%></td>
		<td class=es02 align=right><%=stmnf.format(stXX[i].getSalaryTicketTotalMoney())%></td>
		<td class=es02 align=right><%=stmnf.format(stXX[i].getSalaryTicketPayTimes())%></td>
		<td class=es02 align=right><%=stmnf.format(stXX[i].getSalaryTicketPayMoney())%></td>
		<td class=es02 align=right><%=stmnf.format(stXX[i].getSalaryTicketTotalMoney()-stXX[i].getSalaryTicketPayMoney())%></td>
		<td class=es02> 
			<a href="salaryTicketDetailX.jsp?stNumber=<%=stXX[i].getSalaryTicketSanumberId()%>">薪資明細</a>
		</td>
	</tr>
	<%
	}
	%>
 
	
	<tr>
		<td>合計</td>
		<td colspan=2></td>
		<td align=right><%=stmnf.format(totalType1)%></td>
		<td align=right><%=stmnf.format(totalType2)%></td>
 
		<td align=right><%=stmnf.format(totalType3)%></td>
		<td align=right><%=stmnf.format(totalType1-totalType2-totalType3)%></td>
		<td align=right></td>
		<td align=right><%=stmnf.format(payTotal)%></td> 
		<td align=right><%=stmnf.format(shouldTotal)%></td>
	</tr>	
	</table>
</td></tr></table>

<br>
<%
}
%>
	