<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
   //##v2
    int tid = Integer.parseInt(request.getParameter("tid"));

    boolean commit = false;
    int tran_id = 0;
    try {
        tran_id = dbo.Manager.startTransaction();

        TagMgr tmgr = new TagMgr(tran_id);
        Tag t = tmgr.find("id=" + tid);
        t.setStatus(Tag.STATUS_CURRENT);
        tmgr.save(t);

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
%>
<blockquote>
重啟成功!
</blockquote>