<%@ page language="java" 
    import="com.axiom.mgr.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*"
    contentType="text/html;charset=UTF-8"%>
<%

int tran_id1 = 0;
int tran_id2 = 0;
boolean commit = false;

try {
    tran_id1 = com.axiom.mgr.Manager.startTransaction();
    tran_id2 = dbo.Manager.startTransaction();

    VitemMgr vimgr = new VitemMgr(tran_id2);
    VoucherMgr vchrmgr = new VoucherMgr(tran_id2);
    VPaidMgr vpmgr = new VPaidMgr(tran_id2);

    CostbookMgr cbmgr = new CostbookMgr(tran_id1);
    Object[] all_costbooks = cbmgr.retrieve("", "");
  
    CostMgr cmgr = new CostMgr(tran_id1);
    Object[] all_costs = cmgr.retrieve("", "");
    ArrayList<Cost> tmp1 = new ArrayList<Cost> ();
    Map<Integer, Vector<Cost>> costMap = 
        new SortingMap().doSort(all_costs, tmp1, "getCostCostbookId");

    CostpayMgr cpmgr = new CostpayMgr(tran_id1);
    Object[] all_costpays = cpmgr.retrieve("", "");
    ArrayList<Costpay> tmp2 = new ArrayList<Costpay> ();
    Map<Integer, Vector<Costpay>> costpayMap = 
        new SortingMap().doSort(all_costpays, tmp2, "getCostpayCostbookId");

    BigItemMgr bimgr = new BigItemMgr(tran_id1);
    SmallItemMgr simgr = new SmallItemMgr(tran_id1);
    Object[] objs = bimgr.retrieve("", "");
    Object[] objs2 = simgr.retrieve("", "");

    Map<Integer, Vector<BigItem>> bigitemMap = new SortingMap().
        doSort(objs, new ArrayList<BigItem>(), "getId");
    Map<Integer, Vector<SmallItem>> smallitemMap = new SortingMap().
        doSort(objs2, new ArrayList<SmallItem>(), "getId");
    

    for (int i=0; all_costbooks!=null&&i<all_costbooks.length; i++)
    {
        Costbook cb = (Costbook) all_costbooks[i];
        
        Voucher v = new Voucher();
        v.setCostbookId(cb.getCostbookCostcheckId()+"");
        vchrmgr.create(v);

        Integer id = new Integer(cb.getId());
        Vector<Cost> vcost = costMap.get(id);
        Vector<Costpay> vpays = costpayMap.get(id);

        int type = (cb.getCostbookOutIn()==0)?Vitem.TYPE_INCOME:Vitem.TYPE_SPENDING;

        if (cb.getCostbookOutIn()==0)
            out.print("##### ");
        else
            out.print("@@@@@ ");
        
        out.print(cb.getCostbookName() + "[" + cb.getCostbookTotalMoney() + "] [" + cb.getCostbookTotalMoney() + "] [" + cb.getCostbookPaiedStatus() + "]");

        int m = 0;
        ArrayList<Vitem> vitems = new ArrayList<Vitem>();
        for (int j=0; vcost!=null && j<vcost.size(); j++) {
            Cost c = vcost.get(j);
            String acctcode = null;
            Vector<BigItem> bv = bigitemMap.get(new Integer(c.getCostBigItem()));
            if (bv!=null) {
                acctcode = bv.get(0).getAcctCode();
            }
            Vector<SmallItem> sv = smallitemMap.get(new Integer(c.getCostSmallItem()));
            if (sv!=null) {
                acctcode += sv.get(0).getAcctCode();
            }

            Vitem vi = new Vitem();
            vi.setType(type);
            vi.setCreateTime(c.getCreated());
            vi.setRecordTime(cb.getCostbookAccountDate());
            String title = cb.getCostbookName() + "-" + c.getCostName();
            if (title.length()>40)
                title = title.substring(0,39);
            vi.setTitle(title);
            vi.setTotal(c.getCostMoney());
            vi.setUserId(c.getCostLogId());
            vi.setCostTradeId(cb.getCostbookCosttradeId());
            vi.setNote(c.getCostPs());
            vi.setAcctcode(acctcode);
            /*
            if (cb.getCostbookPaiedStatus()==90) {
                vi.setRealized(c.getCostMoney());
                vi.setPaidstatus(Vitem.STATUS_FULLY_PAID);
            }
            else
                throw new Exception("costbook " + cb.getId() + " not fully paid");
            */
            if (cb.getCostbookAttachType()==91)
                vi.setAttachtype(Vitem.ATTACH_TAXSLIP);
            else if (cb.getCostbookAttachType()==93)
                vi.setAttachtype(Vitem.ATTACH_RECEIPT);

            if (cb.getCostbookVerifyStatus()==90) {
                vi.setVerifystatus(Vitem.VERIFY_YES);
                vi.setVerifyUserId(cb.getCostbookVerifyId());
                vi.setVerifyDate(cb.getCostbookVerifyDate());
            }
            vi.setVoucherId(v.getId());
            vimgr.create(vi);
            vitems.add(vi);
            m += c.getCostMoney();
        }

        out.print(" cost total=" + m);
        int amount = 0;
        int n = 0;
        for (int j=0; vpays!=null && j<vpays.size(); j++) {
            Costpay cp = vpays.get(j);
            if (cp.getCostpayNumberInOut()==0)
                amount += cp.getCostpayIncomeNumber();
            else
                amount += cp.getCostpayCostNumber();
            n += amount;
            
            Iterator<Vitem> iter = vitems.iterator();
            while (iter.hasNext() && amount>0) {
                Vitem vi = iter.next();
                if (vi.getPaidstatus()==Vitem.STATUS_FULLY_PAID)
                    continue;
                VPaid vp = new VPaid();
                vp.setVitemId(vi.getId());
                vp.setCostpayId(cp.getId());
                int unpaid = vi.getTotal() - vi.getRealized();
                if (amount>=unpaid) {
                    vi.setRealized(vi.getTotal());
                    vi.setPaidstatus(Vitem.STATUS_FULLY_PAID);
                    vp.setAmount(unpaid);
                    amount -= unpaid;
                }
                else {
                    vi.setRealized(vi.getRealized()+amount);
                    vi.setPaidstatus(Vitem.STATUS_PARTLY_PAID);
                    vp.setAmount(amount);
                    amount = 0;
                }
                vimgr.save(vi);
                vpmgr.create(vp);
            }
        }

        if (cb.getCostbookTotalMoney()!=m || m!=n ||cb.getCostbookTotalMoney()!=n)
            out.println("<font color=red>");
        out.println(" pay1 total=" + m);
        if (cb.getCostbookTotalMoney()!=m || m!=n ||cb.getCostbookTotalMoney()!=n)
            out.println("</font>");
        out.println("<br>");

    }

    /*
    ArrayList<Costbook> tmp = new ArrayList<Costbook>();
    Map<Integer, Vector<Costbook>> costbookMap = 
        new SortingMap().doSort(all_costbooks, tmp, "getId");

    CostMgr cmgr = new CostMgr(tran_id1);
    Object[] all_costs = cmgr.retrieve("", "");
    for (int i=0; all_costs!=null && i<all_costs.length; i++) {
        Cost c = (Cost) all_costs[i];
        try {
            Costbook cb = costbookMap.get(new Integer(c.getCostCostbookId())).get(0);
            out.println(cb.getCostbookName() + " - " + c.getCostName() + "<br>");
        }
        catch (Exception e) {
            out.println("######## - "  + c.getCostName() + "<br>");
        }
    }

    Costbook2Mgr cbmgr = new Costbook2Mgr(tran_id2);
    ArrayList<Costbook2> all_costbook = cbmgr.retreiveList("", "");
    Iterator<Costbook2> iter = all_costbook.iterator();
    */

    com.axiom.mgr.Manager.commit(tran_id1);
    dbo.Manager.commit(tran_id2);
    commit = true;
}
finally {
    if (!commit) {
        com.axiom.mgr.Manager.rollback(tran_id1);
        try { dbo.Manager.rollback(tran_id2); } catch (Exception ee) {}
    }
}

%> 
done!




