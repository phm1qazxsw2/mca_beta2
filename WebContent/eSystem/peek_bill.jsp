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
        items = new SortingMap(items).descendingBy("getMyAmount");
        Iterator<ChargeItemMembr> iter = items.iterator();
        int i=0;
        int subtotal = (int) 0;
        while (iter.hasNext()) {
            ChargeItemMembr c = iter.next();
            // 2. get the discount for this chargeitem
            Iterator<Discount> diter = dmgr.retrieveList("chargeItemId=" + c.getChargeItemId() + 
                " and membrId=" + sbr.getMembrId(), "").iterator();
            int dAmount = 0;
            while (diter.hasNext()) {
                Discount dc = diter.next();
                dAmount += dc.getAmount();
            }
            // chargeAmount, d.amount is what we want
            content.append("<tr bgcolor=ffffff class=es02><td nowrap><img src=img/flag2.png border=0>&nbsp;" + c.getChargeName() + "</td><td nowrap align=right>" + mnf.format(c.getMyAmount()) + "</td>");
            if (dAmount==0)
                content.append("<td nowrap></td>");
            else
                content.append("<td nowrap align=right>(" + mnf.format(dAmount) + ")</td>");
            subtotal += (c.getMyAmount() - dAmount);
            content.append("<td align=right>"+mnf.format(c.getMyAmount() - dAmount)+"</td></tr>");
            i++;
        }
        if (sbr.getReceived()>0) {
            String color = "F77510";
            String pending = "";
            if (sbr.getPending_cheque()==1)
                pending = "(支票未兌) ";
            content.append("<tr bgcolor="+color+" class=es02><td colspan=2 align=middle><font color=white>已收金額</font></td><td align=right colspan=2><font color=white>" + pending + mnf.format(sbr.getReceived()) + "</font></td></tr>");
        }else{
            String str = "<tr class=es02 bgcolor=4A7DBD><td colspan=3 align=middle><font color=white>本單新增金額小計:</font></td><td align=right><font color=white>" + mnf.format(subtotal-sbr.getReceived()) + "</font></td></tr>";
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
    StringBuffer sb = new StringBuffer("<table width=333 border=0 cellpadding=0 cellspacing=0>"+
                        "<tr align=left valign=top><td bgcolor=#e9e3de><table width=100% border=0 cellpadding=4 cellspacing=1>"+
                        "<tr bgcolor=f0f0f0 class=es02><td></td><td nowrap align=middle>應收</td><td nowrap align=middle>折扣</td><td  align=middle>小計</td></tr>");
    getDetail(sbr, sb);
    sb.append("</table></td></tr></table>");
    out.println(sb.toString());
%>