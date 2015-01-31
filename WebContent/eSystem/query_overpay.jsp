<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=1;
    int leftMenu=2;
%>
<%@ include file="topMenuAdvanced.jsp"%>
<%
    if(!checkAuth(ud2,authHa,104))
    {
        response.sendRedirect("authIndex.jsp?code=104");
    }
%>
<%@ include file="leftMenu1.jsp"%>
<%
    //##v2

    ArrayList<BillPayInfo> allpays = BillPayInfoMgr.getInstance().retrieveListX(
        "remain>0 and membr.type=" + Membr.TYPE_STUDENT, "", _ws.getBunitSpace("billpay.bunitId"));
%>
<br>
<b>&nbsp;&nbsp;&nbsp;溢繳查詢</b> 
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  
<br>
<center>
<%
    _ws.setBookmark(ud2, "溢繳查詢");
    if (allpays.size()==0) {
        out.println("<br>沒有任何餘額記錄");
%>
        <%@ include file="bottom.jsp"%>
<%
        return;
    }

    DecimalFormat mnf = new DecimalFormat("###,###,##0");
    Map<Integer,Vector<BillPayInfo>> m1 = new SortingMap(allpays).doSort("getMembrId");
    Set keys = m1.keySet();
    Iterator<Integer> iter = keys.iterator();
    StringBuffer sb = new StringBuffer();
    while (iter.hasNext()) {
        if (sb.length()>0) sb.append(",");
        sb.append(iter.next().intValue());
    }
    ArrayList<MembrInfoBillRecord> unpaid_bills = MembrInfoBillRecordMgr.getInstance().
        retrieveListX("paidStatus in (0,1) and membr.id in (" + sb.toString() + 
        ") and billType=" + Bill.TYPE_BILLING, "", _ws.getBunitSpace("bill.bunitId"));
    Map<Integer, Vector<MembrInfoBillRecord>> m2 = new SortingMap(unpaid_bills).doSort("getMembrId");
%>
<table width="96%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
	
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
        <td align=middle>帳號</td>
        <td align=middle>溢繳餘額</td>
        <td align=middle>未繳帳單</td>
        <td></td>
	</tr>

<%
    iter = keys.iterator();
    while (iter.hasNext()) {
        Integer mid = iter.next();
        Vector<BillPayInfo> v = m1.get(mid);        if (v==null || v.size()==0)
            continue;
        int remain = (int) 0;
        Vector<MembrInfoBillRecord> v2 = m2.get(mid);
        for (int i=0; i<v.size(); i++)
            remain +=v.get(i).getRemain();
%>
    <tr bgcolor=#ffffff class=es02>
        <td nowrap><%=v.get(0).getMembrName()%></td>
        <td align=right><a href="javascript:openwindow_phm('pay_info.jsp?sid=<%=mid.intValue()%>','歷史繳費',800,500,false);"><%=mnf.format(remain)%></a></td>
        <td>
        <% 
            if (v2!=null) {
                for (int j=0; j<v2.size(); j++) {
                    MembrInfoBillRecord bill = v2.get(j);
                    %><a href="bill_detail.jsp?rid=<%=bill.getBillRecordId()%>&sid=<%=bill.getMembrId()%>&backurl=query_overpay.jsp"><%=bill.getBillRecordName()%></a><br>
        <%
                }
            }
        %> 
        </td>
        <td nowrap align=middle>
        <%
            if (v2!=null) {
                out.println("<a href=\"javascript:openwindow_phm('otc_pay_all.jsp?sid="+v.get(0).getMembrId()+"&input=no','沖帳',500,500,true)\">沖帳</a>");
                out.println("| <a href=\"javascript:openwindow_phm('refund.jsp?sid="+v.get(0).getMembrId()+"','退費',500,300,true)\">退費</a>");
            }
        %>
        </td>
<%  } %>
    </tr>
    </table>

</td></tr></table>
</center>
<%@ include file="bottom.jsp"%>