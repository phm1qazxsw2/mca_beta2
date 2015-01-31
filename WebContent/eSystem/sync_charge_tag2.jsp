<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%	
    //##v2
    if(!checkAuth(ud2,authHa,602))
    {
        response.sendRedirect("authIndex.jsp?code=502");
    }

    int cid = Integer.parseInt(request.getParameter("cid"));
    int mid = Integer.parseInt(request.getParameter("mid"));
    int tid = Integer.parseInt(request.getParameter("tid"));

    int tran_id = 0;
    boolean commit = false;
    try {
        tran_id = dbo.Manager.startTransaction();
        TagMembrMgr tmmgr = new TagMembrMgr(tran_id);
        TagMembr tm = new TagMembr();
        tm.setTagId(tid);
        tm.setMembrId(mid);
        tmmgr.create(tm);

        dbo.Manager.commit(tran_id);
        commit = true;
        response.sendRedirect("sync_charge_tag.jsp?cid=" + cid);
    }
    catch (Exception e) {
        e.printStackTrace();
        if (e.getMessage()!=null) {
      %><script>alert('<%=e.getMessage()%>');history.go(-1);</script><%
        }
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
%>
        