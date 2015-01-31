<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,mca.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    boolean commit = false;
    int tran_id = dbo.Manager.startTransaction();
    try {     
        McaStudentMgr msmgr = new McaStudentMgr(tran_id);
        McaService mcasvc = new McaService(tran_id);

        McaStudent ms = msmgr.find("id=" + request.getParameter("id"));

        if (new TagMembrMgr(tran_id).numOfRows("membrId=" + ms.getMembrId())>0)
            throw new Exception("Student in tags, cannot delete");
        if (new ChargeMgr(tran_id).numOfRows("membrId=" + ms.getMembrId())>0)
            throw new Exception("Student has fees, cannot delete");

        msmgr.executeSQL("delete from student where id=" + ms.getStudId());
        msmgr.executeSQL("delete from membr where id=" + ms.getMembrId());
        msmgr.executeSQL("delete from mca_student where id=" + ms.getId());

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
%>
<blockquote>
   刪除成功!
</blockquote>
<script>
   parent.do_reload = true;
</script>
