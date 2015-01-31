<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=2;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu2-new.jsp"%>
<%

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    String backurl=request.getParameter("backurl");
    String idstr = request.getParameter("id");
    ArrayList<Vitem> vitems = new ArrayList<Vitem>();
    if (idstr.charAt(0)=='I') {
        Vitem vi = VitemMgr.getInstance().find("id=" + idstr.substring(1));
        vitems.add(vi);
    }
    else {
        VitemMgr.getInstance().retrieveList("voucherId=" + idstr.substring(1), "", vitems);
    }
%>

<br>
<div class=es02>
<b>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;複製傳票:</b>
&nbsp;&nbsp;&nbsp;</b>
<a href="<%=backurl%>"><img src="pic/last.gif" border=0 width=14>&nbsp;回上一頁</a>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<form action="spending_copy2.jsp" method=post>
<center>
<table width="96%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
		<td align=middle nowrap width=80>入帳日期</td>
        <td align=middle width=150>明細</td>
        <td align=middle width=80 nowrap>帳面金額</td>
        <td align=middle width=80 nowrap>附件</td>
        <td align=middle nowrap width=100>備註</td>
	</tr>
<%
    int total = 0;
    int paid = 0;
    StringBuffer sbContent=new StringBuffer();
    Iterator<Vitem> iter = vitems.iterator();
    while (iter.hasNext()) {
        Vitem vi = iter.next(); %>    
    <input type=hidden name="id" value="<%=vi.getId()%>">
    <tr bgcolor=#ffffff class=es02>
        <td class=es02 valign=top><input type=text name="<%=vi.getId()%>_recordTime" value="<%=sdf.format(new Date())%>" size=7></td>
        <td class=es02 valign=top><input type=text name="<%=vi.getId()%>_title" value="<%=phm.util.TextUtil.encodeHtml(vi.getTitle())%>" size=40></td>
        <td align=right class=es02 valign=top><input type="text" name="<%=vi.getId()%>_total" value="<%=vi.getTotal()%>" size=5></td>
        <td align=right class=es02 valign=top>
            <select name="<%=vi.getId()%>_attachtype">
                <option value="<%=Vitem.ATTACH_NONE%>" <%=(vi.getAttachtype()==Vitem.ATTACH_NONE)?"selected":""%>>無
                <option value="<%=Vitem.ATTACH_RECEIPT%>" <%=(vi.getAttachtype()==Vitem.ATTACH_RECEIPT)?"selected":""%>>收據
                <option value="<%=Vitem.ATTACH_TAXSLIP%>" <%=(vi.getAttachtype()==Vitem.ATTACH_TAXSLIP)?"selected":""%>>發票
            </select>
        </td>
        <td align=right class=es02 valign=top><input type="note" name="<%=vi.getId()%>_note" value="" size=40></td>
    </tr>
<%  } %>  
    <tr>
        <td colspan=5 align=middle>
            <input type=submit value="複製">
        </td>
    </tr>

    </table> 

</td>
</tr>
</table>
<br>

</form>

</center>

<%@ include file="bottom.jsp"%>