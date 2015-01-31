<%@ page language="java" 
    import="dbo.*,phm.ezcounting.*,literalstore.*,java.util.*,phm.accounting.*,java.text.*"
    contentType="text/html;charset=UTF-8"%>
<%@ include file="../justHeader.jsp"%>
<pre>
<%
    boolean commit = false;
    int tran_id = 0;
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    Date d = new Date();    
    try {
        d = sdf.parse(request.getParameter("d"));
    }
    catch (Exception e) {
        d = new Date();
    }
    Calendar c = Calendar.getInstance();
    c.setTime(d);
    c.add(Calendar.DATE, 1);
    Date nextDay = c.getTime();


    try {           
        tran_id = dbo.Manager.startTransaction();
        ArrayList<VchrHolder> vchrs = new VchrHolderMgr(tran_id).retrieveList("registerDate>='" + sdf.format(d) + 
            "' and registerDate<'" + sdf.format(nextDay) + "' and type=" + VchrHolder.TYPE_INSTANCE, "");
        
        String vchrIds = new RangeMaker().makeRange(vchrs, "getId");
        ArrayList<VchrItem> items = new VchrItemMgr(tran_id).retrieveList("vchrId in (" + vchrIds + ")", "");
        Map<Integer, ArrayList<VchrItem>> itemsMap = new SortingMap(items).doSortA("getVchrId"); 
        VchrInfo vinfo = new VchrInfo(items, tran_id);
        vinfo.config(6,6,2);
        DecimalFormat mnf = new DecimalFormat("###,###.#"); 
        out.print(sdf.format(d));
        out.println("  日記帳");
        out.println("");
        for (int i=0; i<vchrs.size(); i++) {
            VchrHolder v = vchrs.get(i);
            out.print("傳票序號:" + PaymentPrinter.makePrecise(v.getSerial(), 15, true, ' '));
            out.println(" 入帳日期:" + sdf.format(v.getRegisterDate()));
            items = itemsMap.get(v.getId());
            out.print("by " + vinfo.getUserName(v.getUserId()) + " " + sdf.format(v.getCreated()));
            out.println("   <a target=_blank href='find_source.jsp?thread="+items.get(0).getThreadId()+"'>" + vinfo.getVchrNote(v) + "</a>");
            out.println("                                          借             貸       ");
            double credit = 0, debit = 0;
            for (int j=0; j<items.size(); j++) {
                VchrItem vi = items.get(j);
                out.print(vinfo.getAcodeFullName(vi, 36, true));
                if (vi.getFlag()==VchrItem.FLAG_DEBIT) {
                    debit += vi.getDebit();
                    out.print(PaymentPrinter.makePrecise(mnf.format(vi.getDebit()), 10, false, ' '));
                    out.print("              ");
                }
                else {
                    credit += vi.getCredit();
                    out.print("               ");
                    out.print(PaymentPrinter.makePrecise(mnf.format(vi.getCredit()), 9, false, ' '));
                }
                out.print("   ");
                out.println(vinfo.getItemNote(vi));
            }
            out.println("                                       -----------------------");
            out.print(PaymentPrinter.makePrecise(mnf.format(debit), 46, false, ' '));
            out.println(PaymentPrinter.makePrecise(mnf.format(credit), 14, false, ' '));
            out.println("==============================================================");
        }

        //dbo.Manager.commit(tran_id);
        //commit = true;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }    
%>
</pre>