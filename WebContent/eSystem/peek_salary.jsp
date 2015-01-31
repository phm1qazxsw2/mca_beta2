<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<%!
    //##v2
    static DecimalFormat mnf = new DecimalFormat("###,###,##0");
    public void getDetail(MembrBillRecord sbr, StringBuffer content)
        throws Exception
    {
        String q = "chargeitem.billRecordId=" + sbr.getBillRecordId() + " and membr.id=" + sbr.getMembrId();
        DiscountMgr dmgr = DiscountMgr.getInstance();
        // 1. get all chargeitem for this bill
        ArrayList<ChargeItemMembr> items = ChargeItemMembrMgr.getInstance().retrieveList(q,"");
        Iterator<ChargeItemMembr> iter = items.iterator();
        int i=0;
        int subtotal = (int) 0;
        while (iter.hasNext()) {
            ChargeItemMembr c = iter.next();
            // chargeAmount, d.amount is what we want
            content.append("<tr bgcolor=ffffff class=es02><td nowrap><img src=img/flag2.png border=0>&nbsp;" + c.getChargeName() + "</td><td nowrap align=right>"+((c.getMyAmount()<0)?"("+Math.abs(c.getMyAmount())+")":c.getMyAmount()+"")+"</td>");
            subtotal += c.getMyAmount();
            content.append("<td align=right>"+((subtotal<0)?"("+Math.abs(subtotal)+")":subtotal+"")+"</td></tr>");
            i++;
        }
        if (sbr.getReceived()>0) {
            content.append("<tr bgcolor=f0f0f0 class=es02><td colspan=2 align=middle><b>已付金額</b></td><td align=right>" + mnf.format(sbr.getReceived()) + "</td></tr>");
        }else{
            String str = "<tr class=es02 bgcolor=f0f0f0><td colspan=2 align=middle><b>本期新增金額小計</b></td><td align=right>" + mnf.format(subtotal-sbr.getReceived()) + "</td></tr>";
            content.append(str);
        }
    }
%>
<%
    int rid = Integer.parseInt(request.getParameter("rid"));
    int sid = Integer.parseInt(request.getParameter("sid"));
    MembrBillRecord sbr = MembrBillRecordMgr.getInstance().find("membrId=" + sid + " and billRecordId=" + rid);
    if (sbr==null) {
        out.println("<br><br><blockquote>這筆資料不存在，可能已經被刪除了.</blockquote>");
        return;
    }
    StringBuffer sb = new StringBuffer("<table width=310 border=0 cellpadding=0 cellspacing=0>"+
                        "<tr align=left valign=top><td bgcolor=#e9e3de><table width=100% border=0 cellpadding=4 cellspacing=1>"+
                        "<tr bgcolor=f0f0f0 class=es02><td></td><td nowrap align=middle>項目</td><td  align=middle>小計</td></tr>");
    getDetail(sbr, sb);
    sb.append("</table></td></tr></table>");
    out.println(sb.toString());
%>