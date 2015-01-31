<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=1;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu1.jsp"%>
<%
    //##v2
    if(!AuthAdmin.authPage(ud2,4))
    {
        response.sendRedirect("authIndex.jsp?info=1&page=1");
    }
    int billId = Integer.parseInt(request.getParameter("id"));
    EzCountingService ezsvc = EzCountingService.getInstance();
    Bill bill = BillMgr.getInstance().find("id=" + billId);
    BillRecord[] brecords = BillRecordMgr.getInstance().
        retrieveList("billId=" + bill.getId(), "order by month desc");
    java.text.DecimalFormat mf = new java.text.DecimalFormat("###,###,###,###.##");
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM");
System.out.println("## 2");
%>
<br> 
&nbsp;&nbsp;&nbsp; <b><a href="listBills.jsp">帳單類型列表</a> - <%=bill.getName()%></b>
<br>

<blockquote>
<a href="#" onclick="openwindow_phm('addbillRecord.jsp?billId=<%=billId%>','開單',400,400,true);return false;">
<img src="pic/add.gif" border=0>開立新一期的帳單 (<%=bill.getName()%>)</a>

<ul>
依據此帳單類型產生新一期的開單記錄
<br>
使用者可選擇此次開單要重新開始 或 複製之前某次<br>的開單記錄以便稍加修改即可(所有帳單細目和減免都會複製).
</ul>


</blockquote>

<b>&nbsp;&nbsp;&nbsp;<img src="pic/fix.gif" border=0>歷史開單記錄</b>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<blockquote> 
<%
	if(brecords.size()==0)
	{
		out.println("<br>此類型帳單尚無開單記錄");
%>
		<%@ include file="bottom.jsp"%>	
<%
		return;
	}
%>
	<table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
    	<td>名稱</td>
        <td>開單月份</td>
        <td></td>
        <td></td>
        <td>應收</td>
        <td>已收</td>
        <td></td>
    </tr>
<%
    Iterator<BillRecord> iter = brecords.iterator();
    for (BillRecord br=iter.next(); iter.hasNext(); br=iter.next())
    {
        MembrBillRecordMgr sbrmgr = MembrBillRecordMgr.getInstance();
        Object[] objs = sbrmgr.retrieve("billrecordId=" + br.getId(), "");
        int receivableNum = 0;
        int receivable = (int)0;
        int receivedNum = 0;
        int received = (int)0;
        if (objs!=null) {
            for (int j=0; j<objs.length; j++) {
                MembrBillRecord sbr = (MembrBillRecord) objs[j];
                receivableNum ++;
                receivable += sbr.getReceivable();
                if (sbr.getReceived()>=sbr.getReceivable()) {
                    receivedNum ++;
                    received += sbr.getReceived();
                }
            }
        }

%>
    <form action="modifyClass.jsp" method=post>	
    <tr bgcolor=ffffff class=es02 valign=center height=30>
		<td width=80%><%=br.getName()%> </td>
        <td><a href="billoverview.jsp"><%=sdf.format(br.getMonth())%></a></td>
        <td nowrap>&nbsp;&nbsp;<a href="editBillRecord.jsp?recordId=<%=br.getId()%>">編輯收費內容</a>&nbsp;&nbsp;</td>
        <td nowrap><a href=''>下載編輯繳費單</td>
        <td nowrap><%=receivableNum+"筆("+mf.format(receivable)+")"%></td>
        <td nowrap><%=receivedNum+"筆("+mf.format(received)+")"%></td>
        <td><%=(br.getConfirmed()==0)?"<input type=button value='刪除'>":"已鎖住"%></td>
    </tr>
    </form>
<%
}
%>
</table>
</td></tr></table> 

</blockquote>



<!--- end 主內容 --->


<%@ include file="bottom.jsp"%>	