<%@ page language="java"  import="web.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<%
    int id1 = Integer.parseInt(request.getParameter("id"));
    int id2 = Integer.parseInt(request.getParameter("switch"));

    int tran_id = 0;
    boolean commit = false;
    try {            
        tran_id = dbo.Manager.startTransaction();
        TagTypeMgr ttmgr = new TagTypeMgr(tran_id);
        TagType tt1 = ttmgr.find("id=" + id1);
        TagType tt2 = ttmgr.find("id=" + id2);
        ttmgr.executeSQL("update tagtype set num=" + tt1.getNum() + " where id=" + id2);
        ttmgr.executeSQL("update tagtype set num=" + tt2.getNum() + " where id=" + id1);
        dbo.Manager.commit(tran_id);
        commit = true;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
    response.sendRedirect("tagtype_list.jsp");
%>