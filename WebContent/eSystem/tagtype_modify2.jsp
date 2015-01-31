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
    String name = request.getParameter("name");
    String backurl = request.getParameter("backurl");
    TagTypeMgr ttmgr = TagTypeMgr.getInstance();
    TagType tt = ttmgr.find("id=" + id);
    tt.setName(name);
    ttmgr.save(tt);
    backurl += (backurl.indexOf("?")<0)?"?":"&";
    response.sendRedirect(backurl + "t=" + tt.getId());
%>
