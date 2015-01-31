<%@ page language="java" buffer="32kb"  import="web.*,jsf.*,phm.ezcounting.*,mca.*,java.lang.reflect.*,java.util.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%@ include file="justHeader.jsp"%>	
<%
boolean commit = false;
int tran_id = 0;
try {           
    tran_id = dbo.Manager.startTransaction();

    int id = Integer.parseInt(request.getParameter("id"));
    int status = Integer.parseInt(request.getParameter("status"));

    McaStudentMgr msmgr = new McaStudentMgr(tran_id);
    McaStudent s = msmgr.find("id=" + id);
    
    Student2Mgr smgr = new Student2Mgr(tran_id);
    Student2 st = smgr.find("id=" + s.getStudId());
    McaService msvc = new McaService(tran_id);
    if (status==99) { // do leave, need to move student out of all tags
        msvc.leaveCurrentCampus(s, _ws2.getSessionBunitId());
    }
    else if (status==4) { // do back, need to move student back to campus tag
        msvc.addCurrentCampus(s, _ws2.getSessionBunitId());
    }

    dbo.Manager.commit(tran_id);
    commit = true;
}
catch (Exception e) {
    if (e.getMessage()!=null) {
      e.printStackTrace();
  %><script>@@<%=phm.util.TextUtil.escapeJSString(e.getMessage())%><%
    } else {
      e.printStackTrace();
  %>@@錯誤發生，設定沒有寫入<%
    }
}
finally {
    if (!commit)
        dbo.Manager.rollback(tran_id);
}
%>

