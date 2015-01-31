<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,jsi.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=2;
    int leftMenu=0;
%>
<%@ include file="topMenuAdvanced.jsp"%>
<%
    if(ud2.getUserRole()>=4){
        //response.sendRedirect("spending_list.jsp");
		out.println("<script>location.href='spending_list.jsp';</script>");
		return;
    }
%>
<%@ include file="leftMenu2-new.jsp"%>
<%
if(checkAuth(ud2,authHa,501))
{
%>
    <%@ include file="freportIndex.jsp"%>
<%
}else{   //501

	JsfAdmin ja=JsfAdmin.getInstance();
	JsfPay jp=JsfPay.getInstance(); 
	
	//SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
  	DecimalFormat mnf2 = new DecimalFormat("###,###,##0");
    
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM");
	SimpleDateFormat sdf2=new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat sdf3=new SimpleDateFormat("yyyy/MM/dd");

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

System.out.println("#### " + sdf2.format(curMonthStart) + " " + sdf2.format(nextMonthStart) + " " + sdf2.format(prevMonthStart));

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

    String startStr = sdf3.format(curMonthStart);
    String endStr = sdf3.format(curMonthEnd);
%>
<br>
<TABLE width=300>
    <TR class=es02>
        <td width=100>
            <b>&nbsp;&nbsp;&nbsp;雜費統計</b>
        </td>
	
<form action="" method="get">
        <td width=80 align=right>
            <b>查詢月份:</b>
        </td>
        <td width=80>
            <select name="t" size=1 onchange="this.form.submit();"><%
            Calendar c = Calendar.getInstance();
            c.setTime(end);
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
</form>
    </tr>
</table>       


<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<blockquote>
<%
    if(checkAuth(ud2,authHa,201)){
%>
<div class=es02>
&nbsp;&nbsp;<!--<a href="spending_add.jsp?type=0"><img src="pic/costAdd.png" border=0>&nbsp;新增支出</a>
|--> <a href="spending_add.jsp?type=1"><img src="pic/incomeAdd.png" border=0>&nbsp;新增收入</a>
</div>
<%  }   %>
<br>
	<table width="60%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#f0f0f0 class=es02>
			<td></tD>
			<td  width=88 nowrap>應收/應付金額</tD>		
			<td  width=88 nowrap>實收/實付金額</tD>	
			<td  width=88 nowrap>未收/未付金額</td>	
			<td></tD>
 
			
		</tr>	
		
		<tr bgcolor=#f0f0f0 class=es02>
			
			<td nowrap><img src="pic/costOut.png" border=0>&nbsp;<font color=red>雜費支出</font></tD>
			<td bgcolor=#ffffff  align=right> 
				<a href="spending_list.jsp?type=0&start=<%=java.net.URLEncoder.encode(startStr)%>&end=<%=java.net.URLEncoder.encode(endStr)%>"><%=mnf2.format(spending_total)%></a>
			</td>		
			<td bgcolor=#ffffff  align=right> 
				<a href="spending_list.jsp?type=0&start=<%=java.net.URLEncoder.encode(startStr)%>&end=<%=java.net.URLEncoder.encode(endStr)%>&paidstatus=2"><%=mnf2.format(spending_paid)%></a>
			</td>		
			<td bgcolor=#ffffff  align=right> 
				<a href="spending_list.jsp?type=0&start=<%=java.net.URLEncoder.encode(startStr)%>&end=<%=java.net.URLEncoder.encode(endStr)%>"><%=mnf2.format(spending_total-spending_paid)%></a>
			</td>		
			<td bgcolor=#ffffff  align=center nowrap>

                <a href="spending_analysis.jsp?type=0&start=<%=startStr%>&end=<%=endStr%>"><img src="pic/lane.gif" border=0>&nbsp;統計報表</a>  
			</td>
			
		</tr>
	
		<tr bgcolor=#f0f0f0 class=es02>
			
			<td nowrap><img src="pic/costIn.png" border=0>&nbsp;<font color=blue>雜費收入</font></tD>
			<td bgcolor=#ffffff align=right>
				<a href="spending_list.jsp?type=1&start=<%=java.net.URLEncoder.encode(startStr)%>&end=<%=java.net.URLEncoder.encode(endStr)%>"><%=mnf2.format(income_total)%></a>
			</td>		
			<td  bgcolor=#ffffff align=right>
				<a href="spending_list.jsp?type=1&start=<%=java.net.URLEncoder.encode(startStr)%>&end=<%=java.net.URLEncoder.encode(endStr)%>&paidstatus=2"><%=mnf2.format(income_received)%></a>
			</td>		
			<td  bgcolor=#ffffff align=right>
				<a href="spending_list.jsp?type=1&start=<%=java.net.URLEncoder.encode(startStr)%>&end=<%=java.net.URLEncoder.encode(endStr)%>"><%=mnf2.format(income_total-income_received)%></a>
			</td>		
			
			
			<td bgcolor=#ffffff align=center nowrap> 

                <a href="spending_analysis.jsp?type=1&start=<%=startStr%>&end=<%=endStr%>"><img src="pic/lane.gif" border=0>&nbsp;統計報表</a>  
			</td>
		</tr>

	
	</table>		
	
	</tD>
	</tr>
	</table>
</blockquote>

<%
    if(ud2.getUserRole() !=1)
    {
        Userlog[] uls=ja.getUserlogById(ud2.getId()); 
        
        Date beforeDate=null;
        
        if(uls.length<2) 
        {
            beforeDate = uls[0].getUserlogDate() ;
        }else{
            beforeDate = uls[1].getUserlogDate() ;
        }
%>
<script>
    
    function showForm(az1){

        var e=document.getElementById(az1);
        if(!e)return true;

        if(e.style.display=="none"){
            e.style.display="block"
        } else {
            e.style.display="none"
        }
        return true;
    }
</script> 
<br>
<b>&nbsp;&nbsp;&nbsp;雜費<font color=blue><%=sdf3.format(beforeDate)%></b></font>&nbsp;至&nbsp;<font color=blue><b><%=sdf3.format(new Date())%></b></font> 變動記錄<br> 
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<blockquote>
<%
String backurl="incomeIndex.jsp";
%>
<%@ include file="vitemBeforeDate.jsp"%>
<%@ include file="insidetradeBeforeDate.jsp"%>

</blockquote>

<%
    }
%>
</blockquote>

<%
}  //and auth 501
%>
<%@ include file="bottom.jsp"%>