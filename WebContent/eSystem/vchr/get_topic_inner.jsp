<%@ page language="java"  import="phm.ezcounting.*,phm.accounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%!
    public class MyUI {
        String srctype, prjId;
        Date start, end;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        boolean show_main_only = false;

        public MyUI(String srctype, boolean show_main_only, Date start, Date end, String prjId) {
            this.srctype = srctype;
            this.start = start;
            this.end = end;
            this.prjId = prjId;
            this.show_main_only = show_main_only;
        }
        String getCheckbox(int acodeId, String name) {
            return "<input type=checkbox name=a value='"+acodeId+"'>";
        }
        String getAcodeLink(int acodeId, String name) {
            String url = "vchr/acode_detail.jsp?a="+acodeId+"&t=" + this.srctype + "&s=" + 
                getdstr(start) + "&e=" + getdstr(end) + "&p=" + prjId;
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

<form name=f1 target=_blank action="vchr/acode_detail.jsp" method=get>
<input type=hidden name=t value="<%=srctype%>">
<input type=hidden name=s value="<%=sdf.format(start)%>">
<input type=hidden name=e value="<%=sdf.format(end)%>">
<input type=hidden name=p value="<%=p%>">
<input type=hidden name=m value="<%=(show_main_only)?"main":"detail"%>">

&nbsp;&nbsp;<a href='javascript:document.f1.submit()'>顯示勾選項目的明細</a>　
<input type=checkbox name="checkall" id="checkall">全選<br>
<table border=0 class=es02>
<%  
    if (sums.size()==0) {
        out.println("沒有資料");
        return;
    }
    VchrSumInfo vinfo = new VchrSumInfo(sums, show_main_only, 0);
    MyUI ui = new MyUI(srctype, show_main_only, start, end, p);
    double debit=0, credit=0;
    out.print("<tr align=right><td colspan=4></td><td width=100>借</td><td width=100>貸</td>");
    //if (full_mode)
    //    out.print("<td width=100>借-貸<td>");
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
        out.print(ui.getCheckbox(s.getAcodeId(), vinfo.getMain(s)));
        out.print("</td><td align=left>");
        out.print(ui.getAcodeLink(s.getAcodeId(), vinfo.getMain(s)));
        out.print("</td><td align=left>");
        out.print(ui.getAcodeLink(s.getAcodeId(), vinfo.getSub(s)));
        out.print("</td><td align=left nowrap>");
System.out.println("### sum.getAcodeId()=" + s.getAcodeId());
        out.print(vinfo.getAcodeName(s));
        out.print("</td><td>");
        out.print(PaymentPrinter.makePrecise(mnf.format(dvalue), 12, false, ' '));
        out.print("</td><td>");
        out.print(PaymentPrinter.makePrecise(mnf.format(cvalue), 15, false, ' '));
        out.print("</td>");
        //if (full_mode) {
        //    out.print("<td>");
        //   out.print(PaymentPrinter.makePrecise(mnf.format(dvalue-cvalue), 15, false, ' '));
        //    out.print("</td>");
        //}
        out.print("</tr>");
    }
    out.println("<tr align=right><td colspan=7><hr width='100%'></td></tr>");
    out.print("<tr align=right><td colspan=4></td><td>");
    out.println(PaymentPrinter.makePrecise(mnf.format(debit), 44, false, ' '));
    out.print("</td><td>");
    out.print(PaymentPrinter.makePrecise(mnf.format(credit), 15, false, ' '));
    out.print("</td>");
    //if (full_mode) {
    //    out.print("<td>");
    //    out.print(PaymentPrinter.makePrecise(mnf.format(debit-credit), 15, false, ' '));
    //    out.print("</td>");
    //}
    out.println("</tr>");
%>
</table>