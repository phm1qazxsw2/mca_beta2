<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,phm.accounting.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="justHeader.jsp"%>
<%
try {
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    Date fz = sdf.parse(request.getParameter("freezeTime"));

    if (MembrInfoBillRecordMgr.getInstance().numOfRowsX("threadId=0 and billrecord.month<='" + 
        sdf.format(fz) + "' and receivable>0", _ws2.getBunitSpace("bill.bunitId"))>0)
        throw new Exception("[" + sdf.format(fz) + "] 之前還有未發佈(尚未入帳)的帳單 不能關帳");

    Freeze f = new Freeze();
    f.setCreated(new Date());
    f.setFreezeTime(fz);
    f.setUserId(ud2.getId());
    f.setBunitId(_ws2.getSessionBunitId());
    FreezeMgr.getInstance().create(f);

    response.sendRedirect("freeze_setup.jsp");
}
catch (Exception e) {
    if (e.getMessage()!=null) {
  %><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>');history.go(-1);</script><%
    } else {
      e.printStackTrace();
  %><script>alert("錯誤發生，設定沒有寫入");history.go(-1);</script><%
    }
}
%>
