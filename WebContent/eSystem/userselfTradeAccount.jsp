<%@ page language="java" contentType="text/html;charset=UTF-8"%><% 
		DecimalFormat mnftrade = new DecimalFormat("###,###,##0");
		Tradeaccount[] tradeA=jp.getActiveTradeaccount(ud2.getId());
         
        for(int p=0;tradeA!=null && p<tradeA.length;p++)
        {
            IncomeCost ic = jp.getIncomeCost(1, tradeA[p].getId(), 99, 99, null);
%>
    <li><img src="pic/casex.png" border=0> &nbsp;<%=tradeA[p].getTradeaccountName()%> 小計:
        <a href="show_costpay_detail.jsp?bankType=1&baid=<%=tradeA[p].getId()%>"><%=mnftrade.format(ic.getIncome() - ic.getCost())%> 元</a>
<%
        }	
%> 

