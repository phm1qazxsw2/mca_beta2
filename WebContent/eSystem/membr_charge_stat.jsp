<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2

    int mid = Integer.parseInt(request.getParameter("mid"));
    Membr membr = MembrMgr.getInstance().find("id=" + mid);
    ArrayList<ChargeItemMembr> chargeitems = ChargeItemMembrMgr.getInstance().
        retrieveList("charge.membrId=" + mid, "");
    ArrayList<DiscountInfo> discounts = DiscountInfoMgr.getInstance().
        retrieveList("discount.membrId=" + mid, "");
    
    Map<Integer,Vector<ChargeItemMembr>> chargeMap = new SortingMap(chargeitems).doSort("getBillItemId");
    Map<Integer,Vector<DiscountInfo>> discountMap = new SortingMap(discounts).doSort("getChargeItemId");
%>
	
<b>&nbsp;&nbsp;<font color=blue><%=(membr!=null)?membr.getName():"不明帳號"%></font>
&nbsp;&nbsp;項目統計</b> 
<br>
<br>
<%
    if (chargeitems.size()==0) {
        out.println("<blockquote>沒有繳費記錄</blockquote>");
        return;
    }

    Set keys = chargeMap.keySet();
    Iterator<Integer> iter = keys.iterator();
    while (iter.hasNext()) {
        Vector<ChargeItemMembr> v = chargeMap.get(iter.next());
        for (int i=0; i<v.size(); i++) {
            ChargeItemMembr c = v.get(i);
            Vector<DiscountInfo> v2 = discountMap.get(new Integer(c.getChargeItemId()));
            out.println("<li>" + c.getChargeName() + " " + c.getMyAmount());
            if (v2!=null && v2.size()>0) {
                out.println("<ul>");
                for (int j=0; j<v2.size(); j++) {
                    DiscountInfo dinfo = v2.get(j);
                    out.println("<li>" + dinfo.getDiscountTypeName() + " " + dinfo.getAmount());
                }
                out.println("</ul>");
            }
        }
    }
%>
