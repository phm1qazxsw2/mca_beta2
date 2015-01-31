<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%!
    public String getUserName(int uid, Map<Integer,Vector<User>> userMap)
    {
        Vector<User> vu = userMap.get(new Integer(uid));
        if (vu==null)
            return "###";

        if(vu.get(0).getUserFullname().length()>0)
            return vu.get(0).getUserFullname();
        else
            return vu.get(0).getUserLoginId();
    }

%>
<%
    //##v2
    if(!checkAuth(ud2,authHa,302))
    {
        response.sendRedirect("authIndex.jsp?code=302");
    }

    int pid = Integer.parseInt(request.getParameter("pid"));
    BillPayInfo bpay = BillPayInfoMgr.getInstance().find("billpay.id=" + pid);

    ArrayList<BillPaidInfo> paid_entries = 
        BillPaidInfoMgr.getInstance().retrieveList("billpay.id=" + pid, "");

    String ticketIds = new RangeMaker().makeRange(paid_entries, "getTicketId");

    ArrayList<MembrInfoBillRecord> salaries = 
        MembrInfoBillRecordMgr.getInstance().retrieveList("ticketId in (" + ticketIds + ")", "");

    Map<String, Vector<MembrInfoBillRecord>> salaryMap = 
        new SortingMap(salaries).doSort("getTicketId");

    Iterator<BillPaidInfo> iter = paid_entries.iterator();

    Costpay2 cp = Costpay2Mgr.getInstance().find("costpayFeePayFeeID=" + Costpay2.COSPAY_TYPE_SALARY + 
        " and costpayStudentAccountId=" + bpay.getId());

    if (cp==null) {
     %><blockquote>舊系統資料,無法顯示</blockquote><%
        return;
    }

    String acctName = "";
    if (bpay.getVia()==BillPay.SALARY_CASH) {
        Tradeaccount ta = (Tradeaccount) ObjectService.find("jsf.Tradeaccount", "id=" + cp.getCostpayAccountId());
        acctName = ta.getTradeaccountName();
    }
    else if (bpay.getVia()==BillPay.SALARY_WIRE) {
        BankAccount ba = (BankAccount) ObjectService.find("jsf.BankAccount", "id=" + cp.getCostpayAccountId());
        acctName = ba.getBankAccountName();
    }

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy/MM");
    DecimalFormat mnf = new DecimalFormat("###,###,##0");
    int total = (int)0;

    Object[] users2 = UserMgr.getInstance().retrieve("", "");
    Map<Integer, Vector<User>> userMap = new SortingMap().doSort(users2, new ArrayList<User>(), "getId");
%>
	
<b>&nbsp;&nbsp;&nbsp;&nbsp;薪資付款記錄</b> 
<br>
<br>

<center>
<table width="96%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
	
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
		<td>登入日期</td>
        <td>帳戶</td>
        <td>支出</td>
        <td>存入</td>
        <td>小計</td>
        <td>登入人</td>
        <td>備註</td>
	</tr>

    <tr bgcolor=#ffffff class=es02>		
        <td><%=sdf.format(bpay.getRecordTime())%></td>
        <td>
            <img src="pic/salaryOut.png"> 薪資付款-<%  
            if (bpay.getVia()==BillPay.SALARY_CASH)
                out.println("現金");
            else if (bpay.getVia()==BillPay.SALARY_WIRE)
                out.println("匯款");
            else if (bpay.getVia()==BillPay.VIA_CHECK)
                out.println("支票");
            else
                out.println("其他");
            out.println("(" + acctName + ")");
            %>
        </td>	
        <td align=right><%=mnf.format(bpay.getAmount())%></td>
        <td align=right></td>
        <td align=right><b><%=mnf.format(bpay.getAmount())%></b></td>
        <td><%=getUserName(bpay.getUserId(), userMap)%></td>  
        <td>
        </td>		
    </tr>	
<% 
    int sub_total = bpay.getAmount();
    while(iter.hasNext()) {
        BillPaidInfo b = iter.next(); 
        sub_total -= b.getPaidAmount();
%>
    <tr bgcolor=#ffffff class=es02>		
        <td><%=sdf.format(b.getPaidTime())%></td>
        <td>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            薪資沖帳<br>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            銷帳流水號:<%=b.getTicketId()%>
        </td>	
        <td></td>
        <td align=right><%=mnf.format(b.getPaidAmount())%></td>
        <td align=right><b><%=sub_total%></b></td>
        <td><%=getUserName(b.getUserId(), userMap)%></td>  
        <td><%
            MembrInfoBillRecord s = salaryMap.get(b.getTicketId()).get(0);
            out.println(sdf2.format(s.getBillMonth()) + " " + s.getMembrName() + "薪資");
        %></td>
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
<br>
<br>
