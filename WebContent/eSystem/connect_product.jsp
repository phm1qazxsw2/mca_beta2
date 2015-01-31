<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    request.setCharacterEncoding("UTF-8");
    if(!AuthAdmin.authPage(ud2,4))
    {
        response.sendRedirect("authIndex.jsp?info=1&page=1");
    }

    String billId = request.getParameter("billId"); // for create
    String bid = request.getParameter("bid"); // for modify

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    ArrayList<PItem> items = PItemMgr.getInstance().retrieveList("status=1", "");
    ArrayList<InvInfo> inv_infos = InvInfoMgr.getInstance().retrieveList("", "group by pitemId");
    Map<Integer, Vector<InvInfo>> invMap = new SortingMap(inv_infos).doSort("getPitemId");

    Map<Integer, Vector<BillItem>> billitemMap = new SortingMap
        (BillItemMgr.getInstance().retrieveList("","")).doSort("getPitemId");
%>

<div class=es02>
&nbsp;&nbsp;&nbsp;&nbsp;<b>
<img src=pic/costAdd.png border=0>&nbsp;連結收費與學用品
</b>


&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:history.go(-1)"><img src="pic/last.gif" border=0 width=14>&nbsp;回上一頁</a>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<center>
<form action="connect_product.jsp" method=post name="f">

<br>
<table width="500" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
    <table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
        <td>學用品名</td>
        <td>進貨成本/個</td>
        <td>庫存</td>
        <td></td>
    </tr>
<%
    Iterator<PItem> iter = items.iterator();
    while (iter.hasNext()) {
        PItem pi = iter.next();
        Vector<InvInfo> vi = invMap.get(new Integer(pi.getId()));
        int quantity = 0;
        int cost = 0;
        if (vi!=null) {
            quantity = vi.get(0).getQuantity();
            cost = vi.get(0).getCost();
        }
%>
	<tr bgcolor=white class=es02>
        <td><%=pi.getName()%></td>
        <td><%=cost%><%=(quantity>0)?("/"+cost/quantity):""%></td>
        <td><%=quantity%></td>
        <td align=center>
        <% if (billitemMap.get(new Integer(pi.getId()))!=null) { %>
            已連結
        <% } else if (bid==null) { %>
            <a href="addBillItem.jsp?billId=<%=billId%>&pid=<%=pi.getId()%>">連結此項</a>
        <% } else { %>
            <a href="billitem_edit.jsp?bid=<%=bid%>&pid=<%=pi.getId()%>">連結此項</a>
        <% } %>
        </td>
    </tr>
<%  } %>
    </table>
</tD>
</tR>
</table>
</form>
</center>

