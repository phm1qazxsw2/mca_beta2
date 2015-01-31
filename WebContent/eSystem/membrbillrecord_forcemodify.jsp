<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="justHeader.jsp"%>
<%
boolean commit = false;
int tran_id = 0;
try { 
    //##v2
    if(!checkAuth(ud2,authHa,102))
        throw new Exception("權限不足!");

    MembrBillRecordMgr mbrmgr = new MembrBillRecordMgr(tran_id);
    MembrBillRecord mbr = mbrmgr.find("ticketId='" + request.getParameter("ticketId") + "'");
    mbr.setForcemodify(new Date().getTime());
    mbrmgr.save(mbr);
}
catch (Exception e) {
    if (e.getMessage()!=null) {
  %>@@<%=e.getMessage()%><%
    } else {
  %>@@錯誤發生<%
    }
    e.printStackTrace();
}    
finally {
    if (!commit)
        try { Manager.rollback(tran_id); } catch (Exception e2) {}  
}
%>
