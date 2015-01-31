<%@ page language="java" 
    import="com.axiom.mgr.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*"
    contentType="text/html;charset=UTF-8"%>
<%

int tran_id1 = 0;
boolean commit = false;

try {
    tran_id1 = com.axiom.mgr.Manager.startTransaction();

    CostbookMgr cbmgr = new CostbookMgr(tran_id1);
    CostpayMgr cpmgr = new CostpayMgr(tran_id1);

    Object[] objs = cpmgr.retrieve("costpayCostbookId!=0", "");
    for (int i=0; objs!=null && i<objs.length; i++) {
        Costpay cp = (Costpay) objs[i];
        Costbook co =(Costbook) cbmgr.find(cp.getCostpayCostbookId());
        if (co==null)
            continue;
        cp.setCostpayLogPs(co.getCostbookName());
        cpmgr.save(cp);
        out.println(co.getCostbookName() + "<br>");
    }

    com.axiom.mgr.Manager.commit(tran_id1);
    commit = true;
}
finally {
    if (!commit) {
        com.axiom.mgr.Manager.rollback(tran_id1);
    }
}

%> 
done!




