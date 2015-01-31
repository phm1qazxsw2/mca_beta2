<%@ page language="java"  import="phm.ezcounting.*,phm.accounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<link href="../ft02.css" rel=stylesheet type=text/css>
<link rel="stylesheet" href="../css/dhtmlwindow.css" type="text/css" />
<script type="text/javascript" src="../openWindow.js"></script> 
<script src="../js/show_voucher.js"></script>

<table border=0 class=es02>
<%
    SimpleDateFormat _sdf = new SimpleDateFormat("yyyy/MM/dd");
    out.println("<tr align=right><td nowrap>序號</td><td width=100 align=left>入帳日期</td><td width=100>借&nbsp;&nbsp;</td><td width=100>貸&nbsp;&nbsp;</td><td width=100 nowrap>小計(借-貸)&nbsp;</td><td width=100 align=center>傳票</td><td align=left>&nbsp;&nbsp;摘要</td><td>&nbsp;登入人&nbsp;</td></tr>");
    VchrInfo vinfo = VchrInfo.getVchrInfo(vitems, 0);
    double subtotal = 0;
    for (int i=0; i<vitems.size(); i++) {
        VchrItemInfo vi = vitems.get(i);
        out.print("<tr align=right><td>"+(i+1)+"&nbsp;&nbsp;</td><td align=left>" + _sdf.format(vi.getRegisterDate()));
        out.print("</td><td>&nbsp;&nbsp;");
        out.print(vinfo.formatDebit(vi));
        out.print("&nbsp;&nbsp;</td><td>&nbsp;&nbsp;");
        out.print(vinfo.formatCredit(vi));
        out.print("&nbsp;&nbsp;</td><td>");
        subtotal += (vi.getDebit() - vi.getCredit());
        out.print(mnf.format(subtotal) + "&nbsp;");
        out.print("&nbsp;&nbsp;</td><td align=left>");
        out.print("<a href=# onclick=\"show_voucher("+vi.getVchrId()+");return false;\">" + vi.getSerial() + "</a>");
        out.print("</td><td align=left nowrap>&nbsp;&nbsp;");
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