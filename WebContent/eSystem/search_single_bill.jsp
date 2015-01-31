<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=1;
    int leftMenu=1;
%>
<%@ include file="topMenuAdvanced.jsp"%>
<%
    //##v2
    String ticketId = request.getParameter("ticketId");
    MembrInfoBillRecord sinfo = MembrInfoBillRecordMgr.getInstance().find("ticketId='" + ticketId + 
        "' and billType=" + Bill.TYPE_BILLING);
    if (sinfo!=null) {
        response.sendRedirect("bill_detail.jsp?sid=" + sinfo.getMembrId() + "&rid=" + sinfo.getBillRecordId()
            + "&backurl=searchbillrecord.jsp");
        return;
    }
%>
<%@ include file="leftMenu1.jsp"%>
<br>
<br>
<blockquote>
輸入的流水號沒有對應的帳單。
<br>
<br>
<a href="javascript:history.go(-1);">回上一頁</a>
</blockquote>
<%@ include file="bottom.jsp"%>