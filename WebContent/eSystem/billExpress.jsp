<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*,java.util.*" contentType="text/html;charset=UTF-8"%>
<%
        String frameWidth=request.getParameter("frameWidth");
%>

<%@ include file="jumpTopExpress.jsp"%>
<%!
    public String getItemName(BillItem bi, Map<Integer, Vector<Alias>> aliasMap)
    {
        String ret = bi.getName();
        if (bi.getAliasId()>0) {
            Vector<Alias> va = aliasMap.get(new Integer(bi.getAliasId()));
            if (va!=null)
                ret = "[" + va.get(0).getName() + "] <span class=es01>" + ret + "</span>";
        }
        return ret;
    }

    public String getConnectingPitem(int pitemId, Map<Integer, Vector<PItem>> pitemMap)
    {
        if (pitemId<=0)
            return "";
        Vector<PItem> vp = pitemMap.get(new Integer(pitemId));
        if (vp==null)
            return "";
        String ret = vp.get(0).getName();
        if (ret.length()>4)
            ret = ret.substring(0,3) + "..";
        return "<a href=\"javascript:openwindow_phm('modify_product.jsp?id="+pitemId+"','學用品資料',400,300,false);\">" + ret + "</a>";
    }
%>
<%
    //##v2
    if(!checkAuth(ud2,authHa,102))
    {
        response.sendRedirect("authIndex.jsp?code=102");
    }
    int recordId = Integer.parseInt(request.getParameter("recordId"));
    EzCountingService ezsvc = EzCountingService.getInstance();
    BillRecord record = BillRecordMgr.getInstance().find("id="+recordId);
    Bill b = BillMgr.getInstance().find("id="+record.getBillId());

    ArrayList<BillItem> bitems = BillItemMgr.getInstance().
        retrieveList("billId=" + b.getId(),"");
        // 如果只 select status==active, 那在比對 chargeitem 的 billitem 時就不會找到已刪除的
        // 所以在這要全部選出
        // retrieveList("billId=" + b.getId() + " and status=" + BillItem.STATUS_ACTIVE,"");
    // billItemId
    Map<Integer, Vector<BillItem>> billitemMap = new SortingMap(bitems).doSort("getId");

    ArrayList<ChargeItemMembr> allcharges = ChargeItemMembrMgr.getInstance().
        retrieveList("chargeitem.billRecordId=" + recordId, "");
    allcharges = new SortingMap(allcharges).descendingBy("getMyAmount");

    // billItemId
    Map<Integer, Vector<ChargeItemMembr>> chargeMap = 
        new SortingMap(allcharges).doSort("getBillItemId");
    // chargeItemId
    Map<Integer, Vector<Discount>> discountMap = null;
    if (allcharges.size()>0) {
        String chargeItemIds = new RangeMaker().makeRange(allcharges, "getChargeItemId");
        ArrayList<Discount> discounts = DiscountMgr.getInstance().
            retrieveList("chargeItemId in (" + chargeItemIds + ")", "");        
        discountMap = new SortingMap(discounts).doSort("getChargeItemId");
    }  

    Map<Integer, Vector<Alias>> aliasMap = 
        new SortingMap(AliasMgr.getInstance().retrieveListX("","", _ws2.getBunitSpace("bunitId"))).doSort("getId");
    Map<Integer, Vector<PItem>> pitemMap = 
        new SortingMap(PItemMgr.getInstance().retrieveList("","")).doSort("getId");

    int billNum = MembrBillRecordMgr.getInstance().numOfRows("billRecordId=" + recordId);

    String backurl = "editBillRecord.jsp?" + request.getQueryString();
  	DecimalFormat mnf = new DecimalFormat("###,###,##0");
%>
&nbsp; 
<div class=es02>
<b>&nbsp;&nbsp;<%=record.getName()%></b> 
<br>
<br>
        <%
            Set cikeys = chargeMap.keySet();
            Iterator<Integer> citer = cikeys.iterator();
            int total_sum = 0;
            while (citer.hasNext())
            {
                Integer bkey = citer.next();
                Vector<ChargeItemMembr> cv = chargeMap.get(bkey);
                BillItem bi = billitemMap.remove(bkey).get(0);
                ChargeItemMembr sample_ci = cv.get(0);
                Vector<Discount> dv = discountMap.get(new Integer(sample_ci.getChargeItemId()));
                int amt = 0;
                for (int i=0; i<cv.size(); i++) {
                    amt += cv.get(i).getMyAmount();
                    total_sum += cv.get(i).getMyAmount();
                }
                for (int i=0; dv!=null&&i<dv.size(); i++) {
                    amt -= dv.get(i).getAmount();
                    total_sum -= dv.get(i).getAmount();
                }
                %>
                

                &nbsp;&nbsp;&nbsp;<%=getItemName(bi, aliasMap)%>-
                        <br>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="editChargeItemExpress.jsp?rid=<%=recordId%>&bid=<%=bi.getId()%>&cid=<%=sample_ci.getChargeItemId()%>" target="mainFrame"><img src="pic/fix.gif" border=0 width=12>收費編輯 <%=cv.size()%> 筆</a>
                        <br>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="editChargeItemDiscountExpress.jsp?cid=<%=sample_ci.getChargeItemId()%>"  target="mainFrame"><img src="pic/fix.gif" border=0 width=12>折扣編輯 <%=(dv==null)?0:dv.size()+" 筆"%></a>  <br><br>


        <%  }

        %>
            
        <%
            
            Set bikeys = billitemMap.keySet();
            Iterator<Integer> biter = bikeys.iterator();

            int xStart=0;
            while (biter.hasNext()) {
                BillItem bi = billitemMap.get(biter.next()).get(0);
                if (bi.getStatus()!=BillItem.STATUS_ACTIVE)
                    continue;
        
                if(xStart==0){
%>
                    &nbsp;&nbsp;&nbsp;尚未編輯-
                    <br>
<%
                }
        %>
                    <br>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <%=getItemName(bi, aliasMap)%>&nbsp;<a href="editChargeItemExpress.jsp?rid=<%=recordId%>&bid=<%=bi.getId()%>&cid=-1" target="mainFrame">編輯</a><br><br>
        <%  
            }
        %>
</center>

<!--- end 主內容 --->