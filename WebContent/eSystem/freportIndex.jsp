<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,java.io.*,jsi.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<%
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM");
	SimpleDateFormat sdf2=new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat sdf3=new SimpleDateFormat("yyyy/MM/dd");
    DecimalFormat mnf = new DecimalFormat("###,###,##0");

    CostpayMgr cpmgr = CostpayMgr.getInstance();
    MembrInfoBillRecordMgr mbrmgr = MembrInfoBillRecordMgr.getInstance();

    Date start = new Date();
    Date end = new Date();
    if (cpmgr.numOfRowsX("", _ws.getBunitSpace("bunitId"))>0) {
        Object[] objs = cpmgr.retrieveX("", "order by id asc limit 1", _ws.getBunitSpace("bunitId"));
        Costpay first = (Costpay) objs[0];
        objs = cpmgr.retrieveX("", "order by id desc limit 1", _ws.getBunitSpace("bunitId"));
        Costpay last = (Costpay) objs[0];
        start = first.getCostpayDate();
        end = last.getCostpayDate();
    }
    if (mbrmgr.numOfRowsX("", _ws.getBunitSpace("bill.bunitId"))>0) {
        ArrayList<MembrInfoBillRecord> objs = mbrmgr.retrieveListX("", "order by ticketId asc limit 1", _ws.getBunitSpace("bill.bunitId"));
        MembrInfoBillRecord first = objs.get(0);
        objs = mbrmgr.retrieveListX("", "order by ticketId desc limit 1", _ws.getBunitSpace("bill.bunitId"));
        MembrInfoBillRecord last = objs.get(0);
        if (first.getBillMonth().compareTo(start)<0)
            start = first.getBillMonth();
        if (last.getBillMonth().compareTo(end)>0)
            end = last.getBillMonth();
    }
    Date cur = end;
    String monstr = request.getParameter("t");
    if (monstr!=null) {
        cur = sdf.parse(monstr);
    }
    
    EzCountingService ezsvc = EzCountingService.getInstance();

    Calendar cal = Calendar.getInstance();
    Date curMonthStart = sdf.parse(sdf.format(cur));
    cal.setTime(curMonthStart);
    cal.add(Calendar.MONTH, 1);
    Date nextMonthStart = cal.getTime();
    cal.add(Calendar.DATE, -1);
    Date curMonthEnd = cal.getTime();
    cal.add(Calendar.DATE, 1);
    cal.add(Calendar.MONTH, -2);
    Date prevMonthStart = sdf.parse(sdf.format(cal.getTime()));

//out.println("#### " + sdf2.format(curMonthStart) + " " + sdf2.format(nextMonthStart));

    int[] numbers = new int[8]; // 
    ArrayList<MembrInfoBillRecord> bills = new ArrayList<MembrInfoBillRecord>();
    ArrayList<MembrInfoBillRecord> salaries = new ArrayList<MembrInfoBillRecord>();
    ArrayList<Vitem> income = new ArrayList<Vitem>();
    ArrayList<Vitem> cost = new ArrayList<Vitem>();
    ezsvc.getMonthlyNumbers(_ws.getSessionBunitId(), 
        numbers, curMonthStart, nextMonthStart, bills, salaries, income, cost);
    int income_total = numbers[0];
    int income_received = numbers[1];
    int spending_total = numbers[2];
    int spending_paid = numbers[3];
    int revenue_total = numbers[4];
    int revenue_received = numbers[5];
    int salary_total = numbers[6];
    int salary_paid = numbers[7];
    int this_result = revenue_total + income_total - salary_total - spending_total;

    int[] last_numbers = new int[8];
    bills = new ArrayList<MembrInfoBillRecord>();
    salaries = new ArrayList<MembrInfoBillRecord>();
    income = new ArrayList<Vitem>();
    cost = new ArrayList<Vitem>();
    ezsvc.getMonthlyNumbers(_ws.getSessionBunitId(),
        last_numbers, prevMonthStart, curMonthStart, bills, salaries, income, cost);
    int last_income_total = last_numbers[0];
    int last_income_received = last_numbers[1];
    int last_spending_total = last_numbers[2];
    int last_spending_paid = last_numbers[3];
    int last_revenue_total = last_numbers[4];
    int last_revenue_received = last_numbers[5];
    int last_salary_total = last_numbers[6];
    int last_salary_paid = last_numbers[7];
    int last_result = last_revenue_total + last_income_total - last_salary_total - last_spending_total;

    Date runDate = new Date();
    Date now = new Date();

	SimpleDateFormat sdfShow1=new SimpleDateFormat("yyyy/MM/01");
	SimpleDateFormat sdfShow2=new SimpleDateFormat("yyyy/MM/dd");		
	SimpleDateFormat sdfShow3=new SimpleDateFormat("yyyy/MM");	
%>
<br>
<TABLE width=300>
    <TR class=es02>
        <td width=100>
            <b>&nbsp;&nbsp;&nbsp;損益試算</b>
        </td>
        
<form action="" method="get">
        <td width=80 align=right>
            <b>查詢月份:</b>
        </td>
        <td width=80>
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
        </td>
        <tD width=40>
            <input type=submit value="確認">    
        </td>
</form>
    </tr>
    </table>       

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>


<BR>
<blockquote>
	<table height=250 width=660> 
		<tr>
			<td width=220 height=250>
		 
				<table border=0 leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" width=210 height=225 background="pic/income.gif">
					<tr>
						<td height=23 colspan=3>
						</tD> 
					</tr>
					<tr height=30>
						<td width=36></td>
						<tD colspan=2 class=es02 width=174>
						<font color=white><%=sdfShow1.format(curMonthStart)%>-<%=sdfShow2.format(curMonthEnd)%></font>
					</tD>
					</tR>		
					
					<tr>
						<td height=10 class=es02 colspan=2>
							<font color=blue>&nbsp;&nbsp;本月學費收入
						</tD>  
						<tD align=right class=es02 valign=top><a href="searchbillrecord.jsp?month=<%=sdf.format(curMonthStart)%>"><font color=blue><%=mnf.format(revenue_total)%></font></a>&nbsp;&nbsp;&nbsp;</td>		
				</tr>
					<tr class=es02>
						<td height=10>
					</tD>
						<td>已收現金</tD> 
						<tD align=right><%=mnf.format(revenue_received)%>&nbsp;&nbsp;&nbsp;</td>		
					</tr>
					<tr class=es02>
						<td height=10>
					</tD>
						<td>應收學費</tD> 
						<tD align=right><%=mnf.format(revenue_total-revenue_received)%>&nbsp;&nbsp;&nbsp;</td>		
					</tr>
					
					<tr>
						<td height=10 class=es02 colspan=2>
							<font color=blue>&nbsp;&nbsp;本月雜費收入
						</tD>
						<tD align=right class=es02>
						<a href="spending_list.jsp?type=1&start=<%=java.net.URLEncoder.encode(sdf3.format(curMonthStart))%>&end=<%=java.net.URLEncoder.encode(sdf3.format(curMonthEnd))%>"><font color=blue><%=mnf.format(income_total)%></font></a>&nbsp;&nbsp;&nbsp;</td>		
					</tr> 
					<tr class=es02>
						<td height=10>
						</tD>
						<td>已收現金</tD> 
						<tD align=right><%=mnf.format(income_received)%>&nbsp;&nbsp;&nbsp;</td>		
					</tr>
					<tr class=es02>
						<td height=10>
						</tD>
						<td>應收雜費</tD> 
						<tD align=right><%=mnf.format(income_total-income_received)%>&nbsp;&nbsp;&nbsp;</td>
					</tr>
					<tr> 
						<td colspan=3 height=4 align=middle> 
						<table width="90%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table>
						</tD>
					</tr>  
					<tr>
						<td height=10 class=es02 colspan=2>
							<font color=black>&nbsp;&nbsp;<b>收入合計</b>
						</tD>
						<tD align=right class=es02><b><font color=black><%=mnf.format(revenue_total+income_total)%></font></b>&nbsp;&nbsp;&nbsp;</td>		
					</tr> 
	
				<tr>
						<td colspan=3 height=21>  
												
						
						</tD>
					</tr>
				</table>

		</tD>
		<td width=220 height=250>
				<table border=0 leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" width=210 height=225 background="pic/cost.gif">
					<tr>
						<td height=23 colspan=3>
						</tD> 
					</tr>
					<tr height=30>
						<td width=36></td>
						<tD colspan=2 class=es02 width=174>
						<font color=white><%=sdfShow1.format(curMonthStart)%>-<%=sdfShow2.format(curMonthEnd)%></font>
					</tD>
					</tR>		
					
					<tr>
						<td height=10 class=es02 colspan=2>
							<font color=red>&nbsp;&nbsp;本月薪資支出
						</tD>
 
 
						<tD align=right class=es02>
						<a href="searchsalaryrecord.jsp?month=<%=sdf.format(curMonthStart)%>"><font color=red><%=mnf.format(salary_total)%></font></a>&nbsp;&nbsp;&nbsp;</td>		
				</tr>
					<tr class=es02>
						<td height=10>
					</tD>
						<td>已付現金</tD> 
						<tD align=right><%=mnf.format(salary_paid)%>&nbsp;&nbsp;&nbsp;</td>		
					</tr>
					<tr class=es02>
						<td height=10>
					</tD>
						<td>應付薪資</tD> 
						<tD align=right><%=mnf.format(salary_total-salary_paid)%>&nbsp;&nbsp;&nbsp;</td>		
					</tr>
					
					<tr>
						<td height=10 class=es02 colspan=2>
							<font color=red>&nbsp;&nbsp;本月雜費支出
						</tD>
						<tD align=right class=es02>
							<a href="spending_list.jsp?type=0&start=<%=java.net.URLEncoder.encode(sdf3.format(curMonthStart))%>&end=<%=java.net.URLEncoder.encode(sdf3.format(curMonthEnd))%>"><font color=red><%=mnf.format(spending_total)%></font></a>&nbsp;&nbsp;&nbsp;
						</td>		
					</tr> 
					<tr class=es02>
						<td height=10>
						</tD>
						<td>已付現金</tD> 
						<tD align=right><%=mnf.format(spending_paid)%>&nbsp;&nbsp;&nbsp;</td>		
					</tr>
					<tr class=es02>
						<td height=10>
						</tD>
						<td>應付雜費</tD> 
						<tD align=right><%=mnf.format(spending_total-spending_paid)%>&nbsp;&nbsp;&nbsp;</td>
					</tr>
					<tr> 
						<td colspan=3 height=4 align=middle> 
						<table width="90%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table>
						</tD>
					</tr>
 
 
					<tr>
						<td height=10 class=es02 colspan=2>
							<font color=black>&nbsp;&nbsp;<b>支出合計</b>
						</tD>
						<tD align=right class=es02><b><font color=black><%=mnf.format(salary_total+spending_total)%></font></b>&nbsp;&nbsp;&nbsp;</td>		
					</tr> 
	
					<tr>
						<td colspan=3 height=21>  
						</tD>
					</tr>
				</table>

		
		</td>
		<td width=220 height=250> 
			 	 <table border=0 leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" width=210 height=225 background="pic/balance.gif">
					<tr>
						<td height=23 colspan=3>
						</tD> 
					</tr>
					<tr height=30>
						<td width="36"></td>
						<td colspan=2 class=es02 align=left>
							<font color=white>月份: <%=sdfShow3.format(cur)%></font>
						</tD>
					</tR>		
					
					<tr>
						<td height=10 class=es02 width=110 colspan=2 nowrap> 
							<font color=black>&nbsp;&nbsp;<b>本月損益試算</b>
						</tD>
						<tD align=right width=100 class=es02><b><font color=black><%=mnf.format(this_result)%></font></b>&nbsp;&nbsp;&nbsp;</td>		
					</tr>
					
					<tr> 
						<td colspan=3 height=4 align=middle> 
						<table width="90%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
						</tD>
					</tr>
					<tr>
						<td height=10 class=es02 colspan=2>
							&nbsp;&nbsp;上月結餘
						</tD>
						<tD align=right width=120 class=es02><%=mnf.format(last_result)%>&nbsp;&nbsp;&nbsp;</td>		
					</tr>
				

					<tr>
						<td height=10 colspan=2  class=es02> 
						
							&nbsp;&nbsp;<font color=black>預計成長金額</font>
						</tD>
						<tD align=right width=120 class=es02>
							<font color=black><%=mnf.format(this_result-last_result)%></font>&nbsp;&nbsp;&nbsp;</td>		
					</tr>

 

					<tr>
						<td colspan=3 height=98>  
						
						</tD>
					</tr>
				</table>

		</tD>
	</tr>
	</table>			

    <div class=es02 align=right>
    	<a href="print_income_statement.jsp?t=<%=sdf.format(cur)%>" target="_blank"><img src="pic/pdf.gif" border=0>&nbsp;輸出電子報表</a>		
        |
        <a href="incomeAnalyze.jsp">跨月的損益統計</a> 
        <!-- |<a target=_blank href="print_income_statement_2008.jsp">2008年 損益統計報表</a>  -->
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    </div>
</blockquote>
