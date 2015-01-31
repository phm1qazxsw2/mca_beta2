<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
   //##v2
    User ud2 = WebSecurity.getInstance(pageContext).getCurrentUser();

    
    int tid = Integer.parseInt(request.getParameter("tid"));

    boolean commit = false;
    int tran_id = 0;
    try {
        tran_id = dbo.Manager.startTransaction();

        TagMgr tmgr = new TagMgr(tran_id);
        Tag t = tmgr.find("id=" + tid);
        t.setStatus(Tag.STATUS_HISTORY);
        tmgr.save(t);

        // ## 2009/2/8 by peter, tag 現在要保留 history 了
        /*
        TagMembrMgr tmmgr = new TagMembrMgr(tran_id);
        Object[] objs = tmmgr.retrieve("tagId=" + tid, "");
        tmmgr.remove(objs);
        TagMgr tmgr = new TagMgr(tran_id);
        Object[] objs2 = { tmgr.find("id=" + tid) };
        tmgr.remove(objs2);
        */
        dbo.Manager.commit(tran_id);
        commit = true;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
    response.sendRedirect("studentoverview.jsp");
%>