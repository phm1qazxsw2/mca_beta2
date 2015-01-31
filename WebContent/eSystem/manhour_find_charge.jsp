<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM");
    SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
    Date d = sdf1.parse(request.getParameter("d"));
    // 只找主要 billitem 出來
    ArrayList<BillChargeItem> citems = BillChargeItemMgr.getInstance().retrieveList("month='" + sdf1.format(d) + 
        "' and billitem.status=1 and billType=" + Bill.TYPE_BILLING + " and mainBillItemId=0", "");
    for (int i=0; i<citems.size(); i++) {
        BillChargeItem citem = citems.get(i);
        out.println(citem.getBillItemId() + "," + citem.getBillRecordId() + "," +citem.getId()+","+citem.getMyAmount()+","+citem.getName());
    }
%>