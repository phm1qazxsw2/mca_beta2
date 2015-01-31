<%@ page language="java" 
    import="dbo.*,phm.ezcounting.*,java.util.*,phm.accounting.*,java.text.*,jsf.*"
    contentType="text/html;charset=UTF-8"%>
<%
    boolean commit = false;
    int tran_id = 0;
    try {           
        tran_id = dbo.Manager.startTransaction();
        VoucherService vsvc = new VoucherService(tran_id);

        // ######### upgrade old ################
        BigItemMgr bim=BigItemMgr.getInstance();
        SmallItemMgr smm=SmallItemMgr.getInstance();
        Object[] bigs = bim.retrieve("", "");
        Object[] smalls = smm.retrieve("", "");
        Map<Integer, ArrayList<SmallItem>> smallitemMap = new SortingMap(smalls).doSortA("getSmallItemBigItemId");
        
        for (int i=0; i<bigs.length; i++) {
            out.println("");
            BigItem bi = (BigItem) bigs[i];
            if (bi.getAcctCode()==null||bi.getAcctCode().length()==0)
                continue;
            out.print(PaymentPrinter.makePrecise(bi.getAcctCode(), 7, true, ' '));
            out.print(PaymentPrinter.makePrecise(bi.getBigItemName(), 20, false, ' '));
            out.print(PaymentPrinter.makePrecise(bi.getBigItemActive()+"", 2, true, ' '));
            vsvc.getAcode(bi.getAcctCode(), null, bi.getBigItemName());
            ArrayList<SmallItem> sitems = smallitemMap.get(bi.getId());
            if (sitems!=null) {
                for (int j=0; j<sitems.size(); j++) {
                    SmallItem si = (SmallItem) sitems.get(j);
                    if (si.getAcctCode().length()==0)
                        continue;
                    out.println("");
                    out.print("       ");
                    out.print(PaymentPrinter.makePrecise(si.getAcctCode(), 5, true, ' '));
                    out.print(PaymentPrinter.makePrecise(si.getSmallItemName(), 20, false, ' '));
                    out.print(PaymentPrinter.makePrecise(si.getSmallItemActive()+"", 2, true, ' '));
                    vsvc.getAcode(bi.getAcctCode(), si.getAcctCode(), si.getSmallItemName());
                }
            }
        }
        //##############################       


        dbo.Manager.commit(tran_id);
        commit = true;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }    
%>
<br>ok