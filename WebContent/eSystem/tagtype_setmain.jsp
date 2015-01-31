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

    TagTypeMgr ttmgr = TagTypeMgr.getInstance();
    TagType tt1 = ttmgr.findX("main=1", _ws2.getStudentBunitSpace("bunitId"));
    TagType tt2 = ttmgr.findX("id=" + id, _ws2.getStudentBunitSpace("bunitId"));
    if (tt1.getId()!=tt2.getId()) {
        tt1.setMain(0);
        tt2.setMain(1);
        ttmgr.save(tt1);
        ttmgr.save(tt2);
    }
    response.sendRedirect("tagtype_list.jsp");
%>
