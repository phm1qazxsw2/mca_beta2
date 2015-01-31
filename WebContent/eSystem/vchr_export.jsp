<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,phm.accounting.*,literalstore.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="justHeader.jsp"%>
<%@ include file="vchr_search_handler.jsp"%>
<link href=ft02.css rel=stylesheet type=text/css>
<table class=es02 border=1>
<%    
    ArrayList<VchrItemSum> sums =VchrItemSumMgr.getInstance().retrieveList(q, spec);
    VchrSumInfo vinfo = new VchrSumInfo(sums, show_main_only, 0);

    for (int i=0, idx=0; i<sums.size(); i++) {
        VchrItemSum s = sums.get(i);
        double dvalue = (full_mode)?s.getDebit():vinfo.getNominalDebit(s);
        double cvalue = (full_mode)?s.getCredit():vinfo.getNominalCredit(s);
        if (dvalue==0 && cvalue==0)
            continue;
        out.println("<tr><td nowrap>");
        out.println(vinfo.getMain(s) + " " + vinfo.getSub(s));
        out.println("</td><td nowrap>");
        out.println(vinfo.getAcodeName(s));
        out.println("</td><td nowrap>");
        out.println(dvalue);
        out.println("</td><td nowrap>");
        out.println(cvalue);
        out.println("</td></tr>");
    }
%>
</table>