<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,mca.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    String keys = request.getParameter("keys");
    String[] pairs = keys.split(",");
    StringBuffer sb1 = new StringBuffer();
    StringBuffer sb2 = new StringBuffer();
    for (int i=0; i<pairs.length; i++) {
        String[] tokens = pairs[i].split("#");
        if (i>0) {
            sb1.append(",");
            sb2.append(",");
        }
        sb1.append(tokens[0]);
        sb2.append(tokens[1]);
    }

    ArrayList<ChargeItemMembr> citems = ChargeItemMembrMgr.getInstance().retrieveList(
        "charge.membrId in (" + sb1.toString() + 
        ") and charge.chargeItemId in (" + sb2.toString() + ")", 
        "order by charge.membrId asc, charge.chargeItemId asc");
%>
<center>
<table width="390" height="" border="0" cellpadding="0" cellspacing="0">
    <tr align=left valign=top bgcolor="#e9e3de">
    <td>

        <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr class=es02 bgcolor=f0f0f0>
                <td>
                    Name
                </td>
                <td>
                    Charge
                </td>
                <td>
                    Amount
                </td>
                <td>
                    Reason
                </td>
            </tr>
<%
    for (int i=0; i<citems.size(); i++) {
        ChargeItemMembr ci = citems.get(i);
%>
            <tr class=es02 bgcolor=ffffff>
                <td nowrap>
                    <%=ci.getMembrName()%>
                </td>
                <td>
                    <%=ci.getChargeName()%>
                </td>
                <td>
                    <%=ci.getMyAmount()%>
                </td>
                <td nowrap>
                    <%=ci.getNote()%>
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