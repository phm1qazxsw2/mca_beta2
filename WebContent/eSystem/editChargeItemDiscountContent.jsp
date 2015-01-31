<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<%
    //##v2
    if(!checkAuth(ud2,authHa,102))
    {
        response.sendRedirect("authIndex.jsp?code=102");
    }
    WebSecurity _ws_ = WebSecurity.getInstance(pageContext);
    int citemId = Integer.parseInt(request.getParameter("cid"));
    EzCountingService ezsvc = EzCountingService.getInstance();
    BillChargeItem bcitem = BillChargeItemMgr.getInstance().findX("chargeitem.id=" + citemId, 
    _ws_.getBunitSpace("bill.bunitId"));  
    
    if (bcitem==null) { 
        %><script>alert("找不到資料");history.go(-1);</script><%
        return;
    }

    ArrayList<MembrBillRecord> allbills = MembrBillRecordMgr.getInstance().
        retrieveList("billRecordId=" + bcitem.getBillRecordId(), "");
    // membrId
    Map<Integer, Vector<MembrBillRecord>> billMap = new SortingMap(allbills).doSort("getMembrId");

    DiscountInfoMgr dimgr = DiscountInfoMgr.getInstance();
    ArrayList<DiscountInfo> discounts = dimgr.retrieveList("chargeItemId=" + citemId, "");
    DecimalFormat mnf = new DecimalFormat("###,###,##0");
%>
<br> 
<div class=es02>
&nbsp;&nbsp;&nbsp;&nbsp; <b><%=bcitem.getBillRecordName()%></b> - 整批編輯調整名單
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
<a href="editBillRecord.jsp?recordId=<%=bcitem.getBillRecordId()%>"><img src="pic/last2.png" border=0 width=12>&nbsp;回整批編輯帳單</a>
</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<center>
<table width="85%" height="" border="0" cellpadding="0" cellspacing="0">

    <tr>

    <td align=middle valign=top width=150 class=es02>
        <br>
        <img src="img/dbill.gif" border=0>
        <br>

        </td>
        <td valign=top>    
<div class=es02>
&nbsp;<b><%=bcitem.getBillRecordName()%>調整名單</b>

<a href="javascript:openwindow_phm('addDiscount.jsp?cid=<%=citemId%>','新增調整項目',800,800,true);"><img src="pic/add.gif" border=0>&nbsp;新增調整</a>
|
<a href="<%=(pageType==0)?"editChargeItem":"editChargeItemExpress"%>.jsp?cid=<%=citemId%>"><img src="pic/last.gif" border=0>&nbsp;回編輯收費項目</a>

</div>
<%
    if(discounts.size()==0)
    {
%>

        <blockquote>
        <div class=es02>尚未加入名單</div>
        </blockquote>    
        </td>
        </tr>
        </table>

        <%
        if(pageType==0){          
        %>
            <%@ include file="bottom.jsp"%>	    
        <%  }   %>
<%  
        return;
    }else{  %>
<br>
<table width="600" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
    	<td width=15%>對象</td>
        <td nowrap width=15%>金額</td>
        <td nowrap width=15%>登入者</td>
        <td width="*" align=middle>附註</td>
        <td width="3%"></td>
        <td width="3%"></td>
    </tr>
<%
    int total = 0;
    Iterator<DiscountInfo> diter = discounts.iterator();
    while (diter.hasNext()) {
        DiscountInfo d = diter.next();
        MembrBillRecord mbr = billMap.get(new Integer(d.getMembrId())).get(0);
        boolean paid = mbr.getPaidStatus()!=MembrBillRecord.STATUS_NOT_PAID;
        boolean locked = mbr.getPrintDate()>0;
        total += d.getAmount();
        String str = null;
        if (paid) 
            str = "<img src='pic/lockfinish2.png' align=top width=15 height=15 alt='已付'> 已付款";
        else if (locked) 
            str = "<img src='pic/lockno2.png' align=top width=15 height=15 alt='已鎖'> 已鎖定"; 
        %>
        <tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'">
        <td class=es02><%=d.getMembrName()%></td>
        <td nowrap align=right class=es02><%=mnf.format(0-d.getAmount())%></td>
        <td nowrap align=right class=es02><%=d.getUserLoginId()%></td>
        <td class=es02 nowrap><%=d.getNote()%></td>
    <% if (paid || locked) { %>
        <td colspan=2 class=es02 nowrap><%=str%></td>
    <% } else { %>
        <td nowrap class=es02><a href="javascript:openwindow_phm('discount_modify.jsp?id=<%=d.getId()%>','修改調整',500,300,true)">修改</a></td>
        <td nowrap class=es02><a onclick="if (confirm('確定刪除？')) return true; else return false;" href="discount_remove.jsp?id=<%=d.getId()%>&backurl=<%=java.net.URLEncoder.encode(backurl)%>">刪除</a></td>
    <% } %>
    </tr>
<%  
    }
%>
	<tr bgcolor=#f0f0f0 class=es02>
    	<td align=right>小計</td>
        <td align=right><%=mnf.format(0-total)%></td>
        <td colspan=4></td>
    </tr>
</table>
</td></tr></table>
<br>
<br>
<%  }   %>

</td>
</tr>
</table>
</center>