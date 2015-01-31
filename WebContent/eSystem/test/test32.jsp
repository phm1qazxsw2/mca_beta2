<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,phm.accounting.*,literalstore.*,mca.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="../justHeader.jsp"%>
<%
    boolean commit = false;
    int tran_id = 0;
    try {           
        tran_id = dbo.Manager.startTransaction();

        ArrayList<Charge> charges = new ChargeMgr(tran_id).retrieveList("", "");
        ArrayList<ChargeItemMembr> cims = new ChargeItemMembrMgr(tran_id).retrieveList("", "");
        ArrayList<Discount> discounts = new DiscountMgr(tran_id).retrieveList("", "");

        Map<String, ChargeItemMembr> cimMap = new SortingMap(cims).doSortSingleton("getChargeKey");
        Map<String, Charge> chargeMap = new SortingMap(charges).doSortSingleton("getChargeKey");
        Map<String, ArrayList<Discount>> discountMap = new SortingMap(discounts).doSortA("getChargeKey");
        ChargeMgr cmgr = new ChargeMgr(tran_id);

        Iterator<String> iter = chargeMap.keySet().iterator();
        while (iter.hasNext()) {
            String key = iter.next();
            ChargeItemMembr cim = cimMap.get(key);
            if (cim.getTicketId()==null) {
                cmgr.executeSQL("delete from charge where chargeItemId="+cim.getChargeItemId()+ 
                    " and membrId=" + cim.getMembrId());
            }
        }


        dbo.Manager.commit(tran_id);
        commit = true;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }    
%>done!