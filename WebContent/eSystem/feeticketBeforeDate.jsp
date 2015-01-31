<%@ page language="java" import="java.text.*" contentType="text/html;charset=UTF-8"%>
<%  
	DecimalFormat mnffee = new DecimalFormat("###,###,##0");

	StudentMgr sm=StudentMgr.getInstance();	

    //SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd");
    ArrayList<MembrInfoBillRecord> bills = null;
    
    if (beforeDate!=null) {
        bills = MembrInfoBillRecordMgr.getInstance().retrieveListX("billType=" + Bill.TYPE_BILLING + 
            " and modifyTime>'" + sdf.format(beforeDate) + "'", "",  _ws.getBunitSpace("bill.bunitId"));
    }
	if(bills!=null && bills.size()>0) {
%>
<link rel="stylesheet" href="css/ajax-tooltip-billsearch.css" media="screen" type="text/css">
<script language="JavaScript" src="js/in.js"></script>
<script type="text/javascript" src="js/ajax-dynamic-content.js"></script>
<script type="text/javascript" src="js/ajax.js"></script>
<script type="text/javascript" src="js/ajax-tooltip.js"></script>
<script type="text/javascript" src="js/check.js"></script>

<div class=es02>
<b><img src="pic/billx.png" border=0 width=16> 學費帳單</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;更動概況: <a href="#" onClick="showForm('feeticketDiv');return false"><%=bills.size()%> 筆</a></div>

<div id=feeticketDiv style="display:none" class=es02>
<table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
    <table width="100%" border=0 cellpadding=4 cellspacing=1>
        <tr bgcolor=#f0f0f0  class=es02 align=left valign=middle>
            <td align=middle>姓名</td><td align=middle>流水序號</td><td align=middle>繳款狀態</td><td align=middle>應繳金額</td><td align=middle>已收金額</td><td></td>
        </tr>
	<%
        Iterator<MembrInfoBillRecord> iter = bills.iterator();  
        while (iter.hasNext()) {
            MembrInfoBillRecord bill = iter.next();
	%>	
	<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
	
	<td class=es02>
    	<%=bill.getMembrName()%>
	</td>
	<td class=es02>
        <%
            boolean lcked = (bill.getPrintDate()>0);
            boolean paid = bill.getPaidStatus()==MembrBillRecord.STATUS_FULLY_PAID;
            String icon = "";
            if (paid)
                icon = "<img src='pic/lockfinish2.png' width=15 height=15 align=top>";
            else if (lcked) 
                icon = "<img src='pic/lockno2.png' width=15 height=15 align=top>";
        %><%=icon%>
        <a name=<%=bill.getTicketId()%>>
        <a href='bill_detail.jsp?rid=<%=bill.getBillRecordId()%>&sid=<%=bill.getMembrId()%>&backurl=<%=java.net.URLEncoder.encode(backurl+"#" +bill.getTicketId())%>' onmouseover="ajax_showTooltip('peek_bill.jsp?rid=<%=bill.getBillRecordId()%>&sid=<%=bill.getMembrId()%>',this);return false" onmouseout="ajax_hideTooltip()"><%=bill.getTicketId()%></a>
	</td>
	<td class=es02>
	<%
        String bgcolorX="";

	    switch(bill.getPaidStatus()){
		case MembrBillRecord.STATUS_NOT_PAID:
            bgcolorX="#4A7DBD";
			out.println("尚未繳款");
			break;
		case MembrBillRecord.STATUS_PARTLY_PAID:
            bgcolorX="#4A7DBD";
			out.println("已繳款尚未繳清");
			break;
		case MembrBillRecord.STATUS_FULLY_PAID:
            bgcolorX="#F77510";
			out.println("已繳清");
			break;	
	}
	%></td>
    <td class=es02 align=right><%=mnffee.format(bill.getReceivable())%></tD>
<%
        int needpay=bill.getReceivable()-bill.getReceived();
%>
    <td bgcolor=<%=bgcolorX%> align=right class=es02 valign=middle>
        <font color=white>
        <%=mnffee.format(bill.getReceived())%>
        </font>
    </tD>
    <td class=es02 align=middle>
            <a href='bill_detail.jsp?rid=<%=bill.getBillRecordId()%>&sid=<%=bill.getMembrId()%>&backurl=<%=java.net.URLEncoder.encode(backurl+"#" +bill.getTicketId())%>'>詳細資料</a>
    </tD>   
	</tr>
	
	<%
	}
	%>
	</table>
	</td>
	</tr>
	</table>
    </div>
	<br>
<%	
	}
%>