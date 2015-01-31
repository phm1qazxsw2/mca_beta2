<%@ page language="java"  import="phm.ezcounting.*,phm.accounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="../justHeader.jsp"%><%!
    class MyUI {
        int type;
        Date start, end;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        boolean show_main_only = false;

        MyUI(int type, boolean show_main_only, Date start, Date end) {
            this.type = type;
            this.start = start;
            this.end = end;
            this.show_main_only = show_main_only;
        }
        String getAcodeLink(int acodeId, String name) {
            String url = "show_acode.jsp?a="+acodeId+"&t=" + this.type + "&s=" + 
                getdstr(start) + "&e=" + getdstr(end);
            if (show_main_only)
                url += "&m=main";
            else
                url += "&m=detail";
            String ret = "<a target=_blank href=\"" + url + "\">" + name + "</a>";
            return ret;
        }
        String getdstr(Date d) {
            return java.net.URLEncoder.encode(sdf.format(d));
        }
    }
%>
<link href="../ft02.css" rel=stylesheet type=text/css>
<table border=0 class=es02>
<%
    int t = Integer.parseInt(request.getParameter("t"));
    boolean show_main_only = request.getParameter("m").equals("main");
    boolean full_mode = false;
    try { full_mode = request.getParameter("f").equals("true"); } catch (Exception e) {}

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    DecimalFormat mnf = new DecimalFormat("###,###.#"); 
    Date start = sdf.parse(request.getParameter("s"));
    Date end = sdf.parse(request.getParameter("e"));
    Calendar cal = Calendar.getInstance();
    cal.setTime(end);
    cal.add(Calendar.DATE, 1);
    Date nextEndDay = cal.getTime();
    
    String q = "registerDate>='" + sdf.format(start) + "' and registerDate<'" + sdf.format(nextEndDay) + "' and vchr_holder.type="+VchrHolder.TYPE_INSTANCE;
    if (t==1) {
        q += " and vchr_thread.srcType in (1,4,5)";
    }
    else if (t==2) {
        q += " and vchr_thread.srcType in (2,7,8)";
    }
    else if (t==3) {
        q += " and vchr_thread.srcType in (3,9,10)";
    }
    else if (t==4) {
        q += " and vchr_thread.srcType in (11)";
    }
    else if (t==5) {
        q += " and vchr_thread.srcType in (6,12,13)";
    }
    else if (t==6) {
        q += " and vchr_thread.srcType in (1)";
    }
    
    String spec = (show_main_only)?"group by acode.main order by acode.main":"group by acode.id order by acode.main,acode.sub";
    
    ArrayList<VchrItemSum> sums =VchrItemSumMgr.getInstance().retrieveList(q, spec);

    VchrSumInfo vinfo = new VchrSumInfo(sums, show_main_only, 0);
    MyUI ui = new MyUI(t, show_main_only, start, end);
    double debit=0, credit=0;
    out.print("<tr align=right><td colspan=3></td><td width=100>借</td><td width=100>貸</td>");
    if (full_mode)
        out.print("<td width=100>借-貸<td>");
    out.println("</tr>");
    for (int i=0; i<sums.size(); i++) {
        VchrItemSum s = sums.get(i);
        double dvalue = (full_mode)?s.getDebit():vinfo.getNominalDebit(s);
        double cvalue = (full_mode)?s.getCredit():vinfo.getNominalCredit(s);
        if (dvalue==0 && cvalue==0)
            continue;
        debit += dvalue;
        credit += cvalue;
        out.print("<tr align=right><td align=left>");
        out.print(ui.getAcodeLink(s.getAcodeId(), vinfo.getMain(s)));
        out.print("</td><td align=left>");
        out.print(ui.getAcodeLink(s.getAcodeId(), vinfo.getSub(s)));
        out.print("</td><td align=left nowrap>");
        out.print(vinfo.getAcodeName(s));
        out.print("</td><td>");
        out.print(PaymentPrinter.makePrecise(mnf.format(dvalue), 12, false, ' '));
        out.print("</td><td>");
        out.print(PaymentPrinter.makePrecise(mnf.format(cvalue), 15, false, ' '));
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
</table>