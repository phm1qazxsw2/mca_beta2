<%@ page language="java" 
    import="dbo.*,phm.ezcounting.*,literalstore.*,java.util.*,phm.accounting.*,java.text.*"
    contentType="text/html;charset=UTF-8"%>
<%@ include file="../justHeader.jsp"%>
<pre>
<%
    boolean commit = false;
    int tran_id = 0;
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    Date d = null;
    Date nextDay = null;

    Date d1=null;
    try {
        d = sdf.parse(request.getParameter("d"));
        Calendar c = Calendar.getInstance();
        c.setTime(d);
        c.add(Calendar.DATE, 1);
        nextDay = c.getTime();

        String d1S=request.getParameter("d1");
        if(d1S !=null)
            d1=sdf.parse(d1S);

    }catch (Exception e) {}

    try {           
        tran_id = dbo.Manager.startTransaction();
        VchrItemSumMgr vismgr = new VchrItemSumMgr(tran_id);

        Acode a = new AcodeMgr(tran_id).find("id=" + request.getParameter("a"));
        if (a==null) {
            out.println("沒有資料");
            return;
        }
        String query ="";
        if(d1 !=null)
            query="'"+sdf.format(d1)+"' <= registerDate and registerDate<'"+sdf.format(nextDay)+"'";
        else
            query=" registerDate<'"+sdf.format(nextDay)+"'";                

         query+=" and acodeId=" + a.getId();

        ArrayList<VchrItemInfo> items = new VchrItemInfoMgr(tran_id).retrieveList(query, "order by registerDate asc");
        if (items.size()==0) {
            out.println("沒有資料");
            return;
        }

        VchrInfo vinfo = VchrInfo.getVchrInfo(items, tran_id);
        out.print(PaymentPrinter.makePrecise(a.getMain(), 6, false, ' '));
        out.print(" ");
        out.print(PaymentPrinter.makePrecise(a.getSub(), 6, false, ' '));
        out.print(vinfo.getAcodeName(items.get(0)));
        out.println("    (明細帳)");
        out.println("                        借        貸          借-貸     ");
        out.println("============================================================================");
    
        double debit = 0, credit = 0;
        DecimalFormat mnf = new DecimalFormat("###,###,###.#");
        for (int i=0; i<items.size(); i++) {
            VchrItemInfo vi = items.get(i);
            out.print("<a target=_blank href='range-query.jsp?d="+sdf.format(vi.getRegisterDate())+ "'>"+sdf.format(vi.getRegisterDate())+"</a>");
            out.print(" ");
            if (vi.getFlag()==VchrItem.FLAG_DEBIT) {
                debit += vi.getDebit();
                out.print("    ");
                out.print(PaymentPrinter.makePrecise(mnf.format(vi.getDebit()), 12, false, ' '));
                out.print("          ");
                out.print(PaymentPrinter.makePrecise(mnf.format(debit - credit), 15, false, ' '));
            }
            else {
                credit += vi.getCredit();
                out.print("              ");
                out.print(PaymentPrinter.makePrecise(mnf.format(vi.getCredit()), 12, false, ' '));
                out.print(PaymentPrinter.makePrecise(mnf.format(debit - credit), 15, false, ' '));
            }
            out.print("    <a target=_blank href='find_source.jsp?thread="+vi.getThreadId()+"'>" + vinfo.getVchrNote(vi) + "</a>");
            out.print(" ");
            out.print(vinfo.getItemNote(vi));
            out.println("");
        }
        out.println("===========================================================================");
        out.print(PaymentPrinter.makePrecise(mnf.format(debit), 25, false, ' '));
        out.print(PaymentPrinter.makePrecise(mnf.format(credit), 12, false, ' '));
        out.print(PaymentPrinter.makePrecise(mnf.format(debit-credit), 15, false, ' '));
        out.println("");
        //dbo.Manager.commit(tran_id);
        //commit = true;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }    
%>
</pre>