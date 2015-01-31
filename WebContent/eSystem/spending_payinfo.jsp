<script>
function do_delete(cpId)
{
    if (!confirm('確認刪除此筆記錄?'))
        return;
    openwindow_phm2('mca_spending_delete.jsp?cpid='+cpId, '刪除收費', 200, 200, 'delwin');
}
</script>

<table width="96%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
		<td align=middle nowrap width=80>入帳日期</td>
		<td align=middle nowrap width=80>編號</td>
        <td align=middle nowrap width=120>帳戶</td>
		<td align=middle nowrap width=80>登入人</td>
        <td align=middle nowrap width=80>金額</td>
        <td align=middle nowrap width=80>備註</td>
        <td align=middle nowrap width=100></td>
        <td align=middle width=30></td>
        <td align=middle width=30></td>

	</tr>
<%

    String backurl2 = request.getRequestURI() + "?" + request.getQueryString();
    CostpayDescription cpd = new CostpayDescription(costpays);
    EzCountingService ezsvc2 = EzCountingService.getInstance();
    Iterator<Costpay2> iter2 = costpays.iterator();
    int sum = 0;
    while (iter2.hasNext()) {
        Costpay2 cp = iter2.next();
        if (cp.getCostpayNumberInOut()==1)
            sum += cp.getCostpayCostNumber();
        else
            sum += cp.getCostpayIncomeNumber();
%>
    <tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
        <td class=es02 valign=top><%=sdf.format(cp.getCostpayDate())%></td>	
        <td class=es02 valign=top><%=cp.getId()%></td>
        <td class=es02 valign=top>
        <%= cpd.getAccountName(cp) %>
        </td>
        <td class=es02 valign=top align=middle><%=ezsvc2.getUserName(cp.getCostpayLogId())%></td>	

        <td align=right class=es02 valign=top ><%=cpd.getAmount(cp)%></td>  
        <td colspan=2 class=es02 width=180>
            <%=cp.getCostpayLogPs()%>
        </tD>
        <td class=es02 valign=middle colspan=2 align=middle>
<%
    if(checkAuth(ud2,authHa,202) && ud2.getId()==cp.getCostpayLogId())
    {
%>
<a href="javascript:do_delete(<%=cp.getId()%>)">刪除</a>
<%
    }
%>
        </td>
    </tr>	
<%
    }     
%>
    <tr class=es02>
        <td align=right colspan=3></td>
        <td align=middle>交易小計:</td>
        <td align=right><b><%=mnf.format(sum)%></b></td> 
    </tr>
    </table> 

</td>
</tr>
</table>
