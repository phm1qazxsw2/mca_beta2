<%@ page language="java" buffer="32kb" 
import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" type="text/css" media="print" href="css/print_style.css" />
<div class=noprint>
<%@ include file="jumpTop.jsp"%>
</div>
<br>
<%
    request.setCharacterEncoding("UTF-8");
    // 1: 零用金 2: 銀行
    int bankType = Integer.parseInt(request.getParameter("bankType"));	 
	DecimalFormat mnf = new DecimalFormat("###,###,##0");
    int acctId = Integer.parseInt(request.getParameter("baid"));
	JsfAdmin ja=JsfAdmin.getInstance();

	if(bankType==2)
 
	{ 
		if(ud2.getUserRole()>2 && !ja.isAuthBank(acctId,ud2.getId()))
		{	
%>
			<br>	
			<br>
			<blockquote>	
				<div class=es02>權限不足!	</div>
			</blockquote>			
	
			<%@ include file="bottom.jsp"%>
<%		
				return;
		}	
	}	
	
	JsfPay jp = JsfPay.getInstance();
 

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf2 = new SimpleDateFormat("MM/dd");
	int type = 99;
 
	int tradeType = 99;
    try { type=Integer.parseInt(request.getParameter("type")); } catch (Exception e) {}
	try { tradeType=Integer.parseInt(request.getParameter("tradeType")); } catch (Exception e) {}

    Date endDate = new Date();
    try { endDate=sdf.parse(request.getParameter("endDate")); } catch (Exception e) {}
    Calendar c = Calendar.getInstance();
    c.setTime(endDate);
    c.add(Calendar.DATE, -7);
    Date startDate = c.getTime();
    try { startDate=sdf.parse(request.getParameter("startDate")); } catch (Exception e) {}

    IncomeCost ic = jp.getIncomeCost(bankType, acctId, type, tradeType, endDate);
    String query = jp.getCostpayQueryString(bankType, acctId, type, tradeType, startDate, endDate);
    Object[] objs = CostpayMgr.getInstance().retrieve(query, "order by costpayLogDate desc");
	
	TradeaccountMgr tam=TradeaccountMgr.getInstance(); 
	BankAccountMgr bam2=BankAccountMgr.getInstance();

    String backurl = "show_costpay_detail.jsp?" + request.getQueryString();
    String encodeBackurl = java.net.URLEncoder.encode(backurl);
%>

        <div class=es02>
<%	
	if(bankType==2)
	{
		BankAccount  banNow=(BankAccount)bam2.find(acctId);
%>
    <div class="title">
	<b>&nbsp;&nbsp;<img src="pic/bank.png" border=0>&nbsp;<%=banNow.getBankAccountName()%>-交易查詢</b>	
    </div>
<%	
	}else{
		Tradeaccount tradeA=(Tradeaccount)tam.find(acctId);
%>
    <div class="title">
	<b>&nbsp;&nbsp;&nbsp;<img src="pic/casex.png" border=0>&nbsp;<%=tradeA.getTradeaccountName()%>-交易明細</b>	
    </div>
<%
	}
%>	
</div>			
	<blockquote>
        形式:
        <b>
        <%
            switch(type){
                case 99:
                    out.println("全部");
                    break;
                case 1:
                    out.println("支出");
                    break;
                case 0:
                    out.println("收入");
                    break;
            }   %>

        </b>
		 		交易類別:
            <b>
            <%
            switch(tradeType){
                case 99:
                    out.println("全部");
                    break;
                case 1:
                    out.println("學費交易");
                    break;
                case 2:
                    out.println("薪資交易");
                    break;
                case 3:
                    out.println("雜費交易");
                    break;
                case 4:
                    out.println("內部轉帳");
            }   
        %>
        </b>
                入帳日期 起:<b><%=sdf.format(startDate)%></b>
                至:
                <b><%=sdf.format(endDate)%></b>
	</blockquote>

<%
    int sum = 0;
    int in_sum = 0;
    int out_sum = 0;
    for (int i=0; objs!=null&&i<objs.length; i++)
    {
        Costpay cp = (Costpay) objs[i];
        in_sum += cp.getCostpayIncomeNumber();
        out_sum += cp.getCostpayCostNumber();
        sum += (cp.getCostpayIncomeNumber() - cp.getCostpayCostNumber());
    }
%>
<div class=noprint>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>	
<BR>	
<center>
<form>
<input type="button" value="列印本頁" onClick="window.print();" />
</form>
</center>
</div>

<center>
<div align=right class=es02>合計: <font color=blue><%=(objs==null)?0:objs.length%></font> 筆&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div> 

<table width="97%" border=1 class=htable>
<tr bgcolor=#ffffff align=left>
    <th bgcolor=#f0f0f0 class=es02 height=25>序號</th>
    <th bgcolor=#f0f0f0 class=es02>入帳日期</th>
    <th bgcolor=#f0f0f0 class=es02 width=200>交易明細</th>
    <th bgcolor=#f0f0f0 class=es02 width=50>存入</th>
    <th bgcolor=#f0f0f0 class=es02 width=50>支出</th>
    <th bgcolor=#f0f0f0 class=es02 width=50>累計</th>	
    <th bgcolor=#f0f0f0 class=es02>註記</th>	
</tr>

<%    
    StringBuilder sb = new StringBuilder(10000);
    sb.append(" <tr class=es02 bgcolor=#ffffff>");
	sb.append("     <td colspan=3 align=middle><b>小 計</b></td>");
	sb.append("     <td align=right>&nbsp;" + mnf.format(in_sum)+ "</td>");
	sb.append("     <td align=right>&nbsp;" + mnf.format(out_sum)+ "</td>");	
	sb.append("     <td align=right>&nbsp;<b>" + mnf.format(ic.getIncome()-ic.getCost()) + "</b></td>");
	sb.append("     <td align=left>(存入-支出)&nbsp;" + mnf.format(sum) + "</td>");
    sb.append("</tr>");

    int cur_subtotal = ic.getIncome() - ic.getCost();
    CostpayDescription cpd = new CostpayDescription(objs);
    for (int i=0; objs!=null&& i<objs.length; i++) {
        Costpay cp = (Costpay) objs[i];
        String[] outTitle = jp.showCostpayTitle(cp, ud2, cpd, backurl);
        StringBuilder item = new StringBuilder();
    item.append("<tr bgcolor=#ffffff>");
		item.append("<td class=es02>" + cp.getId() + "<br>&nbsp;</td>");
		item.append("<td class=es02>");
        item.append(sdf.format(cp.getCostpayLogDate()));
		item.append("</td>");
		item.append("<td class=es02 width=200>");
	    item.append(outTitle[0]);
        item.append("</td>");
        item.append("<td class=es02 align=right valign=top>" + ((cp.getCostpayIncomeNumber()==0)?"&nbsp;":mnf.format(cp.getCostpayIncomeNumber()))+"</td>");
        item.append("<td class=es02 align=right valign=top>" + ((cp.getCostpayCostNumber()==0)?"&nbsp;":mnf.format(cp.getCostpayCostNumber()))+ "</td>");
        item.append("<td class=es02 align=right valign=bottom>" + mnf.format(cur_subtotal) + "</td>");

        item.append("<td class=es02 align=left>");

        StringBuffer ps = new StringBuffer();
        if (cp.getCostpayFeeticketID()>0)
            if (cp.getCostpayFeePayFeeID()!=-9999) // 最舊的銷帳對 ticketId
                ps.append("&nbsp;&nbsp;("+sdf.format(cp.getCostpayDate()) + " 繳費)");
            else { // 我后來的 costpay (getCostpayFeeticketID==1 && getCostpayFeePayFeeID==-9999)
                ps.append(cpd.getMoneyflowDetail(cp));
            }
        else if (cp.getCostpayStudentAccountId()>0 && cp.getCostpayFeePayFeeID()!=-9999) { // 后來 henry 寫的用先入學生帳戶
            if (!cp.getCostpayDate().equals(cp.getCostpayLogDate()))
                ps.append(" 繳費日期 "+sdf.format(cp.getCostpayDate()));
        }
        
        
        ps.append(((cp.getCostpayLogPs()!=null && cp.getCostpayLogPs().length()>0)?cp.getCostpayLogPs():"&nbsp;"));
        
        if (cp.getCostpayIncomeNumber()==0 && cp.getCostpayCostNumber()==0)
            ps.append("(已刪除)");

        item.append(ps);
        item.append("</td>");
        item.append("</tr>");
	    sb.insert(0, item.toString());
        int diff = (cp.getCostpayCostNumber() - cp.getCostpayIncomeNumber());
        cur_subtotal += diff;
        sum += diff;
    }
    StringBuilder sb2 = new StringBuilder();
    if (objs!=null) {
        sb2.append(" <tr class=es02>");
        sb2.append("     <td colspan=5 align=middle><b>期 初 </b></td>");
        sb2.append("     <td align=right><b>" + mnf.format(cur_subtotal) + "</b></td>");
        sb2.append("<tD>&nbsp;</tD></tr>");
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
 </center>  
    <br>
