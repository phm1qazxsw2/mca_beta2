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
    Date nextDay = null;
    try {
        //d = sdf.parse(request.getParameter("d"));
        Calendar c = Calendar.getInstance();
        c.setTime(d);
        c.add(Calendar.DATE, 1);
        nextDay = c.getTime();
    }
    catch (Exception e) {
    }

    try {           
        tran_id = dbo.Manager.startTransaction();
        VchrItemSumMgr vismgr = new VchrItemSumMgr(tran_id);

        String query = "";
        if (nextDay!=null)
            query += "vchr_holder.registerDate<'" + sdf.format(nextDay) + "'";

        query += " and vchr_holder.type=" + VchrHolder.TYPE_INSTANCE;

        //ArrayList<VchrItemSum> sums = vismgr.retrieveList(query, "group by fullkey");
        ArrayList<VchrItemSum> sums = vismgr.retrieveList(query, " group by acode.main");
        boolean show_main_only = true;
        Map<String, ArrayList<VchrItemSum>> sumsMap = new SortingMap(sums).doSortA("getFirstDigit");

        String[] loops = { "1", "資產", "2", "負債", "3", "業主權益", "4", "收入", "5", "成本", "6", "費用", "7", "業外收入費用" };
        DecimalFormat mnf = new DecimalFormat("###,###.#"); 

        for (int i=0; i<loops.length; )
        {
            out.println("");
            out.println("");
            String cat = loops[i++];
            String name = loops[i++];

            out.println("(" + cat + ") " + name);
            out.println("                                              借             貸          借-貸 ");
            sums = sumsMap.get(cat);
            double debit = 0;
            double credit = 0;
            if (sums!=null) {
                VchrSumInfo vinfo = new VchrSumInfo(sums, show_main_only, tran_id);
                for (int j=0; j<sums.size(); j++) {
                    VchrItemSum s = sums.get(j);
                    debit += s.getDebit();
                    credit += s.getCredit();
                    out.print(vinfo.printSum(s));
                    out.println("   <a target=_blank href='history.jsp?a="+s.getAcodeId()+
                        ((d!=null)?"&d=" + sdf.format(d):"")+"'>明細</a>");
                }
            }
            out.println("========================================================================================");
            out.println(PaymentPrinter.makePrecise(mnf.format(debit), 48, false, ' ')
                        + PaymentPrinter.makePrecise(mnf.format(credit), 15, false, ' ') 
                        + PaymentPrinter.makePrecise(mnf.format(debit-credit), 15, false, ' '));
        }

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }    
%>
</pre>