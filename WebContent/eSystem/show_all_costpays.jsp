<%@ page language="java" buffer="32kb" 
import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<script src="js/show_voucher.js"></script>
<%
    int topMenu=11;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu2-new.jsp"%>
<br>
<br>
<%!
	static DecimalFormat mnf1 = new DecimalFormat("###,###,##0");
	static DecimalFormat mnf2 = new DecimalFormat("###,###,###.##");
    String getPrintValue(double value, boolean usd)
    {
        if (usd) {
            double r = Math.rint(value);
            return mnf2.format(r);
        }
        return mnf1.format(value);
    }

    String getCheckInfo(Costpay cp)
    {
        if (cp.getCheckInfo()!=null&&cp.getCheckInfo().length()>0)
            return cp.getCheckInfo();
        return "";
    }

    String getReceiptNo(Costpay cp)
    {
        if (cp.getReceiptNo()!=null&&cp.getReceiptNo().length()>0)
            return cp.getReceiptNo();
        return "";
    }

    String getPrintValueNoRounding(double value, boolean usd)
    {
        if (usd) {
            return mnf2.format(value);
        }
        return mnf1.format(value);
    }

    String getTotal(IncomeCost ic, boolean usd)
    {
        if (usd) {
            double r = Math.rint(ic.getOrgAmount());
            return mnf2.format(r);
        }
        return mnf1.format(ic.getIncome()-ic.getCost());
    }

    String getIncomeNum(Costpay cp) {
        if (cp.getCostpayNumberInOut()==0 && (cp.getCostpayAccountType()==4 || cp.getCostpayAccountType()==5))
            return mnf2.format(cp.getOrgAmount());
        return mnf1.format(cp.getCostpayIncomeNumber());
    }

    String getCostNum(Costpay cp) {
        if (cp.getCostpayNumberInOut()==1 && (cp.getCostpayAccountType()==4 || cp.getCostpayAccountType()==5))
            return mnf2.format(cp.getOrgAmount());
        return mnf1.format(cp.getCostpayCostNumber());
    }

    String getAccountName(int acctType, Tradeaccount t)
    {
        String ret = t.getTradeaccountName();
        if (acctType==1)
            ret += "(Cash in TWD)";
        else if (acctType==3)
            ret += "(Check in TWD)";
        else if (acctType==4)
            ret += "(Cash in USD)";
        else if (acctType==5)
            ret += "(Check in USD)";
        return ret;
    }


    static SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    static SimpleDateFormat sdf2 = new SimpleDateFormat("MM/dd");

    Date getCookieTime(String ckname, Date d, HttpServletRequest req)
        throws Exception
    {
        Cookie[] cks = req.getCookies();
        for (int i=0; cks!=null && i<cks.length; i++)
        {
            if (cks[i].getName().equals(ckname))
            {
                return sdf.parse(cks[i].getValue());
            }
        }
        return d;
    }
%>
<%  
    request.setCharacterEncoding("UTF-8");
	DecimalFormat mnf = new DecimalFormat("###,###,##0");

    int type = 99; 
	int tradeType = 99;
    try { type=Integer.parseInt(request.getParameter("type")); } catch (Exception e) {}
	try { tradeType=Integer.parseInt(request.getParameter("tradeType")); } catch (Exception e) {}

    Calendar c = Calendar.getInstance();
    c.add(Calendar.DATE, 7);
    Date endDate = getCookieTime("end2", c.getTime(), request);
    try { endDate=sdf.parse(request.getParameter("endDate")); } catch (Exception e) {}
    c.setTime(endDate);
    c.add(Calendar.DATE, -7);
    Date startDate = getCookieTime("start2", c.getTime(), request);
    try { startDate=sdf.parse(request.getParameter("startDate")); } catch (Exception e) {}

    IncomeCost ic = jp.getIncomeCost(bankType, acctId, type, tradeType, endDate);
    String query = jp.getCostpayQueryString(bankType, acctId, type, tradeType, startDate, endDate);
    int vstatus = 99;
    try { vstatus = Integer.parseInt(request.getParameter("vstatus")); } catch (Exception e) {}
    if (vstatus!=99)
        query += " and costpayVerifyStatus=" + vstatus;
    Object[] objs = CostpayMgr.getInstance().retrieveX(query, 
        "order by costpayLogDate desc", _ws.getBunitSpace("bunitId"));
	
	TradeaccountMgr tam=TradeaccountMgr.getInstance(); 
	BankAccountMgr bam2=BankAccountMgr.getInstance();

    String backurl = "show_costpay_detail.jsp?" + request.getQueryString();
    String encodeBackurl = java.net.URLEncoder.encode(backurl);
%>

        <div class=es02>
<%	
	if(bankType==2)
	{ 
		BankAccount  banNow=(BankAccount)bam2.find(acctId);
        _ws.setBookmark(ud2, banNow.getBankAccountName() + "明細" + sdf2.format(startDate) + "-" + sdf2.format(endDate));
%> 
	<b>&nbsp;&nbsp;<img src="pic/bank.png" border=0>&nbsp;<%=banNow.getBankAccountName()%>-交易查詢</b>	
<%	
	}else{ 
		
		Tradeaccount tradeA=(Tradeaccount)tam.find(acctId);
        _ws.setBookmark(ud2, tradeA.getTradeaccountName() + "明細" + sdf2.format(startDate) + "-" + sdf2.format(endDate));
%>
	<b>&nbsp;&nbsp;&nbsp;<img src="pic/casex.png" border=0>&nbsp;<%=getAccountName(bankType, tradeA)%>-交易明細</b>	
<%
	}
%>	
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" onClick="history.go(-1)"><img src="pic/last2.png" border=0>&nbsp;回上一頁</a></div>			
	<blockquote>
	<form action="show_costpay_detail.jsp" method="get"> 
	
	<table width="60%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#ffffff class=es02>
		 	<td nowrap>形式</tD>
		 	<td bgcolor=#ffffff>
			<select size=1 name="type">
				<option value="99" <%=(type==99)?"selected":""%>>全部</option>
				<option value="1" <%=(type==1)?"selected":""%>>支出</option>
				<option value="0" <%=(type==0)?"selected":""%>>收入</option>
			</select>
		 	</td>
		 	<td nowrap>
		 		交易類別
		 	</tD>
		 	<td bgcolor=#ffffff>
			 	<select size=1 name="tradeType">
					<option value="99" <%=(tradeType==99)?"selected":""%>>全部</option>
					<option value="1" <%=(tradeType==1)?"selected":""%>>學費交易</option>
					<option value="2" <%=(tradeType==2)?"selected":""%>>薪資交易</option>
					<option value="3" <%=(tradeType==3)?"selected":""%>>雜費交易</option>
					<option value="4" <%=(tradeType==4)?"selected":""%>>內部轉帳</option>

				</select>
		 	</tD>
		 	<tD nowrap>入帳日期起:
                <input type=text id="start2" name="startDate" value="<%=(startDate==null)?"":sdf.format(startDate)%>" size=7>
                至:
				<input type=text id="end2" name="endDate" value="<%=sdf.format(endDate)%>" size=7>
			</td>
		 	<td nowrap>
		 		狀態
		 	</tD>
            <td bgcolor=#ffffff>
			 	<select size=1 name="vstatus">
					<option value="99" <%=(vstatus==99)?"selected":""%>>全部</option>
					<option value="0" <%=(vstatus==0)?"selected":""%>>未確認</option>
					<option value="2" <%=(vstatus==2)?"selected":""%>>OK</option>
					<option value="1" <%=(vstatus==1)?"selected":""%>>警示</option>
				</select>
		 	</tD>
		 	<td bgcolor=#ffffff>
		 		<input type=hidden name="baid" value="<%=acctId%>">
                <input type=hidden name="bankType" value=<%=bankType%>>
 		 		<input type=submit value="搜尋">
		 	</tD>
		</tR>
	</table> 	
		</tD>
		</tr>
		</table>
	
	</form> 
	</blockquote>

<%
    double sum = 0;
    double in_sum = 0;
    double out_sum = 0;
    for (int i=0; objs!=null&&i<objs.length; i++)
    {
        Costpay cp = (Costpay) objs[i];
        boolean income = (cp.getCostpayNumberInOut()==0)?true:false;
        double curAmount = (USD)?cp.getOrgAmount():(income)?cp.getCostpayIncomeNumber():cp.getCostpayCostNumber();
        in_sum += (income)?curAmount:0;
        out_sum += (income)?0:curAmount;
        sum += (income)?curAmount:(0-curAmount);
    }
%>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>	
<BR>	
<center>
<div align=right class=es02>合計: <font color=blue><%=(objs==null)?0:objs.length%></font> 筆
&nbsp;&nbsp;<a target="_blank" href="print_costpay_detail.jsp">匯出</a>
<div id="content">
<!-- | 
<a target=_blank href="show_costpay_detail_little.jsp?type=<%=type%>&tradeType=<%=tradeType%>&startDate=<%=sdf.format(startDate)%>&endDate=<%=sdf.format(endDate)%>&baid=<%=acctId%>&bankType=<%=bankType%>"><img src="pic/print.png" border=0>&nbsp;可列印版本</a>
&nbsp;&nbsp;&nbsp;&nbsp;
</div> 
-->

<table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

    <table width="100%" border=0 cellpadding=4 cellspacing=1>
    <tr bgcolor=#ffffff align=left valign=middle>
		<td bgcolor=#f0f0f0 class=es02>序號</td>
		<td bgcolor=#f0f0f0 class=es02>入帳日期</td>
		<td bgcolor=#f0f0f0 class=es02 width=200 align=middle>交易明細</td>
		<td bgcolor=#f0f0f0 class=es02 width=50 align=middle>存入</tD>
		<td bgcolor=#f0f0f0 class=es02 width=50 align=middle>支出</tD>
		<td bgcolor=#f0f0f0 class=es02 width=50 align=middle>累計</td>		
		<td bgcolor=#f0f0f0 class=es02 width=50 align=middle>CheckInfo</td>	
		<td bgcolor=#f0f0f0 class=es02 width=50 align=middle>Receipt#</td>	
		<td bgcolor=#f0f0f0 class=es02 colspan=2 align=middle>註記</td>	
		<td bgcolor=#f0f0f0 class=es02></td>
	</tr>

<%    
    StringBuilder sb = new StringBuilder(10000);
    sb.append(" <tr class=es02>");
	sb.append("     <td colspan=3 align=middle><b>小 計</b></td>");
	sb.append("     <td align=right>" + getPrintValue(in_sum, USD)+ "</td>");
	sb.append("     <td align=right>" + getPrintValue(out_sum, USD)+ "</td>");	
	sb.append("     <td align=right>&nbsp;<b>" + getTotal(ic, USD) + "&nbsp;</b></td>");
	sb.append("     <td align=left colspan=4 nowrap>(本次搜尋區間 存入-支出: &nbsp;" + mnf.format(sum) + ")</td>");
    sb.append(" </tr>");

    double cur_subtotal = (!USD)?(ic.getIncome() - ic.getCost()):ic.getOrgAmount();
    CostpayDescription cpd = new CostpayDescription(objs);
    for (int i=0; objs!=null&& i<objs.length; i++) {
        Costpay cp = (Costpay) objs[i];
        String[] outTitle = jp.showCostpayTitle(cp, ud2, cpd, backurl);
        StringBuilder item = new StringBuilder();
    item.append("<tr bgcolor=#ffffff align=left  onmouseover=\"this.className='highlight'\"  onmouseout=\"this.className='normal2'\" valign=middle>");
		item.append("<td class=es02>" + cp.getId() + "&nbsp;</td>");
		item.append("<td class=es02>");
        item.append(sdf.format(cp.getCostpayLogDate()));
		item.append("</td>");
		item.append("<td class=es02 width=200>");
	    item.append(outTitle[0]);
        item.append("</td>");
        item.append("<td class=es02 align=right valign=top>" + getIncomeNum(cp)+"</td>");
        item.append("<td class=es02 align=right valign=top>" + getCostNum(cp)+ "</td>");
        item.append("<td class=es02 align=right valign=bottom>&nbsp;" + getPrintValueNoRounding(cur_subtotal, USD) + "&nbsp;</td>");

        item.append("<td align=right class=es02>");
        item.append(getCheckInfo(cp));
        item.append("&nbsp;</td>");
        item.append("<td align=right class=es02>");
        item.append(getReceiptNo(cp));
        item.append("&nbsp;</td>");
        
        item.append("<td class=es02 align=left colspan=2>");

        StringBuffer ps = new StringBuffer();
        if (cp.getCostpayFeeticketID()>0) {
            if (cp.getCostpayFeePayFeeID()!=-9999) // 最舊的銷帳對 ticketId
                ps.append("&nbsp;&nbsp;("+sdf.format(cp.getCostpayDate()) + " 繳費)");
            else { // 我后來的 costpay (getCostpayFeeticketID==1 && getCostpayFeePayFeeID==-9999)
                ps.append(cpd.getMoneyflowDetail(cp));
            }
        }
        else if (cp.getCostpayStudentAccountId()>0 && cp.getCostpayFeePayFeeID()!=-9999) { // 后來 henry 寫的用先入學生帳戶
            if (!cp.getCostpayDate().equals(cp.getCostpayLogDate()))
                ps.append(" 繳費日期 "+sdf.format(cp.getCostpayDate()));
        }
        
        if (ps.length()>0)
            ps.append("");
        
        ps.append(((cp.getCostpayLogPs()!=null && cp.getCostpayLogPs().length()>0)?cp.getCostpayLogPs():""));
        
        ps.append("<a href=\"javascript:openwindow_phm('modifyCostpayPs.jsp?cpId="+cp.getId()+"','編輯註解',300,200,true);\"><img src=\"images/lockyes.gif\" border=0 width=15 alt=\"編輯註記\"></a>");

        if (cp.getCostpayIncomeNumber()==0 && cp.getCostpayCostNumber()==0)
            ps.append("(已刪除)");

        item.append(ps);
        item.append("</td>");
        item.append("<td class=es02 nowrap>");
        item.append(outTitle[1]);
        item.append("</td>");
        item.append("</tr>");
	    sb.insert(0, item.toString());
        double diff = 0;
        if (!USD) {
            diff = (cp.getCostpayCostNumber() - cp.getCostpayIncomeNumber());
        }
        else {
            if (cp.getCostpayNumberInOut()==0) // income
                diff = 0-cp.getOrgAmount();
            else
                diff = cp.getOrgAmount();
        }
        cur_subtotal += diff;
        sum += diff;
    }
    StringBuilder sb2 = new StringBuilder();
    if (objs!=null) {
        sb2.append(" <tr class=es02>");
        sb2.append("     <td colspan=5 align=middle><b>期 初 </b></td>");
        sb2.append("     <td align=right><b>" + getPrintValue(cur_subtotal, USD) + "</b></td>");
        sb2.append(" </tr>");
    }
    else {
        sb2.append(" <tr class=es02 bgcolor=ffffff>");
        sb2.append("     <td colspan=10 align=center><b>本段期間沒有記錄</b></td>");
        sb2.append(" </tr>");
    }
    sb.insert(0, sb2.toString());
    out.println(sb.toString());
%>
 	
    </table>
</td>
</tr>
</table>
</div>
 </center>  
  <br>
  <br>

<script src="js/cookie.js"></script>
<script>
    var d = document.getElementById("start2");
    d.onchange = function() {
        Set_Cookie("start2", this.value);
    }
    d = document.getElementById("end2");
    d.onchange = function() {
        Set_Cookie("end2", this.value);
    }
</script>

<%@ include file="bottom.jsp"%>
