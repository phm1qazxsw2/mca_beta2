<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,java.io.*,mca.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
boolean commit = false;
int tran_id = 0;
try {           
    tran_id = dbo.Manager.startTransaction();

    String ticketId = request.getParameter("ticketId");
    int type = Integer.parseInt(request.getParameter("type"));
    MembrInfoBillRecord bill = new MembrInfoBillRecordMgr(tran_id).findX("ticketId='" + ticketId + "'", _ws2.getBunitSpace("bill.bunitId"));

    if (bill==null) {
        %><script>alert("資料不存在");</script><%
        return;
    }

    int r = new McaService(tran_id).setupDeferred(bill, type, ud2.getId(), true);

    dbo.Manager.commit(tran_id);
    commit = true;
}
catch (Exception e) {
    if (e.getMessage()!=null) {
      e.printStackTrace();
  %><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>');history.go(-1);</script><%
    } else {
      e.printStackTrace();
  %><script>alert("錯誤發生，設定沒有寫入");history.go(-1);</script><%
    }
}
finally {
    if (!commit)
        dbo.Manager.rollback(tran_id);
}
%>
<blockquote>
    success!
</blockquote>
<script>
    parent.do_reload = true;
</script>
