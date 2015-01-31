<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,java.io.*,mca.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    String ticketId = request.getParameter("ticketId");
    MembrInfoBillRecord bill = MembrInfoBillRecordMgr.getInstance().findX("ticketId='" + ticketId + "'", _ws2.getBunitSpace("bill.bunitId"));

    if (bill==null) {
        %><script>alert("資料不存在");</script><%
        return;
    }

    McaDeferred md = McaDeferredMgr.getInstance().find("ticketId='" + ticketId + "'");
    int type = 0;
    if (md!=null)
        type = md.getType();

    boolean donedeal = (bill.getPrintDate()>0) || (bill.getPaidStatus()!=MembrBillRecord.STATUS_NOT_PAID);
%>
<blockquote>
<form action="mca_setup_deferred2.jsp">
    <input type=hidden name="ticketId" value="<%=ticketId%>">
    <input type=radio name="type" value="0" <%=(donedeal)?"disabled":""%> <%=(type==0)?"checked":""%>> None
    <br>
    <br>
    <input type=radio name="type" value="1" <%=(donedeal)?"disabled":""%> <%=(type==1)?"checked":""%>> Standard
    <br>
    <br>
    <input type=radio name="type" value="2" <%=(donedeal)?"disabled":""%> <%=(type==2)?"checked":""%>> Monthly
    <br>
    <br>
    　<input type="submit" value="Save" <%=(donedeal)?"disabled":""%>>
</form>
</blockquote>

