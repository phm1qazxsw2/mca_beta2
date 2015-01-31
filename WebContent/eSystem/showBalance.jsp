<%@ page language="java"  import="web.*,jsf.*,jsi.*,java.util.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=10;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu10.jsp"%>
<% 
    
    if(!AuthAdmin.authPage(ud2,3))
    {
        response.sendRedirect("authIndex.jsp?page=8&info=1");
    }

    CostpayMgr cpmgr = CostpayMgr.getInstance();
    MembrInfoBillRecordMgr mbrmgr = MembrInfoBillRecordMgr.getInstance();

    Date start = new Date();
    Date end = new Date();
    if (cpmgr.numOfRows("")>0) {
        Object[] objs = cpmgr.retrieve("", "order by id asc limit 1");
        Costpay first = (Costpay) objs[0];
        objs = cpmgr.retrieve("", "order by id desc limit 1");
        Costpay last = (Costpay) objs[0];
        start = first.getCostpayDate();
        end = last.getCostpayDate();
    }
    if (mbrmgr.numOfRows("")>0) {
        Object[] objs = mbrmgr.retrieve("", "order by ticketId asc limit 1");
        MembrInfoBillRecord first = (MembrInfoBillRecord) objs[0];
        objs = mbrmgr.retrieve("", "order by ticketId desc limit 1");
        MembrInfoBillRecord last = (MembrInfoBillRecord) objs[0];
        if (first.getBillMonth().compareTo(start)<0)
            start = first.getBillMonth();
        if (last.getBillMonth().compareTo(end)>0)
            end = last.getBillMonth();
    }

    SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM");
    SimpleDateFormat sdf2=new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat sdf3=new SimpleDateFormat("yyyy/MM/dd");
    DecimalFormat mnf = new DecimalFormat("###,###,##0");

    Date cur = end;
    String monstr = request.getParameter("t");
    if (monstr!=null) {
        cur = sdf.parse(monstr);
    }

    Calendar cal = Calendar.getInstance();
    cal.setTime(cur);
    Date curMonthStart = sdf.parse(sdf.format(cal.getTime()));
    cal.add(Calendar.MONTH, 1);
    Date nextMonthStart = sdf.parse(sdf.format(cal.getTime()));
    cal.add(Calendar.DATE, -1);
    Date curMonthEnd = cal.getTime();

    EzCountingService ezsvc = EzCountingService.getInstance();    
    int[] numbers = new int[8]; // 
    ArrayList<MembrInfoBillRecord> bills = new ArrayList<MembrInfoBillRecord>();
    ArrayList<MembrInfoBillRecord> salaries = new ArrayList<MembrInfoBillRecord>();
    ArrayList<Vitem> income = new ArrayList<Vitem>();
    ArrayList<Vitem> cost = new ArrayList<Vitem>();
    ezsvc.getMonthlyNumbers(_ws.getSessionBunitId(), numbers, curMonthStart, nextMonthStart, bills, salaries, income, cost);
    int income_total = numbers[0];
    int income_received = numbers[1];
    int spending_total = numbers[2];
    int spending_paid = numbers[3];
    int revenue_total = numbers[4];
    int revenue_received = numbers[5];
    int salary_total = numbers[6];
    int salary_paid = numbers[7];
    int this_result = revenue_total + income_total - salary_total - spending_total;
%>
 
<br>
<b>損益試算</b>
<blockquote> 

<form action="showBalance.jsp" method="post">
<table>
 
	 <tr>
	  	<td>
            <select name="t" size=1 onchange="this.form.submit();"><%
            Calendar c = Calendar.getInstance();
            c.setTime(end);
            int i = 0;
            String curmonstr = sdf.format(cur);
            for (Date d=c.getTime(); d.compareTo(start)>=0; c.add(Calendar.MONTH, -1),d=c.getTime()) {
                String mstr = sdf.format(d);
              %><option value="<%=mstr%>" <%=(mstr.equals(curmonstr)?"selected":"")%>><%=mstr%></option>
              <%
            }
          %></select>
		</tD>
 
		<td>
			<input type=submit value="查詢">
		</td>
	</tr>
</table> 
</form>
</blockquote>
 

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
			
<blockquote>

	<table width="85%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#f0f0f0 class=es02>
			<td width=100 colspan=2></td>
			<td  width=88 >應收金額</tD>		
			<td  width=88 >實收金額</tD>	
			<td  width=88 >未收金額</td>	
			<td></tD>
		</tr>		
		<tr bgcolor=#f0f0f0 class=es02>
			<td width=50></td>		
			<td width=50>
				學費收入
			</td> 
			<td bgcolor=#ffffff align=right><font class=es02><%=mnf.format(revenue_total)%></font></td>		
			<td bgcolor=#ffffff align=right><font class=es02><%=mnf.format(revenue_received)%></font></td>
			<td bgcolor=#ffffff align=right><%=mnf.format(revenue_total-revenue_received)%></font></td>	
			<td width=150  bgcolor=#ffffff>			
			<a href=searchbillrecord.jsp?month=<%=sdf.format(curMonthStart)%>&type=0><img src="pic/list.gif" border=0>詳細名單</a> |
			<a href=billrecord_chart.jsp?month=<%=sdf2.format(curMonthStart)%>&type=0><img src="pic/char.gif" border=0>統計報表</a>
			
			</td>
		</tr> 
		<tr bgcolor=#f0f0f0 class=es02>
			<td></td>
			<td>雜費收入</tD>
			<td bgcolor=#ffffff align=right>
				<font class=es02><%=mnf.format(income_total)%></font>
			</td>		
			<td  bgcolor=#ffffff align=right>
				<font class=es02><%=mnf.format(income_received)%></font>
			</td>		
			<td  bgcolor=#ffffff align=right>
				<%=mnf.format(income_total-income_received)%></font>
			</td>		
	        <td width=150  bgcolor=#ffffff>	
			<a href="listCostbook.jsp?type=0&trader=0&vstatus=99&attachstatus=0&logId=0&startDate=<%=sdf3.format(curMonthStart)%>&endDate=<%=sdf3.format(curMonthEnd)%>"><img src="pic/list.gif" border=0>詳細內容</a> |   			
			<a href="CostbookReport.jsp?type=0&trader=0&logId=0&startDate=<%=sdf3.format(curMonthStart)%>&endDate=<%=sdf3.format(curMonthEnd)%>"><img src="pic/lane.gif" border=0>統計報表</a>
			</td>
		</tr>
		<tr bgcolor=#f0f0f0 class=es02>
			<td colspan=2>
				收入總和 (A)
			</td>
			<td bgcolor=#ffffff align=right>
				<font color=blue><%=mnf.format(revenue_total+income_total)%></font>
			</tD> 
			<td bgcolor=#ffffff align=right>
				<font color=blue><%=mnf.format(revenue_received+income_received)%></font>
			</tD>  
			<td bgcolor=#ffffff align=right>
				<font color=blue><%=mnf.format(revenue_total-revenue_received+income_total-income_received)%></font>
			</tD> 
			<td  bgcolor=#ffffff></td>

		</tr>
		
		<tr bgcolor=#f0f0f0 class=es02>
			<td colspan=2></td>
			<td>應付金額</tD>		
			<td>已付金額</tD>	
			<td>未付金額</td>	
			<td></td>
		</tr>		
		<tr bgcolor=#f0f0f0 class=es02>
			<td></td>		
			<td>
				薪資
			</td> 
			<td bgcolor=#ffffff  align=right> 
				<font class=es02><%=mnf.format(salary_total)%></font>
			</td>		
			<td bgcolor=#ffffff  align=right> 
				<%=mnf.format(salary_paid)%>
			</td>		
			<td bgcolor=#ffffff  align=right> 
				<%=mnf.format(salary_total-salary_paid)%>
			</td>		
			<td bgcolor=#ffffff>
			<a href=searchsalaryrecord.jsp?month=<%=sdf.format(curMonthStart)%>&type=0><img src="pic/list.gif" border=0>詳細名單</a> |
			<a href=salaryrecord_chart.jsp?month=<%=sdf2.format(curMonthStart)%>&type=0><img src="pic/char.gif" border=0>統計報表</a>
            </td>
		</tr> 
		<tr bgcolor=#f0f0f0 class=es02>
			<td></td>
			<td>雜費支出</tD>
			<td bgcolor=#ffffff  align=right> 
				<font class=es02><%=mnf.format(spending_total)%></font>
			</td>		
			<td bgcolor=#ffffff  align=right> 
				<font class=es02><%=mnf.format(spending_paid)%></font>
			</td>		
			<td bgcolor=#ffffff  align=right> 
				<font class=es02><%=mnf.format(spending_total-spending_paid)%></font>
			</td>		
			<td bgcolor=#ffffff>
				<a href="listCostbook.jsp?type=1&trader=0&vstatus=99&attachstatus=0&logId=0&startDate=<%=sdf3.format(curMonthStart)%>&endDate=<%=sdf3.format(curMonthEnd)%>"><img src="pic/list.gif" border=0>詳細報表 |
				<a href="CostbookReport.jsp?type=1&trader=0&logId=0&startDate=<%=sdf3.format(curMonthStart)%>&endDate=<%=sdf3.format(curMonthEnd)%>"><img src="pic/lane.gif" border=0>統計報表</a>
			</td>
			
		</tr>
		<tr bgcolor=#f0f0f0 class=es02>
			<td colspan=2>支出總和 (B)</td>
			<td bgcolor=#ffffff align=right>
				<font color=blue><%=mnf.format(salary_total+spending_total)%></font>
			</tD> 
			<td bgcolor=#ffffff align=right>
				<font color=blue><%=mnf.format(salary_paid+spending_paid)%></font>
			</tD>  
			<td bgcolor=#ffffff align=right>
				<font color=blue><%=mnf.format(salary_total-salary_paid+spending_total-spending_paid)%></font>
			</tD> 
			<td  bgcolor=#ffffff></td>
		</tr>		
		<tr class=es02>
			<td colspan=2>合計 (A-B)</tD>
			<td align=right>
				<b><%=mnf.format((revenue_total+income_total)-(salary_total+spending_total))%></b>
			</tD>
			<td align=right>
				<b><%=mnf.format((revenue_received+income_received)-(salary_paid+spending_paid))%></b>
			</tD> 
			<td align=right>
				<b><%=mnf.format((revenue_total-revenue_received+income_total-income_received)-(salary_total-salary_paid+spending_total-spending_paid))%></b>
			</tD>

		</tr>			
	</table>		
	
	</tD>
	</tr>
	</table> 
	<a href="print_income_statement.jsp?t=<%=sdf.format(cur)%>"><img src="pic/pdf.gif" border=0>輸出電子報表</a>		
</blockquote>
 

<%@ include file="bottom.jsp"%>	
