<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%

    int sid = Integer.parseInt(request.getParameter("sid"));
    WebSecurity _ws_ = WebSecurity.getInstance(pageContext);
    Membr membr = MembrMgr.getInstance().findX("id=" + sid, _ws_.getStudentBunitSpace("bunitId"));

    if (membr==null) {
        %><script>alert("資料不存在");history.go(-1)</script><%
        return;
    }

    ArrayList<BillPayInfo> history = BillPayInfoMgr.getInstance().retrieveList("billpay.membrId=" + sid, "");
    Iterator<BillPayInfo> iter = history.iterator();
    SimpleDateFormat sdfPay = new SimpleDateFormat("yyyy/MM/dd");
    DecimalFormat mnf = new DecimalFormat("###,###,##0");

    Map<Integer, Vector<BillPaidInfo>> paidmap = new HashMap<Integer, Vector<BillPaidInfo>>();
    if (history.size()>0) {
        String billPayIds = new RangeMaker().makeRange(history, "getId");
        ArrayList<BillPaidInfo> paidhistory = BillPaidInfoMgr.getInstance().
            retrieveList("billPayId in (" + billPayIds + ")", "");
        paidmap = new SortingMap(paidhistory).doSort("getBillPayId");
    }
    int total = (int)0;

    Object[] users2 = UserMgr.getInstance().retrieve("", "");
    Map<Integer, Vector<User>> userMap = new SortingMap().doSort(users2, new ArrayList<User>(), "getId");
%>
<script>
function do_delete(payId)
{
    if (confirm('確定刪除此筆收款記錄?'))
        location.href = "payinfo_delete.jsp?pid=" + payId + "&backurl=<%=java.net.URLEncoder.encode(backurl2)%>";
}
</script>	
<b>&nbsp;&nbsp;<font color=blue><%=(membr!=null)?membr.getName():"不明帳號"%></font>
&nbsp;&nbsp;個人帳戶交易記錄</b> 
<br>
<br>
<%
    if (history.size()==0) {
        out.println("<blockquote>沒有繳費記錄</blockquote>");
    }
    else{
        String sourceIds = new RangeMaker().makeRange(history, "getBillSourceId");
        ArrayList<BillSource> sourcelines = BillSourceMgr.getInstance().
            retrieveList("id in (" + sourceIds + ")", "");
        Map<Integer/*sourceId*/, Vector<BillSource>> sourceMap = new SortingMap(sourcelines).doSort("getId");
%>

<center>
<table width="96%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
	
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
		<td>登入日期</td>
		<td>繳費日期</td>
        <td>帳號</td>
        <td>存入</td>
        <td>支出</td>
        <td>小計</td>
        <td>登入人</td>
        <td>備註</td>
	</tr>
<%
    Map<Integer, Integer> handled_refund = new HashMap<Integer, Integer>();
    while(iter.hasNext()) {
        BillPayInfo b = iter.next(); 
        total += b.getAmount();
%>
    <tr bgcolor=#ffffff class=es02>		
        <td><%=sdfPay.format(b.getCreateTime())%></td>
        <td><%=sdfPay.format(b.getRecordTime())%></td>
        <td>
            <img src="pic/feeIn.png"> 學費收款-<%  
            if (b.getVia()==BillPay.VIA_INPERSON)
                out.println("臨櫃繳款");
            else if (b.getVia()==BillPay.VIA_ATM) {
                out.println("ATM繳款");
                Vector<BillSource> bsv = sourceMap.get(new Integer(b.getBillSourceId()));
                if (bsv!=null) {
                    BillSource bs = bsv.get(0);
                    String accountId = "";
                    try { accountId = bs.getLine().substring(57,71); } catch (Exception e) {} // 2008-12-11 by peter 聯邦的格式不同，以後要考慮，現在先 catch 起來
                    out.println(" " + accountId);
                }
            }
            else if (b.getVia()==BillPay.VIA_STORE)
                out.println("便利商店代收");
            else if (b.getVia()==BillPay.VIA_CHECK) {
                out.println("支票");
                if (b.getPending()==1)
                    out.println(" <a target=_top href='query_cheque.jsp'>尚未兌現</a>");
            }
            else if (b.getVia()==BillPay.VIA_WIRE)
                out.println("匯款");
            else if (b.getVia()==BillPay.VIA_CREDITCARD)
                out.println("信用卡");
            else
                out.println("其他");
            %>	
        </td>	
        <td align=right><%=mnf.format(b.getAmount())%></td>
        <td align=right>
<%
           Costpay2 cp = null;
           boolean do_refund = b.getRefundCostPayId()>0 && handled_refund.get(b.getRefundCostPayId())==null;
           if (do_refund) {
                cp = Costpay2Mgr.getInstance().find("id=" + b.getRefundCostPayId());
                out.println(mnf.format(cp.getCostpayCostNumber()));
                total  -= cp.getCostpayCostNumber();
                handled_refund.put(b.getRefundCostPayId(), b.getRefundCostPayId());
           }
%>        
        </td>
        <td align=right><b><%=mnf.format(total)%></b></td>
        <td align=middle><%=(b.getUserId()==0)?"系統":getUserName(b.getUserId(), userMap)%></td>  
        <td>
<%
           if (do_refund) {
                String name = "";
                if (cp.getCostpayAccountType()==1) {
                    Tradeaccount ta = (Tradeaccount) ObjectService.find("jsf.Tradeaccount", "id=" + cp.getCostpayAccountId());
                    name = ta.getTradeaccountName();
                }
                else if (cp.getCostpayAccountType()==2) {
                    BankAccount ba = (BankAccount) ObjectService.find("jsf.BankAccount", "id=" + cp.getCostpayAccountId());
                    name = ba.getBankAccountName();
                }
                out.println("<font color=red>從 "+name+" 退費</font>");
           }else{

                if(b.getUserId()==ud2.getId()){
%>
            <a href="#" onClick="do_delete('<%=b.getId()%>');return false">刪除</a>
<%          }   
        }
%>

        </td>		
    </tr>	
<%
        Vector<BillPaidInfo> paidv = paidmap.get(new Integer(b.getId()));
        for (int i=0; paidv!=null && i<paidv.size(); i++) {
            BillPaidInfo p = paidv.get(i);
            total -= p.getPaidAmount();
%>
    <tr bgcolor=#ffffff class=es02>
        <td><%=sdfPay.format(b.getCreateTime())%></td>
        <td><%=sdfPay.format(b.getRecordTime())%></td>
        <td>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;學費沖帳<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;銷帳流水號: <%=p.getTicketId()%>
    
        </td>	
        <td align=right></td>
        <td align=right><%=mnf.format(p.getPaidAmount())%></td>

        <td align=right><b><%=mnf.format(total)%></b></td>
        <td align=middle> 
             <%=(b.getUserId()==0)?"系統":getUserName(b.getUserId(), userMap)%>
        </td> 
        <td>  

        </td>
    </tr>	

<%      }  
    }
%>
    <tr class=es02> 
        <td colspan=4 align=middle><b>帳 戶 餘 額</b></td>
        <td align=right>
            <b><font color=blue><%=mnf.format(total)%></font></b>
        </td>
        <td colspan=3 align=center>
        <%
            if (total>0) {
                out.println("<a href=\"javascript:parent.openwindow_phm('refund.jsp?sid="+sid+"','退   費',500,300,true)\">進行退費</a>");
            }
        %>
        </td>	
    </tr>
    </table> 
    </td>
    </tr>
    </table>

</center>
<br>
<br>
<%
    }
%>

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