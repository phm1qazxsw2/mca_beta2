<%@ page language="java" 
    import="dbo.*,phm.ezcounting.*,literalstore.*,java.util.*,phm.accounting.*,java.text.*,phm.util.*"
    contentType="text/html;charset=UTF-8"%>
<%@ include file="../justHeader.jsp"%>
<link href="../ft02.css" rel=stylesheet type=text/css>
<script type="text/javascript" src="js/show_voucher.js"></script>
<%!
    ArrayList<VchrThread> getRelatedThreads(ArrayList<Vitem> vitems)
        throws Exception
    {
        String vitemIds = new RangeMaker().makeRange(vitems, "getId");
        ArrayList<VPaid> paids = VPaidMgr.getInstance().retrieveList("vitemId in (" + vitemIds + ")", "");
        String costpayIds = new RangeMaker().makeRange(paids, "getCostpayId");
        ArrayList<Costpay2> costpays = Costpay2Mgr.getInstance().retrieveList("id in (" + costpayIds + ")", "");
        String threadIds = new RangeMaker().makeRange(costpays, "getThreadId");
        ArrayList<VchrThread> threads = VchrThreadMgr.getInstance().retrieveList("id in (" + threadIds + 
            ") and srcType in (3,9,10)", "");
        PArrayList<VchrThread> ret = new PArrayList<VchrThread>(threads);
        threadIds = new RangeMaker().makeRange(vitems, "getThreadId");
        ret.concate(VchrThreadMgr.getInstance().retrieveList("id in (" + threadIds + 
            ") and srcType in (3,9,10)", ""));
        return ret;
    }
%>
<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    DecimalFormat mnf = new DecimalFormat("###,###.#"); 

    String vitemIds = request.getParameter("vids");
    ArrayList<Vitem> vitems = VitemMgr.getInstance().retrieveList("id in (" + vitemIds + ")", "");
    ArrayList<VchrThread> threads = getRelatedThreads(vitems);

    if (threads.size()==0) {
        out.println("沒有資料");
        return;
    }
    String threadIds = new RangeMaker().makeRange(threads, "getId");
    ArrayList<VchrItemInfo> items = VchrItemInfoMgr.getInstance().
        retrieveList("vchr_item.threadId in (" + threadIds + ")", "order by main asc, sub asc");

    boolean full_mode = false;
    try { full_mode = request.getParameter("f").equals("true"); } catch (Exception e) {}

    VchrInfo vinfo = VchrInfo.getVchrInfo(items, 0);
    out.println("<table border=0 class=es02><tr align=right><td colspan=3></td><td width=100>借</td><td width=100>貸</td>");
    if (full_mode)
        out.print("<td width=100>借-貸<td>");
    out.println("</tr>");
    Map<Integer, ArrayList<VchrItemInfo>> acodeitemMap = new SortingMap(items).doSortA("getAcodeId");
    Iterator<Integer> iter2 = acodeitemMap.keySet().iterator();
    double debit_total = 0, credit_total = 0;
    while (iter2.hasNext()) {
        ArrayList<VchrItemInfo> tmp = acodeitemMap.get(iter2.next());
        double debit=0, credit=0;
        for (int i=0; i<tmp.size(); i++) {
            debit += tmp.get(i).getDebit();
            credit += tmp.get(i).getCredit();
        }
        if (!full_mode) {
            if (debit==credit)
                continue;
            else if (debit!=0 && credit!=0) {            
                if (debit>credit) {
                    debit = debit - credit;
                    credit = 0;
                }
                else {
                    credit = credit - debit;
                    debit = 0;
                }
            }
        }
        debit_total += debit;
        credit_total += credit;
        out.print("<tr align=right><td align=left>");
        out.print(vinfo.getMain(tmp.get(0)));
        out.print("</td><td align=left>");
        out.print(vinfo.getSub(tmp.get(0)));
        out.print("</td><td align=left nowrap>");
        out.print(vinfo.getAcodeName(tmp.get(0)));
        out.print("</td><td>");
        out.print((debit!=0)?mnf.format(debit):"");
        out.print("</td><td>");
        out.print((credit!=0)?mnf.format(credit):"");
        out.print("</td>");
        if (full_mode) {
            out.print("<td>");
            out.print(mnf.format(debit-credit));
            out.print("</td>");
        }
        out.print("</tr>");
    }
    out.println("</table>");


    out.println("<div class=es02><br>明細:<br><hr width='100%'></div>");
    out.println("<table class=es02>");
    out.println("<tr align=right><td width=100 align=left>入帳日期</td><td width=100 align=center>傳票</td><td colspan=3 align=center>科目</td><td width=100>借&nbsp;&nbsp;</td><td width=100>貸&nbsp;&nbsp;</td><td width=100 nowrap>小計(借-貸)&nbsp;</td><td align=left>&nbsp;&nbsp;摘要</td></tr>");
    
    items = VchrItemInfoMgr.getInstance().retrieveList("vchr_item.threadId in (" + threadIds + 
        ")", "order by vchrId asc, vchr_item.id asc");
    Map<Integer, ArrayList<VchrItemInfo>> vchritemMap = new SortingMap(items).doSortA("getVchrId");
    Map<Integer, VchrHolder> vchrMap = vinfo.getVchrMap();
    Iterator<Integer> iter = vchrMap.keySet().iterator();
    while (iter.hasNext()) {
        VchrHolder v = vchrMap.get(iter.next());
        ArrayList<VchrItemInfo> tmp = vchritemMap.get(v.getId());
        double credit = 0, debit = 0;
        double subtotal = 0;
        for (int j=0; j<tmp.size(); j++) {
            VchrItem vi = tmp.get(j);
            if (vi.getFlag()==VchrItem.FLAG_DEBIT) {
                debit += vi.getDebit();
            }
            else {
                credit += vi.getCredit();
            }

            out.print("<tr align=right><td align=left>" + sdf.format(vinfo.getRegisterDate(vi)));
            out.print("</td><td align=left>");
            out.print("<a href=# onclick=\"parent.show_voucher2("+vi.getVchrId()+",null, false);return false;\">" + 
                vinfo.getSerial(vi) + "</a>");
            out.print("</td><td align=left>&nbsp;&nbsp;");
            out.print(vinfo.getMain(vi));
            out.print("</td><td align=left>");
            out.print(vinfo.getSub(vi));
            out.print("&nbsp;&nbsp;</td><td align=left nowrap>");
            out.print(vinfo.getAcodeName(vi));
            out.print("</td><td>&nbsp;&nbsp;");
            out.print(vinfo.formatDebit(vi));
            out.print("&nbsp;&nbsp;</td><td>&nbsp;&nbsp;");
            out.print(vinfo.formatCredit(vi));
            out.print("&nbsp;&nbsp;</td><td>");
            subtotal += (vi.getDebit() - vi.getCredit());
            out.print(mnf.format(subtotal) + "&nbsp;");
            out.print("&nbsp;&nbsp;</td><td align=left nowrap>&nbsp;&nbsp;");
            out.print(vinfo.getTotalNote(vi));
            out.print("</td></tr>");
        }
    }
    out.println("</table>");
%>
