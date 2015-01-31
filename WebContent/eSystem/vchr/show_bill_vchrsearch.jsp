<%@ page language="java" 
    import="dbo.*,phm.ezcounting.*,literalstore.*,java.util.*,phm.accounting.*,java.text.*"
    contentType="text/html;charset=UTF-8"%>
<%@ include file="../justHeader.jsp"%>
<link href="../ft02.css" rel=stylesheet type=text/css>
<%!
    String getAcodeLink(int acodeId, String name) {
        return "<a href=\"javascript:show_acode_detail("+acodeId+")\">"+name+"</a>";
    }
%>
<%
    //########## 找 bill 出來, 這段 copy 自 print_bill_step2
    String o =  request.getParameter("o");
    String t = request.getParameter("t");
    StringBuffer sb1 = new StringBuffer();
    String[] tickets = o.split(",");
    for (int i=0; i<tickets.length; i++) {
        if (sb1.length()>0) sb1.append(",");
        sb1.append("'");
        sb1.append(tickets[i]);
        sb1.append("'");
    }

    MembrInfoBillRecordMgr snbrmgr = MembrInfoBillRecordMgr.getInstance();
    ArrayList<MembrInfoBillRecord> bills = 
        snbrmgr.retrieveList("membrbillrecord.ticketId in (" + sb1.toString() + ")", "");

    boolean not_complate = false;
    for (int i=0; i<bills.size(); i++)
        if (bills.get(i).getThreadId()==0) {
            not_complate = true;
            break;
    }

    String all_threadIds = new VoucherService(0, _ws2.getSessionBunitId()).getBillRelatedThreadIds(bills);
    //############3
    
    
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    DecimalFormat mnf = new DecimalFormat("###,###,###.##");
    boolean full_mode = false;
    try { full_mode = request.getParameter("f").equals("true"); } catch (Exception e) {}

    ArrayList<VchrItemSum> sums = VchrItemSumMgr.getInstance().retrieveListX("vchr_item.threadId in (" + all_threadIds + ")", "group by fullkey order by fullkey asc", _ws2.getBunitSpace("vchr_holder.buId"));

    if (not_complate)
        out.println("<div class=es02><font color=red>還有尚未發佈的帳單(傳票還未產生)，以下資料不完整！</font></div>");

    out.println("<br><div class=es02><b><img src='pic/costtype3.png' border=0>&nbsp;傳票試算</b></div>");
    out.println("<table width=\"100%\" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background='pic/h01.gif'><img src='pic/h01.gif' height=1 border=0></td></tr></table>");


    out.println("<br><table border=0 class=es02>");
    out.print("<tr align=middle bgcolor='#f0f0f0'><td colspan=3></td><td width=100>借</td><td width=100>貸</td>");
    if (full_mode)
        out.print("<td width=100>借-貸<td>");
    out.println("</tr>");
    boolean show_main_only = false;
    VchrSumInfo vinfo = new VchrSumInfo(sums, show_main_only, 0);
    double debit = 0;
    double credit = 0;
    for (int j=0; j<sums.size(); j++) {
        VchrItemSum s = sums.get(j);
        double dvalue = (full_mode)?s.getDebit():vinfo.getNominalDebit(s);
        double cvalue = (full_mode)?s.getCredit():vinfo.getNominalCredit(s);
        if (dvalue==0 && cvalue==0)
            continue;
        debit += dvalue;
        credit += cvalue;
        out.print("<tr align=right><td align=left>");
        out.print(getAcodeLink(s.getAcodeId(), vinfo.getMain(s)));
        out.print("</td><td align=left>");
        out.print(getAcodeLink(s.getAcodeId(), vinfo.getSub(s)));
        out.print("</td><td align=left nowrap>");
        out.print(vinfo.getAcodeName(s));
        out.print("</td><td>");
        out.print((dvalue !=0)?PaymentPrinter.makePrecise(mnf.format(dvalue), 12, false, ' '):"");
        out.print("</td><td>");
        out.print((cvalue !=0)?PaymentPrinter.makePrecise(mnf.format(cvalue), 15, false, ' '):"");
        out.print("</td>");
        if (full_mode) {
            out.print("<td>");
            out.print(PaymentPrinter.makePrecise(mnf.format(dvalue-cvalue), 15, false, ' '));
            out.print("</td>");
        }
        out.print("</tr>");
    }
    out.println("<tr align=right><td colspan=6><hr width='100%'></td></tr>");
    out.print("<tr align=right><td colspan=3></td><td>");
    out.println(PaymentPrinter.makePrecise(mnf.format(debit), 44, false, ' '));
    out.print("</td><td>");
    out.print(PaymentPrinter.makePrecise(mnf.format(credit), 15, false, ' '));
    out.print("</td>");
    if (full_mode) {
        out.print("<td>");
        out.print(PaymentPrinter.makePrecise(mnf.format(debit-credit), 15, false, ' '));
        out.print("</td>");
    }
    out.println("</tr></table>");
%>

<br>
<div class=es02 style="position:relative;left:10px">
    <a href="javascript:document.f2.submit();">匯出</a>
</div>
<br>
<div class=es02 style="position:relative;left:10px">
    <a href="javascript:export_history()">歷史匯出資料</a>
</div>

<form name=f1 action="show_acode_billsearch.jsp" method=post target=_blank>
<input type=hidden name="a">
<input type=hidden name="main" value="false">
<input type=hidden name="o" value="<%=o%>">
</form>

<form name=f2 action="vchr_bill_search_export.jsp" method=post target=_blank>
<input type=hidden name="main" value="false">
<input type=hidden name="o" value="<%=o%>">
<input type=hidden name="t" value="<%=t%>">
</form>

