<%@ page language="java"  import="phm.ezcounting.*,phm.accounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="../justHeader.jsp"%>
<%
    MembrInfoBillRecordMgr snbrmgr = MembrInfoBillRecordMgr.getInstance();
    ArrayList<MembrInfoBillRecord> bills = 
        snbrmgr.retrieveListX("billRecordId=" + request.getParameter("brId"), "", _ws2.getBunitSpace("bill.bunitId"));

    if (bills.size()==0) {
        %><script>alert("沒有帳單資料");window.close();</script><%
        return;
    }

    String threadIds = new RangeMaker().makeRange(bills, "getThreadId");
    //############
    
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    DecimalFormat mnf = new DecimalFormat("###,###,###.##");
    boolean full_mode = false;

    String q = "vchr_item.threadId in (" + threadIds + ") and main='1144'"; // 應收帳款改變
    
    ArrayList<VchrItemInfo> vitems =VchrItemInfoMgr.getInstance().retrieveListX(
        q, "order by vchr_holder.created desc, vchr_item.id asc", _ws2.getBunitSpace("vchr_holder.buId"));

%>
<div class=es_title><b>帳單修改歷史明細</b></div>


<link href="../ft02.css" rel=stylesheet type=text/css>
<link rel="stylesheet" href="../css/dhtmlwindow.css" type="text/css" />
<script type="text/javascript" src="../openWindow.js"></script> 
<script src="../js/show_voucher.js"></script>

<table border=0 class=es02>
<%
    SimpleDateFormat _sdf = new SimpleDateFormat("yyyy/MM/dd");
    out.println("<tr align=right><td nowrap>序號</td><td width=100 align=left>&nbsp;&nbsp;入帳日期</td><td width=100 nowrap>金額&nbsp;&nbsp;&nbsp;</td><td align=left>&nbsp;&nbsp;摘要</td><td>&nbsp;登入人&nbsp;</td></tr>");
    VchrInfo vinfo = VchrInfo.getVchrInfo(vitems, 0);
    double subtotal = 0;
    for (int i=0; i<vitems.size(); i++) {
        VchrItemInfo vi = vitems.get(i);
        out.print("<tr align=right><td>"+(i+1)+"&nbsp;&nbsp;</td><td align=left>" + _sdf.format(vi.getRegisterDate()));
        out.print("</td><td>");
        out.print(mnf.format(vi.getDebit() - vi.getCredit()) + "&nbsp;");
        out.print("&nbsp;&nbsp;</td><td align=left nowrap>&nbsp;&nbsp;");
        out.print("<a target=_blank href='find_source.jsp?thread=" + vi.getThreadId() + "'>");
        out.print(vinfo.getTotalNote(vi));
        out.print("</a>");
        out.print("</td>");
        out.print("<td>");
        out.print((vi.getUserId()==0)?"系統":vinfo.getUserName(vi.getUserId()));
        out.print("</td>");
        out.print("</tr>");
    }
%>
</table>