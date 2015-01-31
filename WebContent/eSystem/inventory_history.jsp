<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%@ include file="jumpTop.jsp"%>
<%
    if(!AuthAdmin.authPage(ud2,4))
    {
        response.sendRedirect("authIndex.jsp?page=6&info=1");
    }
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    PItem pi = PItemMgr.getInstance().find("id=" + request.getParameter("id"));
    ArrayList<Inventory> invs = InventoryMgr.getInstance().
        retrieveList("pitemId=" + request.getParameter("id"), "order by orderDate asc");
    Object[] objs = CosttradeMgr.getInstance().retrieve("","");
    Map<Integer, Vector<Costtrade>> traderMap = new SortingMap().doSort(objs, new ArrayList<Costtrade>(), "getId");
%>

<div class=es02>
&nbsp;&nbsp;&nbsp;&nbsp;<b>
<img src=pic/littlebag.png border=0>&nbsp;<%=pi.getName()%>進貨歷史
</b>

</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<center>
<form action="inventory_add2.jsp" method=post name="xs" id="xs"  onsubmit="return(checkForm())">

<table width="500" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
    <table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
        <td>序號</td>
        <td>日期</td>
        <td>數量</td>
        <td>金額合計</td>
        <td>廠商</td>
        <td></td>
    </tr>
<%
    Iterator<Inventory> iter = invs.iterator();
    while (iter.hasNext()) {
        Inventory inv = iter.next();
        Vector<Costtrade> cv = traderMap.get(new Integer(inv.getTraderId()));
        String traderName = "##";
        if (cv!=null)
            traderName = cv.get(0).getCosttradeName();
%>
	<tr bgcolor=white class=es02>
        <td><%=inv.getId()%></td>
        <td><%=sdf.format(inv.getOrderDate())%></td>
        <td><%=inv.getQuantity()%></td>
        <td><%=inv.getTotalPrice()%></td>
        <td><%=traderName%></td>
        <td><a href="inventory_modify.jsp?id=<%=inv.getId()%>">修改</a></td>
    </tr>
<%  } %>
    </table>
</tD>
</tR>
</table>
</form>
</center>

