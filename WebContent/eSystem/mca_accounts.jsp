<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,jsi.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=2;
    int leftMenu=0;
%>
<%@ include file="topMenuAdvanced.jsp"%>
<%@ include file="leftMenu2-new.jsp"%>
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
%><br>
<blockquote>
  
<table width="390" height="" border="0" cellpadding="0" cellspacing="0">
    <tr align=left valign=top>
    <td bgcolor="#e9e3de">

            <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr class=es02 bgcolor=f0f0f0>
                <td>
                    Cash Account
                </td>
                <td>
                    Balance
                </td>
                <td nowrap>
                </td>
            </tr>
<%
    JsfPay jp=JsfPay.getInstance();
    Tradeaccount[] tradeAccts = jp.getActiveTradeaccount(ud2.getId());
    for (int i=0; tradeAccts!=null && i<tradeAccts.length; i++) {
        int id = tradeAccts[i].getId();
        String name = tradeAccts[i].getTradeaccountName();
        IncomeCost ic1 = jp.getIncomeCost(1, tradeAccts[i].getId(), 99, 99, null);
        IncomeCost ic3 = jp.getIncomeCost(3, tradeAccts[i].getId(), 99, 99, null);
        String query = jp.getCostpayQueryString(4, tradeAccts[i].getId(), 99, 99, null, null);

        IncomeCost ic4 = jp.getIncomeCost(4, tradeAccts[i].getId(), 99, 99, null);
        IncomeCost ic5 = jp.getIncomeCost(5, tradeAccts[i].getId(), 99, 99, null);
%> 
            <tr class=es02 bgcolor=ffffff>
                <td>
                    臺幣現金－<%=name%>
                </td>
                <td align=right>
                    <%=ic1.getIncome() - ic1.getCost()%>&nbsp;
                </td>
                <td nowrap>
                    <a href="show_costpay_detail.jsp?bankType=1&baid=<%=id%>">詳細資料</a>
                </td>
            </tr>
            <tr class=es02 bgcolor=ffffff>
                <td>
                    臺幣支票－<%=name%>
                </td>
                <td align=right>
                    <%=ic3.getIncome() - ic3.getCost()%>&nbsp;
                </td>
                <td nowrap>
                    <a href="show_costpay_detail.jsp?bankType=3&baid=<%=id%>">詳細資料</a>
                </td>
            </tr>
            <tr class=es02 bgcolor=ffffff>
                <td>
                    USD Cash－<%=name%>
                </td>
                <td align=right>
                    USD$ <%=getPrintValue(ic4.getOrgAmount(), true)%>&nbsp;
                </td>
                <td nowrap>
                    <a href="show_costpay_detail.jsp?bankType=4&baid=<%=id%>">詳細資料</a>
                </td>
            </tr>
            <tr class=es02 bgcolor=ffffff>
                <td>
                    USD Check－<%=name%>
                </td>
                <td align=right>
                    USD$ <%=getPrintValue(ic5.getOrgAmount(), true)%>&nbsp;
                </td>
                <td nowrap>
                    <a href="show_costpay_detail.jsp?bankType=5&baid=<%=id%>">詳細資料</a>
                </td>
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

<table width="390" height="" border="0" cellpadding="0" cellspacing="0">
    <tr align=left valign=top>
    <td bgcolor="#e9e3de">

            <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr class=es02 bgcolor=f0f0f0>
                <td>
                    Bank Account
                </td>
                <td>
                    Balance
                </td>
                <td nowrap>
                </td>
            </tr>
<%
    Map<Integer, BankAccount> bankMap = new SortingMap(BankAccountMgr.getInstance().retrieveX("", "",
        _ws.getBunitSpace("bunitId"))).doSortSingleton("getId");
    SalarybankAuth[] bankAuths = jp.getSalarybankAuthByUserId(ud2);
    for (int i=0; bankAuths!=null && i<bankAuths.length; i++) {
        SalarybankAuth sba = bankAuths[i];
        BankAccount ba = bankMap.get(sba.getSalarybankAuthId());
        if (ba==null)
            continue;
        String name = ba.getBankAccountName();
        IncomeCost ic1 = jp.getIncomeCost(2, ba.getId(), 99, 99, null);
%>
            <tr class=es02 bgcolor=ffffff>
                <td>
                    <%=name%>
                </td>
                <td align=right>
                <%
                if (name.indexOf("USD$")<0)
                    out.println(ic1.getIncome() - ic1.getCost());
                else
                    out.println("USD$ " + getPrintValue(ic1.getOrgAmount(), true));
                %>&nbsp;
                </td>
                <td nowrap>
                    <a href="show_costpay_detail.jsp?bankType=2&baid=<%=ba.getId()%>">詳細資料</a>
                </td>
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
<a href="cashflow.jsp">查詢全部</a>

</blockquote>
<%@ include file="bottom.jsp"%>