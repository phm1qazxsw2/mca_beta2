<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,mca.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    int feeId = Integer.parseInt(request.getParameter("feeId"));
    ArrayList<McaRecordInfo> mrs = McaRecordInfoMgr.getInstance().retrieveList("mcaFeeId=" + feeId + 
        " and mca_fee.status!=-1", "");
    String billRecordIds = new RangeMaker().makeRange(mrs, "getBillRecordId");
    BillRecordInfo br = BillRecordInfoMgr.getInstance().findX("billrecord.id in (" + billRecordIds + ")",
        _ws2.getBunitSpace("bill.bunitId"));
    ArrayList<MembrInfoBillRecord> bills = new MembrInfoBillRecordMgr(0).retrieveList("billRecordId=" + br.getId(), "");
    String ticketIds = new RangeMaker().makeRange(bills, "getTicketIdAsString");
    ArrayList<McaDeferred> defers = new McaDeferredMgr(0).retrieveList("ticketId in (" + ticketIds + ")", "");
    Map<String, MembrInfoBillRecord> billMap = new SortingMap(bills).doSortSingleton("getTicketId");
    // #############
%>

<center>
<table width="390" height="" border="0" cellpadding="0" cellspacing="0">
        <tr align=left valign=top>
        <td bgcolor="#e9e3de">

            <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr class=es02 bgcolor=f0f0f0>
                <td width=30%>
                    Name
                </td>
                <td width=30%>
                    Type
                </td>
            </tr>
<%
    for (int i=0; i<defers.size(); i++) {
        McaDeferred md = defers.get(i);
        MembrInfoBillRecord bill = billMap.get(md.getTicketId());  
%>
            <tr class=es02 bgcolor=ffffff>
                <td nowrap>
                    <%=bill.getMembrName()%>
                    <a target=_blank href="bill_detail.jsp?sid=<%=bill.getMembrId()%>&rid=<%=bill.getBillRecordId()%>&poId=-1&backurl=mca_fee_list.jsp"><img src="img/billlink.png" height=14 border=0></a>&nbsp;&nbsp;
                </td>
                <td>
                <%
                    if (md.getType()==McaDeferred.TYPE_STANDARD)
                        out.println("Standard");
                    else if (md.getType()==McaDeferred.TYPE_MONTHLY)
                        out.println("Monthly");
                    else
                        out.println("None");
                %>
                </td>
            </tr>
<%
    }
%>
        </table>
    </td>
    </tr>
</table>
</center>
<br>
<br>
</blockquote>

