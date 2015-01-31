<%@ page language="java" 
    import="dbo.*,phm.ezcounting.*,literalstore.*,java.util.*,phm.accounting.*,java.text.*"
    contentType="text/html;charset=UTF-8"%>
<link href="../ft02.css" rel=stylesheet type=text/css>
<%@ include file="../justHeader.jsp"%>
<script type="text/javascript" src="js/show_voucher.js"></script>
<%!
    String getAcodeLink(int acodeId, String name) {
        return "<a href=\"javascript:show_acode_detail("+acodeId+")\">"+name+"</a>";
    }
%>
<script>
function show_acode_detail(aid) {
    document.acodeform.a.value = aid;
    document.acodeform.submit();
}
</script>
<%
    int threadId = Integer.parseInt(request.getParameter("thread"));
    VchrThread t = VchrThreadMgr.getInstance().find("id=" + threadId);
    if (t==null) {
        out.println("沒有資料");
        return;
    }
    ArrayList<BillPaid> paids = BillPaidMgr.getInstance().retrieveList("ticketId=" + t.getSrcInfo(), "");
    String billpayIds = new RangeMaker().makeRange(paids, "getBillPayId");
    ArrayList<BillPay> pays = BillPayMgr.getInstance().retrieveList("id in (" + billpayIds + ")", "");


    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    DecimalFormat mnf = new DecimalFormat("###,###.#"); 
    boolean full_mode = false;
    try { full_mode = request.getParameter("f").equals("true"); } catch (Exception e) {}

    VchrItemInfoMgr vimgr = VchrItemInfoMgr.getInstance();
    ArrayList<VchrItemInfo> items = vimgr.retrieveList("vchr_item.threadId=" + t.getId(), "");
    phm.util.PArrayList pitems = new phm.util.PArrayList<VchrItemInfo>(items);
    for (int i=0; i<paids.size(); i++) {
        BillPaid p = paids.get(i);
        if (p.getThreadId()>0) {
            pitems.concate(vimgr.retrieveList("vchr_item.threadId=" + p.getThreadId(), ""));
        }
    }
    for (int i=0; i<pays.size(); i++) {
        BillPay p = pays.get(i);
        if (p.getThreadId()>0) {
            pitems.concate(vimgr.retrieveList("vchr_item.threadId=" + p.getThreadId(), ""));
        }
    }
    VchrInfo vinfo = new VchrInfo(pitems, 0);

    out.println("<div class=es02><b>帳單 "+t.getSrcInfo()+" - <img src='../pic/costtype3.png' border=0>&nbsp;相關傳票</b></div>");

    out.println("<table width=\"100%\" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background='../pic/h01.gif'><img src='../pic/h01.gif' height=1 border=0></td></tr></table>");

    out.println("<div class=es02><br><font color=blue>傳票試算:</font></div>");

    //<br><hr width='100%'>
    out.print("<table border=0 class=es02><tr align=middle bgcolor=\"#f0f0f0\"><td colspan=3></td><td width=100>借</td><td width=100>貸</td></tr>");
    if (full_mode)
        out.print("<td width=100>借-貸<td>");
    Map<Integer, ArrayList<VchrItem>> acodeitemMap = new SortingMap(pitems).doSortA("getAcodeId");
    Iterator<Integer> iter2 = acodeitemMap.keySet().iterator();
    double debit_total=0, credit_total=0;
    while (iter2.hasNext()) {
        ArrayList<VchrItem> vitems = acodeitemMap.get(iter2.next());
        double debit=0, credit=0;
        for (int i=0; i<vitems.size(); i++) {
            debit += vitems.get(i).getDebit();
            credit += vitems.get(i).getCredit();
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
        out.print(getAcodeLink(vitems.get(0).getAcodeId(),vinfo.getMain(vitems.get(0))));
        out.print("</td><td align=left>");
        out.print(getAcodeLink(vitems.get(0).getAcodeId(), vinfo.getSub(vitems.get(0))));
        out.print("</td><td align=left nowrap>");
        out.print(vinfo.getAcodeName(vitems.get(0)));
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
        out.println("</tr>");
    }
    out.println("<tr align=right><td colspan=6><hr width='100%'></td></tr>");
    out.print("<tr align=right><td colspan=3></td><td>");
    out.println(PaymentPrinter.makePrecise(mnf.format(debit_total), 44, false, ' '));
    out.print("</td><td>");
    out.print(PaymentPrinter.makePrecise(mnf.format(credit_total), 15, false, ' '));
    out.print("</td>");
    if (full_mode) {
        out.print("<td>");
        out.print(PaymentPrinter.makePrecise(mnf.format(debit_total-credit_total), 15, false, ' '));
        out.print("</td>");
    }
    out.println("</tr></table>");

    out.println("</table>");


    out.println("<br><div class=es02><br><font color=blue>傳票明細:</font></div>");
    out.println("<table class=es02>");
    out.println("<tr align=middle bgcolor=\"#f0f0f0\"><td width=100 align=middle>入帳日期</td><td width=100 align=center>傳&nbsp;票</td><td colspan=3 align=center>科&nbsp;目</td><td width=100>借&nbsp;&nbsp;</td><td width=100>貸&nbsp;&nbsp;</td><td align=middle>摘&nbsp;要</td></tr>");   
    
    String threadIds = new RangeMaker().makeRange(pitems, "getThreadId");
    ArrayList<VchrItemInfo> tmp = VchrItemInfoMgr.getInstance().retrieveList("vchr_item.threadId in (" + threadIds + ")", 
        "order by registerDate asc, vchr_holder.id asc, vchr_item.id asc");

    Map<Integer, ArrayList<VchrItemInfo>> vchritemMap = new SortingMap(tmp).doSortA("getVchrId");
    for (int i=0; i<tmp.size(); i++) {
        VchrItemInfo vi = tmp.get(i);
        double credit = 0, debit = 0;
        if (vi.getFlag()==VchrItem.FLAG_DEBIT) {
            debit += vi.getDebit();
        }
        else {
            credit += vi.getCredit();
        }

        out.print("<tr align=right><td align=left>" + sdf.format(vi.getRegisterDate()));
        out.print("</td><td align=left>");
        out.print("<a href=# onclick=\"parent.show_voucher2("+vi.getVchrId()+",null, false);return false;\">" + 
            vi.getSerial() + "</a>");
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
        out.print("&nbsp;&nbsp;</td>");
        out.print("<td align=left nowrap>&nbsp;&nbsp;");
        out.print(vinfo.getTotalNote(vi));
        out.print("</td></tr>");
    }
    out.println("</table>");
%>
<form name=acodeform target="_blank" method=post action="show_acode_billsearch.jsp">
<input type=hidden name="o" value="<%=t.getSrcInfo()%>">
<input type=hidden name="a">
<input type=hidden name="m" value="false">
</form>


