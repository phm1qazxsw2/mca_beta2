<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    if(!AuthAdmin.authPage(ud2,4))
    {
        response.sendRedirect("authIndex.jsp?info=1&page=1");
    }
    request.setCharacterEncoding("UTF-8");
    int id = Integer.parseInt(request.getParameter("id"));
    TagMgr tagmgr = TagMgr.getInstance();
    ArrayList<Tag> tags = tagmgr.retrieveList("typeId=" + id, "");
    Iterator<Tag> titer = tags.iterator();
    while (titer.hasNext()) {
        Tag t = titer.next();
        t.setTypeId(0);
        tagmgr.save(t);
    }

    TagTypeMgr ttmgr = TagTypeMgr.getInstance();
    Object[] objs = ttmgr.retrieve("id=" + id, "");
    ttmgr.remove(objs);
    response.sendRedirect("tagtype_list.jsp");
%>
