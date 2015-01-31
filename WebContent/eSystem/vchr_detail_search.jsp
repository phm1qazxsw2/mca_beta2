<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,phm.accounting.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="justHeader.jsp"%>
<%!
    String makeLink(String name, int threadId) {
        if (threadId>0)
            return "<a target=_blank href='vchr/find_source.jsp?thread=" + threadId + "'>" + name + "</a>";
        return name;
    }
%>
<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    DecimalFormat mnf = new DecimalFormat("###,###,##0");
    Date end = sdf.parse(request.getParameter("e"));
    Date start = sdf.parse(request.getParameter("s"));
    Calendar cal = Calendar.getInstance();
    cal.setTime(end);
    cal.add(Calendar.DATE, 1);
    Date nextEndDay = cal.getTime();
    VoucherService vsvc = new VoucherService(0, _ws2.getSessionBunitId());
    boolean use_create_time = false;
    try { use_create_time = request.getParameter("t").equals("1"); } catch (Exception e) {}

    String q = null;
    if (use_create_time)
        q = "created>='" + sdf.format(start) + "' and created<'" + sdf.format(nextEndDay) + "'";
    else
        q = "registerDate>='" + sdf.format(start) + "' and registerDate<'" + sdf.format(nextEndDay) + "'";
    q += " and vchr_holder.type=" + VchrHolder.TYPE_INSTANCE;


    ArrayList<VchrHolderType> vchrs = VchrHolderTypeMgr.getInstance().retrieveListX
        (q, "order by vchr_holder.id asc", _ws2.getBunitSpace("vchr_holder.buId"));
    String vchrIds = new RangeMaker().makeRange(vchrs, "getId");
    ArrayList<VchrItem> vchritems = VchrItemMgr.getInstance().retrieveList("vchrId in (" + vchrIds + ")", "");
    Map<String, ArrayList<VchrHolderType>> vchrdateMap = new SortingMap(vchrs).doSortA("getRegisterDateAsDateStr");
    Map<Integer, ArrayList<VchrItem>> vchritemMap = new SortingMap(vchritems).doSortA("getVchrId");

    if (vchrs.size()==0) {
        out.println("沒有資料");
        return;
    }

    boolean format = (request.getParameter("format")!=null && request.getParameter("format").equals("1"));
System.out.println("## format=" + format + " : " + request.getParameter("format"));
%>
<link href="ft02.css" rel=stylesheet type=text/css>
<table border=0 class=es02 border=1>
<tr align=center bgcolor="#f0f0f0">
   <td nowrap>入帳日期&nbsp;&nbsp;</td><td nowrap>部門</td><td colspan=2 nowrap>會計科目</td><td nowrap>摘要</td><td>借</td><td>貸</td>
</tr>
<%
    Iterator<String> iter = vchrdateMap.keySet().iterator();
    while (iter.hasNext()) {
        String d = iter.next();
        if (!format)
            out.println("<tr><td colspan=7><span style=\"border:solid black 1px\">&nbsp;" + d + "&nbsp;</span></td></tr>");
        vchrs = vchrdateMap.get(d);
        for (int i=0; i<vchrs.size(); i++) {
            VchrHolderType v = vchrs.get(i);
            if (!format)
                out.println("<tr><td colspan=7>　　" + v.getSerial() + 
                    " ("+makeLink(VchrThread.getSrcTypeName(v.getSrcType()+"",' '), v.getThreadId())+")</td></tr>");
            ArrayList<VchrItem> items = vchritemMap.get(v.getId());
            VchrInfo vinfo = new VchrInfo(items,0);
            for (int j=0; j<items.size(); j++) {
                VchrItem vi = items.get(j);
                out.print("<tr align=left valign=top><td>"+((format)?d:"")+"</td>");
                out.print("<td nowrap>&nbsp;" + vinfo.getBunitName(vi) + "&nbsp;&nbsp;&nbsp;</td>");
                out.print("<td nowrap>" + vinfo.formatAcode(vi) + "</td>");
                out.print("<td nowrap>&nbsp;&nbsp;" + vinfo.getAcodeName(vi) + "</td>");
                out.print("<td width=250>&nbsp;&nbsp;" + vinfo.getNote(vi) + "&nbsp;&nbsp;</td>");
                out.print("<td align=right nowrap>&nbsp;" + vinfo.formatDebit(vi) + "&nbsp;&nbsp;</td>");
                out.print("<td align=right nowrap>&nbsp;" + vinfo.formatCredit(vi) + "&nbsp;&nbsp;</td>");
                out.println("</tr>");
            }
            if (!format)
                out.println("<tr><td></td><td colspan=6 height=10><hr style=\"color:#f0f0f0;height:1px\" width='100%'></td></tr>");
        }
    }
%>
</table>


