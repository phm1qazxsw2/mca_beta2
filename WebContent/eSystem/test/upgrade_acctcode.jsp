<%@ page language="java" 
    import="com.axiom.mgr.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*"
    contentType="text/html;charset=UTF-8"%>
<%

int tran_id = 0;
boolean commit = false;
try {
    tran_id = com.axiom.mgr.Manager.startTransaction();
    BigItemMgr bimgr = new BigItemMgr(tran_id);
    SmallItemMgr simgr = new SmallItemMgr(tran_id);

    Object[] objs = bimgr.retrieve("", "");
    Object[] objs2 = simgr.retrieve("", "");

    Map<Integer, Vector<SmallItem>> smallItemMap = new SortingMap().
        doSort(objs2, new ArrayList<SmallItem>(), "getSmallItemBigItemId");
    for (int i=0; i<objs.length; i++) {
        BigItem bi = (BigItem) objs[i];
        out.println(bi.getBigItemName());
        String acctcode = "6a" + PaymentPrinter.makePrecise((i+1)+"", 2, false, '0');
        bi.setAcctCode(acctcode);
        out.print(acctcode);
        bimgr.save(bi);

        Vector<SmallItem> vs = smallItemMap.get(new Integer(bi.getId()));
        if (vs!=null) {
            out.println("　" + vs.size());
            for (int j=0; j<vs.size(); j++) {
                SmallItem si = (SmallItem) vs.get(j);
                String code2 = PaymentPrinter.makePrecise((j+1)+"", 3, false, '0');
                si.setAcctCode(code2);
                simgr.save(si);
                out.print(" " + code2);
            }
        }
        out.println("<br>");
    }
    com.axiom.mgr.Manager.commit(tran_id);
    commit = true;
}
finally {
    if (!commit) {
        com.axiom.mgr.Manager.rollback(tran_id);
    }
}

%> 
done!




