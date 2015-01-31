<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    int pid = Integer.parseInt(request.getParameter("id"));

    ArrayList<BillItem> bitems = BillItemMgr.getInstance().retrieveList("pitemId=" + pid, "");
    String billitemIds = new RangeMaker().makeRange(bitems, "getId");
    ArrayList<ChargeItem> citems = ChargeItemMgr.getInstance().retrieveList("billItemId in (" + billitemIds + ")", "");

    String chargeItemIds = new RangeMaker().makeRange(citems, "getId");
    ArrayList<Charge> charges = ChargeMgr.getInstance().retrieveList("chargeItemId in (" + chargeItemIds 
        + ") and pitemNum>0", "");

    EzCountingService ezsvc = EzCountingService.getInstance();
    ArrayList<ChargeItemMembr> chargemembrs = ezsvc.getChargeItemMembrs(0, 
        charges, "order by ticketId desc");
    
    String membrIds = new RangeMaker().makeRange(charges, "getMembrId");
    Map<Integer, Membr> membrMap = new SortingMap(MembrMgr.getInstance().retrieveList("id in (" + membrIds + ")", ""))
        .doSortSingleton("getId");

    PItem pi = PItemMgr.getInstance().findX("id=" + pid, _ws2.getBunitSpace("bunitId"));
%>
  
<center>
<%=pi.getName()%> 出貨歷史
<table width="390" height="" border="0" cellpadding="0" cellspacing="0">
    <tr align=left valign=top>
        <td bgcolor="#e9e3de">

            <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr class=es02 bgcolor=f0f0f0>
                <td>
                    單號   
                </td>
                <td>
                    領用人
                </td>
                <td align=right>
                    數量&nbsp;&nbsp;
                </td>
                <td align=right>
                    售價&nbsp;&nbsp;
                </td>
                <td>
                    登入人
                </td>
            </tr>

<%
    for (int i=0; i<chargemembrs.size(); i++) {
        ChargeItemMembr ci = chargemembrs.get(i);
        Membr m = membrMap.get(ci.getMembrId());
%>
            <tr class=es02 bgcolor=ffffff>
                <td>
                    <a target=_blank href="bill_detail.jsp?sid=<%=ci.getMembrId()%>&rid=<%=ci.getBillRecordId()%>&backurl=##"><%=ci.getTicketId()%></a>
                </td>
                <td>
                    <%=m.getName()%>
                </td>
                <td align=right>
                    <%=ci.getPitemNum()%>&nbsp;&nbsp;
                </td>
                <td align=right>
                    <%=ci.getMyAmount()%>&nbsp;&nbsp;
                </td>
                <td>
                    <%=ezsvc.getUserName(ci.getUserId())%>
                </td>
            </tr>
<%
    }
%>
        </table>
    </td>
    </tr>
</table>
