<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,mca.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    boolean commit = false;
    int tran_id = 0;
    try {           
        tran_id = dbo.Manager.startTransaction();

        McaStudentMgr msmgr = new McaStudentMgr(tran_id);

        String id = request.getParameter("id");
        McaStudent s = msmgr.find("id=" + id);
        Tag grade = new TagMgr(tran_id).findX("id=" + request.getParameter("grade"), _ws2.getBunitSpace("bunitId"));

        McaService mcasvc = new McaService(tran_id);
        mcasvc.addCurrentCampus(s, _ws2.getSessionBunitId());
        TagMembrMgr tmmgr = new TagMembrMgr(tran_id);
        if (tmmgr.numOfRows("tagId=" + grade.getId() + " and membrId=" + s.getMembrId())==0) {
            TagMembr tm = new TagMembr();
            tm.setMembrId(s.getMembrId());
            tm.setTagId(grade.getId());
            tmmgr.create(tm);
        }

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
%>
<blockquote>
done!
<blockquote>
<script>
    parent.do_reload = true;
    parent.parent.do_reload = true;
</script>