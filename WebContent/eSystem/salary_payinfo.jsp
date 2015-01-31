<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=5;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%
    if(!checkAuth(ud2,authHa,302))
    {
        response.sendRedirect("authIndex.jsp?code=302");
    }
%>
<%@ include file="leftMenu5.jsp"%>
<%
    //##v2

    DecimalFormat mnf = new DecimalFormat("###,###,##0");
    ArrayList<BillPayInfo> payhistory = BillPayInfoMgr.getInstance().retrieveListX("via>=100 and amount>0", 
        "order by recordTime desc limit 50", _ws.getBunitSpace("billpay.bunitId"));

    _ws.setBookmark(ud2, "薪資付款記錄");

    if (payhistory.size()==0) {
      %><br><blockquote>目前沒有付款記錄</blockquote><%
          return;
    }

    String payIds = new RangeMaker().makeRange(payhistory, "getId");

    // 找是否有比 user 還高的權限才能看得付款記錄
    ArrayList<BillPaidInfo> retrictedPaidHistory = BillPaidInfoMgr.getInstance().
        retrieveList("billPayId in (" + payIds + ") and privLevel<" + ud2.getUserRole(), "limit 300");

    Map<Integer/*billPayId*/, Vector<BillPaidInfo>> restrictedPaidMap = 
        new SortingMap(retrictedPaidHistory).doSort("getBillPayId");

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");

    Object[] objs = TradeaccountMgr.getInstance().retrieveX("","", _ws.getBunitSpace("bunitId"));    
    Map<Integer, Vector<Tradeaccount>> tradeMap = 
        new SortingMap().doSort(objs, new ArrayList<Tradeaccount>(), "getId");

    objs = BankAccountMgr.getInstance().retrieveX("","", _ws.getBunitSpace("bunitId"));    
    Map<Integer, Vector<BankAccount>> bankMap = 
        new SortingMap().doSort(objs, new ArrayList<BankAccount>(), "getId");

    ArrayList<Costpay2> salaryCostpays = Costpay2Mgr.getInstance().
        retrieveListX("costpayFeePayFeeID=" + Costpay2.COSPAY_TYPE_SALARY, "",_ws.getBunitSpace("bunitId"));

    Map<Integer/*billPayId*/, Vector<Costpay2>> costpayMap = 
        new SortingMap(salaryCostpays).doSort("getCostpayStudentAccountId");

    EzCountingService ezsvc = EzCountingService.getInstance();


%>
<script>
function do_delete(payId)
{
    if (confirm('確定刪除此筆付款記錄?'))
        location.href = "salary_pay_delete.jsp?pid=" + payId;    
}
</script>
<body>
<br>
<b>&nbsp;&nbsp;&nbsp;薪資支付明細</b>
 <table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  

<blockquote>

<table width="" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
  
  <table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#ffffff align=left valign=middle>
        <td bgcolor=#f0f0f0 class=es02 width=100 align=middle>付款時間</td>
        <td bgcolor=#f0f0f0 class=es02 align=middle width=50>付款方式</td>
        <td bgcolor=#f0f0f0 class=es02 align=middle width=50>金額</td>
        <td bgcolor=#f0f0f0 class=es02 width=100 nowrap>轉出帳戶</td>
        <td bgcolor=#f0f0f0 class=es02 align=middle width=40>登入人</td>
        <td bgcolor=#f0f0f0 class=es02 align=middle width=60>匯款日期</td>
        <td bgcolor=#f0f0f0 class=es02></td>
    </tr>
<%
    Iterator<BillPayInfo> iter = payhistory.iterator();
    int i = 0;
    while (iter.hasNext()) {
        BillPayInfo payinfo = iter.next();
        if (restrictedPaidMap.get(new Integer(payinfo.getId()))!=null) {
            System.out.println("## restricted paying record");
            continue;
        }
        i ++;
  %><tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
        <td class=es02><%=sdf.format(payinfo.getRecordTime())%></td>
        <td class=es02 align=right><%
            if (payinfo.getVia()==BillPay.SALARY_CASH) out.println("現金");
            else if (payinfo.getVia()==BillPay.SALARY_WIRE) out.println("匯款");
            else if (payinfo.getVia()==BillPay.SALARY_CHECK) out.println("支票"); 
            else out.println("其他");
      %>&nbsp;&nbsp;&nbsp;</td>
        <td class=es02 align=right><%=mnf.format(payinfo.getAmount())%></td>
        <td class=es02 nowrap><%=getAccountName(payinfo, tradeMap, bankMap, costpayMap)%></td>
        <td class=es02 align=middle><%=ezsvc.getUserName(payinfo.getUserId())%></td>
        <td class=es02 align=right>     
        <%
            if(payinfo.getExportDate()>0){
                out.println(sdf.format(payinfo.getExportDate()));
            }
        %>    
        </td>
        <td class=es02 nowrap>
            <a href="javascript:openwindow_phm('salary_paydetail.jsp?pid=<%=payinfo.getId()%>','薪資支付歷史',800,500,false);">內容</a> 
      <%  if (payinfo.getVia()==BillPay.SALARY_WIRE) { %>
            | <a href="javascript:openwindow_phm('pre_salary_excel.jsp?pid=<%=payinfo.getId()%>','匯款名單Excel檔',600,400,true)"><% if (payinfo.getExportDate()<=0){%><img src="pic/star2.png" border=0>&nbsp;<%}else{ out.println("&nbsp;&nbsp;&nbsp;");}%>匯款名單Excel檔</a>
      <%  } %>
          |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="javascript:do_delete(<%=payinfo.getId()%>)">刪除</a>
        </td>
    </tr><%
    }
%>
  </table>

</td>
</tr>
</table>
<br>
<div class=es02>
    說明: <img src="pic/star2.png" border=0> 為尚未產生匯款名單excel檔的明細.
</div>
<%
    if (i==0) {
        out.println("<br><br>目前沒有付款記錄");
    }
%>

</blockquote>
<br>
<br>
<br>
<%@ include file="bottom.jsp"%>	
</body>


<%!
    String getAccountName(BillPayInfo payinfo, 
        Map<Integer, Vector<Tradeaccount>> tradeMap,
        Map<Integer, Vector<BankAccount>> bankMap, 
        Map<Integer/*billPayId*/, Vector<Costpay2>> costpayMap)
    {
        Integer payId = new Integer(payinfo.getId());
        Vector<Costpay2> vc = costpayMap.get(payId);
        String ret = "##";
        if (payinfo.getVia()==BillPay.SALARY_CASH) {
            try {
                Costpay2 cp = vc.get(0);
                Tradeaccount t = tradeMap.get(new Integer(cp.getCostpayAccountId())).get(0);
                ret = t.getTradeaccountName();
            } 
            catch (Exception e) {
                ret = "零用金帳戶";
            }
        }
        else if (payinfo.getVia()==BillPay.SALARY_WIRE) {
            try {
                Costpay2 cp = vc.get(0);
                BankAccount b = bankMap.get(new Integer(cp.getCostpayAccountId())).get(0);
                ret = b.getBankAccountName();
            } catch (Exception e) {
                ret = "銀行帳戶";
            }
        }      
        return ret;
    }
%>

